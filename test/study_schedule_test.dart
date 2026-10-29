import 'package:flutter_test/flutter_test.dart';

import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/engines/adaptive_engine.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/engines/study_schedule.dart';

/// The scheduling arithmetic, pinned to exact numbers.
///
/// The engine is handed its "today" rather than reading a clock, so every case
/// below is a fixed sum: 58 days at 20 minutes is 1160 minutes, six steps of
/// 13, 13, 12, 12, 12 and 12 minutes are 74, and two days at 20 minutes is 40 -
/// which needs 37 minutes a day and not one minute more.
///
/// The gap cases add one more sum. A day that went by unworked still owed the
/// minutes the cadence gave it, and today is not a missed day yet - it is the
/// one in hand - so 25 minutes of work two days out at 20 a day, with one day
/// missed, owes 45 minutes in two days: 23 a day, not 20.

/// A fixed day to count from. 1 January 2026 plus 58 days is 28 February 2026.
final DateTime _today = DateTime(2026, 1, 1);
final DateTime _fiftyEightDaysOut = DateTime(2026, 2, 28);

ScheduleStep _step(String id, int minutes, [double points = 1]) =>
    ScheduleStep(id: id, label: id, minutes: minutes, points: points);

List<String> _ids(List<ScheduleStep> steps) =>
    steps.map((s) => s.id).toList(growable: false);

/// The plan the app actually builds for a real candidate, mapped for the
/// scheduler: jenna's weakest six skills after the placement diagnostic.
StudySchedule _realPlan({
  required DateTime? targetDate,
  required int daily,
  DateTime? lastActiveDay,
}) {
  final report = PersonaRunner.run(Personas.byId('jenna')).report;
  final plan = AdaptiveEngine.buildPlan(
    report,
    goal: GoalProfile(
      displayName: 'Candidate',
      targetAfqt: 65,
      targetGt: 110,
      targetMosCodes: const <String>['68W'],
      targetDate: targetDate,
      officerTrack: false,
      dailyMinutes: daily,
    ),
    limit: 6,
  );
  return StudyScheduler.forPlan(
    plan: plan,
    goal: GoalProfile(
      displayName: 'Candidate',
      targetAfqt: 65,
      targetGt: 110,
      targetMosCodes: const <String>['68W'],
      targetDate: targetDate,
      officerTrack: false,
      dailyMinutes: daily,
    ),
    today: _today,
    lastActiveDay: lastActiveDay,
  );
}

/// Two steps worth 25 minutes, two days to run at 20 minutes a day.
///
/// The tightest plan the app builds: 40 minutes of runway against 25 minutes of
/// work, so a missed day has nowhere to hide and every number moves.
StudySchedule _tightPlan({DateTime? lastActiveDay}) => StudyScheduler.build(
  steps: <ScheduleStep>[_step('a', 13, 3), _step('b', 12, 2)],
  targetDate: DateTime(2026, 1, 3),
  dailyMinutes: 20,
  today: _today,
  lastActiveDay: lastActiveDay,
);

