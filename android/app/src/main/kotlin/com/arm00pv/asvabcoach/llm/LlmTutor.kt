package com.arm00pv.asvabcoach.llm

import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.net.HttpURLConnection
import java.net.URL
import java.security.MessageDigest
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicBoolean

/// The C entry points of the tutor engine.
///
/// The library is packaged for arm64 only; every other ABI gets a stub that
/// reports no engine, so the app still installs and runs there.
object NativeLlm {
    @Volatile private var loaded = false

    /// Why the library could not be opened, for the settings page to print
    /// rather than a candidate being told "not available" with no reason.
    @Volatile var loadError: String? = null

    fun ensureLoaded(): Boolean {
        if (loaded) return true
        return try {
            System.loadLibrary("asvab_llm")
            loaded = true
            true
        } catch (error: Throwable) {
            loadError = error.message ?: error.javaClass.simpleName
            false
        }
    }

    external fun probe(libDir: String): Boolean

    /// 1 when the tutor will run on the GPU, 0 when it runs on the CPU.
    external fun gpu(): Int

    external fun load(path: String, nCtx: Int, nThreads: Int, useGpu: Boolean): Long

    external fun generate(
        handle: Long,
        prompt: String,
        maxTokens: Int,
        temp: Float,
        topK: Int,
        topP: Float,
        sink: Any,
    ): String

    external fun cancel(handle: Long)

    external fun free(handle: Long)
}

/// Where the engine's tokens land while it is writing an answer.
///
/// It is a named class for one reason: the native bridge finds `onToken` with
/// GetMethodID, so the method's name and signature are part of the ABI. R8 sees
/// no caller and renames it, the lookup fails, and the pending
/// NoSuchMethodError kills the process when the JNI frame returns - which is
/// exactly what happened the first time this ran on a phone. proguard-rules.pro
/// keeps both class and method; test/native_contract_test.dart fails if either
/// side of that contract drifts.
class LlmTokenSink(private val onText: (String) -> Unit) {
    @Suppress("unused")
    fun onToken(text: String) {
        onText(text)
    }
}

/// The on-device tutor: download, load, generate, forget.
///
/// Everything happens on the phone. There is no server, no key and no network
/// call except the one that fetches the model file the first time.
class LlmTutor(private val context: Context) {
    companion object {
        /// The published Q4 build of LFM3-Omni-2B, pinned by size and digest.
        /// A file that does not match is thrown away rather than loaded: a
        /// truncated model does not fail loudly, it answers nonsense.
        const val MODEL_URL =
            "https://huggingface.co/LiquidAI/LFM3-Omni-2B-GGUF/resolve/main/LFM3-Omni-2B-Q4_K_M.gguf?download=true"
        const val MODEL_BYTES = 1_099_630_080L
        const val MODEL_SHA256 =
            "9f8d30e9d4fd7a9349d586e077988229b3ca0a0e4ad730897563d1eccc9893e2"
        const val MODEL_FILE = "lfm3-omni-2b-q4_k_m.gguf"
    }

    private val main = Handler(Looper.getMainLooper())
    private val worker: ExecutorService = Executors.newSingleThreadExecutor()
    private var events: EventChannel.EventSink? = null

    @Volatile private var handle: Long = 0
    @Volatile private var downloading = false

    /// True while a load is on the worker. The model is 1.1 GB, so a second
    /// `load` request has to wait for the first rather than queue another copy.
    @Volatile private var loadingModel = false
    @Volatile private var generateCancel = AtomicBoolean(false)

    /// The candidate's choice, sent with the load. True means "use the GPU when
    /// the phone has one", which is not the same as "this phone has one".
    @Volatile private var useGpu = true

    /// Whether the load in memory actually went to the GPU. Kept so the status
    /// can answer for the model that is running, not for one that might.
    @Volatile private var loadedOnGpu = false

    private fun modelDir(): File = File(context.filesDir, "models").apply { mkdirs() }

    private fun modelFile(): File = File(modelDir(), MODEL_FILE)

    fun setSink(sink: EventChannel.EventSink?) {
        events = sink
    }

    private fun emit(event: Map<String, Any?>) {
        main.post { events?.success(event) }
    }

    private fun emitError(message: String) {
        emit(mapOf("type" to "error", "message" to message))
    }

