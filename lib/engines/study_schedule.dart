import 'dart:math' as math;

import '../data/bank/lessons_index.dart';
import '../data/models/lesson.dart';
import '../data/models/mos.dart';

/// Turns the ordered plan into a day-by-day schedule against the target date.
///
/// The plan knows what is worth doing and nothing about when. A candidate who
/// set a target date and a daily minutes budget still had to invent a cadence
/// between the two, so this does that arithmetic out loud: the days that are
/// left, the minutes those days hold, whether the outstanding work fits inside
/// them, how many steps a day that comes to, and - when it does not fit - the
/// minutes a day the work would actually need. "It needs 37 minutes a day" is
/// an answer; "you are behind" is not.
///
/// A plan drawn against a date assumes one day of study per day. A candidate
/// who has since skipped whole days owes the minutes those days were meant to
/// hold, and the runway to the target did not grow to make room for them, so
/// the same work costs more a day than it did. That is the whole of the
/// recalculation here: [StudySchedule.requiredDailyMinutes] rises, and
/// [StudySchedule.reflowNote] states it once, as a number. Nothing counts a
/// streak, and nothing tells anybody off.
///
/// Every question is answered from the numbers passed in. There is no clock
/// inside: [today] and [lastActiveDay] are arguments, so the same inputs always
/// give the same schedule and a test can pin the answer to a fixed date.
abstract final class StudyScheduler {
  /// Reading a lesson, on top of the minutes it is authored at: the mastery
  /// check at the end has to be sat for the step to count as done.
  static const int masteryCheckMinutes = 6;

  /// A drill is twelve questions and the review of what was missed.
  static const int drillMinutes = 12;

  /// A review sitting over the questions flagged in an earlier attempt.
  static const int reviewMinutes = 8;

  /// A full mock is the paper plus a review sitting, the same figure the
  /// planner uses.
  static const int mockMinutes = 260;

  /// What a lesson step costs when its lesson has not been written yet.
  static const int unwrittenLessonMinutes = 10;

  /// Days without study before the cadence has been missed.
  ///
  /// Last studied yesterday is on cadence: yesterday was that day's session and
  /// today is the one the cadence set aside for the next. Behind starts at two
  /// days without study, which is one day that went by unworked.
  static const int behindAfterDaysWithoutStudy = 2;

  /// The most minutes a day a candidate can realistically put into the plan.
  ///
  /// Past this the pace is not a recommendation any more, so a schedule that
  /// needs more says what part of the plan still fits instead of stating a
  /// number nobody could keep.
  static const int realisticDailyCeilingMinutes = 180;

  /// What one plan step costs, in minutes.
  static int minutesFor(PlanStep step) => switch (step.kind) {
    PlanStepKind.lesson =>
      (LessonRepository.bySkill(step.skillId)?.minutes ??
              unwrittenLessonMinutes) +
          masteryCheckMinutes,
    PlanStepKind.drill => drillMinutes,
    PlanStepKind.review => reviewMinutes,
    PlanStepKind.mock => mockMinutes,
  };

  /// The plan, mapped onto what the scheduler needs.
  ///
  /// Minutes come from the authored lesson where there is one. Points come from
  /// the plan's own order, which was already a value ordering: the first step is
  /// worth more to the score than the last.
  static List<ScheduleStep> stepsFromPlan(List<PlanStep> plan) {
    final count = plan.length;
    return <ScheduleStep>[
      for (final step in plan)
        ScheduleStep(
          id: step.skillId,
          label: step.skill.label,
          minutes: minutesFor(step),
          points: (count - step.priority).toDouble(),
        ),
    ];
  }

  /// The plan against a stated goal, which is the pair the plan screen holds.
  ///
  /// [lastActiveDay] is the calendar day of the candidate's last finished
  /// attempt, handed in from the stored history. It is never read from the
  /// clock here, and it is null when there is no history: a candidate with no
  /// attempts has no cadence to be behind, and no start date is invented for
  /// them.
  static StudySchedule forPlan({
    required List<PlanStep> plan,
    required GoalProfile? goal,
    required DateTime today,
    DateTime? lastActiveDay,
  }) => build(
    steps: stepsFromPlan(plan),
    targetDate: goal?.targetDate,
    dailyMinutes: goal?.dailyMinutes ?? 0,
    today: today,
    lastActiveDay: lastActiveDay,
  );

