import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the words we use to describe where a candidate's data lives.
///
/// The Android build once told every user that their name was 'stored in this
/// browser', which is copy written for the web target and is simply false on a
/// phone. Nobody noticed because no test looked at the words.
void main() {
  final screens = Directory('lib/screens')
      .listSync()
      .whereType<File>()
      .where((File f) => f.path.endsWith('.dart'))
      .toList();

  test('there are screens to check', () {
    expect(screens, isNotEmpty);
  });

  test('no screen calls the device a browser', () {
    final offenders = <String>[];
    for (final File file in screens) {
      final String source = file.readAsStringSync();
      if (source.toLowerCase().contains('browser')) {
        offenders.add(file.uri.pathSegments.last);
      }
    }
    expect(
      offenders,
      isEmpty,
      reason: 'Say "on this device": the app also ships as an Android build.',
    );
  });

  test('the onboarding line promises device storage, not browser storage', () {
    final String source = File('lib/screens/onboarding_screen.dart')
        .readAsStringSync();
    expect(source, contains('stored on this device'));
  });
}
