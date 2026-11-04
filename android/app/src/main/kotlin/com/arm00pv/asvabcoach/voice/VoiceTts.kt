package com.arm00pv.asvabcoach.voice

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioManager
import android.util.Log
import android.media.AudioFormat
import android.media.AudioTrack
import java.io.File
import java.util.concurrent.Executors

/// The C entry points of the neural voice engine.
///
/// sherpa-onnx is a JNI library of its own, and it depends on onnxruntime, so
/// they are loaded in that order before the bridge that calls the C API.
object NativeVoice {
    @Volatile private var loaded = false
    @Volatile var loadError: String? = null

    fun ensureLoaded(): Boolean {
        if (loaded) return true
        return try {
            // The vendored file is libsherpa-onnx-c-api.so: loadLibrary is a
            // filename join, not a C identifier, so the hyphens have to be
            // spelled as they are on disk.
            System.loadLibrary("onnxruntime")
            System.loadLibrary("sherpa-onnx-c-api")
            System.loadLibrary("asvab_voice")
            loaded = true
            true
        } catch (error: Throwable) {
            loadError = error.message ?: error.javaClass.simpleName
            false
        }
    }

    external fun create(
        kind: Int,
        model: String,
        tokens: String,
        voices: String,
        dataDir: String,
        threads: Int,
    ): Long

    external fun sampleRate(handle: Long): Int

    external fun generate(
        handle: Long,
        text: String,
        speakerId: Int,
        speed: Float,
    ): FloatArray?

    external fun free(handle: Long)
}

/// Reads text aloud with a downloaded voice, on the device.
///
/// Generation happens on a worker because a paragraph takes a few seconds; the
/// samples go straight into an AudioTrack, so the first sound follows the
/// generation rather than a file being written and read again.
class VoiceTts(private val context: Context) {
    private companion object {
        const val TAG = "AsvabVoice"
    }

    private val worker = Executors.newSingleThreadExecutor()

    @Volatile private var handle: Long = 0
    @Volatile private var packId: String = ""
    @Volatile private var sampleRate: Int = 0
    @Volatile private var playing: Boolean = false
    @Volatile private var stopping: Boolean = false

    private var track: AudioTrack? = null

    /// Where a downloaded pack lives: filesDir/voices/<id>/.
    fun packDir(id: String): File = File(File(context.filesDir, "voices"), id)

    fun isReady(): Boolean = NativeVoice.ensureLoaded()

    fun isLoaded(id: String): Boolean = handle != 0L && packId == id

    /// Creates the engine for a pack, or returns false and logs why.
    fun load(id: String): Boolean {
        if (!NativeVoice.ensureLoaded()) return false
        if (isLoaded(id)) return true
        unload()
        val dir = packDir(id)
        val model = File(dir, "model.onnx")
        val tokens = File(dir, "tokens.txt")
        val voices = File(dir, "voices.bin")
        val dataDir = File(dir, "espeak-ng-data")
        if (!model.isFile || !tokens.isFile || !dataDir.isDirectory) return false
        // Kokoro ships a voices.bin; a VITS pack has one speaker and no file.
        val kind = if (voices.isFile) 1 else 0
        val cores = Runtime.getRuntime().availableProcessors().coerceIn(2, 4)
        val created = NativeVoice.create(
            kind,
            model.absolutePath,
            tokens.absolutePath,
            if (kind == 1) voices.absolutePath else "",
            dataDir.absolutePath,
            cores,
        )
        if (created == 0L) return false
        handle = created
        packId = id
        sampleRate = NativeVoice.sampleRate(created)
        Log.i(TAG, "pack $id loaded: kind=$kind, $sampleRate Hz")
        return sampleRate > 0
    }

    fun unload() {
        val current = handle
        handle = 0
        packId = ""
        sampleRate = 0
        if (current != 0L) NativeVoice.free(current)
    }

