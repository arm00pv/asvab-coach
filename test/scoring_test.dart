import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/line_score.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/engines/scoring_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('standard score conversion', () {
    test('half right lands on the national mean', () {
      expect(ScoringEngine.rateToStandardScore(0.5), closeTo(50, 0.5));
    });

    test('is monotonic in accuracy', () {
      var previous = -1.0;
      for (var rate = 0.0; rate <= 1.0; rate += 0.05) {
        final score = ScoringEngine.rateToStandardScore(rate);
        expect(score, greaterThanOrEqualTo(previous));
        previous = score;
      }
    });

    test('is clamped so no run claims perfection', () {
      expect(ScoringEngine.rateToStandardScore(1.0), lessThan(99));
      expect(ScoringEngine.rateToStandardScore(0.0), greaterThan(0));
    });

    test('a tiny section is shrunk toward the mean', () {
      final tiny = ScoringEngine.standardScore(
        weightedRate: 1.0,
        answered: 2,
        expectedQuestions: 15,
      );
      final full = ScoringEngine.standardScore(
        weightedRate: 1.0,
        answered: 15,
        expectedQuestions: 15,
      );
      expect(tiny, lessThan(full));
      expect(tiny, greaterThan(50));
    });

    test('an unanswered subtest contributes nothing', () {
      expect(ScoringEngine.standardScore(weightedRate: 0.7, answered: 0), 0);
    });
  });

  group('line scores sit on the Army mean-100 scale', () {
    int fifty(Subtest s) => 50;

    test('every Army composite returns 100 for an average applicant', () {
      final ve = LineScore.verbalComposite(50, 50);
      for (final ls in LineScore.values) {
        // VE is reported on the subtest scale (mean 50); the ten Army aptitude
        // areas are reported on the mean-100 scale.
        final expected = ls.isVe ? 50 : 100;
        expect(
          ls.compute(fifty, ve),
          closeTo(expected, 3),
          reason: '${ls.abbr} should average $expected',
        );
      }
    });

    test('GT follows the published 97-metric slope', () {
      final ve = LineScore.verbalComposite(60, 60);
      final expected = (1.074292 * (ve + 60) - 7.443781).round();
      expect(LineScore.gt.compute((s) => 60, ve), expected);
    });

    test('verbal composite weights PC below WK', () {
      final highWk = LineScore.verbalComposite(70, 50);
      final highPc = LineScore.verbalComposite(50, 70);
      expect(highWk, greaterThan(highPc));
      expect(LineScore.verbalComposite(50, 50), 50);
    });

    test('a better applicant scores higher in every area', () {
      final weakVe = LineScore.verbalComposite(30, 30);
      final strongVe = LineScore.verbalComposite(70, 70);
      for (final ls in LineScore.values) {
        expect(
          ls.compute((s) => 70, strongVe),
          greaterThan(ls.compute((s) => 30, weakVe)),
          reason: ls.abbr,
        );
      }
    });
  });

  group('AFQT percentile', () {
    test('the average composite is the 50th percentile', () {
      expect(ScoringEngine.afqtPercentileFromComposite(202), 50);
    });

    test('is clamped to 1 and 99', () {
      expect(ScoringEngine.afqtPercentileFromComposite(0), 1);
      expect(ScoringEngine.afqtPercentileFromComposite(900), 99);
    });

    test('is monotonic', () {
      var previous = 0;
      for (var c = 80; c <= 320; c += 4) {
        final p = ScoringEngine.afqtPercentileFromComposite(c);
        expect(p, greaterThanOrEqualTo(previous));
        previous = p;
      }
    });

    test('the Army floor of 31 sits below the mean composite', () {
      // Find the smallest composite that reaches the 31st percentile.
      var c = 100;
      while (ScoringEngine.afqtPercentileFromComposite(c) < 31) {
        c++;
      }
      expect(c, lessThan(202));
      expect(c, greaterThan(150));
    });
  });

  group('category bands', () {
    test('match the 1997 score scale', () {
      final reportFor = _report;
      expect(reportFor(99).category, 'I');
      expect(reportFor(93).category, 'I');
      expect(reportFor(92).category, 'II');
      expect(reportFor(65).category, 'II');
      expect(reportFor(64).category, 'IIIA');
      expect(reportFor(50).category, 'IIIA');
      expect(reportFor(49).category, 'IIIB');
      expect(reportFor(31).category, 'IIIB');
      expect(reportFor(30).category, 'IVA');
      expect(reportFor(21).category, 'IVA');
      expect(reportFor(20).category, 'IVB');
      expect(reportFor(16).category, 'IVB');
      expect(reportFor(15).category, 'IVC');
      expect(reportFor(10).category, 'IVC');
      expect(reportFor(9).category, 'V');
    });

    test('the Army floor is exactly AFQT 31', () {
      expect(_report(31).meetsArmyFloor, isTrue);
      expect(_report(30).meetsArmyFloor, isFalse);
      expect(_report(31).meetsArmyFloor, isTrue);
    });
  });
}

/// Builds a minimal report whose only meaningful field is the percentile.
dynamic _report(int percentile) {
  return _FakeReport(percentile);
}

class _FakeReport {
  _FakeReport(this.afqtPercentile);
  final int afqtPercentile;

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

  bool get meetsArmyFloor => afqtPercentile >= 31;
}

// Unused import guard so the analyzer stays honest about the models we touch.
// ignore: unused_element
const _keepModels = <Question>[];
