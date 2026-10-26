package com.arm00pv.asvabcoach

import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/// The stock Flutter activity plus one method channel: keeping the display on
/// while the candidate is in a timed section.
///
/// FLAG_KEEP_SCREEN_ON is a window flag rather than a wakelock, so this adds no
/// permission to the manifest - the app still ships with an empty permission
/// list, as its privacy note promises.
class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "asvabcoach/screen",
        ).setMethodCallHandler { call, result ->
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
    }

    override fun onDestroy() {
        // Never leave the flag set behind us.
        window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        super.onDestroy()
    }
}
