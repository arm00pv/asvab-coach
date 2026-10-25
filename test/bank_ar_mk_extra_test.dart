import 'package:asvab_guard_coach/data/bank/arithmetic.dart';
import 'package:asvab_guard_coach/data/bank/arithmetic_extra.dart';
import 'package:asvab_guard_coach/data/bank/bank_audit.dart';
import 'package:asvab_guard_coach/data/bank/mathematics.dart';
import 'package:asvab_guard_coach/data/bank/mathematics_extra.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('arithmetic extra items pass every item-level rule', () {
    final errors = BankAudit.run(
      arithmeticExtraBank,
      bankLevel: false,
    ).where((f) => f.isError).toList();
    expect(errors, isEmpty, reason: errors.join('\n'));
  });

  test('mathematics extra items pass every item-level rule', () {
    final errors = BankAudit.run(
      mathematicsExtraBank,
      bankLevel: false,
    ).where((f) => f.isError).toList();
    expect(errors, isEmpty, reason: errors.join('\n'));
  });

  test('the two extra banks together pass every item-level rule', () {
    final combined = <Question>[
      ...arithmeticExtraBank,
      ...mathematicsExtraBank,
    ];
    final errors = BankAudit.run(
      combined,
      bankLevel: false,
    ).where((f) => f.isError).toList();
    expect(errors, isEmpty, reason: errors.join('\n'));
  });

  test('arithmetic extra items are internally consistent', () {
    expect(arithmeticExtraBank.length, 18);
    for (final q in arithmeticExtraBank) {
      expect(q.subtest, Subtest.ar, reason: q.id);
      expect(q.id.startsWith('ar-x'), isTrue, reason: q.id);
      expect(q.choices.length, 4, reason: q.id);
      expect(q.choices.toSet().length, 4, reason: q.id);
      expect(q.answerIndex, inInclusiveRange(0, 3), reason: q.id);
      expect(
        q.explanation.trim().length,
        greaterThanOrEqualTo(70),
        reason: q.id,
      );
      expect(q.skills, isNotEmpty, reason: q.id);
    }
  });

  test('mathematics extra items are internally consistent', () {
    expect(mathematicsExtraBank.length, 18);
    for (final q in mathematicsExtraBank) {
      expect(q.subtest, Subtest.mk, reason: q.id);
      expect(q.id.startsWith('mk-x'), isTrue, reason: q.id);
      expect(q.choices.length, 4, reason: q.id);
      expect(q.choices.toSet().length, 4, reason: q.id);
      expect(q.answerIndex, inInclusiveRange(0, 3), reason: q.id);
      expect(
        q.explanation.trim().length,
        greaterThanOrEqualTo(70),
        reason: q.id,
      );
      expect(q.skills, isNotEmpty, reason: q.id);
      expect(q.stem.length, lessThanOrEqualTo(260), reason: q.id);
    }
  });

  test('extra items do not repeat an existing arithmetic or math stem', () {
    String norm(String s) =>
        s.trim().toLowerCase().replaceAll(RegExp(r'\\s+'), ' ');
    String key(Question q) =>
        (q.choices.map((c) => norm(c)).toList()..sort()).join('|');

    final existingStems = <String>{
      ...arithmeticBank.map((q) => norm(q.stem)),
      ...mathematicsBank.map((q) => norm(q.stem)),
    };
    final existingSets = <String>{
      ...arithmeticBank.map(key),
      ...mathematicsBank.map(key),
    };

    for (final q in <Question>[
      ...arithmeticExtraBank,
      ...mathematicsExtraBank,
    ]) {
      expect(existingStems.contains(norm(q.stem)), isFalse, reason: q.id);
      expect(existingSets.contains(key(q)), isFalse, reason: q.id);
    }
  });

  test('arithmetic extra ids and stems are all distinct', () {
    final ids = arithmeticExtraBank.map((q) => q.id).toList();
    expect(ids.toSet().length, ids.length);
    final stems = arithmeticExtraBank.map((q) => q.stem.trim()).toList();
    expect(stems.toSet().length, stems.length);
  });

  test('mathematics extra ids and stems are all distinct', () {
    final ids = mathematicsExtraBank.map((q) => q.id).toList();
    expect(ids.toSet().length, ids.length);
    final stems = mathematicsExtraBank.map((q) => q.stem.trim()).toList();
    expect(stems.toSet().length, stems.length);
  });
}
