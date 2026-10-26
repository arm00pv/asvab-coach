import '../data/models/catalog.dart';
import '../data/models/line_score.dart';
import '../data/models/mos.dart';
import '../data/models/score.dart';
import '../data/repos/mos_repository.dart';

/// Matches a score report against the Army's aptitude gates.
abstract final class EligibilityEngine {
  /// Evaluates one MOS gate against a report.
  static GateEvaluation evaluate(AptitudeGate gate, ScoreReport report) {
    if (gate.isEmpty) {
      return const GateEvaluation(
        qualified: true,
        results: <GateAlternativeResult>[],
        bestShortfall: null,
      );
    }
    final results = <GateAlternativeResult>[];
    for (final alternative in gate.alternatives) {
      final parts = <GatePartResult>[
        for (final req in alternative)
          GatePartResult(
            score: req.score,
            minimum: req.min,
            actual: report.lineFor(req.score),
          ),
      ];
      final satisfied = parts.every((p) => p.met);
      final shortfall = satisfied
          ? 0
          : parts.map((p) => p.gap).fold<int>(0, (a, b) => a < b ? a : b).abs();
      results.add(
        GateAlternativeResult(
          parts: parts,
          satisfied: satisfied,
          shortfall: shortfall,
        ),
      );
    }
    final qualified = results.any((r) => r.satisfied);
    final best = qualified
        ? null
        : results
              .map((r) => r.shortfall)
              .fold<int>(999, (a, b) => a < b ? a : b);
    return GateEvaluation(
      qualified: qualified,
      results: results,
      bestShortfall: best,
    );
  }

  /// Every MOS the report currently clears on [now], plus the near misses.
  ///
  /// The roster is read as two lists, not one, because "the catalogue" and "the
  /// jobs open today" are not the same set: [MosRepository.enlistableAsOf] is
  /// every entry that can be enlisted into on [now], and
  /// [MosRepository.retiredAsOf] is every entry the pamphlet has already
  /// retired. A retired MOS reaches no bucket - not qualified, not near miss,
  /// not further out - because no line score opens it. Counting one is the
  /// defect this signature exists to prevent: 12M read as a job the candidate
  /// qualified for months after the Army withdrew it.
  ///
  /// The retired entries are not dropped on the floor either: [EligibilitySummary
  /// .retired] carries them so a screen can say how many entries its count
  /// leaves out. A denominator that shrinks without a word is its own kind of
  /// dishonesty.
  ///
  /// [now] is a parameter rather than a call to [DateTime.now] inside the loop,
  /// because a rescission month is a boundary, and a boundary can only be tested
  /// by pinning the clock instead of waiting for October.
  ///
  /// A MOS whose gate the app has not verified goes into its own bucket and is
  /// counted as neither qualified nor unqualified. An empty gate would otherwise
  /// read as "no requirement" and hand the candidate a job the app knows nothing
  /// about.
  static EligibilitySummary summarise(
    ScoreReport report, {
    required DateTime now,
  }) {
    final qualified = <Mos>[];
    final near = <Mos>[];
    final far = <Mos>[];
    final unverified = <Mos>[];
    final retired = MosRepository.retiredAsOf(now);
    for (final mos in MosRepository.enlistableAsOf(now)) {
      if (!mos.gateIsKnown) {
        unverified.add(mos);
        continue;
      }
      final e = evaluate(mos.gate, report);
      if (e.qualified) {
        qualified.add(mos);
      } else if (e.nearMiss) {
        near.add(mos);
      } else {
        far.add(mos);
      }
    }
    near.sort((a, b) {
      final ea = evaluate(a.gate, report).bestShortfall ?? 999;
      final eb = evaluate(b.gate, report).bestShortfall ?? 999;
      return ea.compareTo(eb);
    });
    qualified.sort((a, b) => a.code.compareTo(b.code));
    far.sort((a, b) => a.code.compareTo(b.code));
    unverified.sort((a, b) => a.code.compareTo(b.code));
    return EligibilitySummary(
      qualified: qualified,
      nearMiss: near,
      outOfReach: far,
      unverified: unverified,
      retired: retired,
      report: report,
      asOf: now,
    );
  }

  /// Which subtests move a line score the most. Because every composite except
  /// GT is a weighted sum, the highest-weight component is the cheapest place
  /// to gain points.
  static List<LineLever> levers(LineScore score) {
    if (score.isLiteralSum) {
      const ve = 1.074292;
      return <LineLever>[
        const LineLever(
          subtest: Subtest.ar,
          weight: 1.074292,
          label: 'Arithmetic Reasoning',
        ),
        const LineLever(
          subtest: Subtest.wk,
          weight: ve * 0.6175,
          label: 'Word Knowledge',
        ),
        const LineLever(
          subtest: Subtest.pc,
          weight: ve * 0.3825,
          label: 'Paragraph Comprehension',
        ),
      ]..sort((a, b) => b.weight.compareTo(a.weight));
    }
    final out = <LineLever>[];
    for (final entry in score.weights.entries) {
      out.add(
        LineLever(
          subtest: entry.key,
          weight: entry.value,
          label: entry.key.label,
        ),
      );
    }
    out.sort((a, b) => b.weight.compareTo(a.weight));
    return out;
  }

