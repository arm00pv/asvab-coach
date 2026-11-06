import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:asvab_guard_coach/core/speech.dart';

/// The three halves of one contract: Kotlin declares the token callback, C++
/// looks it up by name, and the shrinker is told not to rename it.
///
/// A release build on a phone failed here exactly once - R8 renamed the class,
/// GetMethodID returned null with a pending NoSuchMethodError, and the process
/// died on the next JNI return. None of the Dart tests, the analyzer or the
/// debug build could have caught it, so this test watches the files instead.
void main() {
  test('the tutor token callback survives shrinking', () {
    final String rules = File('android/app/proguard-rules.pro')
        .readAsStringSync();
    expect(rules, contains('com.arm00pv.asvabcoach.llm.LlmTokenSink'));
    expect(rules, contains('onToken(java.lang.String)'));

    final String gradle = File('android/app/build.gradle.kts')
        .readAsStringSync();
    expect(gradle, contains('proguard-rules.pro'));

    final String bridge = File('android/app/src/main/cpp/llm_bridge.cpp')
        .readAsStringSync();
    expect(bridge, contains('"onToken", "(Ljava/lang/String;)V"'));

    final String kotlin = File(
      'android/app/src/main/kotlin/com/arm00pv/asvabcoach/llm/LlmTutor.kt',
    ).readAsStringSync();
    expect(kotlin, contains('fun onToken(text: String)'));
    expect(
      kotlin,
      contains('LlmTokenSink'),
      reason: 'the sink must be a named class R8 can be told about',
    );
  });

  test('the volume a silent voice is blamed on can be raised from the app', () {
    // Two halves of one fix: VoiceTts.kt refuses to play at media volume zero
    // and says so, and the app has to be able to raise it from the screen that
    // reports it. If either name or wording drifts, the button turns into advice.
    final String voice = File(
      'android/app/src/main/kotlin/com/arm00pv/asvabcoach/voice/VoiceTts.kt',
    ).readAsStringSync();
    expect(voice, contains('media volume is zero'));
    final RegExp sentence = RegExp(
      r'"The media volume on this phone is at zero,[^"]*"',
    );
    final Match? found = sentence.firstMatch(voice);
    expect(found, isNotNull, reason: 'the engine reports this in words');
    expect(
      SpeechService.isVolumeProblem(found!.group(0)),
      isTrue,
      reason: 'the screens must recognise the sentence the engine writes',
    );

    final String activity = File(
      'android/app/src/main/kotlin/com/arm00pv/asvabcoach/MainActivity.kt',
    ).readAsStringSync();
    expect(activity, contains('"turnUpVolume"'));
    expect(activity, contains('AudioManager.FLAG_SHOW_UI'));

    // And the channel method the Dart side calls has to be that same name.
    final String backend = File('lib/core/speech_backend_io.dart')
        .readAsStringSync();
    expect(backend, contains("'turnUpVolume'"));
  });

  test('the bridge clears a failed method lookup instead of dying', () {
    final String bridge = File('android/app/src/main/cpp/llm_bridge.cpp')
        .readAsStringSync();
    expect(
      bridge,
      contains('ExceptionClear'),
      reason: 'a pending NoSuchMethodError is rethrown when the frame returns',
    );
  });
}
