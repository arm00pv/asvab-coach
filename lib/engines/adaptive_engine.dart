import '../data/models/catalog.dart';
import '../data/models/lesson.dart';
import '../data/models/mos.dart';
import '../data/models/score.dart';

/// Turns a score report into a specific, ordered study plan.
///
/// Ranking rule: a skill's priority rises with how badly it was missed, how much
/// its subtest is worth, and whether that subtest feeds the AFQT. That last term
/// matters because one point of Arithmetic Reasoning moves the AFQT composite
/// and every line score, while one point of Assembling Objects moves almost
/// nothing.
abstract final class AdaptiveEngine {
  /// How much a subtest matters to the score the user is chasing.
  static double subtestLeverage(Subtest s, {bool officerTrack = false}) {
    var weight = 1.0;
    if (s == Subtest.ar) weight = 3.0;
    if (s == Subtest.mk) weight = 2.6;
    if (s == Subtest.wk) weight = 2.4;
    if (s == Subtest.pc) weight = 2.2;
    if (officerTrack && (s == Subtest.wk || s == Subtest.pc)) weight += 0.8;
    if (officerTrack && s == Subtest.ar) weight += 0.6;
    return weight;
  }

  /// Skills ranked from most to least worth working on right now.
  static List<SkillPriority> priorities(
    ScoreReport report, {
    bool officerTrack = false,
    int minimumSample = 1,
  }) {
    final out = <SkillPriority>[];
    for (final entry in report.skillMastery.entries) {
      final mastery = entry.value;
      if (mastery.total < minimumSample) continue;
      final skill = Skills.maybeById(entry.key);
      if (skill == null) continue;
      final gap = 1 - mastery.mastery;
      final leverage = subtestLeverage(
        skill.subtest,
        officerTrack: officerTrack,
      );
      // Confidence penalty: skills the user flagged for review need attention
      // even when the raw accuracy looks acceptable.
      final flagPenalty = mastery.total == 0
          ? 0.0
          : (mastery.flags / mastery.total).clamp(0.0, 1.0) * 0.15;
      out.add(
        SkillPriority(
          skill: skill,
          mastery: mastery.mastery,
          urgency: gap * leverage * 10 + flagPenalty * 10,
          attempts: mastery.total,
          correct: mastery.correct,
        ),
      );
    }
    out.sort((a, b) => b.urgency.compareTo(a.urgency));
    return out;
  }

  /// Builds the ordered plan behind the dashboard's "do this next" card.
  static List<PlanStep> buildPlan(
    ScoreReport report, {
    GoalProfile? goal,
    int limit = 6,
  }) {
    final officer = goal?.officerTrack ?? false;
    final ranked = priorities(report, officerTrack: officer);
    final steps = <PlanStep>[];
    for (var i = 0; i < ranked.length && steps.length < limit; i++) {
      final p = ranked[i];
      final kind = p.mastery < 0.5
          ? PlanStepKind.lesson
          : (p.mastery < 0.8 ? PlanStepKind.drill : PlanStepKind.review);
      steps.add(
        PlanStep(
          skillId: p.skill.id,
          priority: i,
          kind: kind,
          reason: _reasonFor(p),
          estimatedGain: _gainFor(p),
        ),
      );
    }
    return steps;
  }

  static String _reasonFor(SkillPriority p) {
    final pct = (p.mastery * 100).round();
    final noun = p.attempts == 1 ? 'question' : 'questions';
    if (p.attempts <= 2) {
      return 'Only ${p.attempts} $noun seen here so far, and you answered '
          '$pct percent. A short lesson will settle it.';
    }
    if (p.mastery < 0.4) {
      return '$pct percent mastery across ${p.attempts} questions. This is a real gap.';
    }
    if (p.mastery < 0.75) {
      return '$pct percent mastery. Close, but these are the cheapest points on the board.';
    }
    return '$pct percent mastery. A quick review should lock it in.';
  }

  static String _gainFor(SkillPriority p) {
    final s = p.skill.subtest;
    if (s.feedsAfqt) {
      return 'Feeds ${s.abbr}, which is weighted inside your AFQT.';
    }
    return 'Feeds ${s.abbr}, which drives your line scores.';
  }

