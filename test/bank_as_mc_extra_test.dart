import 'package:asvab_guard_coach/data/bank/auto_shop.dart';
import 'package:asvab_guard_coach/data/bank/auto_shop_extra.dart';
import 'package:asvab_guard_coach/data/bank/bank_audit.dart';
import 'package:asvab_guard_coach/data/bank/mechanical.dart';
import 'package:asvab_guard_coach/data/bank/mechanical_extra.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final List<Question> combined = <Question>[
    ...autoShopExtraBank,
    ...mechanicalExtraBank,
  ];

  test('extra items pass every item-level rule', () {
    final errors = BankAudit.run(
      combined,
      bankLevel: false,
    ).where((f) => f.isError).toList();
    expect(errors, isEmpty, reason: errors.join('\n'));
  });

  test('extra items raise no authoring warnings either', () {
    final warnings = BankAudit.run(
      combined,
      bankLevel: false,
    ).where((f) => !f.isError).toList();
    expect(warnings, isEmpty, reason: warnings.join('\n'));
  });

  test('auto and shop extras are internally consistent', () {
    expect(autoShopExtraBank.length, 20);
    for (final q in autoShopExtraBank) {
      expect(q.subtest, Subtest.as, reason: q.id);
      expect(q.id.startsWith('as-x'), isTrue, reason: q.id);
      expect(q.choices.length, 4, reason: q.id);
      expect(q.answerIndex, inInclusiveRange(0, 3), reason: q.id);
      expect(q.passage, isNull, reason: q.id);
      expect(q.puzzle, isNull, reason: q.id);
    }
  });

  test('mechanical extras are internally consistent', () {
    expect(mechanicalExtraBank.length, 18);
    for (final q in mechanicalExtraBank) {
      expect(q.subtest, Subtest.mc, reason: q.id);
      expect(q.id.startsWith('mc-x'), isTrue, reason: q.id);
      expect(q.choices.length, 4, reason: q.id);
      expect(q.answerIndex, inInclusiveRange(0, 3), reason: q.id);
      expect(q.passage, isNull, reason: q.id);
      expect(q.puzzle, isNull, reason: q.id);
    }
  });

  test('no new item repeats a stem or option set from the shipped pools', () {
    final findings = BankAudit.run(<Question>[
      ...autoShopBank,
      ...autoShopExtraBank,
      ...mechanicalBank,
      ...mechanicalExtraBank,
    ], bankLevel: false).where((f) => f.code.startsWith('duplicate')).toList();
    expect(findings, isEmpty, reason: findings.join('\n'));
  });

  test('ids are unique across both new pools and the shipped pools', () {
    final ids = combined.map((q) => q.id).toList();
    expect(ids.toSet().length, ids.length, reason: ids.join(', '));
    expect(ids.length, 38);
    final shipped = <String>{
      for (final q in autoShopBank) q.id,
      for (final q in mechanicalBank) q.id,
    };
    expect(ids.toSet().intersection(shipped), isEmpty);
  });

  test('every item is tagged with one to three skills of its own subtest', () {
    for (final q in combined) {
      expect(q.skills.length, inInclusiveRange(1, 3), reason: q.id);
      for (final sid in q.skills) {
        expect(Skills.byId(sid).subtest, q.subtest, reason: q.id);
      }
    }
  });

  test('each pool carries all three difficulty bands', () {
    for (final bank in <List<Question>>[
      autoShopExtraBank,
      mechanicalExtraBank,
    ]) {
      final bands = bank.map((q) => q.difficulty).toSet();
      expect(bands.length, 3, reason: bank.first.id);
    }
  });

  test('item text is plain ASCII with no dollar signs', () {
    for (final q in combined) {
      final text = q.stem + ' ' + q.choices.join(' ') + ' ' + q.explanation;
      for (final rune in text.runes) {
        expect(rune, lessThan(128), reason: q.id);
      }
      expect(text.contains(String.fromCharCode(36)), isFalse, reason: q.id);
    }
  });
}
