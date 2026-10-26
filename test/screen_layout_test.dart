import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/engines/exam_builder.dart';
import 'package:asvab_guard_coach/screens/dashboard_screen.dart';
import 'package:asvab_guard_coach/screens/exam_screen.dart';
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
  double textScale = 1,
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
      child: MaterialApp(
        theme: AppTheme.build(Brightness.light),
        home: textScale == 1
            ? screen
            : Builder(
                builder: (context) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(textScale)),
                  child: screen,
                ),
              ),
      ),
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

    testWidgets('dashboard before the first attempt', (tester) async {
      // A first-run dashboard is a different screen: the readiness hero is
      // replaced by a card inviting the diagnostic, and that card overflowed a
      // phone until the journey test visited it.
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final state = AppState();
      await state.init();
      await pumpScreen(
        tester,
        DashboardScreen(onNavigate: (_) {}),
        state: state,
      );
      expect(find.text('Begin diagnostic'), findsOneWidget);
    });

    testWidgets('dashboard at an intermediate width', (tester) async {
      // Between the phone layout and the wide one there is a window where the
      // readiness gauge sits beside its figures in a column barely wide enough
      // for both. That is where the hero's stat row overflowed.
      final state = await seededState();
      await pumpScreen(
        tester,
        DashboardScreen(onNavigate: (_) {}),
        state: state,
        size: const Size(1000, 1600),
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

  // The system font size is a setting the candidate owns, and Android offers up
  // to 2x. An enlarged label that does not fit becomes a painted overflow
  // stripe, and a runner whose options are clipped is a runner nobody finishes.
  group('every screen survives enlarged system text', () {
    for (final scale in <double>[1.3, 2]) {
      testWidgets('dashboard at ${scale}x', (tester) async {
        final state = await seededState();
        await pumpScreen(
          tester,
          DashboardScreen(onNavigate: (_) {}),
          state: state,
          textScale: scale,
        );
      });

      testWidgets('results at ${scale}x', (tester) async {
        final state = await seededState();
        await pumpScreen(
          tester,
          ResultsScreen(attempt: state.attempts.last),
          state: state,
          textScale: scale,
        );
      });

      testWidgets('review at ${scale}x', (tester) async {
        final state = await seededState();
        await pumpScreen(
          tester,
          ReviewScreen(attempt: state.attempts.last),
          state: state,
          textScale: scale,
        );
      });

      testWidgets('settings at ${scale}x', (tester) async {
        final state = await seededState();
        await pumpScreen(
          tester,
          const SettingsScreen(),
          state: state,
          textScale: scale,
        );
      });

      testWidgets('the runner at ${scale}x', (tester) async {
        final state = await seededState();
        await pumpScreen(
          tester,
          ExamScreen(exam: ExamBuilder.section(Subtest.ar, seed: 8)),
          state: state,
          textScale: scale,
        );
      });
    }
  });

  group('every screen survives a small phone', () {
    // 360x640 is a cheap Android handset; 640x360 is the same one held sideways,
    // where the runner has to fit a question, four options and a footer into 360
    // logical pixels of height.
    for (final size in <Size>[const Size(360, 640), const Size(640, 360)]) {
      testWidgets('dashboard at ${size.width.toInt()}x${size.height.toInt()}', (
        tester,
      ) async {
        final state = await seededState();
        await pumpScreen(
          tester,
          DashboardScreen(onNavigate: (_) {}),
          state: state,
          size: size,
        );
      });

      testWidgets(
        'the runner at ${size.width.toInt()}x${size.height.toInt()}',
        (tester) async {
          final state = await seededState();
          await pumpScreen(
            tester,
            ExamScreen(exam: ExamBuilder.section(Subtest.ar, seed: 8)),
            state: state,
            size: size,
          );
        },
      );

      // The two screens that are mostly text in rows. The results card that
      // counts qualifying jobs is a display figure and a sentence, and the
      // review card is badges and option lines: both are the shapes that
      // overrun a narrow phone.
      testWidgets(
        'results at ${size.width.toInt()}x${size.height.toInt()}',
        (tester) async {
          final state = await seededState();
          await pumpScreen(
            tester,
            ResultsScreen(attempt: state.attempts.last),
            state: state,
            size: size,
          );
        },
      );

      testWidgets(
        'review at ${size.width.toInt()}x${size.height.toInt()}',
        (tester) async {
          final state = await seededState();
          await pumpScreen(
            tester,
            ReviewScreen(attempt: state.attempts.last),
            state: state,
            size: size,
          );
        },
      );
    }

    // Both hard conditions at once: the cheapest handset this app claims to
    // support and the largest text Android offers. The eligibility figure
    // overran its Row by 18 pixels here long before 390 dp showed it.
    testWidgets('results at 360x640 with 2x text', (tester) async {
      final state = await seededState();
      await pumpScreen(
        tester,
        ResultsScreen(attempt: state.attempts.last),
        state: state,
        size: const Size(360, 640),
        textScale: 2,
      );
    });

    testWidgets('review at 360x640 with 2x text', (tester) async {
      final state = await seededState();
      await pumpScreen(
        tester,
        ReviewScreen(attempt: state.attempts.last),
        state: state,
        size: const Size(360, 640),
        textScale: 2,
      );
    });
  });
}
