import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Thrown when the check itself could not be completed. Kept distinct from
/// "there is no newer release", which is a perfectly good answer.
class UpdateException implements Exception {
  const UpdateException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// A published release that is newer than the one installed.
class AppUpdate {
  const AppUpdate({
    required this.tag,
    required this.name,
    required this.url,
    required this.bytes,
    this.digest,
    this.published,
  });

  final String tag;
  final String name;

  /// Direct address of the universal APK in the release.
  final String? url;
  final int bytes;

  /// The SHA-256 GitHub publishes for the asset, as "sha256:...". When it is
  /// there the download is verified against it, so a truncated or rewritten
  /// file is refused instead of installed.
  final String? digest;
  final String? published;

  String get version => AppVersions.clean(tag);

  String get sizeLabel {
    if (bytes <= 0) return '';
    final mb = bytes / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }
}

/// Version arithmetic, kept free of the platform so it can be tested.
abstract final class AppVersions {
  /// "v1.2.0" or "1.2.0+3" to "1.2.0".
  static String clean(String raw) {
    var text = raw.trim();
    if (text.startsWith('v') || text.startsWith('V')) {
      text = text.substring(1);
    }
    final plus = text.indexOf('+');
    if (plus >= 0) text = text.substring(0, plus);
    return text;
  }

  /// True when [candidate] is a later release than [installed]. Compares each
  /// dotted field as a number, so 1.10.0 beats 1.9.9 - string order would not.
  static bool isNewer(String candidate, String installed) {
    final a = _fields(clean(candidate));
    final b = _fields(clean(installed));
    final length = a.length > b.length ? a.length : b.length;
    for (var i = 0; i < length; i++) {
      final left = i < a.length ? a[i] : 0;
      final right = i < b.length ? b[i] : 0;
      if (left != right) return left > right;
    }
    return false;
  }

  static List<int> _fields(String version) => <int>[
    for (final part in version.split('.')) int.tryParse(part) ?? 0,
  ];
}

/// The update channel.
///
/// Android only, and deliberately so: the same code runs on the web build,
/// where there is nothing to install and no permission to ask for.
abstract final class UpdateService {
  static const MethodChannel _channel = MethodChannel('asvabcoach/update');

  static bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// The version string of the running build, e.g. "1.2.0".
  static Future<String?> installedVersion() async {
    if (!isSupported) return null;
    try {
      return await _channel.invokeMethod<String>('version');
    } catch (error) {
      // No engine, no channel, or no binding at all: plain unit tests construct
      // this state without a widget binding, and asking the platform for a
      // version is not worth failing a boot over.
      debugPrint('ASVAB coach: could not read the app version: $error');
      return null;
    }
  }

  /// What is published, if a newer release exists.
  static Future<AppUpdate?> check() async {
    if (!isSupported) return null;
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>('check');
      if (result == null) return null;
      final tag = (result['tag'] as String?) ?? '';
      if (tag.isEmpty) return null;
      return AppUpdate(
        tag: tag,
        name: (result['name'] as String?) ?? tag,
        url: result['url'] as String?,
        bytes: (result['bytes'] as num?)?.toInt() ?? 0,
        digest: (result['digest'] as String?)?.trim().isEmpty ?? true
            ? null
            : (result['digest'] as String).trim(),
        published: result['published'] as String?,
      );
    } on MissingPluginException {
      // No updater on this host: the web build has nothing to install.
      return null;
    } on PlatformException catch (error) {
      throw UpdateException(
        error.message ?? 'The update check could not be completed.',
      );
    } catch (error) {
      // Reached only without an engine behind the channel.
      debugPrint('ASVAB coach: update channel unavailable: $error');
      return null;
    }
  }

  /// Downloads [update] and hand it to Android's installer.
  ///
  /// Returns true once the installer has been asked to open. The install itself
  /// is the system's business: it shows its own confirmation, and on the first
  /// time asks the person to allow installs from this app.
  static Future<bool> install(AppUpdate update) async {
    if (!isSupported) return false;
    final url = update.url;
    if (url == null || url.isEmpty) return false;
    try {
      await _channel.invokeMethod<Map<dynamic, dynamic>>('install', <
        String,
        Object
      >{
        'url': url,
        'tag': update.tag,
        // The expected size lets the download be thrown away rather than handed
        // to the installer half-finished, and the digest proves it is the file
        // GitHub published rather than something that arrived in its place.
        'bytes': update.bytes,
        if (update.digest != null) 'digest': update.digest!,
      });
      return true;
    } catch (error) {
      debugPrint('ASVAB coach: install could not start: $error');
      return false;
    }
  }
}
