package com.arm00pv.asvabcoach

import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.view.WindowManager
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.io.File
import java.io.IOException
import java.net.HttpURLConnection
import java.net.URL

/// The stock Flutter activity plus two small channels: keeping the display on
/// during a timed section, and getting a newer build onto the phone.
///
/// Neither needs a dangerous permission. FLAG_KEEP_SCREEN_ON is a window flag,
/// not a wakelock, and the updater uses the app's own cache directory through a
/// FileProvider, so the app still asks for no storage access. It does declare
/// INTERNET - it is the one thing that talks to the network, and only about
/// itself.
class MainActivity : FlutterActivity() {
    private val main = Handler(Looper.getMainLooper())

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

        MethodChannel(messenger, "asvabcoach/update").setMethodCallHandler { call, result ->
            when (call.method) {
                "version" -> result.success(versionName())
                "check" -> offMainThread(result) { checkLatestRelease() }
                "install" -> {
                    val url = call.argument<String>("url")
                    val tag = call.argument<String>("tag") ?: "update"
                    val expected = (call.argument<Number>("bytes"))?.toLong() ?: 0L
                    if (url.isNullOrBlank()) {
                        result.error("bad_args", "No download address was given.", null)
                    } else {
                        offMainThread(result) { downloadAndInstall(url, tag, expected) }
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        // Never leave the flag set behind us.
        window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        super.onDestroy()
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
    ): Map<String, Any?> {
        val directory = File(cacheDir, "updates").apply { mkdirs() }
        val safeTag = tag.replace(Regex("[^A-Za-z0-9._-]"), "_")
        val target = File(directory, "asvab-coach-$safeTag.apk")
        // A half-finished download from an earlier attempt is worse than none:
        // Android answers it with a bare "App not installed". Throw it away
        // rather than handing it to the installer.
        val complete = target.exists() &&
            target.length() > 0L &&
            (expectedBytes <= 0L || target.length() == expectedBytes)
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
                target.delete()
                throw IOException(
                    "The download stopped early (" + target.length() + " of " +
                        expectedBytes + " bytes).",
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
}