  /// The schedule, from the steps, the two numbers the candidate stated and
  /// the day they last studied.
  static StudySchedule build({
    required List<ScheduleStep> steps,
    required DateTime? targetDate,
    required int dailyMinutes,
    required DateTime today,
    DateTime? lastActiveDay,
  }) {
    // Value order, ties broken on id, so the schedule is the same however the
    // caller happened to order the list it handed over.
    final ordered = List<ScheduleStep>.of(steps)
      ..sort((a, b) {
        final byValue = b.points.compareTo(a.points);
        return byValue != 0 ? byValue : a.id.compareTo(b.id);
      });
    final needed = ordered.fold<int>(0, (sum, s) => sum + s.minutes);
    final budget = math.max(0, dailyMinutes);
    final start = _midnight(today);
    final days = targetDate == null
        ? null
        : math.max(0, _midnight(targetDate).difference(start).inDays);
    final available = days == null ? null : days * budget;

    // The gap in the record. A day that went by unworked still owed the minutes
    // the cadence gave it, and the days left to the target are the same number
    // they were, so that work lands on the days that remain. Today is not a
    // missed day yet: it is the day in hand.
    final active = lastActiveDay == null ? null : _midnight(lastActiveDay);
    final sinceStudy = active == null
        ? null
        : math.max(0, start.difference(active).inDays);
    // Nothing planned is nothing to fall behind on, so an empty plan owes no
    // catch-up minutes whatever the history says.
    final missedDays = sinceStudy == null || ordered.isEmpty
        ? 0
        : math.max(0, sinceStudy - 1);
    final missed = missedDays * budget;
    final outstanding = needed + missed;

    final ScheduleStatus status;
    if (ordered.isEmpty) {
      status = ScheduleStatus.nothingPlanned;
    } else if (days == null) {
      status = ScheduleStatus.noTargetDate;
    } else if (days == 0) {
      status = ScheduleStatus.datePassed;
    } else if (budget == 0) {
      status = ScheduleStatus.noBudget;
    } else if (available! >= outstanding) {
      status = ScheduleStatus.fits;
    } else {
      status = ScheduleStatus.needsMoreTime;
    }

    // Without a date there is nothing to pace against, so the cadence is one
    // step at a time. Once the date has gone, everything left is due today.
    final stepsPerDay = switch (status) {
      ScheduleStatus.nothingPlanned => 0,
      ScheduleStatus.noTargetDate => 1,
      ScheduleStatus.datePassed => ordered.length,
      _ => math.max(1, (ordered.length + days! - 1) ~/ days),
    };

    // What the work costs per day, catch-up included. A date that has already
    // gone leaves one day: today.
    final required = switch (days) {
      null => null,
      0 => outstanding,
      _ => (outstanding + days - 1) ~/ days,
    };

    // What would fit when the work no longer fits at any pace a candidate could
    // keep: drop the least valuable steps first. The order is value order, so
    // the tail is what goes and the number dropped is worth naming.
    final ceilingCapacity = days == null
        ? null
        : days * realisticDailyCeilingMinutes - missed;
    var stepsToDrop = 0;
    int? minutesAfterDropping;
    if (required != null && required > realisticDailyCeilingMinutes) {
      var kept = 0;
      var keptMinutes = 0;
      for (final s in ordered) {
        if (keptMinutes + s.minutes > ceilingCapacity!) break;
        keptMinutes += s.minutes;
        kept++;
      }
      stepsToDrop = ordered.length - kept;
      minutesAfterDropping = switch (days) {
        null => null,
        0 => keptMinutes + missed,
        _ => (keptMinutes + missed + days - 1) ~/ days,
      };
    }

    final planned = <ScheduleDay>[];
    var cursor = 0;
    for (var offset = 0; offset <= 2 && cursor < ordered.length; offset++) {
      final slice = ordered
          .skip(cursor)
          .take(stepsPerDay)
          .toList(growable: false);
      if (slice.isEmpty) break;
      cursor += slice.length;
      planned.add(
        ScheduleDay(
          offset: offset,
          date: start.add(Duration(days: offset)),
          steps: slice,
          minutes: slice.fold<int>(0, (sum, s) => sum + s.minutes),
        ),
      );
    }

    return StudySchedule(
      status: status,
      today: start,
      dailyMinutes: budget,
      neededMinutes: needed,
      outstandingMinutes: outstanding,
      lastActiveDay: active,
      daysSinceStudy: sinceStudy,
      missedDays: missedDays,
      missedMinutes: missed,
      daysRemaining: days,
      availableMinutes: available,
      requiredDailyMinutes: required,
      stepsToDrop: stepsToDrop,
      minutesAfterDropping: minutesAfterDropping,
      stepsPerDay: stepsPerDay,
      stepsThroughToday: planned.isEmpty ? 0 : planned.first.steps.length,
      stepCount: ordered.length,
      days: List<ScheduleDay>.unmodifiable(planned),
      orderedSteps: List<ScheduleStep>.unmodifiable(ordered),
    );
  }

