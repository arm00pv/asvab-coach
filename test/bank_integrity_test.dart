import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/polyomino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('question bank integrity', () {
    test('has no structural problems', () {
      final problems = QuestionBank.validate();
      expect(problems, isEmpty, reason: problems.join('\n'));
    });

    test('covers every subtest with enough items for a full mock', () {
      for (final s in Subtest.administrationOrder) {
        expect(
          QuestionBank.countFor(s),
          greaterThanOrEqualTo(s.questionCount),
          reason: '${s.abbr} needs at least ${s.questionCount} items',
        );
      }
    });

    test('difficulty is distributed, not all one band', () {
      for (final s in Subtest.administrationOrder) {
        final pool = QuestionBank.bySubtest(s);
        final bands = pool.map((q) => q.difficulty).toSet();
        expect(
          bands.length,
          greaterThanOrEqualTo(2),
          reason: '${s.abbr} only has one difficulty band',
        );
      }
    });

    test('every assembling objects puzzle has exactly one legal assembly', () {
      for (final q in QuestionBank.bySubtest(Subtest.ao)) {
        final puzzle = q.puzzle!;
        expect(puzzle.legaltyCount, 1, reason: q.id);
        expect(puzzle.correctIndex, q.answerIndex, reason: q.id);
      }
    });

    test('mirroring a piece is never accepted as legal', () {
      final l = Poly.parse('10/10/11');
      final j = Poly.parse('01/01/11');
      expect(
        l.canonicalKey == j.canonicalKey,
        isFalse,
        reason: 'L and J are mirror images and must not be interchangeable',
      );
    });

    test('rotating a piece is accepted as legal', () {
      final l = Poly.parse('10/10/11');
      expect(l.canonicalKey, l.rotated().canonicalKey);
      expect(l.canonicalKey, l.rotated().rotated().canonicalKey);
    });
  });
}
