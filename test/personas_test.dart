import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/line_score.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('persona harness', () {
    late Map<String, PersonaResult> results;

    setUpAll(() {
      results = <String, PersonaResult>{
        for (final p in Personas.all) p.id: PersonaRunner.run(p),
      };
    });

    test('every persona produces a complete report', () {
      for (final r in results.values) {
        expect(r.report.subtestScores.length, 9, reason: r.persona.id);
        expect(r.report.afqtPercentile, inInclusiveRange(1, 99));
        expect(r.report.lineScores.length, LineScore.values.length);
      }
    });

    test('scoring is deterministic', () {
      final a = PersonaRunner.run(Personas.jenna);
      final b = PersonaRunner.run(Personas.jenna);
      expect(a.report.afqtPercentile, b.report.afqtPercentile);
      expect(a.report.gt, b.report.gt);
    });

    test('a strong candidate outscores a weak one', () {
      expect(
        results['ava']!.report.afqtPercentile,
        greaterThan(results['marcus']!.report.afqtPercentile),
      );
      expect(
        results['jenna']!.report.afqtPercentile,
        greaterThan(results['marcus']!.report.afqtPercentile),
      );
    });

    test('a pure guesser stays below the Army floor', () {
      expect(results['sam']!.report.afqtPercentile, lessThan(31));
      expect(results['sam']!.report.meetsArmyFloor, isFalse);
    });

    test('a pure guesser cannot clear a technical aptitude area', () {
      expect(results['sam']!.report.lineFor(LineScore.st), lessThan(95));
      expect(results['sam']!.report.gt, lessThan(110));
    });

    test('a strong candidate reaches at least Category II', () {
      expect(results['jenna']!.report.afqtPercentile, greaterThanOrEqualTo(65));
    });

    test('an officer-minded candidate clears GT 110', () {
      expect(results['ava']!.report.gt, greaterThanOrEqualTo(110));
    });

    test('eligibility grows with ability', () {
      expect(
        results['ava']!.summary.qualified.length,
        greaterThanOrEqualTo(results['marcus']!.summary.qualified.length),
      );
    });

    test('the maths-anxious persona is coached on maths', () {
      final top = results['dana']!.topPriority;
      expect(top, isNotNull);
      expect(
        top!.skill.subtest == Subtest.ar || top.skill.subtest == Subtest.mk,
        isTrue,
        reason:
            'Dana should be pointed at arithmetic reasoning or maths '
            'knowledge, got ${top.skill.id}',
      );
    });

    test('the mechanic persona unlocks a mechanical or logistics job', () {
      final qualified = results['ruiz']!.summary.qualified;
      expect(
        qualified.any(
          (m) =>
              m.category == MosCategory.mechanical ||
              m.category == MosCategory.aviation ||
              m.category == MosCategory.aviation,
        ),
        isTrue,
        reason:
            'Ruiz qualified for: '
            '${qualified.map((m) => m.code).join(', ')}',
      );
    });

    test('the coaching engine always suggests a next action', () {
      for (final r in results.values) {
        expect(r.nextAction.title, isNotEmpty);
        expect(r.nextAction.cta, isNotEmpty);
      }
    });
  });
}
