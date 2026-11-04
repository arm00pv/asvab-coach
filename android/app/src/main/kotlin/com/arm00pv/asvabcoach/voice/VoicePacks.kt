package com.arm00pv.asvabcoach.voice

import android.content.Context
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream
import java.net.HttpURLConnection
import java.net.URL
import java.security.MessageDigest
import java.util.concurrent.Executors
import java.util.zip.GZIPInputStream

/// Downloads, checks and unpacks a voice pack.
///
/// A pack is a gzipped tar: model.onnx, tokens.txt, optionally voices.bin, and a
/// trimmed espeak-ng-data directory. It is verified against a pinned length and
/// SHA-256 before it is unpacked, for the same reason the tutor's model is - a
/// truncated voice file does not fail loudly, it speaks nonsense - and because
/// the archive is unpacked into the app's own storage, where a hostile file
/// could otherwise write wherever it liked.
class VoicePacks(private val context: Context) {
    private val worker = Executors.newSingleThreadExecutor()

    @Volatile private var downloading = ""
    @Volatile private var cancelled = false

    fun root(): File = File(context.filesDir, "voices").apply { mkdirs() }

    fun dir(id: String): File = File(root(), id)

    /// A pack counts as installed when its three required files are there.
    fun isInstalled(id: String): Boolean {
        val base = dir(id)
        return File(base, "model.onnx").isFile &&
            File(base, "tokens.txt").isFile &&
            File(base, "espeak-ng-data").isDirectory
    }

    fun sizeOf(id: String): Long =
        dir(id).walkTopDown().filter { it.isFile }.map { it.length() }.sum()

    fun isDownloading(id: String): Boolean = downloading == id

    fun cancel() {
        cancelled = true
    }

    fun delete(id: String): Boolean = dir(id).deleteRecursively()

    /// Downloads and installs [id]. [onProgress] is called with bytes so far and
    /// the expected total; [onDone] with an empty string on success or a sentence
    /// to show the candidate.
    fun install(
        id: String,
        url: String,
        expectedBytes: Long,
        expectedSha256: String,
        onProgress: (Long, Long) -> Unit,
        onDone: (String) -> Unit,
    ) {
        if (downloading.isNotEmpty()) {
            onDone("A voice is already downloading.")
            return
        }
        downloading = id
        cancelled = false
        worker.execute {
            var failure = ""
            val part = File(root(), "$id.part")
            val archive = File(root(), "$id.tar.gz")
            try {
                download(url, expectedBytes, part) { received, total ->
                    onProgress(received, total)
                }
                if (cancelled) {
                    part.delete()
                    failure = ""
                } else {
                    val digest = sha256Of(part)
                    if (expectedBytes > 0 && part.length() != expectedBytes) {
                        failure = "The voice download is incomplete. Try again."
                    } else if (digest != expectedSha256.lowercase()) {
                        failure = "The voice download did not match its checksum."
                    } else {
                        part.renameTo(archive)
                        val scratch = File(root(), "$id.unpacking")
                        scratch.deleteRecursively()
                        extractTarGz(archive, scratch)
                        val target = dir(id)
                        target.deleteRecursively()
                        if (!scratch.renameTo(target)) {
                            scratch.copyRecursively(target, overwrite = true)
                            scratch.deleteRecursively()
                        }
                    }
                }
            } catch (error: Exception) {
                failure = "The voice could not be downloaded."
            } finally {
                part.delete()
                archive.delete()
                downloading = ""
                onDone(failure)
            }
        }
    }

    private fun download(
        url: String,
        expectedBytes: Long,
        destination: File,
        onProgress: (Long, Long) -> Unit,
    ) {
        val connection = (URL(url).openConnection() as HttpURLConnection).apply {
            connectTimeout = 20000
            readTimeout = 30000
            instanceFollowRedirects = true
            setRequestProperty("User-Agent", "asvab-coach")
        }
        connection.connect()
        if (connection.responseCode !in 200..299) {
            throw IOException("HTTP ${connection.responseCode}")
        }
        val total = if (expectedBytes > 0) expectedBytes else connection.contentLengthLong
        var received = 0L
        var lastReport = 0L
        destination.outputStream().use { output ->
            connection.inputStream.use { input ->
                val buffer = ByteArray(1 shl 16)
                while (true) {
                    if (cancelled) return
                    val read = input.read(buffer)
                    if (read <= 0) break
                    output.write(buffer, 0, read)
                    received += read
                    val now = System.currentTimeMillis()
                    if (now - lastReport > 120) {
                        lastReport = now
                        onProgress(received, total)
                    }
                }
            }
        }
        onProgress(received, total)
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

    /// Unpacks a gzipped tar without a native helper: gzip is in the JDK, and a
    /// tar is a sequence of 512-byte headers followed by the file's bytes.
    private fun extractTarGz(archive: File, target: File) {
        target.mkdirs()
        val root = target.canonicalFile
        GZIPInputStream(FileInputStream(archive)).use { input ->
            val header = ByteArray(512)
            while (true) {
                if (!readFully(input, header)) break
                if (header.all { it.toInt() == 0 }) break
                val rawName = String(header, 0, 100, Charsets.UTF_8)
                val name = rawName.substringBefore('\u0000').trimStart('.', '/')
                val sizeField = String(header, 124, 12, Charsets.UTF_8)
                    .substringBefore('\u0000').trim()
                val size = if (sizeField.isEmpty()) 0L else sizeField.toLong(8)
                val type = header[156].toInt().toChar()
                if (name.isNotEmpty()) {
                    val out = File(target, name).canonicalFile
                    if (!out.path.startsWith(root.path)) {
                        throw IOException("the archive tries to write outside itself")
                    }
                    when (type) {
                        '5' -> out.mkdirs()
                        '0', '\u0000' -> {
                            out.parentFile?.mkdirs()
                            FileOutputStream(out).use { output ->
                                copyN(input, output, size)
                            }
                        }
                        else -> skipN(input, size)
                    }
                } else {
                    skipN(input, size)
                }
                skipN(input, (512 - (size % 512)) % 512)
            }
        }
    }

    private fun readFully(input: InputStream, buffer: ByteArray): Boolean {
        var offset = 0
        while (offset < buffer.size) {
            val read = input.read(buffer, offset, buffer.size - offset)
            if (read <= 0) return false
            offset += read
        }
        return true
    }

    private fun copyN(input: InputStream, output: FileOutputStream, count: Long) {
        var remaining = count
        val buffer = ByteArray(1 shl 16)
        while (remaining > 0) {
            val read = input.read(buffer, 0, minOf(buffer.size.toLong(), remaining).toInt())
            if (read <= 0) break
            output.write(buffer, 0, read)
            remaining -= read
        }
    }

    private fun skipN(input: InputStream, count: Long) {
        var remaining = count
        while (remaining > 0) {
            val skipped = input.skip(remaining)
            if (skipped <= 0) {
                if (input.read() < 0) return
                remaining -= 1
            } else {
                remaining -= skipped
            }
        }
    }

    fun dispose() {
        cancelled = true
        worker.shutdown()
    }
}