  /// A concrete, arithmetic-backed sentence explaining the cheapest route to a
  /// gate the candidate does not yet clear.
  static String gapAdvice(Mos mos, ScoreReport report) {
    final evaluation = evaluate(mos.gate, report);
    if (evaluation.qualified) {
      return 'You already clear the ${mos.code} gate.';
    }
    GateAlternativeResult? closest;
    for (final r in evaluation.results) {
      if (closest == null || r.shortfall < closest.shortfall) closest = r;
    }
    if (closest == null) return 'No published aptitude gate for ${mos.code}.';
    final missing = closest.parts.where((p) => !p.met).toList();
    if (missing.isEmpty) {
      return 'You are ${evaluation.bestShortfall} points short.';
    }
    final worst = missing.reduce((a, b) => a.gap < b.gap ? a : b);
    final ordered = levers(worst.score);
    final top = ordered.first;
    final pointsNeeded = worst.minimum - worst.actual;
    final subtestGain = top.weight == 0
        ? pointsNeeded
        : (pointsNeeded / top.weight).ceil();
    final abbr = worst.score.abbr;
    return 'You need $pointsNeeded more $abbr points. The cheapest route is '
        'raising ${top.label}, which carries the heaviest weight inside '
        '$abbr: roughly $subtestGain standard-score points there would close '
        'the gap.';
  }
}

/// What one score report opens, against the catalogue that exists on one day.
///
/// The buckets only ever hold jobs that can be enlisted into on [asOf]. Retired
/// entries are kept in [retired] and counted in none of them, which is what
/// makes [total] an honest denominator and [retiredNote] an honest sentence.
class EligibilitySummary {
  const EligibilitySummary({
    required this.qualified,
    required this.nearMiss,
    required this.outOfReach,
    required this.report,
    required this.asOf,
    this.unverified = const <Mos>[],
    this.retired = const <Mos>[],
  });

  final List<Mos> qualified;
  final List<Mos> nearMiss;
  final List<Mos> outOfReach;

  /// Jobs whose gate the app has not verified, so it can say nothing about them.
  final List<Mos> unverified;

  /// Entries the pamphlet had already retired on [asOf].
  ///
  /// They are still in the catalogue and still shown, marked, in the job list -
  /// a candidate meets the code in older material and in the roster of soldiers
  /// who hold it. They are simply not jobs, so they are counted nowhere above.
  final List<Mos> retired;

  final ScoreReport report;

  /// The day this summary was computed against. Every count below is a fact
  /// about this date, which is why nothing here calls [DateTime.now].
  final DateTime asOf;

  /// The jobs open on [asOf]: qualified, near, far and unverified together.
  ///
  /// This - not the size of the roster - is the denominator a count is out of.
  int get total =>
      qualified.length +
      nearMiss.length +
      outOfReach.length +
      unverified.length;

  /// The whole roster, retired entries included. The two numbers differ by
  /// exactly [retiredCount], and a screen that prints this one as "jobs" is
  /// describing a catalogue rather than an offer.
  int get catalogueSize => total + retired.length;

  /// How many entries the counts leave out because the Army has retired them.
  int get retiredCount => retired.length;

  List<Mos> get all => <Mos>[...qualified, ...nearMiss, ...outOfReach];

  bool isQualified(Mos m) => qualified.contains(m);
  bool isNearMiss(Mos m) => nearMiss.contains(m);
  bool isRetired(Mos m) => retired.contains(m);

  /// The sentence that goes with the count when some of the catalogue cannot be
  /// enlisted into, or null when the roster and the offer are the same set.
  ///
  /// Named rather than numbered alone, because "$n excluded" reads as an
  /// accounting quirk while "12M is retired" reads as a fact about a job the
  /// candidate may have been planning around.
  String? get retiredNote {
    if (retired.isEmpty) return null;
    final codes = retired.map((m) => m.code).join(', ');
    final them = retired.length == 1 ? 'entry' : 'entries';
    return '${retired.length} retired $them not counted: $codes.';
  }

  int get percentQualified =>
      total == 0 ? 0 : ((qualified.length / total) * 100).round();
}

class LineLever {
  const LineLever({
    required this.subtest,
    required this.weight,
    required this.label,
  });

  final Subtest subtest;
  final double weight;
  final String label;
}
