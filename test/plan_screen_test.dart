import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/engines/adaptive_engine.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/engines/study_schedule.dart';
import 'package:asvab_guard_coach/screens/lesson_screen.dart';
import 'package:asvab_guard_coach/screens/plan_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:asvab_guard_coach/widgets/primitives.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The Today card tells the candidate what to do and has to let them start it.
///
/// It used to be a list of sentences: "Numbers & order of operations - 13
/// minutes". The only way to act on one was to scroll to the plan below, find
/// that same skill in the list and tap it there. These tests pin both halves of
/// the fix - the row opens the lesson, and it opens the same lesson the step
/// card for that skill opens, so a step has one destination and not two.
const Size phone = Size(390, 844);

/// A candidate with one scored attempt, [lastActiveDaysAgo] days ago.
///
/// The attempt's finish date is the only record the plan paces from, so it is
/// the one knob that makes a candidate "behind" or not.
Future<AppState> seeded({int lastActiveDaysAgo = 0}) async {
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
  // One scored attempt, so the plan screen has a plan: six steps that fit the
  // thirty days comfortably, which is the schedule a candidate actually sees.
  final result = PersonaRunner.run(Personas.byId('jenna'));
  await state.addAttempt(
    Attempt(
      id: 'plan-row-attempt',
      kind: ExamKind.fullMock,
      startedAt: DateTime.now().subtract(
        Duration(minutes: 150, days: lastActiveDaysAgo),
      ),
      finishedAt: DateTime.now().subtract(Duration(days: lastActiveDaysAgo)),
      report: result.report,
      responses: const [],
      questionIds: const <String>[],
    ),
    const <String, List<int>>{},
  );
  return state;
}

Future<void> pumpPlan(
  WidgetTester tester,
  AppState state, {
  Size size = phone,
  double textScale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ChangeNotifierProvider<AppState>.value(
      value: state,
      child: MaterialApp(
        theme: AppTheme.build(Brightness.light),
        home: textScale == 1
            ? const PlanScreen()
            : Builder(
                builder: (context) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(textScale)),
                  child: const PlanScreen(),
                ),
              ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
}

/// The first thing the plan says to do today, read off the same engines the
/// screen reads, so the test knows which row it is looking for without reaching
/// into a private widget type.
class TodayStepFixture {
  const TodayStepFixture({
    required this.skillId,
    required this.label,
    required this.rowText,
  });

  final String skillId;
  final String label;

  /// What the row says, unchanged from before it was tappable.
  final String rowText;
}

TodayStepFixture firstTodayStep(AppState state) {
  final plan = AdaptiveEngine.buildPlan(
    state.lastReport!,
    goal: state.goal,
    limit: 6,
  );
  final schedule = StudyScheduler.forPlan(
    plan: plan,
    goal: state.goal,
    today: DateTime.now(),
  );
  expect(
    schedule.status,
    ScheduleStatus.fits,
    reason: 'the fixture is meant to be a plan that fits',
  );
  expect(schedule.todaySteps, isNotEmpty);
  final step = schedule.todaySteps.first;
  final planStep = plan.firstWhere((p) => p.skillId == step.id);
  final minutes = StudyScheduler.minutesFor(planStep);
  return TodayStepFixture(
    skillId: step.id,
    label: step.label,
    rowText: '${step.label} - $minutes minute${minutes == 1 ? '' : 's'}',
  );
}

/// The one sentence the card renders about a gap, read off the same engine the
/// screen reads.
String? _reflowNote(AppState state) => StudyScheduler.forPlan(
  plan: AdaptiveEngine.buildPlan(state.lastReport!, goal: state.goal, limit: 6),
  goal: state.goal,
  today: DateTime.now(),
  lastActiveDay: state.lastActiveDay,
).reflowNote;

void main() {
  testWidgets('a Today row starts the lesson the step card for it starts', (
    tester,
  ) async {
    final state = await seeded();
    final today = firstTodayStep(state);
    await pumpPlan(tester, state);

    // The row still says what the card said before it was tappable.
    final rowText = find.text(today.rowText);
    expect(rowText, findsOneWidget);

    final row = find.ancestor(of: rowText, matching: find.byType(InkWell));
    expect(row, findsOneWidget);
    // Marked as something to open, and tall enough to hit with a thumb.
    expect(
      find.descendant(
        of: row,
        matching: find.byIcon(Icons.chevron_right_rounded),
      ),
      findsOneWidget,
    );
    expect(tester.getSize(row).height, greaterThanOrEqualTo(48.0));

    // The whole row is the target, not just the words, so tap its leading edge
    // where there is nothing but the bullet and empty space.
    await tester.ensureVisible(row);
    await tester.pumpAndSettle();
    final rect = tester.getRect(row);
    await tester.tapAt(Offset(rect.left + 6, rect.center.dy));
    await tester.pumpAndSettle();

    expect(find.byType(LessonScreen), findsOneWidget);
    final fromRow = tester
        .widget<LessonScreen>(find.byType(LessonScreen))
        .skillId;
    expect(fromRow, today.skillId);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(PlanScreen), findsOneWidget);

    // The step card for that same skill, further down the screen.
    final card = find.ancestor(
      of: find.text(today.label),
      matching: find.byWidgetPredicate((w) => w is AppCard && w.onTap != null),
    );
    expect(card, findsOneWidget);
    await tester.ensureVisible(card);
    await tester.pumpAndSettle();
    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.byType(LessonScreen), findsOneWidget);
    expect(
      tester.widget<LessonScreen>(find.byType(LessonScreen)).skillId,
      fromRow,
      reason: 'the Today row and its step card must open the same lesson',
    );
  });

  testWidgets('the Today card lays out at 360x800 with 2x text', (
    tester,
  ) async {
    final state = await seeded();
    final today = firstTodayStep(state);
    await pumpPlan(tester, state, size: const Size(360, 800), textScale: 2);
    expect(tester.takeException(), isNull);
    // The row is still there, still readable, and still one row rather than a
    // wrapped line of overflow.
    final rowText = find.text(today.rowText);
    expect(rowText, findsOneWidget);
    final row = find.ancestor(of: rowText, matching: find.byType(InkWell));
    expect(tester.getSize(row).height, greaterThanOrEqualTo(48.0));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a candidate who studied today is told nothing about a gap', (
    tester,
  ) async {
    final state = await seeded();
    expect(_reflowNote(state), isNull);
    await pumpPlan(tester, state);

    expect(find.textContaining('You have not studied for'), findsNothing);
  });

  testWidgets('a gap in the history is stated once, at 360dp with 2x text', (
    tester,
  ) async {
    final state = await seeded(lastActiveDaysAgo: 3);
    final note = _reflowNote(state);
    // 74 minutes of work over the 30 days left is 5 minutes a day with the gap
    // folded in, and the 30 minutes a day that were set still cover it.
    expect(
      note,
      'You have not studied for 3 days, so the plan now needs 5 minutes a day, '
      'and the 30 you set still covers it.',
    );

    await pumpPlan(tester, state, size: const Size(360, 800), textScale: 2);
    expect(tester.takeException(), isNull);

    // Said exactly once, and the bare pace line it replaces is not also there.
    expect(find.textContaining('You have not studied for'), findsOneWidget);
    expect(find.textContaining('It needs'), findsNothing);

    // It wraps rather than being cut off at the width it has to fit.
    final paragraph = tester.renderObject<RenderParagraph>(
      find.descendant(
        of: find.textContaining('You have not studied for'),
        matching: find.byType(RichText),
      ),
    );
    expect(paragraph.didExceedMaxLines, isFalse);
    expect(tester.takeException(), isNull);
  });
}
