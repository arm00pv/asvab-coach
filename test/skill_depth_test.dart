import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/bank/skill_depth.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:flutter_test/flutter_test.dart';

/// Coverage floors.
///
/// A skill with one or two items behind it cannot be practised: a drill on it
/// serves the same questions, the candidate learns their answers, and the
/// mastery figure on the dashboard becomes a memory test. These tests hold the
/// floor in place so a future edit cannot quietly hollow out a skill.
const int floor = 4;

void main() {
  group('skill coverage', () {
    test('every skill has at least $floor items', () {
      final coverage = QuestionBank.skillCoverage;
      final thin = coverage.entries
          .where((e) => e.value < floor)
          .map((e) => '${e.key}=${e.value}')
          .toList();
      expect(thin, isEmpty, reason: 'thin skills: $thin');
    });

    test('every declared skill is reachable', () {
      final covered = QuestionBank.coveredSkills;
      for (final skill in Skills.all) {
        expect(covered, contains(skill.id), reason: skill.id);
      }
    });

    test('the depth bank only targets its own subtests', () {
      expect(skillDepthBank, isNotEmpty);
      for (final q in skillDepthBank) {
        expect(q.skills, isNotEmpty);
        for (final id in q.skills) {
          final skill = Skills.maybeById(id);
          expect(skill, isNotNull, reason: id);
          expect(
            skill!.subtest,
            q.subtest,
            reason: '${q.id} is tagged $id, which belongs to another subtest',
          );
        }
      }
    });

    test('the depth bank is registered with the aggregator', () {
      final ids = QuestionBank.all.map((q) => q.id).toSet();
      for (final q in skillDepthBank) {
        expect(ids, contains(q.id), reason: '${q.id} is not in the bank');
      }
    });
  });
}
