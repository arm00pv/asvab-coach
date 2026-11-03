import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

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