void main() {
  group('the real plan with 58 days and 20 minutes a day', () {
    test('every step is costed in minutes and the total is 74', () {
      final report = PersonaRunner.run(Personas.byId('jenna')).report;
      final plan = AdaptiveEngine.buildPlan(report, limit: 6);
      final steps = StudyScheduler.stepsFromPlan(plan);

      expect(steps.length, 6);
      expect(steps.map((s) => s.id).toList(), <String>[
        'mk.prealgebra',
        'pc.vocabulary',
        'mk.exponents',
        'pc.mainidea',
        'ar.ratio',
        'ar.rate',
      ]);
      // Two lessons at seven authored minutes plus a six-minute mastery check,
      // then four twelve-minute drills.
      expect(steps.map((s) => s.minutes).toList(), <int>[
        13,
        13,
        12,
        12,
        12,
        12,
      ]);
      expect(steps.fold<int>(0, (sum, s) => sum + s.minutes), 74);
      // The plan's own order is the value order, highest first.
      expect(steps.map((s) => s.points).toList(), <double>[6, 5, 4, 3, 2, 1]);
    });

    test('58 days at 20 minutes holds 1160 minutes, so it fits', () {
      final schedule = _realPlan(targetDate: _fiftyEightDaysOut, daily: 20);

      expect(schedule.status, ScheduleStatus.fits);
      expect(schedule.daysRemaining, 58);
      expect(schedule.availableMinutes, 1160);
      expect(schedule.neededMinutes, 74);
      expect(schedule.status, isNot(ScheduleStatus.needsMoreTime));
      // 74 minutes over 58 days is two minutes a day, and 1086 minutes spare.
      expect(schedule.requiredDailyMinutes, 2);
      expect(schedule.spareMinutes, 1086);
      expect(schedule.fits, isTrue);
    });

    test('one step a day, and today is the pre-algebra lesson', () {
      final schedule = _realPlan(targetDate: _fiftyEightDaysOut, daily: 20);

      expect(schedule.stepsPerDay, 1);
      expect(schedule.stepCount, 6);
      expect(schedule.stepsThroughToday, 1);
      expect(schedule.todaySteps.length, 1);
      expect(schedule.todaySteps.single.id, 'mk.prealgebra');
      expect(schedule.todaySteps.single.minutes, 13);
      expect(schedule.tomorrowSteps.single.id, 'pc.vocabulary');
      expect(schedule.days.map((d) => d.offset).toList(), <int>[0, 1, 2]);
      expect(schedule.days[2].steps.single.id, 'mk.exponents');
      expect(schedule.progressAfterToday, closeTo(1 / 6, 1e-9));
      // Today's work is 13 minutes of a 20-minute budget.
      expect(schedule.days.first.minutes, 13);
      expect(schedule.today, DateTime.utc(2026, 1, 1));
    });

    test('the same plan two days out does not fit, and needs 37 a day', () {
      final schedule = _realPlan(targetDate: DateTime(2026, 1, 3), daily: 20);

      expect(schedule.status, ScheduleStatus.needsMoreTime);
      expect(schedule.daysRemaining, 2);
      expect(schedule.availableMinutes, 40);
      expect(schedule.neededMinutes, 74);
      expect(schedule.spareMinutes, 0);
      // 74 minutes of work in two days is 37 minutes a day, exactly.
      expect(schedule.requiredDailyMinutes, 37);
      // Six steps over two days is three a day, so the whole plan is on screen.
      expect(schedule.stepsPerDay, 3);
      expect(schedule.stepsThroughToday, 3);
      expect(_ids(schedule.todaySteps), <String>[
        'mk.prealgebra',
        'pc.vocabulary',
        'mk.exponents',
      ]);
      expect(schedule.progressAfterToday, 0.5);
    });
  });

  group('no target date', () {
    test('says so, and paces one step at a time', () {
      final schedule = StudyScheduler.build(
        steps: <ScheduleStep>[_step('a', 13, 3), _step('b', 12, 2)],
        targetDate: null,
        dailyMinutes: 20,
        today: _today,
      );

      expect(schedule.status, ScheduleStatus.noTargetDate);
      expect(schedule.daysRemaining, isNull);
      expect(schedule.availableMinutes, isNull);
      // Nothing to divide by, so nothing is claimed about the pace.
      expect(schedule.requiredDailyMinutes, isNull);
      expect(schedule.spareMinutes, isNull);
      expect(schedule.stepsPerDay, 1);
      expect(_ids(schedule.todaySteps), <String>['a']);
      expect(_ids(schedule.tomorrowSteps), <String>['b']);
      expect(schedule.neededMinutes, 25);
    });
  });

  group('a target date that has gone', () {
    test('is reported once, with the work still costing what it costs', () {
      final schedule = StudyScheduler.build(
        steps: <ScheduleStep>[_step('a', 13, 3), _step('b', 12, 2)],
        targetDate: DateTime(2025, 12, 29),
        dailyMinutes: 20,
        today: _today,
      );

      expect(schedule.status, ScheduleStatus.datePassed);
      // Never negative, and never a division by zero.
      expect(schedule.daysRemaining, 0);
      expect(schedule.availableMinutes, 0);
      expect(schedule.stepsPerDay, 2);
      // Everything left is due today.
      expect(schedule.requiredDailyMinutes, 25);
      expect(_ids(schedule.todaySteps), <String>['a', 'b']);
      expect(schedule.progressAfterToday, 1.0);
      expect(schedule.tomorrowSteps, isEmpty);
    });

    test('a target date of today is the same case', () {
      final schedule = StudyScheduler.build(
        steps: <ScheduleStep>[_step('a', 13, 3)],
        targetDate: _today,
        dailyMinutes: 20,
        today: _today,
      );

      expect(schedule.status, ScheduleStatus.datePassed);
      expect(schedule.daysRemaining, 0);
      expect(schedule.requiredDailyMinutes, 13);
    });
  });

  group('no daily minutes', () {
    test('is its own case, and still names the pace the work needs', () {
      final schedule = StudyScheduler.build(
        steps: <ScheduleStep>[_step('a', 13, 3), _step('b', 12, 2)],
        targetDate: DateTime(2026, 1, 11),
        dailyMinutes: 0,
        today: _today,
      );

      expect(schedule.status, ScheduleStatus.noBudget);
      expect(schedule.dailyMinutes, 0);
      expect(schedule.daysRemaining, 10);
      expect(schedule.availableMinutes, 0);
      expect(schedule.fits, isFalse);
      // 25 minutes of work over 10 days is three minutes a day.
      expect(schedule.requiredDailyMinutes, 3);
      expect(schedule.stepsPerDay, 1);
      expect(_ids(schedule.todaySteps), <String>['a']);
    });

    test('a negative budget is treated as no budget', () {
      final schedule = StudyScheduler.build(
        steps: <ScheduleStep>[_step('a', 13, 3)],
        targetDate: DateTime(2026, 1, 11),
        dailyMinutes: -5,
        today: _today,
      );

      expect(schedule.status, ScheduleStatus.noBudget);
      expect(schedule.dailyMinutes, 0);
      expect(schedule.availableMinutes, 0);
    });
  });

  group('a plan with no steps', () {
    test('has nothing to schedule', () {
      final schedule = StudyScheduler.build(
        steps: const <ScheduleStep>[],
        targetDate: _fiftyEightDaysOut,
        dailyMinutes: 20,
        today: _today,
      );

      expect(schedule.status, ScheduleStatus.nothingPlanned);
      expect(schedule.stepCount, 0);
      expect(schedule.stepsPerDay, 0);
      expect(schedule.neededMinutes, 0);
      expect(schedule.requiredDailyMinutes, 0);
      expect(schedule.days, isEmpty);
      expect(schedule.todaySteps, isEmpty);
      expect(schedule.progressAfterToday, 0);
      expect(schedule.daysRemaining, 58);
    });

    test('with no date either, there is no pace to state', () {
      final schedule = StudyScheduler.build(
        steps: const <ScheduleStep>[],
        targetDate: null,
        dailyMinutes: 20,
        today: _today,
      );

      expect(schedule.status, ScheduleStatus.nothingPlanned);
      expect(schedule.requiredDailyMinutes, isNull);
      expect(schedule.availableMinutes, isNull);
      expect(schedule.days, isEmpty);
    });
  });

  group('a plan that fits with time to spare', () {
    test('four twelve-minute steps in ten days of twenty', () {
      final schedule = StudyScheduler.build(
        steps: <ScheduleStep>[
          _step('a', 12, 4),
          _step('b', 12, 3),
          _step('c', 12, 2),
          _step('d', 12, 1),
        ],
        targetDate: DateTime(2026, 1, 11),
        dailyMinutes: 20,
        today: _today,
      );

      expect(schedule.status, ScheduleStatus.fits);
      expect(schedule.daysRemaining, 10);
      expect(schedule.availableMinutes, 200);
      expect(schedule.neededMinutes, 48);
      expect(schedule.spareMinutes, 152);
      // 48 minutes over 10 days is five minutes a day.
      expect(schedule.requiredDailyMinutes, 5);
      expect(schedule.stepsPerDay, 1);
      expect(schedule.progressAfterToday, 0.25);
    });
  });

  group('the schedule does not wander', () {
    test('two calls with the same inputs answer the same thing', () {
      final steps = <ScheduleStep>[
        _step('a', 13, 3),
        _step('b', 12, 2),
        _step('c', 8, 1),
      ];
      StudySchedule once() => StudyScheduler.build(
        steps: steps,
        targetDate: DateTime(2026, 1, 5),
        dailyMinutes: 20,
        today: _today,
      );

      final first = once();
      final second = once();
      expect(second.status, first.status);
      expect(second.daysRemaining, first.daysRemaining);
      expect(second.availableMinutes, first.availableMinutes);
      expect(second.neededMinutes, first.neededMinutes);
      expect(second.requiredDailyMinutes, first.requiredDailyMinutes);
      expect(second.stepsPerDay, first.stepsPerDay);
      expect(second.stepsThroughToday, first.stepsThroughToday);
      expect(second.orderedSteps, orderedEquals(first.orderedSteps));
      expect(_ids(second.todaySteps), _ids(first.todaySteps));
      expect(_ids(second.tomorrowSteps), _ids(first.tomorrowSteps));
    });

    test('the hour of the day it is called with does not matter', () {
      final steps = <ScheduleStep>[_step('a', 13, 3), _step('b', 12, 2)];
      final morning = StudyScheduler.build(
        steps: steps,
        targetDate: DateTime(2026, 1, 11),
        dailyMinutes: 20,
        today: DateTime(2026, 1, 1, 6, 30),
      );
      final lateNight = StudyScheduler.build(
        steps: steps,
        targetDate: DateTime(2026, 1, 11),
        dailyMinutes: 20,
        today: DateTime(2026, 1, 1, 23, 45),
      );

      expect(lateNight.daysRemaining, morning.daysRemaining);
      expect(lateNight.daysRemaining, 10);
      expect(lateNight.today, morning.today);
      expect(_ids(lateNight.todaySteps), _ids(morning.todaySteps));
    });

    test('nor does the order the steps arrive in', () {
      final ordered = <ScheduleStep>[
        _step('mk.prealgebra', 13, 6),
        _step('pc.vocabulary', 13, 5),
        _step('mk.exponents', 12, 4),
        _step('pc.mainidea', 12, 3),
        _step('ar.ratio', 12, 2),
        _step('ar.rate', 12, 1),
      ];
      final shuffled = <ScheduleStep>[
        ordered[4],
        ordered[0],
        ordered[5],
        ordered[2],
        ordered[1],
        ordered[3],
      ];
      final reversed = ordered.reversed.toList(growable: false);

      StudySchedule scheduleOf(List<ScheduleStep> steps) =>
          StudyScheduler.build(
            steps: steps,
            targetDate: DateTime(2026, 1, 3),
            dailyMinutes: 20,
            today: _today,
          );

      final straight = scheduleOf(ordered);
      final mixed = scheduleOf(shuffled);
      final backwards = scheduleOf(reversed);

      for (final other in <StudySchedule>[mixed, backwards]) {
        expect(other.status, straight.status);
        expect(other.neededMinutes, straight.neededMinutes);
        expect(other.requiredDailyMinutes, straight.requiredDailyMinutes);
        expect(other.stepsPerDay, straight.stepsPerDay);
        expect(other.stepsThroughToday, straight.stepsThroughToday);
        expect(other.orderedSteps, orderedEquals(straight.orderedSteps));
        expect(_ids(other.todaySteps), _ids(straight.todaySteps));
        expect(_ids(other.tomorrowSteps), _ids(straight.tomorrowSteps));
      }
      // The value order wins over the order handed in.
      expect(_ids(straight.todaySteps), <String>[
        'mk.prealgebra',
        'pc.vocabulary',
        'mk.exponents',
      ]);
      expect(_ids(mixed.todaySteps), _ids(straight.todaySteps));
    });
  });

  group('a gap in the record', () {
    test('no attempt at all is not behind, and invents no date', () {
      final schedule = _tightPlan();

      expect(schedule.lastActiveDay, isNull);
      expect(schedule.daysSinceStudy, isNull);
      expect(schedule.isBehind, isFalse);
      expect(schedule.missedDays, 0);
      expect(schedule.missedMinutes, 0);
      expect(schedule.reflowNote, isNull);
      // Nothing changes about the numbers either: 25 minutes over 2 days.
      expect(schedule.outstandingMinutes, 25);
      expect(schedule.requiredDailyMinutes, 13);
      expect(schedule.status, ScheduleStatus.fits);
    });

    test('a plan too tight to fit is still not behind without a history', () {
      // One day left, 25 minutes of work, 20 minutes a day. The plan does not
      // fit, and that is the whole of what is said: nobody is behind a cadence
      // they never started.
      final schedule = StudyScheduler.build(
        steps: <ScheduleStep>[_step('a', 13, 3), _step('b', 12, 2)],
        targetDate: DateTime(2026, 1, 2),
        dailyMinutes: 20,
        today: _today,
      );

      expect(schedule.status, ScheduleStatus.needsMoreTime);
      expect(schedule.isBehind, isFalse);
      expect(schedule.lastActiveDay, isNull);
      expect(schedule.daysSinceStudy, isNull);
      expect(schedule.missedMinutes, 0);
      expect(schedule.requiredDailyMinutes, 25);
      expect(schedule.reflowNote, isNull);
    });

    test('activity today is not behind and changes no number', () {
      final withActivity = _tightPlan(lastActiveDay: _today);
      final without = _tightPlan();

      expect(withActivity.daysSinceStudy, 0);
      expect(withActivity.isBehind, isFalse);
      expect(withActivity.missedDays, 0);
      expect(withActivity.missedMinutes, 0);
      expect(withActivity.reflowNote, isNull);
      // Every number the schedule had before the date was passed in.
      expect(withActivity.outstandingMinutes, without.outstandingMinutes);
      expect(withActivity.requiredDailyMinutes, without.requiredDailyMinutes);
      expect(withActivity.status, without.status);
      expect(withActivity.stepsPerDay, without.stepsPerDay);
      expect(_ids(withActivity.todaySteps), _ids(without.todaySteps));
    });

    test('studying yesterday is on cadence: today is the day in hand', () {
      final schedule = _tightPlan(lastActiveDay: DateTime(2025, 12, 31));

      expect(schedule.daysSinceStudy, 1);
      // A whole day has not gone by unworked, so nothing is owed.
      expect(schedule.isBehind, isFalse);
      expect(schedule.missedDays, 0);
      expect(schedule.missedMinutes, 0);
      expect(schedule.outstandingMinutes, 25);
      expect(schedule.requiredDailyMinutes, 13);
      expect(schedule.reflowNote, isNull);
    });

    test(
      'one missed day raises the pace from 20 to 23 a day, and is said once',
      () {
        // Last studied two days ago: yesterday went by unworked, so its 20
        // minutes are owed on top of the 25 already outstanding.
        final schedule = _tightPlan(lastActiveDay: DateTime(2025, 12, 30));

        expect(schedule.daysSinceStudy, 2);
        expect(schedule.isBehind, isTrue);
        expect(schedule.missedDays, 1);
        expect(schedule.missedMinutes, 20);
        expect(schedule.outstandingMinutes, 45);
        expect(schedule.daysRemaining, 2);
        expect(schedule.availableMinutes, 40);
        // 45 minutes of work in two days is 23 a day, and it no longer fits in
        // the 40 minutes the runway holds.
        expect(schedule.requiredDailyMinutes, 23);
        expect(schedule.status, ScheduleStatus.needsMoreTime);
        expect(schedule.fits, isFalse);
        expect(schedule.spareMinutes, 0);
        expect(schedule.fitsAtRealisticPace, isTrue);
        expect(schedule.stepsToDrop, 0);
        expect(schedule.minutesAfterDropping, isNull);
        expect(
          schedule.reflowNote,
          'You have not studied for 2 days, so the plan now needs 23 minutes a '
          'day instead of 20.',
        );
      },
    );

    test('several missed days: 85 minutes in two days is 43 a day', () {
      // Four days without study is three days that went by unworked: 60
      // minutes owed on top of the 25 outstanding.
      final schedule = _tightPlan(lastActiveDay: DateTime(2025, 12, 28));

      expect(schedule.daysSinceStudy, 4);
      expect(schedule.missedDays, 3);
      expect(schedule.missedMinutes, 60);
      expect(schedule.outstandingMinutes, 85);
      expect(schedule.requiredDailyMinutes, 43);
      expect(schedule.status, ScheduleStatus.needsMoreTime);
      expect(schedule.fitsAtRealisticPace, isTrue);
      expect(schedule.stepsToDrop, 0);
      expect(
        schedule.reflowNote,
        'You have not studied for 4 days, so the plan now needs 43 minutes a '
        'day instead of 20.',
      );
    });

    test('the hour of the last activity does not matter', () {
      final late = _tightPlan(lastActiveDay: DateTime(2025, 12, 30, 23, 45));
      final midnight = _tightPlan(lastActiveDay: DateTime(2025, 12, 30));

      expect(late.daysSinceStudy, 2);
      expect(late.daysSinceStudy, midnight.daysSinceStudy);
      expect(late.requiredDailyMinutes, midnight.requiredDailyMinutes);
      expect(late.reflowNote, midnight.reflowNote);
      expect(late.lastActiveDay, DateTime.utc(2025, 12, 30));
    });

    test('activity dated in the future cannot make the plan behind', () {
      final schedule = _tightPlan(lastActiveDay: DateTime(2026, 1, 5));

      expect(schedule.daysSinceStudy, 0);
      expect(schedule.isBehind, isFalse);
      expect(schedule.requiredDailyMinutes, 13);
      expect(schedule.reflowNote, isNull);
    });
  });

  group('the real plan with a gap in the record', () {
    test('three days without study: the honest pace is still 2 a day', () {
      // 74 minutes of work, 58 days of runway at 20 a day. Two days went by
      // unworked, so the plan owes their 40 minutes too - and 114 minutes over
      // 58 days is still 2 minutes a day, inside the 20 that were set.
      final schedule = _realPlan(
        targetDate: _fiftyEightDaysOut,
        daily: 20,
        lastActiveDay: DateTime(2025, 12, 29),
      );

      expect(schedule.daysSinceStudy, 3);
      expect(schedule.isBehind, isTrue);
      expect(schedule.missedDays, 2);
      expect(schedule.missedMinutes, 40);
      expect(schedule.outstandingMinutes, 114);
      expect(schedule.daysRemaining, 58);
      expect(schedule.availableMinutes, 1160);
      expect(schedule.requiredDailyMinutes, 2);
      expect(schedule.status, ScheduleStatus.fits);
      expect(schedule.fitsAtRealisticPace, isTrue);
      expect(schedule.spareMinutes, 1046);
      expect(schedule.stepsToDrop, 0);
      expect(
        schedule.reflowNote,
        'You have not studied for 3 days, so the plan now needs 2 minutes a '
        'day, and the 20 you set still covers it.',
      );
    });

    test('one missed day on the real plan is said once, at 2 a day', () {
      final schedule = _realPlan(
        targetDate: _fiftyEightDaysOut,
        daily: 20,
        lastActiveDay: DateTime(2025, 12, 30),
      );

      expect(schedule.daysSinceStudy, 2);
      expect(schedule.missedDays, 1);
      expect(schedule.missedMinutes, 20);
      expect(schedule.outstandingMinutes, 94);
      expect(schedule.requiredDailyMinutes, 2);
      expect(
        schedule.reflowNote,
        'You have not studied for 2 days, so the plan now needs 2 minutes a '
        'day, and the 20 you set still covers it.',
      );
    });

    test('a gap that outruns any realistic pace says what would fit', () {
      // Two days to the target and 16 days without study: 15 days owed at 20
      // minutes is 300 minutes, so 374 minutes in two days is 187 a day - past
      // the 180 a candidate could keep. Drop the two least valuable steps (the
      // two twelve-minute drills) and 50 minutes of plan plus the 300 owed is
      // 175 a day.
      final schedule = _realPlan(
        targetDate: DateTime(2026, 1, 3),
        daily: 20,
        lastActiveDay: DateTime(2025, 12, 16),
      );

      expect(schedule.daysSinceStudy, 16);
      expect(schedule.isBehind, isTrue);
      expect(schedule.missedDays, 15);
      expect(schedule.missedMinutes, 300);
      expect(schedule.outstandingMinutes, 374);
      expect(schedule.daysRemaining, 2);
      expect(schedule.requiredDailyMinutes, 187);
      expect(schedule.status, ScheduleStatus.needsMoreTime);
      expect(schedule.fitsAtRealisticPace, isFalse);
      expect(StudyScheduler.realisticDailyCeilingMinutes, 180);
      expect(schedule.stepsToDrop, 2);
      expect(schedule.stepCount, 6);
      expect(schedule.minutesAfterDropping, 175);
      expect(
        schedule.reflowNote,
        'You have not studied for 16 days, so the plan needs 187 minutes a day '
        'and no longer fits at any realistic pace; dropping the 2 least '
        'valuable steps brings it to 175 minutes a day.',
      );
    });

    test('when nothing fits, it says that instead of naming a pace', () {
      // Twenty days without study in a two-day runway owes 380 minutes, more
      // than two 180-minute days hold, so no step at all survives the fit.
      final schedule = _realPlan(
        targetDate: DateTime(2026, 1, 3),
        daily: 20,
        lastActiveDay: DateTime(2025, 12, 12),
      );

      expect(schedule.daysSinceStudy, 20);
      expect(schedule.missedDays, 19);
      expect(schedule.missedMinutes, 380);
      expect(schedule.outstandingMinutes, 454);
      expect(schedule.requiredDailyMinutes, 227);
      expect(schedule.fitsAtRealisticPace, isFalse);
      expect(schedule.stepsToDrop, 6);
      expect(schedule.minutesAfterDropping, 190);
      expect(
        schedule.reflowNote,
        'You have not studied for 20 days, so the plan needs 227 minutes a day, '
        'and none of the 6 steps fit at 180 minutes a day.',
      );
    });
  });

  group('a gap against no runway, no budget or no plan', () {
    test('no target date: the gap is a fact, the note is not', () {
      final schedule = StudyScheduler.build(
        steps: <ScheduleStep>[_step('a', 13, 3), _step('b', 12, 2)],
        targetDate: null,
        dailyMinutes: 20,
        today: _today,
        lastActiveDay: DateTime(2025, 12, 28),
      );

      expect(schedule.status, ScheduleStatus.noTargetDate);
      expect(schedule.daysSinceStudy, 4);
      expect(schedule.isBehind, isTrue);
      // Nothing to divide by, so no pace is claimed and nothing is said.
      expect(schedule.requiredDailyMinutes, isNull);
      expect(schedule.reflowNote, isNull);
      expect(schedule.stepsToDrop, 0);
    });

    test(
      'a passed target date owes everything today, and says nothing new',
      () {
        final schedule = StudyScheduler.build(
          steps: <ScheduleStep>[_step('a', 13, 3), _step('b', 12, 2)],
          targetDate: DateTime(2025, 12, 29),
          dailyMinutes: 20,
          today: _today,
          lastActiveDay: DateTime(2025, 12, 28),
        );

        expect(schedule.status, ScheduleStatus.datePassed);
        expect(schedule.isBehind, isTrue);
        expect(schedule.missedDays, 3);
        // Everything left, catch-up included, is due today.
        expect(schedule.outstandingMinutes, 85);
        expect(schedule.requiredDailyMinutes, 85);
        expect(schedule.reflowNote, isNull);
      },
    );

    test('no budget: there is no cadence to raise', () {
      final schedule = StudyScheduler.build(
        steps: <ScheduleStep>[_step('a', 13, 3), _step('b', 12, 2)],
        targetDate: DateTime(2026, 1, 11),
        dailyMinutes: 0,
        today: _today,
        lastActiveDay: DateTime(2025, 12, 28),
      );

      expect(schedule.status, ScheduleStatus.noBudget);
      expect(schedule.daysSinceStudy, 4);
      // Zero minutes a day were promised, so zero minutes are owed.
      expect(schedule.missedMinutes, 0);
      expect(schedule.outstandingMinutes, 25);
      expect(schedule.requiredDailyMinutes, 3);
      expect(schedule.reflowNote, isNull);
    });

    test('an empty plan owes nothing, whatever the history says', () {
      final schedule = StudyScheduler.build(
        steps: const <ScheduleStep>[],
        targetDate: _fiftyEightDaysOut,
        dailyMinutes: 20,
        today: _today,
        lastActiveDay: DateTime(2025, 12, 28),
      );

      expect(schedule.status, ScheduleStatus.nothingPlanned);
      expect(schedule.missedDays, 0);
      expect(schedule.missedMinutes, 0);
      expect(schedule.outstandingMinutes, 0);
      expect(schedule.requiredDailyMinutes, 0);
      expect(schedule.reflowNote, isNull);
    });
  });
}