  /// Skills whose mastery is low enough to justify a full lesson.
  static List<String> weakSkillIds(ScoreReport report, {int limit = 5}) =>
      priorities(report)
          .take(limit)
          .map((p) => p.skill.id)
          .toList(growable: false);

  /// Picks the single best next action for the dashboard.
  static NextAction nextAction({
    required ScoreReport? lastReport,
    required List<Attempt> history,
    required GoalProfile goal,
    required int diagnosticCount,
    int dueReviews = 0,
  }) {
    // Retrieval practice beats new material, so a backlog in the review queue
    // outranks everything else.
    if (dueReviews >= 3) {
      return NextAction(
        kind: NextActionKind.review,
        title: 'Clear your review queue',
        body:
            'You have $dueReviews question${dueReviews == 1 ? '' : 's'} due from '
            'earlier attempts. Coming back to what you missed is the single '
            'highest-value thing you can do today.',
        cta: 'Start review',
      );
    }
    if (history.isEmpty && diagnosticCount == 0) {
      return const NextAction(
        kind: NextActionKind.diagnostic,
        title: 'Start with the placement diagnostic',
        body:
            '27 questions across all nine subtests, about half an hour. It tells '
            'the coach exactly where to aim before you spend hours on the wrong topic.',
        cta: 'Begin diagnostic',
      );
    }
    if (lastReport == null) {
      return const NextAction(
        kind: NextActionKind.lesson,
        title: 'Work through a lesson',
        body: 'Open a reinforcement lesson to build the fundamentals first.',
        cta: 'Browse lessons',
      );
    }
    final weak = weakSkillIds(lastReport, limit: 1);
    if (weak.isNotEmpty) {
      final skill = Skills.byId(weak.first);
      final mastery = lastReport.skillMastery[skill.id]?.mastery ?? 0;
      if (mastery < 0.6) {
        return NextAction(
          kind: NextActionKind.lesson,
          title: 'Reinforce: ${skill.label}',
          body:
              'Your weakest area right now at ${(mastery * 100).round()} percent '
              'mastery, and it feeds ${skill.subtest.abbr}.',
          cta: 'Open lesson',
          skillId: skill.id,
        );
      }
    }
    if (history.length >= 2) {
      return const NextAction(
        kind: NextActionKind.mock,
        title: 'Sit a full mock ASVAB',
        body:
            '135 questions, 197 minutes, official order and per-section timing. '
            'This is the rehearsal that actually matters.',
        cta: 'Start mock exam',
      );
    }
    return const NextAction(
      kind: NextActionKind.drill,
      title: 'Run a targeted drill',
      body: 'Twelve questions pulled from the skills costing you the most points.',
      cta: 'Start drill',
    );
  }
}

class SkillPriority {
  const SkillPriority({
    required this.skill,
    required this.mastery,
    required this.urgency,
    required this.attempts,
    required this.correct,
  });

  final Skill skill;
  final double mastery;
  final double urgency;
  final int attempts;
  final int correct;
}

enum NextActionKind { diagnostic, lesson, drill, mock, jobs, review }

class NextAction {
  const NextAction({
    required this.kind,
    required this.title,
    required this.body,
    required this.cta,
    this.skillId,
  });

  final NextActionKind kind;
  final String title;
  final String body;
  final String cta;
  final String? skillId;
}

/// A named learner profile. Personas drive the in-app QA lab and the automated
/// test suite, proving that scoring and coaching behave sensibly for very
/// different kinds of candidates rather than only for the average one.
class Persona {
  const Persona({
    required this.id,
    required this.name,
    required this.description,
    required this.accuracyBySubtest,
    this.timePerQuestionSeconds = 45,
    this.flagRate = 0.1,
  });

  final String id;
  final String name;
  final String description;
  final Map<Subtest, double> accuracyBySubtest;
  final int timePerQuestionSeconds;
  final double flagRate;

  double accuracyFor(Subtest s) => accuracyBySubtest[s] ?? 0.5;
}
