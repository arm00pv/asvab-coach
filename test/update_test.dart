import 'package:asvab_guard_coach/core/app_update.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The update check, driven through the same channel the phone uses.
///
/// The one thing this app says out loud about the network is that updating is
/// the only reason it touches it, so the channel is faked here and every path is
/// walked: a newer release, the same release, a failure, and a payload that does
/// not parse.
const MethodChannel channel = MethodChannel('asvabcoach/update');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('version arithmetic', () {
    test('strips the decorations a tag carries', () {
      expect(AppVersions.clean('v1.2.0'), '1.2.0');
      expect(AppVersions.clean(' 1.2.0 '), '1.2.0');
      expect(AppVersions.clean('1.2.0+4'), '1.2.0');
    });

    test('compares field by field, not as text', () {
      expect(AppVersions.isNewer('v1.2.0', '1.1.1'), isTrue);
      expect(AppVersions.isNewer('v1.1.1', '1.2.0'), isFalse);
      expect(AppVersions.isNewer('v1.10.0', '1.9.9'), isTrue);
      expect(AppVersions.isNewer('v2.0.0', '1.99.99'), isTrue);
      expect(AppVersions.isNewer('v1.2.0', '1.2.0'), isFalse);
      // A build number in the installed version must not look like a release.
      expect(AppVersions.isNewer('v1.2.0', '1.2.0+9'), isFalse);
    });
  });

  group('the update channel', () {
    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    void answer(Map<String, Object?>? release) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            switch (call.method) {
              case 'version':
                return '1.1.1';
              case 'check':
                return release;
              case 'install':
                lastInstall = call.arguments as Map<Object?, Object?>?;
                return <String, Object?>{
                  'path': '/cache/update.apk',
                  'bytes': 12,
                };
            }
            return null;
          });
    }

    test('reads the published release', () async {
      answer(<String, Object?>{
        'tag': 'v1.2.0',
        'name': 'v1.2.0 - notes',
        'url': 'https://example.test/asvab-coach-1.2.0-universal.apk',
        'bytes': 54800000,
        'published': '2026-09-01T00:00:00Z',
      });
      final update = await UpdateService.check();
      expect(update, isNotNull);
      expect(update!.version, '1.2.0');
      expect(update.sizeLabel, '52.3 MB');
      expect(await UpdateService.installedVersion(), '1.1.1');
    });

    test('an empty payload means there is nothing to offer', () async {
      answer(null);
      expect(await UpdateService.check(), isNull);
    });

    test(
      'hands the download address and its checksum to the installer',
      () async {
        lastInstall = null;
        answer(<String, Object?>{
          'tag': 'v1.2.0',
          'url': 'https://example.test/universal.apk',
          'bytes': 1,
          'digest': 'sha256:abc123',
        });
        final update = await UpdateService.check();
        expect(await UpdateService.install(update!), isTrue);
        expect(lastInstall?['url'], 'https://example.test/universal.apk');
        expect(lastInstall?['tag'], 'v1.2.0');
        // The published checksum travels with the download, so the platform can
        // refuse a file that is not the one GitHub served.
        expect(lastInstall?['digest'], 'sha256:abc123');
      },
    );

    test('a release with no published checksum still installs', () async {
      lastInstall = null;
      answer(<String, Object?>{
        'tag': 'v1.2.0',
        'url': 'https://example.test/universal.apk',
        'bytes': 1,
        'digest': '',
      });
      final update = await UpdateService.check();
      expect(update!.digest, isNull);
      expect(await UpdateService.install(update), isTrue);
      expect(lastInstall?.containsKey('digest'), isFalse);
    });
  });

  group('the app state around an update', () {
    test('offers a newer release and stops offering the same one', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      var release = <String, Object?>{
        'tag': 'v1.2.0',
        'url': 'https://example.test/universal.apk',
        'bytes': 100,
      };
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            switch (call.method) {
              case 'version':
                return '1.1.1';
              case 'check':
                return release;
            }
            return null;
          });
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null);
      });

      final state = AppState();
      await state.init();
      await state.checkForUpdates();
      expect(state.availableUpdate?.version, '1.2.0');
      expect(state.updateError, isNull);

      // Once the running build is the newest, the offer goes away.
      release = <String, Object?>{
        'tag': 'v1.1.1',
        'url': 'https://example.test/old.apk',
        'bytes': 100,
      };
      await state.checkForUpdates();
      expect(state.availableUpdate, isNull);
    });

    test(
      'a failing server is reported only when the candidate asked',
      () async {
        SharedPreferences.setMockInitialValues(<String, Object>{});
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (call) async {
              if (call.method == 'version') return '1.1.1';
              throw PlatformException(
                code: 'update_failed',
                message: 'offline',
              );
            });
        addTearDown(() {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(channel, null);
        });

        final state = AppState();
        await state.init();
        await state.checkForUpdates(silent: true);
        expect(state.updateError, isNull);

        await state.checkForUpdates();
        expect(state.updateError, isNotNull);
        expect(state.availableUpdate, isNull);
      },
    );

    test('the automatic check is remembered', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final state = AppState();
      await state.init();
      expect(state.autoCheckUpdates, isTrue);
      await state.setAutoCheckUpdates(false);
      final reloaded = AppState();
      await reloaded.init();
      expect(reloaded.autoCheckUpdates, isFalse);
    });
  });
}

Map<Object?, Object?>? lastInstall;