  /// A date with no time of day, in UTC.
  ///
  /// Day counts are differences of these, so a daylight-saving shift inside the
  /// window cannot turn 58 days into 57.
  static DateTime _midnight(DateTime d) => DateTime.utc(d.year, d.month, d.day);
}

/// A plan step as the scheduler sees it: what it costs and what it is worth.
class ScheduleStep {
  const ScheduleStep({
    required this.id,
    required this.label,
    required this.minutes,
    required this.points,
  });

  final String id;
  final String label;

  /// What the step costs to do, in minutes.
  final int minutes;

  /// What the step is worth to the score. Orders the schedule: the most
  /// valuable step is the one that comes first.
  final double points;

  @override
  bool operator ==(Object other) =>
      other is ScheduleStep &&
      other.id == id &&
      other.label == label &&
      other.minutes == minutes &&
      other.points == points;

  @override
  int get hashCode => Object.hash(id, label, minutes, points);
}

/// One day of the schedule.
class ScheduleDay {
  const ScheduleDay({
    required this.offset,
    required this.date,
    required this.steps,
    required this.minutes,
  });

  /// 0 is today, 1 tomorrow.
  final int offset;
  final DateTime date;
  final List<ScheduleStep> steps;
  final int minutes;
}

enum ScheduleStatus {
  /// The plan is empty, so there is nothing to schedule.
  nothingPlanned,

  /// No target date was set, so there is no runway to divide the work over.
  noTargetDate,

  /// The target date is today or already behind.
  datePassed,

  /// There is a date but no daily minutes to spend on it.
  noBudget,

  /// The outstanding work fits inside the minutes the days hold.
  fits,

  /// It does not fit: [StudySchedule.requiredDailyMinutes] is the honest pace.
  needsMoreTime,
}

/// The answer: how many days are left, what they hold, what the work costs, and
/// which steps land on today and the two days after it.
class StudySchedule {
  const StudySchedule({
    required this.status,
    required this.today,
    required this.dailyMinutes,
    required this.neededMinutes,
    required this.outstandingMinutes,
    required this.lastActiveDay,
    required this.daysSinceStudy,
    required this.missedDays,
    required this.missedMinutes,
    required this.daysRemaining,
    required this.availableMinutes,
    required this.requiredDailyMinutes,
    required this.stepsToDrop,
    required this.minutesAfterDropping,
    required this.stepsPerDay,
    required this.stepsThroughToday,
    required this.stepCount,
    required this.days,
    required this.orderedSteps,
  });

  final ScheduleStatus status;

  /// Midnight of the day the schedule was built for.
  final DateTime today;

  /// The budget that was passed in, floored at zero.
  final int dailyMinutes;

  /// What the plan's steps cost, in minutes, added up.
  final int neededMinutes;

  /// What is actually outstanding today: [neededMinutes] plus the minutes the
  /// days missed since the last study session were meant to hold.
  ///
  /// Equal to [neededMinutes] whenever the candidate is on cadence.
  final int outstandingMinutes;

  /// Midnight of the last day the candidate studied, as handed in. Null when
  /// no date was given, which is the case for a candidate with no attempts:
  /// no start date is invented for them.
  final DateTime? lastActiveDay;

  /// Calendar days from [lastActiveDay] to [today]. Zero for activity today,
  /// null when there is no activity to count from.
  final int? daysSinceStudy;

  /// Whole days that went by unworked, which is [daysSinceStudy] less today:
  /// the day in hand is not a missed one. Zero when on cadence.
  final int missedDays;

  /// What the missed days were meant to hold: [missedDays] times
  /// [dailyMinutes]. Zero when on cadence, and zero when nothing is planned -
  /// there is nothing to fall behind on with an empty plan.
  final int missedMinutes;

  /// Days from today to the target date. Null when no date was set.
  final int? daysRemaining;

  /// [daysRemaining] times [dailyMinutes]: the minutes the runway holds as a
  /// whole. Null when no date was set.
  final int? availableMinutes;

  /// The minutes a day [outstandingMinutes] actually needs.
  ///
  /// Null only when there is no target date to divide by. When the date has
  /// passed, everything left is due today and this is [outstandingMinutes].
  ///
  /// This is the honest pace, catch-up included: while the candidate is behind
  /// it is higher than it was when the plan was drawn, because the work did not
  /// shrink and the runway did not grow.
  final int? requiredDailyMinutes;

