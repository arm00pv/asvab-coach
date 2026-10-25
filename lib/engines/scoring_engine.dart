import 'dart:math' as math;

import '../data/models/catalog.dart';
import '../data/models/line_score.dart';
import '../data/models/question.dart';
import '../data/models/score.dart';

/// Converts raw responses into a full score report.
///
/// Model
/// -----
/// ASVAB subtest scores are reported on a scale with mean 50 and standard
/// deviation 10. The '97 scale is explicitly untruncated, so values are not
/// forced into 1-99 - that range belongs to the AFQT percentile, not to
/// subtest scores.
///
/// No practice test can reproduce ETS item-response equating. This engine takes
/// the documented approximation route: treat difficulty-weighted accuracy as a
/// percentile of ability and convert it through the inverse normal CDF, so a
/// candidate answering half the items correctly lands on the national mean of
/// 50 and a candidate answering 90 percent lands near 63. Small sections are
/// shrunk toward 50 because three questions cannot support a confident estimate.
///
/// AFQT is AR + MK + 2 x VE (composite mean 202, SD about 36 in PAY97). It is
/// then converted to a percentile through an empirical anchor table derived from
/// the published AFQT lookup (Segall 2004, Table 2.5) rather than a pure normal
/// curve, because the real AFQT distribution has heavier tails than a normal.
abstract final class ScoringEngine {
  /// AFQTS anchors: composite score -> AFQT percentile. The endpoints are the
  /// published clamps (composite <= 109 -> 1st percentile, >= 269 -> 99th).
  static const List<(int, int)> afqtAnchors = <(int, int)>[
    (96, 1),
    (109, 1),
    (136, 5),
    (148, 9),
    (160, 14),
    (168, 19),
    (172, 22),
    (180, 28),
    (184, 32),
    (188, 35),
    (196, 44),
    (200, 48),
    (202, 50),
    (204, 52),
    (212, 61),
    (216, 66),
    (220, 70),
    (228, 77),
    (232, 81),
    (240, 87),
    (252, 94),
    (264, 98),
    (269, 99),
    (304, 99),
  ];

  /// Difficulty-weighted accuracy (0..1) -> subtest standard score.
  ///
  /// Inverse normal CDF of the accuracy, clamped away from 0 and 1 so no finite
  /// run can claim a perfect or hopeless score.
  static double rateToStandardScore(double rate) {
    final p = rate.clamp(0.005, 0.995);
    return (50 + 10 * _inverseNormal(p)).clamp(1.0, 99.0);
  }

  /// Standard-score estimate for one subtest.
  static int standardScore({
    required double weightedRate,
    required int answered,
    int expectedQuestions = 16,
  }) {
    if (answered == 0) return 0;
    // Shrink toward 50 when the sample is tiny: a two-question section must not
    // produce a 76.
    final confidence = math.min(1.0, answered / (expectedQuestions * 0.6));
    final adjusted = 0.5 + (weightedRate - 0.5) * (0.55 + 0.45 * confidence);
    return rateToStandardScore(adjusted).round().clamp(1, 99);
  }

  /// Difficulty-weighted accuracy for a group of responses.
  static double weightedRate({
    required List<Question> questions,
    required Map<String, QuestionResponse> responses,
  }) {
    if (questions.isEmpty) return 0;
    var earned = 0.0;
    var possible = 0.0;
    for (final q in questions) {
      final r = responses[q.id];
      final w = q.difficulty.weight;
      possible += w;
      if (r != null && r.isAnswered && r.selectedIndex == q.answerIndex) {
        earned += w;
      }
    }
    return possible == 0 ? 0 : earned / possible;
  }

  /// AFQT composite (AR + MK + 2 x VE) -> percentile, 1..99.
  static int afqtPercentileFromComposite(int composite) {
    if (composite <= afqtAnchors.first.$1) return 1;
    if (composite >= afqtAnchors.last.$1) return 99;
    for (var i = 0; i < afqtAnchors.length - 1; i++) {
      final (x0, y0) = afqtAnchors[i];
      final (x1, y1) = afqtAnchors[i + 1];
      if (composite >= x0 && composite <= x1) {
        if (x1 == x0) return y1;
        final t = (composite - x0) / (x1 - x0);
        return (y0 + t * (y1 - y0)).round().clamp(1, 99);
      }
    }
    return 50;
  }

