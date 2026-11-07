// The tutor's processor choice, run on the real phone.
//
// The widget tests cover the plumbing with a fake platform; what they cannot
// cover is the JNI call itself. `load` gained a fifth argument (the GPU choice)
// and a mismatch between the Kotlin declaration and the C++ signature would not
// be caught by the compiler on either side - it would be a crash or a wrong
// answer at runtime. This test loads the model on the CPU and then on the GPU
// through the same code path the app uses.
//
//   flutter test integration_test/gpu_load_test.dart -d <device-id>
//
// CAREFUL: this replaces the installed app with a debug build, and Android
// cannot install a debug build over a release one - the installer uninstalls
// first, which deletes the app's data: the 1.02 GB model, the downloaded voices
// and the candidate's history. Run it on a development install with a model
// already downloaded, never on the phone somebody is revising on. It is kept
// because it is the only test that exercises the JNI load call with both GPU
// choices.
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:asvab_guard_coach/core/tutor.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('the model loads on the CPU when the GPU is switched off, and on '
      'the GPU when it is on', (WidgetTester tester) async {
    final TutorService tutor = TutorService();
    await tutor.initialise();

    expect(tutor.status.supported, isTrue, reason: 'the arm64 engine opened');
    expect(tutor.status.installed, isTrue, reason: 'the model is on the phone');
    // ignore: avoid_print
    print(
      'GPU check: available=${tutor.status.gpuAvailable} '
      'gpu=${tutor.status.gpu} abi=${tutor.status.abi}',
    );

    const String prompt = 'Reply with the single word READY.';

    // Off: the same native load call, with use_gpu false.
    await tutor.setUseGpu(false);
    expect(tutor.useGpu, isFalse);
    final String cpuAnswer = await tutor.ask(prompt, maxTokens: 12);
    // ignore: avoid_print
    print(
      'GPU check CPU: ${cpuAnswer.length} chars, '
      'load=${tutor.lastLoadMillis} ms, error=${tutor.error}',
    );
    expect(tutor.error, isNull);
    expect(cpuAnswer, isNotEmpty);

    // On: the layers move to Vulkan, which is the JNI argument this test exists
    // for.
    if (tutor.status.gpuAvailable) {
      await tutor.setUseGpu(true);
      expect(tutor.useGpu, isTrue);
      final String gpuAnswer = await tutor.ask(prompt, maxTokens: 12);
      // ignore: avoid_print
      print(
        'GPU check GPU: ${gpuAnswer.length} chars, '
        'gpu=${tutor.status.gpu}, load=${tutor.lastLoadMillis} ms, '
        'error=${tutor.error}',
      );
      expect(tutor.error, isNull);
      expect(gpuAnswer, isNotEmpty);
      expect(tutor.status.gpu, isTrue);
    } else {
      // ignore: avoid_print
      print('GPU check: no Vulkan backend registered on this phone');
    }

    await tutor.unload();
  }, timeout: const Timeout(Duration(minutes: 8)));
}