    /// Generates and plays [chunks] one after another.
    ///
    /// A paragraph synthesised in one call is silent until all of it is ready,
    /// which on a phone is several seconds. The pieces arrive here already split
    /// at sentence boundaries, so the first sentence is heard while the rest is
    /// still being made - and [onStarted] fires on the first sound rather than on
    /// the first sample generated.
    fun speak(
        id: String,
        chunks: List<String>,
        speaker: Int,
        speed: Float,
        onStarted: () -> Unit,
        onError: (String) -> Unit,
        onDone: () -> Unit,
    ) {
        stopping = false
        // The most common reason a voice is silent on a phone that just made
        // sound: the media stream is at zero, and a speech utterance is a media
        // stream. Saying so beats a button that appears to do nothing.
        val audio = context.getSystemService(Context.AUDIO_SERVICE) as? AudioManager
        val volume = audio?.getStreamVolume(AudioManager.STREAM_MUSIC) ?: -1
        if (volume == 0) {
            Log.e(TAG, "media volume is zero")
            onError(
                "The media volume on this phone is at zero, so the voice cannot " +
                    "be heard. Turn it up and try again.",
            )
            onDone()
            return
        }
        worker.execute {
            try {
                if (!load(id)) {
                    onError("The downloaded voice could not be opened.")
                    return@execute
                }
                var heard = false
                for ((index, chunk) in chunks.withIndex()) {
                    if (stopping) break
                    val samples = NativeVoice.generate(handle, chunk, speaker, speed)
                    if (samples == null || samples.isEmpty()) {
                        Log.e(TAG, "chunk ${index + 1}/${chunks.size} produced no samples")
                        continue
                    }
                    if (stopping) break
                    Log.i(
                        TAG,
                        "chunk ${index + 1}/${chunks.size}: ${samples.size} samples, sid=$speaker",
                    )
                    val problem = play(samples) {
                        if (!heard) {
                            heard = true
                            onStarted()
                        }
                    }
                    if (problem != null) {
                        onError(problem)
                        return@execute
                    }
                }
                if (!heard) {
                    onError("The downloaded voice did not produce any sound.")
                }
            } finally {
                playing = false
                stopping = false
                onDone()
            }
        }
    }

    /// Plays one piece of speech. Returns a sentence to show when it could not,
    /// or null once the samples have finished playing.
    private fun play(samples: FloatArray, onStarted: () -> Unit): String? {
        if (sampleRate <= 0) return "The voice engine did not report a sample rate."
        var peak = 0f
        val shorts = ShortArray(samples.size) { index ->
            val value = samples[index].coerceIn(-1f, 1f)
            val size = if (value < 0f) -value else value
            if (size > peak) peak = size
            (value * Short.MAX_VALUE).toInt().toShort()
        }
        val bytes = shorts.size * 2
        if (bytes <= 0) return "The downloaded voice produced no sound."
        // A model that returns samples of near-zero amplitude is a broken pack,
        // not a quiet phone: say so rather than playing nothing and moving on.
        if (peak < 0.02f) {
            Log.e(TAG, "the samples are silent (peak=$peak)")
            return "The downloaded voice produced silence. Remove it and download it again."
        }
        Log.i(TAG, "speaking ${samples.size} samples at $sampleRate Hz, peak=$peak")
        val audio = AudioTrack.Builder()
            .setAudioAttributes(
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                    .build(),
            )
            .setAudioFormat(
                AudioFormat.Builder()
                    .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                    .setSampleRate(sampleRate)
                    .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                    .build(),
            )
            .setBufferSizeInBytes(maxOf(bytes, AudioTrack.getMinBufferSize(
                sampleRate,
                AudioFormat.CHANNEL_OUT_MONO,
                AudioFormat.ENCODING_PCM_16BIT,
            )))
            .setTransferMode(AudioTrack.MODE_STREAM)
            .build()
        track = audio
        playing = true
        audio.play()
        onStarted()
        var offset = 0
        while (offset < shorts.size && !stopping) {
            val written = audio.write(
                shorts,
                offset,
                shorts.size - offset,
                AudioTrack.WRITE_BLOCKING,
            )
            if (written < 0) {
                // A negative return is an error code, not a short write. Saying
                // "nothing happened" is how a voice button silently lies.
                Log.e(TAG, "AudioTrack.write failed: $written")
                break
            }
            offset += written
        }
        // Let the buffer drain before releasing: stop() cuts the queue off, and
        // the last word of a sentence is the one a candidate most needs to hear.
        if (!stopping && offset > 0) {
            val deadline = System.currentTimeMillis() + 5000
            while (
                audio.playbackHeadPosition < offset &&
                System.currentTimeMillis() < deadline &&
                !stopping
            ) {
                Thread.sleep(10)
            }
        }
        playing = false
        try {
            audio.stop()
        } catch (_: IllegalStateException) {
        }
        audio.release()
        track = null
        return null
    }

    fun stop() {
        stopping = true
        playing = false
        try {
            track?.pause()
            track?.flush()
            track?.stop()
        } catch (_: IllegalStateException) {
        }
    }

    fun isSpeaking(): Boolean = playing || stopping

    fun dispose() {
        stop()
        unload()
        worker.shutdown()
    }
}
