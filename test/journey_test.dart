import 'package:asvab_guard_coach/app.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The whole candidate journey, driven the way a candidate drives it.
///
/// Every other test in the suite pumps one screen. This one goes from a fresh
/// browser to a scored attempt, a review, and back to the shell, answering by
/// keyboard rather than synthetic taps so the runner's keyboard support is
/// exercised too. Its job is to catch the seams: routing that leaves the user
/// trapped, state that does not persist, a report that never arrives.
Future<void> settle(WidgetTester tester, {int pumps = 6}) async {
  for (var i = 0; i < pumps; i++) {
    await tester.pump(const Duration(milliseconds: 120));
  }
}

Future<AppState> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1400, 2200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  await tester.pumpWidget(
    ChangeNotifierProvider<AppState>.value(
      value: state,
      child: const AsvabCoachApp(),
    ),
  );
  await settle(tester);
  return state;
}

Future<void> completeOnboarding(WidgetTester tester) async {
  await tester.tap(find.text('Continue'));
  await settle(tester);
  await tester.enterText(find.byType(TextField).first, 'Journey Soldier');
  await settle(tester);
  await tester.tap(find.text('Continue'));
  await settle(tester);
  await tester.tap(find.text('Continue'));
  await settle(tester);
  await tester.tap(find.text('Start training'));
  await settle(tester);
}

/// The "3 of 10" counter in the question header, as (position, total).
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

/// Answers every question in the section on screen, then finishes the section.
///
/// Choices alternate so the report ends up with both hits and misses, which is
/// what makes the review step worth asserting on. The header carries its own
/// finish action, so the footer button is the later of the two matches and the
/// dialog's confirm button is the later again.
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
  expect(answered, greaterThan(1), reason: 'section $section had no questions');

  final label = find.text('Submit exam').evaluate().isNotEmpty
      ? 'Submit exam'
      : 'Finish section';
  await tester.tap(find.text(label).last);
  await settle(tester);
  await tester.tap(find.text(label).last);
  await settle(tester);
}

Future<int> runDiagnostic(WidgetTester tester) async {
  await tester.tap(find.text('Test'));
  await settle(tester);
  expect(find.text('Diagnostic'), findsOneWidget);
  await tester.tap(find.text('Diagnostic'));
  await settle(tester);

  var sections = 0;
  while (sections < 12 && find.text('Begin section').evaluate().isNotEmpty) {
    await answerSection(tester, sections);
    sections++;
  }
  await settle(tester, pumps: 12);
  return sections;
}

void main() {
  testWidgets('a candidate can go from first launch to a review', (
    tester,
  ) async {
    await pumpApp(tester);
    await completeOnboarding(tester);
    expect(find.textContaining('Hello, Journey Soldier'), findsOneWidget);

    final sections = await runDiagnostic(tester);
    expect(sections, 9, reason: 'the diagnostic covers all nine subtests');

    // The report has to arrive on its own.
    expect(tester.takeException(), isNull);
    expect(find.text('Line scores'), findsOneWidget);

    // Review every answer, and check the review is populated.
    final reviewButton = find.text('Review every answer');
    await tester.ensureVisible(reviewButton);
    await settle(tester);
    await tester.tap(reviewButton);
    await settle(tester);
    expect(find.text('Review'), findsOneWidget);
    expect(
      find.text('Correct').evaluate().isNotEmpty ||
          find.text('Missed').evaluate().isNotEmpty,
      isTrue,
      reason: 'the review shows no scored items',
    );

    // Back to the report, then back to the app: the candidate must not be
    // trapped behind the scored report.
    await tester.pageBack();
    await settle(tester);
    expect(find.text('Line scores'), findsOneWidget);
    await tester.pageBack();
    await settle(tester, pumps: 12);
    expect(tester.takeException(), isNull);
    expect(
      find.text('Line scores'),
      findsNothing,
      reason: 'going back from the report returned to the report again',
    );
    expect(
      find.text('Home'),
      findsOneWidget,
      reason:
          'going back from the report should land in the app, not on a spinner',
    );
  });

  testWidgets('the attempt survives a reload and drives the next step', (
    tester,
  ) async {
    await pumpApp(tester);
    await completeOnboarding(tester);
    final sections = await runDiagnostic(tester);
    expect(sections, 9);

    // The state is in the local store, so a fresh AppState sees it.
    final reloaded = AppState();
    await reloaded.init();
    expect(reloaded.attempts, isNotEmpty, reason: 'attempt was not persisted');
    expect(reloaded.onboarded, isTrue);
    expect(reloaded.lastReport, isNotNull);

    // Back to the shell; a scored attempt now unlocks the weak-spot drill.
    await tester.pageBack();
    await settle(tester, pumps: 12);
    await tester.tap(find.text('Test'));
    await settle(tester);
    expect(find.text('Built from your five weakest skills.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
