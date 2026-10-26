import 'package:asvab_guard_coach/app.dart';
import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/review_item.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/data/repos/storage.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/screens/settings_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The controls that change the candidate's own state.
///
/// Dark mode, export and erase all write to browser storage, and the review
/// session is the only thing that advances the spaced-repetition schedule. None
/// of them had a test before this file.
Future<void> settle(WidgetTester tester, {int pumps = 6}) async {
  for (var i = 0; i < pumps; i++) {
    await tester.pump(const Duration(milliseconds: 120));
  }
}

Future<AppState> freshState({
  Size size = const Size(1000, 1800),
  WidgetTester? tester,
}) async {
  tester?.view.physicalSize = size;
  tester?.view.devicePixelRatio = 1.0;
  tester?.view.reset;
  if (tester != null) addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  await state.setGoal(
    const GoalProfile(
      displayName: 'Control Soldier',
      targetAfqt: 60,
      targetGt: 110,
      targetMosCodes: <String>['68W'],
      targetDate: null,
      officerTrack: false,
      dailyMinutes: 30,
    ),
  );
  return state;
}

Future<void> seedAttempt(AppState state) async {
  final result = PersonaRunner.run(Personas.byId('ava'));
  await state.addAttempt(
    Attempt(
      id: 'seeded-attempt',
      kind: ExamKind.fullMock,
      startedAt: DateTime(2026, 4, 1, 9),
      finishedAt: DateTime(2026, 4, 1, 12),
      report: result.report,
      responses: const <QuestionResponse>[],
      questionIds: const <String>[],
      subtests: Subtest.administrationOrder,
    ),
    const <String, List<int>>{},
  );
}

Future<void> pumpSettings(WidgetTester tester, AppState state) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<AppState>.value(
      value: state,
      child: MaterialApp(
        theme: AppTheme.build(Brightness.light),
        home: const SettingsScreen(),
      ),
    ),
  );
  await settle(tester);
}

void main() {
  testWidgets('dark mode switches and is written to storage', (tester) async {
    final state = await freshState(tester: tester);
    await pumpSettings(tester, state);
    expect(state.darkMode, isFalse);

    await tester.tap(find.text('Dark mode'));
    await settle(tester);
    expect(state.darkMode, isTrue);

    final reloaded = await Storage.load();
    expect(reloaded.darkMode, isTrue, reason: 'the choice has to survive');
  });

  testWidgets('export puts the history on the clipboard', (tester) async {
    final state = await freshState(tester: tester);
    await seedAttempt(state);

    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await pumpSettings(tester, state);
    await tester.tap(find.text('Copy history as JSON'));
    await settle(tester);

    expect(copied, isNotNull, reason: 'nothing reached the clipboard');
    expect(copied, contains('seeded-attempt'));
    expect(find.text('History copied to the clipboard.'), findsOneWidget);
  });

  testWidgets('erase all data clears the store', (tester) async {
    final state = await freshState(tester: tester);
    await seedAttempt(state);
    expect(state.attempts, hasLength(1));

    await pumpSettings(tester, state);
    await tester.tap(find.text('Erase all data'));
    await settle(tester);
    expect(find.text('Erase everything?'), findsOneWidget);
    await tester.tap(find.text('Erase'));
    await settle(tester, pumps: 10);

    expect(state.attempts, isEmpty);
    final reloaded = await Storage.load();
    expect(reloaded.attempts, isEmpty);
    expect(
      reloaded.onboarded,
      isFalse,
      reason: 'a full reset means onboarding',
    );
  });

  testWidgets('a due review session advances the schedule', (tester) async {
    final state = await freshState(tester: tester);
    // The queue comes from a real attempt that missed this question.
    final question = QuestionBank.bySubtest(Subtest.wk).first;
    final missed = Attempt(
      id: 'review-seed',
      kind: ExamKind.section,
      startedAt: DateTime.now().subtract(const Duration(days: 2)),
      finishedAt: DateTime.now().subtract(const Duration(days: 2)),
      report: PersonaRunner.run(Personas.byId('ava')).report,
      responses: <QuestionResponse>[
        QuestionResponse(
          questionId: question.id,
          selectedIndex: (question.answerIndex + 1) % question.choices.length,
          secondsSpent: 20,
        ),
      ],
      questionIds: <String>[question.id],
      subtests: <Subtest>[Subtest.wk],
    );
    await state.addAttempt(missed, const <String, List<int>>{});
    expect(state.reviews, hasLength(1));

    // Force it due now: the first interval is a day, and this test is about the
    // session, not the calendar.
    final item = state.reviews.single;
    await Storage.saveReviews(<ReviewItem>[
      ReviewItem(
        questionId: item.questionId,
        dueAt: DateTime.now().subtract(const Duration(hours: 1)),
        timesMissed: item.timesMissed,
      ),
    ]);
    final reloadedState = AppState();
    await reloadedState.init();
    expect(reloadedState.dueReviewCount, 1);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: reloadedState,
        child: const AsvabCoachApp(),
      ),
    );
    await settle(tester);
    expect(find.text('Review now'), findsOneWidget);

    await tester.tap(find.text('Review now'));
    await settle(tester);
    await tester.tap(find.text('Begin section'));
    await settle(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await settle(tester, pumps: 2);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await settle(tester, pumps: 2);

    // Finish whatever the review session asks for.
    final label = find.text('Submit exam').evaluate().isNotEmpty
        ? 'Submit exam'
        : 'Finish section';
    await tester.tap(find.text(label).last);
    await settle(tester);
    await tester.tap(find.text(label).last);
    await settle(tester, pumps: 14);

    expect(
      reloadedState.attempts.any((a) => a.kind == ExamKind.review),
      isTrue,
    );
    final after = reloadedState.reviews;
    expect(
      after,
      hasLength(1),
      reason: 'a miss or a hit both stay in the queue',
    );
    expect(after.single.lastSeenAt, isNotNull, reason: 'it was reviewed');
    expect(
      after.single.dueAt.isAfter(DateTime.now()),
      isTrue,
      reason: 'reviewing it must push the next sighting forward',
    );
  });
}
