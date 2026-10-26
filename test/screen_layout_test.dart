import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/screens/dashboard_screen.dart';
import 'package:asvab_guard_coach/screens/jobs_screen.dart';
import 'package:asvab_guard_coach/screens/lesson_screen.dart';
import 'package:asvab_guard_coach/screens/onboarding_screen.dart';
import 'package:asvab_guard_coach/screens/plan_screen.dart';
import 'package:asvab_guard_coach/screens/progress_screen.dart';
import 'package:asvab_guard_coach/screens/qa_lab_screen.dart';
import 'package:asvab_guard_coach/screens/results_screen.dart';
import 'package:asvab_guard_coach/screens/review_screen.dart';
import 'package:asvab_guard_coach/screens/settings_screen.dart';
import 'package:asvab_guard_coach/screens/test_center_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Every screen, laid out at phone width and asserted to paint without error.
///
/// This exists because the test runner was once shipped with a Spacer inside a
/// scroll view - a layout Flutter rejects - and no test pumped a screen to find
/// out. A RenderFlex overflow or a bad constraint is not a crash the user can
/// read; it is a painted hazard stripe over their content.
const Size phone = Size(390, 844);

Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen, {
  AppState? state,
  Size size = phone,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  var resolved = state;
  if (resolved == null) {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    resolved = AppState();
    await resolved.init();
  }

  await tester.pumpWidget(
    ChangeNotifierProvider<AppState>.value(
      value: resolved,
      child: MaterialApp(theme: AppTheme.build(Brightness.light), home: screen),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(tester.takeException(), isNull);
}

/// One item per presentation shape, all answered wrongly so the review screen
/// shows them.
final List<Question> reviewQuestions = <Question>[
  QuestionBank.bySubtest(Subtest.pc).first,
  QuestionBank.bySubtest(Subtest.mc).firstWhere((q) => q.figure != null),
  QuestionBank.bySubtest(Subtest.ao).first,
];

/// A state with a finished attempt, so the screens that need history have some.
Future<AppState> seededState() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  await state.setGoal(
    GoalProfile(
      displayName: 'Alex Rivera',
      targetAfqt: 65,
      targetGt: 110,
      targetMosCodes: const <String>['68W'],
      targetDate: DateTime.now().add(const Duration(days: 30)),
      officerTrack: false,
      dailyMinutes: 30,
    ),
  );
  final result = PersonaRunner.run(Personas.byId('jenna'));
  await state.addAttempt(
    Attempt(
      id: 'layout-attempt',
      kind: ExamKind.fullMock,
      startedAt: DateTime.now().subtract(const Duration(minutes: 150)),
      finishedAt: DateTime.now().subtract(const Duration(minutes: 20)),
      report: result.report,
      // Real wrong answers for three item shapes, so the review screen has to
      // render its passage, diagram and assembly cards rather than its empty
      // state. The assembly card is what caught a fixed-height tile that cut
      // the drawing off the bottom.
      responses: <QuestionResponse>[
        for (final q in reviewQuestions)
          QuestionResponse(
            questionId: q.id,
            selectedIndex: (q.answerIndex + 1) % q.choices.length,
            secondsSpent: 25,
          ),
      ],
      questionIds: <String>[for (final q in reviewQuestions) q.id],
      subtests: Subtest.administrationOrder,
    ),
    const <String, List<int>>{},
  );
  return state;
}

void main() {
  group('every screen lays out on a phone', () {
    testWidgets('onboarding', (tester) async {
      await pumpScreen(tester, const OnboardingScreen());
    });

    testWidgets('dashboard', (tester) async {
      final state = await seededState();
      await pumpScreen(
        tester,
        DashboardScreen(onNavigate: (_) {}),
        state: state,
      );
    });

    testWidgets('jobs', (tester) async {
      await pumpScreen(tester, const JobsScreen());
    });

    testWidgets('plan', (tester) async {
      final state = await seededState();
      await pumpScreen(tester, const PlanScreen(), state: state);
    });

    testWidgets('test centre', (tester) async {
      final state = await seededState();
      await pumpScreen(tester, const TestCenterScreen(), state: state);
    });

    testWidgets('progress', (tester) async {
      final state = await seededState();
      await pumpScreen(tester, const ProgressScreen(), state: state);
    });

    testWidgets('results', (tester) async {
      final state = await seededState();
      await pumpScreen(
        tester,
        ResultsScreen(attempt: state.attempts.last),
        state: state,
      );
    });

    testWidgets('review, including a drawing and a puzzle', (tester) async {
      final state = await seededState();
      await pumpScreen(
        tester,
        ReviewScreen(attempt: state.attempts.last),
        state: state,
      );
      // The default filter is "missed", and every seeded answer is wrong, so
      // all three shapes must be on screen.
      expect(find.text('Correct'), findsNothing);
      expect(find.text('Missed'), findsNWidgets(reviewQuestions.length));
    });

    testWidgets('lesson', (tester) async {
      final state = await seededState();
      await pumpScreen(
        tester,
        const LessonScreen(skillId: 'as.tools'),
        state: state,
      );
    });

    testWidgets('settings', (tester) async {
      final state = await seededState();
      await pumpScreen(tester, const SettingsScreen(), state: state);
    });

    testWidgets('QA lab', (tester) async {
      await pumpScreen(tester, const QaLabScreen());
    });
  });
}
