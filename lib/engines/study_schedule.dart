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
/// Every question is answered from the numbers passed in. There is no clock
/// inside: [today] is an argument, so the same inputs always give the same
/// schedule and a test can pin the answer to a fixed date.
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
  static StudySchedule forPlan({
    required List<PlanStep> plan,
    required GoalProfile? goal,
    required DateTime today,
  }) => build(
    steps: stepsFromPlan(plan),
    targetDate: goal?.targetDate,
    dailyMinutes: goal?.dailyMinutes ?? 0,
    today: today,
  );

  /// The schedule, from the steps and the two numbers the candidate stated.
  static StudySchedule build({
    required List<ScheduleStep> steps,
    required DateTime? targetDate,
    required int dailyMinutes,
    required DateTime today,
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

    final ScheduleStatus status;
    if (ordered.isEmpty) {
      status = ScheduleStatus.nothingPlanned;
    } else if (days == null) {
      status = ScheduleStatus.noTargetDate;
    } else if (days == 0) {
      status = ScheduleStatus.datePassed;
    } else if (budget == 0) {
      status = ScheduleStatus.noBudget;
    } else if (available! >= needed) {
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

    // What the work costs per day. A date that has already gone leaves one day:
    // today.
    final required = switch (days) {
      null => null,
      0 => needed,
      _ => (needed + days - 1) ~/ days,
    };

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
      daysRemaining: days,
      availableMinutes: available,
      requiredDailyMinutes: required,
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
    required this.daysRemaining,
    required this.availableMinutes,
    required this.requiredDailyMinutes,
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

  /// Total minutes of work outstanding: every step, added up.
  final int neededMinutes;

  /// Days from today to the target date. Null when no date was set.
  final int? daysRemaining;

  /// [daysRemaining] times [dailyMinutes]: the minutes the runway holds as a
  /// whole. Null when no date was set.
  final int? availableMinutes;

  /// The minutes a day the outstanding work actually needs.
  ///
  /// Null only when there is no target date to divide by. When the date has
  /// passed, everything left is due today and this is [neededMinutes].
  final int? requiredDailyMinutes;

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

  /// Minutes left over once the work is done. Null when there is no date, and
  /// zero when the work does not fit.
  int? get spareMinutes {
    final available = availableMinutes;
    if (available == null) return null;
    return math.max(0, available - neededMinutes);
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
