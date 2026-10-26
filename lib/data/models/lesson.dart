import 'catalog.dart';

/// One block of instructional prose inside a reinforcement lesson.
class LessonSection {
  const LessonSection(
    this.heading,
    this.body, {
    this.bullets = const <String>[],
  });
  final String heading;
  final String body;
  final List<String> bullets;
}

/// A fully worked example, written the way an instructor would talk it out.
class WorkedExample {
  const WorkedExample({
    required this.prompt,
    required this.steps,
    required this.answer,
  });
  final String prompt;
  final List<String> steps;
  final String answer;
}

/// The answer a candidate usually picks instead of the right one, and the
/// reason that answer is wrong.
///
/// A [WorkedExample] shows the route to the answer. A `CommonMistake` shows
/// the wrong turn taken most often instead, because recognising your own wrong
/// answer is faster than relearning the rule behind it.
class CommonMistake {
  const CommonMistake({required this.answer, required this.why});

  /// The wrong answer candidates actually report, written as the value they
  /// wrote down rather than as a description of their mistake.
  final String answer;

  /// Why that answer is wrong, and which move produces the right one.
  final String why;
}

/// The reinforcement lesson for one skill. Lessons are the "instructor" half
/// of the app: after a diagnostic they are selected by weakest skill, and
/// they always end with a mastery check drawn from the question bank.
class Lesson {
  const Lesson({
    required this.skillId,
    required this.title,
    required this.hook,
    required this.whyItMatters,
    required this.sections,
    required this.examples,
    required this.quickRules,
    required this.pitfalls,
    required this.minutes,
    this.commonMistakes = const <CommonMistake>[],
  });

  final String skillId;
  final String title;

  /// One-sentence attention grabber.
  final String hook;

  /// Connects the skill to the score the user is chasing.
  final String whyItMatters;

  final List<LessonSection> sections;

  /// Every lesson carries at least two, so a learner who did not follow the
  /// first route through the problem gets a second one.
  final List<WorkedExample> examples;

  final List<String> quickRules;

  /// The specific mistakes that cost points on this skill.
  final List<String> pitfalls;

  /// The wrong answers this skill attracts, each with the reason it is wrong.
  /// Defaults to empty so a lesson written before this section existed still
  /// builds.
  final List<CommonMistake> commonMistakes;

  final int minutes;

  Skill get skill => Skills.byId(skillId);
  Subtest get subtest => skill.subtest;
}

/// A step in a personalised study plan.
class PlanStep {
  const PlanStep({
    required this.skillId,
    required this.priority,
    required this.reason,
    required this.estimatedGain,
    required this.kind,
  });

  final String skillId;

  /// 0 = most urgent.
  final int priority;

  final String reason;
  final String estimatedGain;
  final PlanStepKind kind;

  Skill get skill => Skills.byId(skillId);
}

enum PlanStepKind {
  lesson('Lesson'),
  drill('Drill'),
  review('Review'),
  mock('Mock exam');

  const PlanStepKind(this.label);
  final String label;
}
