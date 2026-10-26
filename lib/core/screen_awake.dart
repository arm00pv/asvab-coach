import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Keeps the display awake while an exam is on screen.
///
/// A timed section is useless if the phone sleeps in the middle of it, and the
/// Flutter engine offers no way to set the window flag on its own. This talks to
/// a one-method channel implemented in MainActivity.
///
/// It needs no permission: FLAG_KEEP_SCREEN_ON is a window flag, not a wakelock,
/// so the app keeps its empty permission list. Everywhere else - web, desktop,
/// widget tests - it is a no-op that reports false.
abstract final class ScreenAwake {
  static const MethodChannel _channel = MethodChannel('asvabcoach/screen');

  /// Turns the keep-awake flag on or off, reporting whether the platform
  /// honoured it.
  static Future<bool> keepOn(bool on) async {
    if (kIsWeb) return false;
    if (defaultTargetPlatform != TargetPlatform.android) return false;
    try {
      final result = await _channel.invokeMethod<bool>('keepScreenOn', on);
      return result ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
