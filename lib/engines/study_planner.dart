import 'dart:math' as math;

import '../data/bank/lessons_index.dart';
import '../data/models/catalog.dart';
import '../data/models/mos.dart';
import '../data/models/score.dart';
import 'adaptive_engine.dart';

/// Turns a target date and a daily time budget into a week-by-week plan.
///
/// The app already knew the date and the budget but never did anything with
/// them, which left the learner to invent their own pacing. This does the
/// arithmetic out loud instead: how many skills need work, how long each takes,
/// how many full mocks fit, and whether the budget is enough.
abstract final class StudyPlanner {
  /// Minutes for one skill cycle: read the lesson, sit the mastery check, then
  /// drill it once.
  static const int lessonCycleMinutes = 25;

  /// A full mock is 197 minutes plus a review sitting.
  static const int mockMinutes = 260;

  static StudyPlan build({
    required ScoreReport? report,
    required GoalProfile goal,
    required DateTime now,
  }) {
    final days = goal.targetDate == null
        ? 30
        : math.max(0, goal.targetDate!.difference(now).inDays);
    final daily = goal.dailyMinutes.clamp(10, 240);
    final availableMinutes = days * daily;

    // Which skills actually need work.
    final ranked = report == null
        ? <SkillPriority>[]
        : AdaptiveEngine.priorities(report, officerTrack: goal.officerTrack);
    final needsWork = ranked.where((p) => p.mastery < 0.8).toList();
    final focus = needsWork.isEmpty
        ? ranked.take(4).toList()
        : needsWork.take(10).toList();

    final skillMinutes = focus.length * lessonCycleMinutes;

    // Mock cadence: one every two weeks, but never more than the bank can
    // support without repeating itself badly, and never fewer than one.
    final mocksWanted = math.max(1, days ~/ 14);
    final mocksAffordable = availableMinutes == 0
        ? 0
        : math.min(mocksWanted, availableMinutes ~/ mockMinutes);
    final mocks = math.max(0, mocksAffordable);
    final totalNeeded = skillMinutes + mocks * mockMinutes;

    final verdict = switch (availableMinutes) {
      0 => PlanVerdict.noTime,
      final a when a >= totalNeeded * 1.4 => PlanVerdict.comfortable,
      final a when a >= totalNeeded => PlanVerdict.sufficient,
      final a when a >= totalNeeded * 0.6 => PlanVerdict.tight,
      _ => PlanVerdict.insufficient,
    };

    final weeks = _weeks(days, focus, mocks, daily);

    return StudyPlan(
      daysUntilTest: days,
      dailyMinutes: daily,
      availableMinutes: availableMinutes,
      neededMinutes: totalNeeded,
      focus: focus,
      mocksPlanned: mocks,
      verdict: verdict,
      weeks: weeks,
      notes: _notes(report, focus, mocks, verdict, days),
    );
  }

  static List<StudyWeek> _weeks(
    int days,
    List<SkillPriority> focus,
    int mocks,
    int daily,
  ) {
    if (days <= 0) return const <StudyWeek>[];
    final weekCount = math.max(1, (days / 7).ceil());
    final perWeek = focus.isEmpty
        ? 1
        : math.max(1, (focus.length / weekCount).ceil());
    final weeks = <StudyWeek>[];
    var cursor = 0;
    var mockBudget = mocks;
    for (var w = 0; w < weekCount; w++) {
      final slice = focus.skip(cursor).take(perWeek).toList();
      cursor += slice.length;
      final isMockWeek =
          mockBudget > 0 && (w % 2 == 1 || cursor >= focus.length);
      if (isMockWeek) mockBudget--;
      weeks.add(
        StudyWeek(
          index: w + 1,
          skills: slice.map((p) => p.skill.id).toList(growable: false),
          mockThisWeek: isMockWeek,
          minutes: daily * 7,
        ),
      );
    }
    return weeks;
  }

  static List<String> _notes(
    ScoreReport? report,
    List<SkillPriority> focus,
    int mocks,
    PlanVerdict verdict,
    int days,
  ) {
    final notes = <String>[];
    if (report == null) {
      notes.add(
        'Sit the placement diagnostic first. Until there is a scored attempt, '
        'this schedule is pacing without a destination.',
      );
      return notes;
    }
    if (verdict == PlanVerdict.insufficient) {
      notes.add(
        'The budget is short for the work outstanding. Either add minutes, push '
        'the date back, or accept a narrower goal.',
      );
    }
    if (verdict == PlanVerdict.tight) {
      notes.add(
        'This is achievable but leaves no slack. Protect the mock sittings; they '
        'are the only rehearsal that counts.',
      );
    }
    final afqtWeak = focus.where((p) => p.skill.subtest.feedsAfqt).length;
    if (afqtWeak == 0 && focus.isNotEmpty) {
      notes.add(
        'Every skill needing work sits outside the AFQT. Do them anyway, but the '
        'fastest AFQT gains come from Arithmetic Reasoning and Mathematics '
        'Knowledge.',
      );
    }
    if (mocks == 0) {
      notes.add(
        'There is no room for a full mock inside the budget. A section practice '
        'on your weakest subtest is the next best rehearsal.',
      );
    }
    if (days <= 7) {
      notes.add(
        'Inside a week out, stop learning new material. Drill what you nearly '
        'know and get your sleep.',
      );
    }
    for (final p in focus.take(1)) {
      if (!LessonRepository.has(p.skill.id)) {
        notes.add(
          'The lesson for ${p.skill.label} is still being written; drill it '
          'instead and read the review explanations.',
        );
      }
    }
    return notes;
  }
}

enum PlanVerdict { comfortable, sufficient, tight, insufficient, noTime }

class StudyWeek {
  const StudyWeek({
    required this.index,
    required this.skills,
    required this.mockThisWeek,
    required this.minutes,
  });

  final int index;
  final List<String> skills;
  final bool mockThisWeek;
  final int minutes;

  List<Skill> get skillObjects =>
      skills.map(Skills.byId).toList(growable: false);
}

class StudyPlan {
  const StudyPlan({
    required this.daysUntilTest,
    required this.dailyMinutes,
    required this.availableMinutes,
    required this.neededMinutes,
    required this.focus,
    required this.mocksPlanned,
    required this.verdict,
    required this.weeks,
    required this.notes,
  });

  final int daysUntilTest;
  final int dailyMinutes;
  final int availableMinutes;
  final int neededMinutes;
  final List<SkillPriority> focus;
  final int mocksPlanned;
  final PlanVerdict verdict;
  final List<StudyWeek> weeks;
  final List<String> notes;

  String get verdictLabel => switch (verdict) {
    PlanVerdict.comfortable => 'Comfortable',
    PlanVerdict.sufficient => 'On track',
    PlanVerdict.tight => 'Tight',
    PlanVerdict.insufficient => 'Not enough time',
    PlanVerdict.noTime => 'No time budget',
  };
}