  /// How many of the least valuable steps to drop so that what is left fits at
  /// [StudyScheduler.realisticDailyCeilingMinutes] a day.
  ///
  /// Zero unless the work no longer fits at any realistic pace. The steps that
  /// go are always the tail of [orderedSteps], which is value order.
  final int stepsToDrop;

  /// The minutes a day that remains once [stepsToDrop] steps have gone. Null
  /// unless the work no longer fits at any realistic pace.
  final int? minutesAfterDropping;

  /// Steps a day. One at a time with no date to pace against, every remaining
  /// step when the date has gone, otherwise the count the days demand.
  final int stepsPerDay;

  /// Steps that land on today.
  final int stepsThroughToday;

  /// Steps in the plan.
  final int stepCount;

  /// Today, tomorrow and the day after, as far as the steps reach.
  final List<ScheduleDay> days;

  /// The steps in value order, whatever order they were passed in.
  final List<ScheduleStep> orderedSteps;

  bool get fits => status == ScheduleStatus.fits;

  /// True when whole days have gone by since the last study session, so the
  /// cadence the schedule assumed has been missed.
  ///
  /// A candidate with no recorded activity is not behind: there is no cadence
  /// to have missed, and nothing is assumed about when they started.
  bool get isBehind =>
      (daysSinceStudy ?? 0) >= StudyScheduler.behindAfterDaysWithoutStudy;

  /// True when the outstanding work still fits inside a pace a candidate could
  /// keep. False means the plan is no longer doable as drawn.
  bool get fitsAtRealisticPace {
    final required = requiredDailyMinutes;
    return required == null ||
        required <= StudyScheduler.realisticDailyCeilingMinutes;
  }

  /// Minutes left over once the work is done. Null when there is no date, and
  /// zero when the work does not fit.
  int? get spareMinutes {
    final available = availableMinutes;
    if (available == null) return null;
    return math.max(0, available - outstandingMinutes);
  }

  /// The one sentence the plan says when it has been recalculated, or null
  /// when there is nothing to recalculate.
  ///
  /// Null whenever the candidate is on cadence - a candidate who has kept up is
  /// told nothing at all, because there is nothing to say. Null too when there
  /// is no runway or no budget to redo the arithmetic against: without a date,
  /// or with one that has passed, there is no cadence left to fall behind.
  ///
  /// What it says is a sum, not a remark: the gap in days, the minutes a day
  /// that gap now costs, and - when the pace has gone past what anyone could
  /// keep - how many of the least valuable steps would have to go for the rest
  /// to fit. Nothing in it is a verdict on the candidate.
  String? get reflowNote {
    final since = daysSinceStudy;
    final required = requiredDailyMinutes;
    final days = daysRemaining;
    if (since == null || !isBehind) return null;
    if (required == null || days == null || days < 1) return null;
    if (dailyMinutes < 1 || stepCount == 0) return null;

    final head = 'You have not studied for ${_days(since)}, so the plan';
    if (fitsAtRealisticPace) {
      // Still doable at the budget that was set: say so, with the number.
      return required <= dailyMinutes
          ? '$head now needs ${_minutes(required)} a day, and the '
                '$dailyMinutes you set still covers it.'
          : '$head now needs ${_minutes(required)} a day instead of '
                '$dailyMinutes.';
    }
    // No pace a candidate could keep finishes this plan, so name the part of it
    // that still fits rather than a number nobody could hold to.
    final ceiling = StudyScheduler.realisticDailyCeilingMinutes;
    if (stepsToDrop >= stepCount) {
      return '$head needs ${_minutes(required)} a day, and none of the '
          '${_steps(stepCount)} fit at ${_minutes(ceiling)} a day.';
    }
    return '$head needs ${_minutes(required)} a day and no longer fits at '
        'any realistic pace; dropping the $stepsToDrop least valuable '
        '${stepsToDrop == 1 ? 'step' : 'steps'} brings it to '
        '${_minutes(minutesAfterDropping ?? 0)} a day.';
  }

  /// How far through the plan today's work puts the candidate, 0..1.
  double get progressAfterToday =>
      stepCount == 0 ? 0 : stepsThroughToday / stepCount;

  /// The steps that fall on today.
  List<ScheduleStep> get todaySteps =>
      days.isEmpty ? const <ScheduleStep>[] : days.first.steps;

  /// The steps that fall on tomorrow.
  List<ScheduleStep> get tomorrowSteps =>
      days.length < 2 ? const <ScheduleStep>[] : days[1].steps;
}

String _minutes(int n) => '$n minute${n == 1 ? '' : 's'}';

String _days(int n) => '$n day${n == 1 ? '' : 's'}';

String _steps(int n) => '$n step${n == 1 ? '' : 's'}';
