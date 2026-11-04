package com.arm00pv.asvabcoach.voice

import android.content.Context
import android.media.AudioAttributes
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
        onDone: () -> Unit,
    ) {
        stopping = false
        worker.execute {
            try {
                if (!load(id)) {
                    onDone()
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
                    play(samples) {
                        if (!heard) {
                            heard = true
                            onStarted()
                        }
                    }
                }
            } finally {
                playing = false
                stopping = false
                onDone()
            }
        }
    }

    private fun play(samples: FloatArray, onStarted: () -> Unit) {
        if (sampleRate <= 0) return
        Log.i(TAG, "speaking ${samples.size} samples at $sampleRate Hz")
        val shorts = ShortArray(samples.size) { index ->
            (samples[index].coerceIn(-1f, 1f) * Short.MAX_VALUE).toInt().toShort()
        }
        val bytes = shorts.size * 2
        if (bytes <= 0) return
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
            val written = audio.write(shorts, offset, shorts.size - offset)
            if (written <= 0) break
            offset += written
        }
        playing = false
        try {
            audio.stop()
        } catch (_: IllegalStateException) {
        }
        audio.release()
        track = null
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