  /// Full scoring pass.
  static ScoreReport score({
    required List<Question> questions,
    required List<QuestionResponse> responses,
    required int elapsedSeconds,
  }) {
    final responseById = <String, QuestionResponse>{
      for (final r in responses) r.questionId: r,
    };

    final grouped = <Subtest, List<Question>>{};
    for (final q in questions) {
      grouped.putIfAbsent(q.subtest, () => <Question>[]).add(q);
    }

    final subtestScores = <Subtest, SubtestScore>{};
    for (final entry in grouped.entries) {
      final sub = entry.key;
      final list = entry.value;
      var correct = 0;
      var seconds = 0;
      for (final q in list) {
        final r = responseById[q.id];
        if (r != null) {
          seconds += r.secondsSpent;
          if (r.isAnswered && r.selectedIndex == q.answerIndex) correct++;
        }
      }
      final rate = weightedRate(questions: list, responses: responseById);
      subtestScores[sub] = SubtestScore(
        subtest: sub,
        correct: correct,
        total: list.length,
        standardScore: standardScore(
          weightedRate: rate,
          answered: list.length,
          expectedQuestions: sub.questionCount,
        ),
        secondsSpent: seconds,
        difficultyAdjustedRate: rate,
      );
    }

    // VE is the optimally weighted WK/PC composite on the subtest scale.
    final hasVe =
        subtestScores.containsKey(Subtest.wk) ||
        subtestScores.containsKey(Subtest.pc);
    final ve = hasVe
        ? LineScore.verbalComposite(
            subtestScores[Subtest.wk]?.standardScore ?? 50,
            subtestScores[Subtest.pc]?.standardScore ?? 50,
          )
        : 50;

    int sub(Subtest s) => subtestScores[s]?.standardScore ?? 50;

    final composite = LineScore.afqtComposite(
      ve,
      sub(Subtest.ar),
      sub(Subtest.mk),
    );
    final percentile = afqtPercentileFromComposite(composite);

    // Line scores, all on the Army mean-100 / SD-20 reporting scale.
    final lineScores = <LineScore, int>{};
    for (final ls in LineScore.values) {
      lineScores[ls] = ls.compute(sub, ve);
    }

    // Skill mastery.
    final skillTotals = <String, int>{};
    for (final q in questions) {
      for (final sid in q.skills) {
        skillTotals[sid] = (skillTotals[sid] ?? 0) + 1;
      }
    }
    final skillMastery = <String, SkillMastery>{};
    for (final entry in skillTotals.entries) {
      final sid = entry.key;
      var correct = 0;
      var flags = 0;
      for (final q in questions.where((q) => q.skills.contains(sid))) {
        final r = responseById[q.id];
        if (r != null) {
          if (r.flagged) flags++;
          if (r.isAnswered && r.selectedIndex == q.answerIndex) correct++;
        }
      }
      skillMastery[sid] = SkillMastery(
        skillId: sid,
        correct: correct,
        total: entry.value,
        flags: flags,
      );
    }

    var totalCorrect = 0;
    for (final q in questions) {
      final r = responseById[q.id];
      if (r != null && r.isAnswered && r.selectedIndex == q.answerIndex) {
        totalCorrect++;
      }
    }

    return ScoreReport(
      subtestScores: subtestScores,
      skillMastery: skillMastery,
      ve: ve,
      afqtComposite: composite,
      afqtPercentile: percentile,
      lineScores: lineScores,
      elapsedSeconds: elapsedSeconds,
      totalAnswered: questions.length,
      totalCorrect: totalCorrect,
    );
  }

  /// Acklam's rational approximation to the inverse normal CDF. Accurate to
  /// about 1.15e-9 across the whole range, which is far beyond what a score
  /// estimate needs.
  static double _inverseNormal(double p) {
    const a = <double>[
      -3.969683028665376e+01,
      2.209460984245205e+02,
      -2.759285104469687e+02,
      1.383577518672690e+02,
      -3.066479806614716e+01,
      2.506628277459239e+00,
    ];
    const b = <double>[
      -5.447609879822406e+01,
      1.615858368580409e+02,
      -1.556989798598866e+02,
      6.680131188771972e+01,
      -1.328068155288572e+01,
    ];
    const c = <double>[
      -7.784894002430293e-03,
      -3.223964580411365e-01,
      -2.400758277161838e+00,
      -2.549732539343734e+00,
      4.374664141464968e+00,
      2.938163982698783e+00,
    ];
    const d = <double>[
      7.784695709041462e-03,
      3.224671290700398e-01,
      2.445134137142996e+00,
      3.754408661907416e+00,
    ];
    const pLow = 0.02425;
    const pHigh = 1 - pLow;

    if (p < pLow) {
      final q = math.sqrt(-2 * math.log(p));
      return (((((c[0] * q + c[1]) * q + c[2]) * q + c[3]) * q + c[4]) * q +
              c[5]) /
          ((((d[0] * q + d[1]) * q + d[2]) * q + d[3]) * q + 1);
    }
    if (p > pHigh) {
      final q = math.sqrt(-2 * math.log(1 - p));
      return -(((((c[0] * q + c[1]) * q + c[2]) * q + c[3]) * q + c[4]) * q +
              c[5]) /
          ((((d[0] * q + d[1]) * q + d[2]) * q + d[3]) * q + 1);
    }
    final q = p - 0.5;
    final r = q * q;
    return (((((a[0] * r + a[1]) * r + a[2]) * r + a[3]) * r + a[4]) * r +
            a[5]) *
        q /
        (((((b[0] * r + b[1]) * r + b[2]) * r + b[3]) * r + b[4]) * r + 1);
  }
}
