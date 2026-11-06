package com.arm00pv.asvabcoach

import android.content.Context
import android.content.Intent
import android.media.AudioManager
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.speech.tts.TextToSpeech
import android.speech.tts.UtteranceProgressListener
import android.view.WindowManager
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.arm00pv.asvabcoach.llm.LlmTutor
import com.arm00pv.asvabcoach.voice.NativeVoice
import com.arm00pv.asvabcoach.voice.VoicePacks
import com.arm00pv.asvabcoach.voice.VoiceTts
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.io.File
import java.io.IOException
import java.net.HttpURLConnection
import java.net.URL
import java.util.Locale

/// The stock Flutter activity plus three small channels: keeping the display on
/// during a timed section, getting a newer build onto the phone, and speaking
/// the on-screen guide with the device's own voice.
///
/// None of them needs a dangerous permission. FLAG_KEEP_SCREEN_ON is a window
/// flag, not a wakelock; the updater uses the app's own cache directory through
/// a FileProvider, so the app still asks for no storage access; and the voice is
/// the system text-to-speech engine, which the operating system already owns -
/// nothing is recorded, and nothing spoken is sent anywhere. It does declare
/// INTERNET - it is the one thing that talks to the network, and only about
/// itself.
class MainActivity : FlutterActivity() {
    private val main = Handler(Looper.getMainLooper())

    /// The on-device tutor, and the model it runs. Created with the activity so
    /// a download in progress survives a trip to another screen.
    private var tutor: LlmTutor? = null

    /// The system text to speech engine, created on first use.
    private var speech: TextToSpeech? = null
    private var speechReady = false
    private var speechChannel: MethodChannel? = null
    private var utteranceCount = 0

    /// The downloaded voices: sherpa-onnx on the phone, one pack per language.
    private var voiceTts: VoiceTts? = null
    private var voicePacks: VoicePacks? = null
    private var voiceEvents: EventChannel.EventSink? = null

    /// Calls that arrived before the engine finished initialising. The engine
    /// reports readiness asynchronously, and the first call almost always
    /// arrives first.
    private val speechQueue = mutableListOf<() -> Unit>()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger

        MethodChannel(messenger, "asvabcoach/screen").setMethodCallHandler { call, result ->
            if (call.method != "keepScreenOn") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            val on = call.arguments as? Boolean ?: false
            runOnUiThread {
                if (on) {
                    window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                } else {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                }
            }
            result.success(true)
        }

        speechChannel = MethodChannel(messenger, "asvabcoach/speech")
        speechChannel?.setMethodCallHandler { call, result -> handleSpeech(call, result) }

