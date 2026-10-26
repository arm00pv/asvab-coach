// The core loop, run on a real device.
//
// The widget tests in test/ drive the same journey against a mocked
// SharedPreferences store, which proves the logic but not the plugin. This one
// runs on Android: it uses the real plugin, the real app-private file, the real
// font stack and the real touch input, and it reads the history back out of the
// store afterwards to prove the round trip.
//
//   flutter test integration_test/journey_test.dart -d <device-id>
//
// It starts by clearing this app's saved data, so run it against a development
// install, not against a phone somebody is using to revise.
import 'package:asvab_guard_coach/app.dart';
import 'package:asvab_guard_coach/core/screen_awake.dart';
import 'package:asvab_guard_coach/engines/exam_builder.dart';
import 'package:asvab_guard_coach/screens/exam_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> settle(WidgetTester tester, {int pumps = 8}) async {
  for (var i = 0; i < pumps; i++) {
    await tester.pump(const Duration(milliseconds: 150));
  }
}

/// The "3 of 10" counter in the question header.
(int, int)? counter() {
  final pattern = RegExp(r'^(\d+) of (\d+)$');
  for (final element
      in find.textContaining(RegExp(r'^\d+ of \d+$')).evaluate()) {
    final data = (element.widget as Text).data;
    final match = pattern.firstMatch(data ?? '');
    if (match != null) {
      return (int.parse(match.group(1)!), int.parse(match.group(2)!));
    }
  }
  return null;
}

Future<void> answerSection(WidgetTester tester, int section) async {
  await tester.tap(find.text('Begin section'));
  await settle(tester);

  var answered = 0;
  for (var guard = 0; guard < 40; guard++) {
    final at = counter();
    if (at == null) break;
    await tester.sendKeyEvent(
      (answered + section).isEven
          ? LogicalKeyboardKey.digit1
          : LogicalKeyboardKey.digit4,
    );
    await settle(tester, pumps: 2);
    answered++;
    if (at.$1 >= at.$2) break;
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await settle(tester, pumps: 2);
  }
  expect(answered, greaterThan(0), reason: 'section $section had no questions');

  final label = find.text('Submit exam').evaluate().isNotEmpty
      ? 'Submit exam'
      : 'Finish section';
  await tester.tap(find.text(label).last);
  await settle(tester);
  await tester.tap(find.text(label).last);
  await settle(tester);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('a full journey on this device, with real storage', (
    tester,
  ) async {
    // Real plugin, real file. Start from nothing so the assertions mean
    // something.
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    final state = AppState();
    await state.init();
    expect(state.loading, isFalse);
    expect(state.attempts, isEmpty);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const AsvabCoachApp(),
      ),
    );
    await settle(tester);

    // Onboarding, on the device keyboard.
    expect(find.text('Your ASVAB coach'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await settle(tester);
    await tester.enterText(find.byType(TextField).first, 'Device Soldier');
    await settle(tester);
    await tester.tap(find.text('Continue'));
    await settle(tester);
    await tester.tap(find.text('Continue'));
    await settle(tester);
    await tester.tap(find.text('Start training'));
    await settle(tester);
    expect(find.textContaining('Hello, Device Soldier'), findsOneWidget);

    // The goal must be in the real store now.
    final afterOnboarding = AppState();
    await afterOnboarding.init();
    expect(afterOnboarding.onboarded, isTrue);
    expect(afterOnboarding.goal?.displayName, 'Device Soldier');

    // A placement diagnostic, answered by keyboard.
    await tester.tap(find.text('Test'));
    await settle(tester);
    await tester.tap(find.text('Diagnostic'));
    await settle(tester);

    var sections = 0;
    while (sections < 12 && find.text('Begin section').evaluate().isNotEmpty) {
      await answerSection(tester, sections);
      sections++;
    }
    expect(sections, 9);
    await settle(tester, pumps: 16);
    expect(find.text('Line scores'), findsOneWidget);

    // The scored attempt has to be on disk, not just in memory.
    final reloaded = AppState();
    await reloaded.init();
    expect(reloaded.attempts, hasLength(1));
    expect(reloaded.lastReport, isNotNull);
    expect(reloaded.lastReport!.afqtPercentile, inInclusiveRange(1, 99));
    expect(reloaded.dueReviewCount, greaterThanOrEqualTo(0));

    // Reviewing what was missed is the point of the whole loop.
    final review = find.text('Review every answer');
    await tester.ensureVisible(review);
    await settle(tester);
    await tester.tap(review);
    await settle(tester);
    expect(find.text('Review'), findsOneWidget);
    expect(
      find.text('Missed').evaluate().isNotEmpty ||
          find.text('Correct').evaluate().isNotEmpty,
      isTrue,
    );
  });

  // The two behaviours that only exist on the device: the platform channel that
  // keeps the screen on, and the snapshot that survives the app being sent to
  // the background. Neither can be proved against a mock.
  testWidgets('the platform keeps the screen awake, and a backgrounded exam is '
      'still there afterwards', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    final awake = await ScreenAwake.keepOn(true);
    expect(
      awake,
      isTrue,
      reason: 'MainActivity should answer asvabcoach/screen',
    );
    expect(await ScreenAwake.keepOn(false), isTrue);

    final state = AppState();
    await state.init();
    final exam = ExamBuilder.section(Subtest.ar, seed: 5);
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(home: ExamScreen(exam: exam)),
      ),
    );
    await settle(tester);
    await tester.tap(find.text('Begin section'));
    await settle(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await settle(tester, pumps: 2);

    // Sent to the background the way a phone call does it.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await settle(tester, pumps: 2);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await settle(tester, pumps: 2);

    final reopened = AppState();
    await reopened.init();
    expect(reopened.hasPendingAttempt, isTrue);
    expect(reopened.pendingAttempt!.answered, 1);
    expect(reopened.pendingAttempt!.sections.first.subtest, Subtest.ar);

    // And the runner that comes of it is the same attempt, not a fresh one.
    final rebuilt = reopened.pendingExam;
    expect(rebuilt, isNotNull);
    expect(rebuilt!.allQuestions.first.id, exam.allQuestions.first.id);
    expect(rebuilt.allQuestions.first.order, exam.allQuestions.first.order);
  });
}
