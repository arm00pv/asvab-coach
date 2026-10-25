import 'catalog.dart';
import 'line_score.dart';
import 'question.dart';

/// Result for one subtest inside a single attempt.
class SubtestScore {
  const SubtestScore({
    required this.subtest,
    required this.correct,
    required this.total,
    required this.standardScore,
    required this.secondsSpent,
    required this.difficultyAdjustedRate,
  });

  final Subtest subtest;
  final int correct;
  final int total;

  /// Estimated ASVAB subtest standard score on the official 1-99 scale
  /// (mean 50, standard deviation 10).
  final int standardScore;

  final int secondsSpent;

  /// Weighted accuracy in 0..1 where harder questions count more.
  final double difficultyAdjustedRate;

  double get rate => total == 0 ? 0 : correct / total;
  bool get hasData => total > 0;
  int get secondsPerQuestion => total == 0 ? 0 : (secondsSpent / total).round();
}

/// Mastery for one skill tag, accumulated inside a single attempt.
class SkillMastery {
  const SkillMastery({
    required this.skillId,
    required this.correct,
    required this.total,
    this.flags = 0,
  });

  final String skillId;
  final int correct;
  final int total;

  /// Questions the user marked for review, a signal of low confidence.
  final int flags;

  double get rate => total == 0 ? 0 : correct / total;

  /// 0..1 mastery with a small-sample shrinkage so 1/1 does not read as 100%.
  double get mastery {
    if (total == 0) return 0;
    const prior = 2.0;
    const priorRate = 0.5;
    return (correct + prior * priorRate) / (total + prior);
  }
}

/// A complete scored attempt. This is the single object every insight screen
/// reads from, which keeps scoring logic in exactly one place.
class ScoreReport {
  const ScoreReport({
    required this.subtestScores,
    required this.skillMastery,
    required this.ve,
    required this.afqtComposite,
    required this.afqtPercentile,
    required this.lineScores,
    required this.elapsedSeconds,
    required this.totalAnswered,
    required this.totalCorrect,
  });

  final Map<Subtest, SubtestScore> subtestScores;
  final Map<String, SkillMastery> skillMastery;

  /// Estimated Verbal Expression standard score (WK + PC, both on the 1-99
  /// subtest scale, then re-anchored so VE itself averages 50).
  final int ve;

  /// 2 x VE + AR + MK on the subtest standard-score scale.
  final int afqtComposite;

  /// Estimated AFQT percentile, 1-99.
  final int afqtPercentile;

  final Map<LineScore, int> lineScores;
  final int elapsedSeconds;
  final int totalAnswered;
  final int totalCorrect;

  int scoreFor(Subtest s) => subtestScores[s]?.standardScore ?? 0;
  int lineFor(LineScore s) => lineScores[s] ?? 0;
  int get gt => lineFor(LineScore.gt);

  /// AFQT category band. Bands verified against the 1997 score scale
  /// (Segall 2004, Table 2.2): I 93-99, II 65-92, IIIA 50-64, IIIB 31-49,
  /// IVA 21-30, IVB 16-20, IVC 10-15, V 1-9.
  String get category {
    final p = afqtPercentile;
    if (p >= 93) return 'I';
    if (p >= 65) return 'II';
    if (p >= 50) return 'IIIA';
    if (p >= 31) return 'IIIB';
    if (p >= 21) return 'IVA';
    if (p >= 16) return 'IVB';
    if (p >= 10) return 'IVC';
    return 'V';
  }

  /// Whether the score clears the Army National Guard enlistment floor for a
  /// traditional high school diploma graduate.
  bool get meetsArmyFloor => afqtPercentile >= 31;

  /// The GT an officer candidate needs for OCS or warrant officer.
  static const int officerGtMinimum = 110;

  SubtestScore? operator [](Subtest s) => subtestScores[s];
}

enum ExamKind {
  diagnostic('Diagnostic', 'A short placement test across all nine subtests.'),
  fullMock(
    'Full Mock',
    'Every subtest, official question counts and time limits.',
  ),
  section('Section Practice', 'One subtest, untimed by default.'),
  drill('Targeted Drill', 'Questions drawn from your weakest skills.'),
  lessonQuiz(
    'Lesson Check',
    'A short mastery check after a reinforcement lesson.',
  );

  const ExamKind(this.label, this.blurb);
  final String label;
  final String blurb;
}

/// A finished attempt, persisted to local storage.
class Attempt {
  const Attempt({
    required this.id,
    required this.kind,
    required this.startedAt,
    required this.finishedAt,
    required this.report,
    required this.responses,
    required this.questionIds,
    this.subtests = const <Subtest>[],
  });

  final String id;
  final ExamKind kind;
  final DateTime startedAt;
  final DateTime finishedAt;
  final ScoreReport report;
  final List<QuestionResponse> responses;
  final List<String> questionIds;
  final List<Subtest> subtests;

  Duration get duration => finishedAt.difference(startedAt);
}