        // The on-device tutor: a downloaded GGUF, llama.cpp, and nothing else
        // involved. No server, no key, no network once the file is here.
        val tutor = LlmTutor(this)
        this.tutor = tutor
        MethodChannel(messenger, "asvabcoach/llm").setMethodCallHandler { call, result ->
            tutor.onMethodCall(call, result)
        }
        EventChannel(messenger, "asvabcoach/llm_events").setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    tutor.setSink(events)
                }

                override fun onCancel(arguments: Any?) {
                    tutor.setSink(null)
                }
            },
        )

        // The neural voices. A pack is downloaded once, verified, and then spoken
        // with by sherpa-onnx inside the app - no network, no system voice.
        val packs = VoicePacks(this)
        this.voicePacks = packs
        val voice = VoiceTts(this)
        this.voiceTts = voice
        MethodChannel(messenger, "asvabcoach/voice").setMethodCallHandler { call, result ->
            handleVoice(call, result, voice, packs)
        }
        EventChannel(messenger, "asvabcoach/voice_events").setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    voiceEvents = events
                }

                override fun onCancel(arguments: Any?) {
                    voiceEvents = null
                }
            },
        )

        MethodChannel(messenger, "asvabcoach/update").setMethodCallHandler { call, result ->
            when (call.method) {
                "version" -> result.success(versionName())
                "check" -> offMainThread(result) { checkLatestRelease() }
                "install" -> {
                    val url = call.argument<String>("url")
                    val tag = call.argument<String>("tag") ?: "update"
                    val expected = (call.argument<Number>("bytes"))?.toLong() ?: 0L
                    val digest = call.argument<String>("digest")
                    if (url.isNullOrBlank()) {
                        result.error("bad_args", "No download address was given.", null)
                    } else {
                        offMainThread(result) {
                            downloadAndInstall(url, tag, expected, digest)
                        }
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        // Never leave the flag set behind us.
        window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        speechQueue.clear()
        speech?.stop()
        speech?.shutdown()
        speech = null
        speechReady = false
        tutor?.dispose()
        tutor = null
        voiceTts?.dispose()
        voiceTts = null
        voicePacks?.dispose()
        voicePacks = null
        voiceEvents = null
        super.onDestroy()
    }

    // ---- The spoken study guide ------------------------------------------

    /// Runs [work] now if the engine is ready, and otherwise as soon as it is.
    private fun withEngine(work: () -> Unit) {
        ensureEngine()
        if (speechReady) {
            work()
        } else {
            speechQueue.add(work)
        }
    }

    private fun ensureEngine() {
        if (speech != null) return
        speech = TextToSpeech(applicationContext) { status ->
            speechReady = status == TextToSpeech.SUCCESS
            if (speechReady) {
                speech?.setOnUtteranceProgressListener(
                    object : UtteranceProgressListener() {
                        override fun onStart(utteranceId: String?) = emit("started")

                        override fun onDone(utteranceId: String?) = emit("finished")

                        @Deprecated("Deprecated in Java")
                        override fun onError(utteranceId: String?) = emit("failed")

                        override fun onError(utteranceId: String?, errorCode: Int) =
                            emit("failed")
                    },
                )
            }
            // Whatever was waiting is answered either way: a device with no
            // engine must hear "no voices", not nothing at all.
            val waiting = speechQueue.toList()
            speechQueue.clear()
            for (call in waiting) call()
        }
    }

    private fun emit(event: String) {
        main.post { speechChannel?.invokeMethod(event, null) }
    }

    /// Every voice the device has, with the language tag the app speaks it
    /// with. Network voices are marked, because the guide promises offline.
    private fun describeVoices(): List<Map<String, Any?>> {
        val engine = speech ?: return emptyList()
        if (!speechReady) return emptyList()
        return try {
            engine.voices
                .filter { it.locale != null }
                .map { voice ->
                    mapOf(
                        "name" to voice.name,
                        "locale" to voice.locale.toLanguageTag(),
                        "quality" to voice.quality,
                        "local" to !voice.isNetworkConnectionRequired,
                    )
                }
        } catch (error: Exception) {
            emptyList()
        }
    }

    private fun handleSpeech(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "voices" -> withEngine { result.success(describeVoices()) }
            "speak" -> {
                val text = call.argument<String>("text").orEmpty()
                val tag = call.argument<String>("locale").orEmpty()
                val wanted = call.argument<String>("voice").orEmpty()
                val rate = (call.argument<Number>("rate") ?: 1.0).toFloat()
                if (text.isBlank()) {
                    result.success(null)
                    return
                }
                withEngine {
                    val engine = speech
                    if (engine == null || !speechReady) {
                        result.error("no_engine", "This device has no speech engine.", null)
                        return@withEngine
                    }
                    val requested = if (tag.isBlank()) {
                        Locale.getDefault()
                    } else {
                        Locale.forLanguageTag(tag)
                    }
                    var language = engine.setLanguage(requested)
                    if (
                        language == TextToSpeech.LANG_MISSING_DATA ||
                        language == TextToSpeech.LANG_NOT_SUPPORTED
                    ) {
                        // The exact tag is not installed. A voice in the same
                        // language is a better answer than silence.
                        val fallback = engine.voices.firstOrNull {
                            it.locale?.language == requested.language
                        }
                        if (fallback != null) language = engine.setVoice(fallback)
                    }
                    if (
                        language == TextToSpeech.LANG_MISSING_DATA ||
                        language == TextToSpeech.LANG_NOT_SUPPORTED
                    ) {
                        result.error(
                            "no_voice",
                            "No voice is installed for " + tag + ".",
                            null,
                        )
                        return@withEngine
                    }
                    // The exact voice the candidate picked, applied after the
                    // language so it is not overwritten by it. A voice that has
                    // been uninstalled since is not a reason to say nothing:
                    // the language chosen above still speaks.
                    if (wanted.isNotBlank()) {
                        engine.voices
                            .firstOrNull { it.name == wanted }
                            ?.let { engine.setVoice(it) }
                    }
                    engine.setSpeechRate(rate.coerceIn(0.5f, 2.0f))
                    utteranceCount += 1
                    val queued = engine.speak(
                        text,
                        TextToSpeech.QUEUE_FLUSH,
                        null,
                        "asvab-" + utteranceCount,
                    )
                    if (queued == TextToSpeech.ERROR) {
                        result.error("speak_failed", "The voice refused the text.", null)
                    } else {
                        result.success(true)
                    }
                }
            }
            "stop" -> {
                speech?.stop()
                result.success(true)
            }
            // The engine's own voice list lives in Android's settings, not in
            // this app: Google ships one language per engine until the rest are
            // downloaded, and that download has to be done there. Taking the
            // candidate straight to it is more useful than explaining that this
            // app cannot add voices it does not own.
            "openVoiceSettings" -> {
                val opened = try {
                    startActivity(
                        Intent("com.android.settings.TTS_SETTINGS").apply {
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        },
                    )
                    true
                } catch (error: Exception) {
                    try {
                        startActivity(
                            Intent(Settings.ACTION_SETTINGS).apply {
                                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            },
                        )
                        true
                    } catch (unlikely: Exception) {
                        false
                    }
                }
                result.success(opened)
            }
            // A speech utterance is a media stream, and a media stream at zero is
            // the commonest reason a voice is silent. Raising it from here - with
            // the system's own volume panel on screen - is the fix the candidate
            // can make where the problem is shown, instead of being told to leave
            // the sheet and find a side button.
            "turnUpVolume" -> {
                val audio =
                    getSystemService(Context.AUDIO_SERVICE) as? AudioManager
                if (audio == null) {
                    result.success(0)
                    return
                }
                result.success(raiseMediaVolume(audio))
            }
            else -> result.notImplemented()
        }
    }

    /// Raises the media stream until speech is audible, and returns where it
    /// ended up.
    ///
    /// One step above zero is index 1 of 25 on a Pixel - technically on, still
    /// inaudible across a room. The target is a third of the range, or three
    /// steps when the range is short, and never lower than where the candidate
    /// already had it: this button turns the volume up, it does not choose a
    /// volume for them. FLAG_SHOW_UI puts the system slider on screen so the
    /// change is visible and adjustable in the same gesture.
    private fun raiseMediaVolume(audio: AudioManager): Int {
        val max = audio.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
        val current = audio.getStreamVolume(AudioManager.STREAM_MUSIC)
        val target = maxOf(
            current,
            minOf(max, maxOf(3, Math.round(max * 0.3f))),
        )
        if (target <= current) return current
        return try {
            audio.setStreamVolume(
                AudioManager.STREAM_MUSIC,
                target,
                AudioManager.FLAG_SHOW_UI,
            )
            audio.getStreamVolume(AudioManager.STREAM_MUSIC)
        } catch (error: Exception) {
            // Some OEMs refuse this without a foreground service. Nothing is lost:
            // the caller shows the volume it read, and the message still stands.
            current
        }
    }

    // ---- Downloaded voices -------------------------------------------------

    private fun emitVoice(event: Map<String, Any?>) {
        main.post { voiceEvents?.success(event) }
    }

    private fun handleVoice(
        call: MethodCall,
        result: MethodChannel.Result,
        voice: VoiceTts,
        packs: VoicePacks,
    ) {
        when (call.method) {
            "status" -> {
                val ids = call.argument<List<String>>("ids").orEmpty()
                val states = HashMap<String, Map<String, Any?>>()
                for (id in ids) {
                    states[id] = mapOf(
                        "installed" to packs.isInstalled(id),
                        "bytes" to packs.sizeOf(id),
                        "downloading" to packs.isDownloading(id),
                    )
                }
                result.success(
                    mapOf(
                        "supported" to voice.isReady(),
                        "error" to NativeVoice.loadError,
                        "packs" to states,
                    ),
                )
            }
            "install" -> {
                val id = call.argument<String>("id").orEmpty()
                val url = call.argument<String>("url").orEmpty()
                val bytes = call.argument<Number>("bytes")?.toLong() ?: 0L
                val sha = call.argument<String>("sha256").orEmpty()
                if (id.isEmpty() || url.isEmpty() || sha.isEmpty()) {
                    result.error("bad_args", "A pack, an address and a checksum are needed.", null)
                    return
                }
                packs.install(
                    id,
                    url,
                    bytes,
                    sha,
                    onProgress = { received, total ->
                        emitVoice(
                            mapOf(
                                "type" to "download",
                                "id" to id,
                                "received" to received,
                                "total" to total,
                            ),
                        )
                    },
                    onDone = { failure ->
                        if (failure.isEmpty()) {
                            emitVoice(mapOf("type" to "installed", "id" to id))
                        } else {
                            emitVoice(
                                mapOf("type" to "error", "id" to id, "message" to failure),
                            )
                        }
                    },
                )
                result.success(true)
            }
            "cancelInstall" -> {
                packs.cancel()
                result.success(true)
            }
            "delete" -> {
                val id = call.argument<String>("id").orEmpty()
                voice.unload()
                result.success(packs.delete(id))
            }
            "speak" -> {
                val id = call.argument<String>("id").orEmpty()
                // The text arrives split at sentence boundaries, so the engine
                // can speak the first piece while it makes the rest.
                val chunks = call.argument<List<String>>("chunks").orEmpty()
                val speaker = call.argument<Number>("speaker")?.toInt() ?: 0
                val speed = (call.argument<Number>("speed") ?: 1.0).toFloat()
                if (id.isEmpty() || chunks.isEmpty()) {
                    result.success(false)
                    return
                }
                voice.speak(
                    id,
                    chunks,
                    speaker,
                    speed,
                    onStarted = {
                        emitVoice(mapOf("type" to "started", "id" to id))
                    },
                    onError = { message ->
                        emitVoice(
                            mapOf("type" to "error", "id" to id, "message" to message),
                        )
                    },
                    onDone = {
                        emitVoice(mapOf("type" to "finished", "id" to id))
                    },
                )
                result.success(true)
            }
            "stop" -> {
                voice.stop()
                emitVoice(mapOf("type" to "finished", "id" to ""))
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    private fun versionName(): String = try {
        packageManager.getPackageInfo(packageName, 0).versionName ?: "unknown"
    } catch (error: Exception) {
        "unknown"
    }

    /// Runs [work] off the UI thread and answers the channel on it.
    private fun offMainThread(result: MethodChannel.Result, work: () -> Any?) {
        Thread {
            try {
                val value = work()
                main.post { result.success(value) }
            } catch (error: Exception) {
                val message = error.message ?: error.javaClass.simpleName
                main.post { result.error("update_failed", message, null) }
            }
        }.start()
    }

    /// Asks GitHub for the newest published release.
    ///
    /// Deliberately quiet about the device: no identifier, no cookie, nothing
    /// but the request the public API needs. The answer is the release tag, the
    /// universal APK's address and its size.
    private fun checkLatestRelease(): Map<String, Any?> {
        val connection = URL(
            "https://api.github.com/repos/arm00pv/asvab-coach/releases/latest",
        ).openConnection() as HttpURLConnection
        connection.setRequestProperty("Accept", "application/vnd.github+json")
        connection.setRequestProperty("User-Agent", "asvab-coach-android")
        connection.connectTimeout = 15000
        connection.readTimeout = 15000
        try {
            if (connection.responseCode != 200) {
                throw IOException("GitHub answered HTTP ${connection.responseCode}.")
            }
            val body = connection.inputStream.bufferedReader().use { it.readText() }
            val json = JSONObject(body)
            val assets = json.optJSONArray("assets")
            var url: String? = null
            var bytes = 0L
            var named: String? = null
            var digest: String? = null
            if (assets != null) {
                for (index in 0 until assets.length()) {
                    val asset = assets.getJSONObject(index)
                    val name = asset.optString("name")
                    if (!name.endsWith(".apk")) continue
                    // Prefer the universal build: it installs on anything.
                    val isUniversal = name.contains("universal")
                    if (url == null || isUniversal) {
                        url = asset.optString("browser_download_url")
                        bytes = asset.optLong("size")
                        // GitHub publishes a SHA-256 for the asset; carrying it
                        // through means the download can be checked, not just
                        // measured.
                        digest = asset.optString("digest").ifBlank { null }
                        named = name
                        if (isUniversal) break
                    }
                }
            }
            return mapOf(
                "tag" to json.optString("tag_name"),
                "name" to json.optString("name"),
                "asset" to named,
                "url" to url,
                "bytes" to bytes,
                "digest" to digest,
                "published" to json.optString("published_at"),
            )
        } finally {
            connection.disconnect()
        }
    }

    /// Downloads the APK into the app's cache and hands it to the installer.
    private fun downloadAndInstall(
        link: String,
        tag: String,
        expectedBytes: Long,
        expectedDigest: String?,
    ): Map<String, Any?> {
        val directory = File(cacheDir, "updates").apply { mkdirs() }
        val safeTag = tag.replace(Regex("[^A-Za-z0-9._-]"), "_")
        val target = File(directory, "asvab-coach-$safeTag.apk")
        // A half-finished download from an earlier attempt is worse than none:
        // Android answers it with a bare "App not installed". Throw it away
        // rather than handing it to the installer.
        val complete = target.exists() &&
            target.length() > 0L &&
            (expectedBytes <= 0L || target.length() == expectedBytes) &&
            (expectedDigest.isNullOrBlank() || expectedDigest == digestOf(target))
        if (!complete) {
            target.delete()
            val connection = URL(link).openConnection() as HttpURLConnection
            connection.instanceFollowRedirects = true
            connection.connectTimeout = 20000
            connection.readTimeout = 30000
            try {
                if (connection.responseCode !in 200..299) {
                    throw IOException("Download failed with HTTP ${connection.responseCode}.")
                }
                connection.inputStream.use { input ->
                    target.outputStream().use { output -> input.copyTo(output) }
                }
            } finally {
                connection.disconnect()
            }
            if (expectedBytes > 0L && target.length() != expectedBytes) {
                val received = target.length()
                target.delete()
                throw IOException(
                    "The download stopped early (" + received + " of " +
                        expectedBytes + " bytes).",
                )
            }
            if (!expectedDigest.isNullOrBlank() && expectedDigest != digestOf(target)) {
                target.delete()
                throw IOException(
                    "The download did not match the published checksum, so it was " +
                        "discarded. Try again on a steadier connection.",
                )
            }
        }
        val uri: Uri = FileProvider.getUriForFile(
            this,
            "$packageName.updates",
            target,
        )
        val intent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(uri, "application/vnd.android.package-archive")
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        // Go straight to the system installer when it is there. Without this,
        // any app that also handles APK files - a terminal, a file manager -
        // puts a "Open with" chooser between the candidate and the update.
        val handlers = packageManager.queryIntentActivities(intent, 0)
        val systemInstaller = handlers.firstOrNull {
            it.activityInfo.packageName.contains("packageinstaller", ignoreCase = true)
        }
        if (systemInstaller != null) {
            intent.setClassName(
                systemInstaller.activityInfo.packageName,
                systemInstaller.activityInfo.name,
            )
        }
        main.post { startActivity(intent) }
        return mapOf("path" to target.absolutePath, "bytes" to target.length())
    }

    /// "sha256:abcd..." for [file], in the same form GitHub publishes, or null
    /// when there is nothing to hash.
    private fun digestOf(file: File): String? {
        if (!file.exists()) return null
        return try {
            val digest = java.security.MessageDigest.getInstance("SHA-256")
            file.inputStream().use { input ->
                val buffer = ByteArray(64 * 1024)
                while (true) {
                    val read = input.read(buffer)
                    if (read <= 0) break
                    digest.update(buffer, 0, read)
                }
            }
            "sha256:" + digest.digest().joinToString("") { "%02x".format(it) }
        } catch (error: Exception) {
            null
        }
    }
}