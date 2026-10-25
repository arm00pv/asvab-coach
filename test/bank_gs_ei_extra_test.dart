import 'package:asvab_guard_coach/data/bank/bank_audit.dart';
import 'package:asvab_guard_coach/data/bank/electronics_extra.dart';
import 'package:asvab_guard_coach/data/bank/general_science_extra.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('extra GS items pass every item-level rule', () {
    final errors = BankAudit.run(
      generalScienceExtraBank,
      bankLevel: false,
    ).where((f) => f.isError).toList();
    expect(errors, isEmpty, reason: errors.join('\n'));
  });

  test('extra EI items pass every item-level rule', () {
    final errors = BankAudit.run(
      electronicsExtraBank,
      bankLevel: false,
    ).where((f) => f.isError).toList();
    expect(errors, isEmpty, reason: errors.join('\n'));
  });

  test('extra GS items are internally consistent', () {
    expect(generalScienceExtraBank.length, 18);
    for (final q in generalScienceExtraBank) {
      expect(q.subtest, Subtest.gs, reason: q.id);
      expect(q.id.startsWith('gs-x'), isTrue, reason: q.id);
      expect(q.choices.length, 4, reason: q.id);
      expect(q.skills, isNotEmpty, reason: q.id);
      for (final sid in q.skills) {
        expect(sid.startsWith('gs.'), isTrue, reason: '${q.id} -> $sid');
      }
    }
  });

  test('extra EI items are internally consistent', () {
    expect(electronicsExtraBank.length, 16);
    for (final q in electronicsExtraBank) {
      expect(q.subtest, Subtest.ei, reason: q.id);
      expect(q.id.startsWith('ei-x'), isTrue, reason: q.id);
      expect(q.choices.length, 4, reason: q.id);
      expect(q.skills, isNotEmpty, reason: q.id);
      for (final sid in q.skills) {
        expect(sid.startsWith('ei.'), isTrue, reason: '${q.id} -> $sid');
      }
    }
  });

  test('extra GS covers the four GS skills in the real subtest weights', () {
    final counts = BankAudit.coverage(generalScienceExtraBank);
    expect(counts['gs.biology'], 6);
    expect(counts['gs.chemistry'], 4);
    expect(counts['gs.physics'], 3);
    expect(counts['gs.earth'], 5);
  });

  test('extra EI covers the five EI skills in the real subtest weights', () {
    final counts = BankAudit.coverage(electronicsExtraBank);
    expect(counts['ei.ohms'], 4);
    expect(counts['ei.circuits'], 5);
    expect(counts['ei.components'], 4);
    expect(counts['ei.systems'], 2);
    expect(counts['ei.safety'], 1);
  });

  test('ids are unique across both new banks', () {
    final ids = <String>{
      ...generalScienceExtraBank.map((q) => q.id),
      ...electronicsExtraBank.map((q) => q.id),
    };
    expect(
      ids.length,
      generalScienceExtraBank.length + electronicsExtraBank.length,
    );
  });
}