    private fun sha256Of(file: File): String {
        val digest = MessageDigest.getInstance("SHA-256")
        file.inputStream().use { input ->
            val buffer = ByteArray(1 shl 16)
            while (true) {
                val read = input.read(buffer)
                if (read <= 0) break
                digest.update(buffer, 0, read)
            }
        }
        return digest.digest().joinToString("") { "%02x".format(it) }
    }

    private fun isInstalled(): Boolean {
        val file = modelFile()
        return file.exists() && file.length() == MODEL_BYTES
    }

    private fun status(): Map<String, Any?> {
        val supported = NativeLlm.ensureLoaded() &&
            NativeLlm.probe(context.applicationInfo.nativeLibraryDir)
        val file = modelFile()
        val gpuAvailable = supported && NativeLlm.gpu() == 1
        return mapOf(
            "supported" to supported,
            // What the phone can do, and what it is doing: the settings switch is
            // only offered where the backend registered, and the card says which
            // processor the loaded model is on.
            "gpuAvailable" to gpuAvailable,
            "gpu" to if (handle != 0L) loadedOnGpu else (gpuAvailable && useGpu),
            "abi" to (Build.SUPPORTED_ABIS.firstOrNull() ?: "unknown"),
            "loaded" to (handle != 0L),
            "installed" to isInstalled(),
            "bytes" to (if (file.exists()) file.length() else 0L),
            "expectedBytes" to MODEL_BYTES,
            "downloading" to downloading,
            "path" to file.absolutePath,
            "error" to NativeLlm.loadError,
        )
    }

    fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "status" -> result.success(status())
            "install" -> {
                if (downloading) {
                    result.error("busy", "A download is already running.", null)
                    return
                }
                if (isInstalled()) {
                    result.success(status())
                    return
                }
                downloading = true
                result.success(status())
                worker.execute { download() }
            }
            "cancelInstall" -> {
                downloading = false
                result.success(status())
            }
            "delete" -> {
                unload()
                val file = modelFile()
                val removed = file.delete()
                File(modelDir(), MODEL_FILE + ".part").delete()
                result.success(mapOf("removed" to removed, "status" to status()))
            }
            "load" -> {
                if (handle != 0L) {
                    result.success(status())
                    return
                }
                if (loadingModel) {
                    // Already reading the file. Acknowledging is the whole job:
                    // the "loaded" event is what the Dart side waits for.
                    result.success(mapOf("started" to true))
                    return
                }
                if (!isInstalled()) {
                    result.error("missing", "The tutor model is not installed.", null)
                    return
                }
                // The candidate's choice travels with the load, because that is
                // the moment the layers are placed.
                useGpu = call.argument<Boolean>("gpu") ?: useGpu
                loadingModel = true
                result.success(mapOf("started" to true))
                worker.execute { loadModel() }
            }
            "generate" -> {
                val prompt = call.argument<String>("prompt").orEmpty()
                val maxTokens = call.argument<Number>("maxTokens")?.toInt() ?: 320
                val temp = call.argument<Number>("temp")?.toFloat() ?: 0f
                val topK = call.argument<Number>("topK")?.toInt() ?: 40
                val topP = call.argument<Number>("topP")?.toFloat() ?: 0.95f
                if (prompt.isBlank()) {
                    result.error("empty", "There is nothing to ask.", null)
                    return
                }
                if (handle == 0L) {
                    result.error("not_loaded", "The tutor has not been loaded.", null)
                    return
                }
                result.success(true)
                worker.execute { generate(prompt, maxTokens, temp, topK, topP) }
            }
            "cancelGenerate" -> {
                generateCancel.set(true)
                if (handle != 0L) NativeLlm.cancel(handle)
                result.success(true)
            }
            "unload" -> {
                unload()
                result.success(status())
            }
            else -> result.notImplemented()
        }
    }

    private fun loadModel() {
        try {
            if (handle != 0L) return
            emit(mapOf("type" to "loading"))
            if (!NativeLlm.ensureLoaded()) {
                emitError("The tutor engine could not be opened on this device.")
                return
            }
            val cores = Runtime.getRuntime().availableProcessors().coerceIn(2, 6)
            val started = System.currentTimeMillis()
            val loadedHandle =
                NativeLlm.load(modelFile().absolutePath, 2048, cores, useGpu)
            loadedOnGpu = useGpu && NativeLlm.gpu() == 1
            if (loadedHandle == 0L) {
                emitError("The model could not be loaded into memory.")
                return
            }
            handle = loadedHandle
            emit(
                mapOf(
                    "type" to "loaded",
                    "millis" to (System.currentTimeMillis() - started),
                    "cores" to cores,
                ),
            )
        } finally {
            // Whatever happened, the next tap may ask again.
            loadingModel = false
        }
    }

    private fun generate(prompt: String, maxTokens: Int, temp: Float, topK: Int, topP: Float) {
        generateCancel.set(false)
        val started = System.currentTimeMillis()
        // Counted here rather than guessed from characters: a tokens-per-second
        // figure that is estimated is not a measurement, and this is the number
        // that decides whether the tutor feels usable on a phone.
        var tokens = 0
        // Reading the question and writing the answer are different speeds by
        // an order of magnitude on a phone, so they are timed apart. One number
        // that divides answer tokens by the whole call is a number that says
        // "1.7 tokens/s" about an engine that writes at eight.
        var firstTokenAt = 0L
        val sink = LlmTokenSink { text ->
            if (tokens == 0) firstTokenAt = System.currentTimeMillis()
            tokens += 1
            if (!generateCancel.get()) emit(mapOf("type" to "token", "text" to text))
        }
        val text = NativeLlm.generate(handle, prompt, maxTokens, temp, topK, topP, sink)
        emit(
            mapOf(
                "type" to "done",
                "text" to text,
                "millis" to (System.currentTimeMillis() - started),
                "tokens" to tokens,
                "firstTokenMillis" to (if (firstTokenAt == 0L) 0L else firstTokenAt - started),
                "cancelled" to generateCancel.get(),
            ),
        )
    }

    /// Frees everything when the activity goes away, so a candidate who leaves
    /// the app is not still holding a loaded model in memory.
    fun dispose() {
        downloading = false
        generateCancel.set(true)
        val current = handle
        handle = 0
        if (current != 0L) {
            NativeLlm.cancel(current)
            worker.execute { NativeLlm.free(current) }
        }
        worker.shutdown()
    }

    private fun unload() {
        val current = handle
        handle = 0
        if (current != 0L) {
            worker.execute {
                NativeLlm.free(current)
                emit(mapOf("type" to "unloaded"))
            }
        }
    }

    private fun download() {
        val target = modelFile()
        val part = File(modelDir(), MODEL_FILE + ".part")
        part.delete()
        emit(mapOf("type" to "download", "received" to 0L, "total" to MODEL_BYTES))
        var connection: HttpURLConnection? = null
        try {
            connection = URL(MODEL_URL).openConnection() as HttpURLConnection
            connection.instanceFollowRedirects = true
            connection.connectTimeout = 20000
            connection.readTimeout = 60000
            connection.setRequestProperty("User-Agent", "asvab-coach-android")
            if (connection.responseCode !in 200..299) {
                throw IllegalStateException("HTTP " + connection.responseCode)
            }
            val digest = MessageDigest.getInstance("SHA-256")
            var received = 0L
            var lastReport = 0L
            connection.inputStream.use { input ->
                part.outputStream().use { output ->
                    val buffer = ByteArray(1 shl 16)
                    while (downloading) {
                        val read = input.read(buffer)
                        if (read <= 0) break
                        output.write(buffer, 0, read)
                        digest.update(buffer, 0, read)
                        received += read
                        if (received - lastReport > (4L shl 20)) {
                            lastReport = received
                            emit(
                                mapOf(
                                    "type" to "download",
                                    "received" to received,
                                    "total" to MODEL_BYTES,
                                ),
                            )
                        }
                    }
                }
            }
            if (!downloading) {
                part.delete()
                emit(mapOf("type" to "downloadCancelled"))
                return
            }
            if (received != MODEL_BYTES) {
                part.delete()
                emitError("The download stopped early (" + received + " of " + MODEL_BYTES + " bytes).")
                return
            }
            val got = digest.digest().joinToString("") { "%02x".format(it) }
            if (got != MODEL_SHA256) {
                part.delete()
                emitError("The file did not match the published checksum, so it was discarded.")
                return
            }
            target.delete()
            if (!part.renameTo(target)) {
                part.copyTo(target, overwrite = true)
                part.delete()
            }
            emit(mapOf("type" to "installed", "status" to status()))
        } catch (error: Exception) {
            part.delete()
            emitError(error.message ?: "The download failed.")
        } finally {
            downloading = false
            connection?.disconnect()
        }
    }
}
