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
  DateTime? today,
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
            ? PlanScreen(today: today)
            : Builder(
                builder: (context) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(textScale)),
                  child: PlanScreen(today: today),
                ),
              ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
}

// The two cards on the plan screen count from the same two dates, so a day
// pinned to the wall calendar is what makes their answers comparable. The
// defect was seen on a real phone: "Your schedule" printed 57 days left over a
// Today card that printed 58, because the schedule card subtracted its own days
// inside the planner - which truncates a part-day remainder - while the Today
// card asked the scheduler, which counts whole days at midnight.
//
// 1 January 2026 plus 58 days is 28 February 2026, the pair the scheduler's own
// tests are pinned to, and the candidate studied earlier that same day, so no
// missed day moves any figure.
//
// The time of day is part of the fixture, not decoration. A planner left to
// subtract its own days only loses one when the clock it subtracts from has a
// time on it: 28 February at midnight less 1 January at 21:47 is 57 days and a
// remainder, which truncates to 57, while the scheduler counts 58 whole days
// whichever hour it is handed. Pinning the screen to midnight would let a
// second calculation pass this test and fail on the phone.
final DateTime fixedDay = DateTime(2026, 1, 1, 21, 47);

/// The morning of the same day, so [AppState.lastActiveDay] is [fixedDay].
final DateTime fixedDayMorning = DateTime(2026, 1, 1, 9);
final DateTime fiftyEightDaysOut = DateTime(2026, 2, 28);

GoalProfile fixedGoal({DateTime? targetDate, int dailyMinutes = 20}) =>
    GoalProfile(
      displayName: 'Alex Rivera',
      targetAfqt: 65,
      targetGt: 110,
      targetMosCodes: const <String>['68W'],
      targetDate: targetDate ?? fiftyEightDaysOut,
      officerTrack: false,
      dailyMinutes: dailyMinutes,
    );

/// A candidate with one scored attempt, finished on [fixedDay].
Future<AppState> seededOnFixedDay({
  DateTime? targetDate,
  int dailyMinutes = 20,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  await state.setGoal(
    fixedGoal(targetDate: targetDate, dailyMinutes: dailyMinutes),
  );
  final result = PersonaRunner.run(Personas.byId('jenna'));
  await state.addAttempt(
    Attempt(
      id: 'fixed-day-attempt',
      kind: ExamKind.fullMock,
      startedAt: fixedDayMorning.subtract(const Duration(minutes: 150)),
      finishedAt: fixedDayMorning,
      report: result.report,
      responses: const [],
      questionIds: const <String>[],
    ),
    const <String, List<int>>{},
  );
  return state;
}

/// The schedule the screen is supposed to be reading, from the same inputs.
StudySchedule fixedSchedule(AppState state) => StudyScheduler.forPlan(
  plan: AdaptiveEngine.buildPlan(state.lastReport!, goal: state.goal, limit: 6),
  goal: state.goal,
  today: fixedDay,
  lastActiveDay: state.lastActiveDay,
);

/// What one figure in the schedule card says.
StatTile scheduleTile(WidgetTester tester, String label) =>
    tester.widget<StatTile>(
      find.byWidgetPredicate((w) => w is StatTile && w.label == label),
    );

/// The day count the Today card prints in its first line: "58 days left at 20
/// minutes a day is 1160 minutes."
int todayCardDays(WidgetTester tester) {
  final line = tester.widget<Text>(find.textContaining('days left at')).data!;
  final match = RegExp(r'^(\d+) days? left at ').firstMatch(line);
  expect(
    match,
    isNotNull,
    reason: 'the Today card no longer states a day count: $line',
  );
  return int.parse(match!.group(1)!);
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

  // One screen, one day count.
  //
  // "Your schedule" said 57 days left while "Today" said 58 on the same screen,
  // because the schedule card counted its own days from a DateTime.now() and the
  // Today card asked the scheduler. These tests pin the two cards to the
  // scheduler's answer, so a second calculation of the runway cannot come back
  // without turning them red.
  testWidgets('both cards print the day count the scheduler counts', (
    tester,
  ) async {
    final state = await seededOnFixedDay();
    final schedule = fixedSchedule(state);
    // 1 January to 28 February is 58 whole days, not 57 and a remainder: the
    // planner's own subtraction gave 57 whenever "now" carried a time of day.
    expect(schedule.daysRemaining, 58);

    await pumpPlan(tester, state, today: fixedDay);

    final onScheduleCard = scheduleTile(tester, 'Days left').value;
    final onTodayCard = todayCardDays(tester);

    expect(
      onScheduleCard,
      '${schedule.daysRemaining}',
      reason: 'the schedule card must print the scheduler\'s days remaining',
    );
    expect(onTodayCard, schedule.daysRemaining);
    expect(
      onScheduleCard,
      '$onTodayCard',
      reason:
          'one screen cannot print two day counts: the schedule card said '
          '$onScheduleCard and the Today card said $onTodayCard',
    );
  });

  testWidgets('the schedule card figures and verdict are the scheduler\'s', (
    tester,
  ) async {
    final state = await seededOnFixedDay();
    final schedule = fixedSchedule(state);
    expect(schedule.status, ScheduleStatus.fits);

    await pumpPlan(tester, state, today: fixedDay);

    // Days left, the minutes those days hold and the minutes of work
    // outstanding are one schedule's answers, not a second set of sums.
    expect(
      scheduleTile(tester, 'Time available').value,
      '${(schedule.availableMinutes! / 60).round()}',
    );
    expect(scheduleTile(tester, 'Time available').suffix, 'h');
    expect(
      scheduleTile(tester, 'Work outstanding').value,
      '${(schedule.outstandingMinutes / 60).round()}',
    );
    expect(scheduleTile(tester, 'Work outstanding').suffix, 'h');

    // The pill is the scheduler's verdict: the work fits the runway it counted.
    expect(find.text('On track'), findsOneWidget);
    // And the sentence under the meter is drawn from the same pair of numbers.
    expect(find.textContaining('You have enough time for'), findsOneWidget);
    expect(find.textContaining('more minutes than you have'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a target date that has gone reads as the schedule says', (
    tester,
  ) async {
    // Two days past the date the plan was drawn against. The scheduler calls
    // that a passed date with everything left due today; the planner, dividing
    // by a runway of zero, called the same state "No time budget". The card now
    // says what the schedule says.
    final state = await seededOnFixedDay(
      targetDate: fixedDay.subtract(const Duration(days: 2)),
    );
    final schedule = fixedSchedule(state);
    expect(schedule.status, ScheduleStatus.datePassed);
    expect(schedule.daysRemaining, 0);

    await pumpPlan(tester, state, today: fixedDay);

    expect(scheduleTile(tester, 'Days left').value, '0');
    expect(find.text('Date passed'), findsOneWidget);
    expect(find.text('No time budget'), findsNothing);
    // Nothing is available, so the whole outstanding work is the shortfall.
    expect(
      find.textContaining(
        'needs about ${schedule.outstandingMinutes} more minutes than you have',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
