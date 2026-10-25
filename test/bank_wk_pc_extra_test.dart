import 'package:asvab_guard_coach/data/bank/bank_audit.dart';
import 'package:asvab_guard_coach/data/bank/paragraph_comprehension.dart';
import 'package:asvab_guard_coach/data/bank/paragraph_comprehension_extra.dart';
import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/bank/word_knowledge.dart';
import 'package:asvab_guard_coach/data/bank/word_knowledge_extra.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:flutter_test/flutter_test.dart';

/// Authoring checks for the second Word Knowledge and Paragraph Comprehension
/// banks. Everything here is mechanical: the item-level rules from
/// [BankAudit], plus the presentation mix the real subtests use, plus the
/// promise that no new item repeats a stem or an option set already shipped.
void main() {
  final extra = <Question>[...wordKnowledgeExtraBank, ...readingExtraBank];
  final shipped = <Question>[...wordKnowledgeBank, ...readingBank];
  final extraIds = extra.map((q) => q.id).toSet();

  int bandCount(List<Question> pool, Difficulty d) =>
      pool.where((q) => q.difficulty == d).length;

  int skillCount(List<Question> pool, String id) =>
      pool.where((q) => q.skills.contains(id)).length;

  String expectedId(String prefix, int n) =>
      <String>[prefix, n.toString().padLeft(2, '0')].join();

  group('word knowledge extra bank', () {
    test('has 18 items with the expected ids', () {
      expect(wordKnowledgeExtraBank, hasLength(18));
      final expected = <String>[
        for (var i = 1; i <= 18; i++) expectedId('wk-x', i),
      ];
      expect(
        wordKnowledgeExtraBank.map((q) => q.id).toList(),
        expected,
        reason: 'ids must run wk-x01 .. wk-x18',
      );
      expect(
        wordKnowledgeExtraBank.every((q) => q.subtest == Subtest.wk),
        isTrue,
      );
    });

    test('matches the presentation mix of the real subtest', () {
      expect(skillCount(wordKnowledgeExtraBank, 'wk.synonym'), 8);
      expect(skillCount(wordKnowledgeExtraBank, 'wk.context'), 6);
      expect(skillCount(wordKnowledgeExtraBank, 'wk.academic'), 2);
      expect(skillCount(wordKnowledgeExtraBank, 'wk.roots'), 2);
    });

    test(
      'bare items are one word and context items pin the word in a sentence',
      () {
        final bare = wordKnowledgeExtraBank.where(
          (q) => q.skills.contains('wk.synonym'),
        );
        for (final q in bare) {
          expect(q.stem.trim(), isNot(contains(' ')), reason: q.id);
          expect(q.stem, q.stem.toUpperCase(), reason: q.id);
        }
        final pinned = wordKnowledgeExtraBank.where(
          (q) => q.skills.contains('wk.context'),
        );
        for (final q in pinned) {
          expect(q.stem, contains(' '), reason: q.id);
          expect(
            RegExp(r'[A-Z]{4,}').hasMatch(q.stem),
            isTrue,
            reason: <String>[
              q.id,
              'must print the target word in capitals',
            ].join(' '),
          );
        }
      },
    );

    test('never asks for a definition in the stem', () {
      for (final q in wordKnowledgeExtraBank) {
        final stem = q.stem.toLowerCase();
        expect(stem.startsWith('the word '), isFalse, reason: q.id);
        expect(stem.contains(' means '), isFalse, reason: q.id);
      }
    });

    test('difficulty follows the four easy, ten medium, four hard profile', () {
      expect(bandCount(wordKnowledgeExtraBank, Difficulty.easy), 4);
      expect(bandCount(wordKnowledgeExtraBank, Difficulty.medium), 10);
      expect(bandCount(wordKnowledgeExtraBank, Difficulty.hard), 4);
    });

    test('options are one-synonym options, not definitions', () {
      for (final q in wordKnowledgeExtraBank) {
        for (final c in q.choices) {
          expect(c.split(' ').length, lessThanOrEqualTo(3), reason: q.id);
        }
      }
    });
  });

  group('paragraph comprehension extra bank', () {
    test('has 14 items with the expected ids', () {
      expect(readingExtraBank, hasLength(14));
      final expected = <String>[
        for (var i = 1; i <= 14; i++) expectedId('pc-x', i),
      ];
      expect(
        readingExtraBank.map((q) => q.id).toList(),
        expected,
        reason: 'ids must run pc-x01 .. pc-x14',
      );
      expect(readingExtraBank.every((q) => q.subtest == Subtest.pc), isTrue);
    });

    test('seven passages of 60 to 130 words, two questions each', () {
      final byPassage = <String, List<Question>>{};
      for (final q in readingExtraBank) {
        final passage = q.passage;
        expect(passage, isNotNull, reason: q.id);
        byPassage.putIfAbsent(passage!.trim(), () => <Question>[]).add(q);
      }
      expect(byPassage, hasLength(7), reason: 'seven passages, two items each');
      byPassage.forEach((passage, items) {
        expect(items, hasLength(2), reason: passage.substring(0, 40));
        final words = passage.split(RegExp(r'\s+')).length;
        expect(
          words,
          inInclusiveRange(60, 130),
          reason: <String>[
            'passage of',
            items.first.id,
            'is',
            words.toString(),
            'words',
          ].join(' '),
        );
      });
    });

    test('the two items on a passage ask different things', () {
      final byPassage = <String, List<Question>>{};
      for (final q in readingExtraBank) {
        byPassage.putIfAbsent(q.passage!.trim(), () => <Question>[]).add(q);
      }
      for (final items in byPassage.values) {
        final a = items[0];
        final b = items[1];
        expect(
          a.skills.toSet().intersection(b.skills.toSet()),
          isEmpty,
          reason: <String>[a.id, 'and', b.id, 'share a skill'].join(' '),
        );
        expect(a.stem, isNot(b.stem));
      }
    });

    test('question types match the required mix', () {
      expect(skillCount(readingExtraBank, 'pc.mainidea'), 2);
      expect(skillCount(readingExtraBank, 'pc.detail'), 2);
      expect(skillCount(readingExtraBank, 'pc.inference'), 3);
      expect(skillCount(readingExtraBank, 'pc.purpose'), 2);
      expect(skillCount(readingExtraBank, 'pc.vocabulary'), 3);
      expect(skillCount(readingExtraBank, 'pc.sequence'), 2);
    });

    test('difficulty is spread across the three bands', () {
      expect(bandCount(readingExtraBank, Difficulty.easy), 3);
      expect(bandCount(readingExtraBank, Difficulty.medium), 8);
      expect(bandCount(readingExtraBank, Difficulty.hard), 3);
    });
  });

  group('both banks against the audit', () {
    test('the new items alone audit clean, errors and warnings', () {
      final findings = BankAudit.run(extra, bankLevel: false);
      expect(
        findings.map((f) => f.toString()).toList(),
        isEmpty,
        reason: 'every finding here is an item defect',
      );
    });

    test(
      'no new item repeats a stem or an option set from the shipped bank',
      () {
        final findings =
            BankAudit.run(<Question>[...shipped, ...extra], bankLevel: false)
                .where(
                  (f) =>
                      f.questionId != null && extraIds.contains(f.questionId),
                )
                .toList();
        expect(
          findings.map((f) => f.toString()).toList(),
          isEmpty,
          reason: 'a repeat of shipped content is a wasted item',
        );
      },
    );

    test('ids are unique across the whole app', () {
      // These banks are now wired INTO QuestionBank, so exclude their own ids
      // before asking whether anything collides.
      final ownIds = extra.map((q) => q.id).toSet();
      final shippedIds = QuestionBank.all
          .map((q) => q.id)
          .where((id) => !ownIds.contains(id))
          .toSet();
      for (final q in extra) {
        expect(
          shippedIds.contains(q.id),
          isFalse,
          reason: <String>[
            q.id,
            'already exists in the shipped bank',
          ].join(' '),
        );
      }
      final allIds = QuestionBank.all.map((q) => q.id).toList();
      expect(
        allIds.toSet(),
        hasLength(allIds.length),
        reason: 'QuestionBank.all repeats an id',
      );
      expect(extraIds, hasLength(extra.length));
    });

    test('every skill id exists and belongs to the item subtest', () {
      for (final q in extra) {
        expect(q.skills, isNotEmpty, reason: q.id);
        expect(q.skills.length, lessThanOrEqualTo(3), reason: q.id);
        for (final id in q.skills) {
          final skill = Skills.maybeById(id);
          expect(
            skill,
            isNotNull,
            reason: <String>[q.id, 'uses unknown skill', id].join(' '),
          );
          expect(
            skill!.subtest,
            q.subtest,
            reason: <String>[q.id, 'files', id, 'wrong'].join(' '),
          );
        }
      }
    });

    test('the correct answer is spread across the four positions', () {
      for (final pool in <List<Question>>[
        wordKnowledgeExtraBank,
        readingExtraBank,
      ]) {
        final positions = List<int>.filled(4, 0);
        for (final q in pool) {
          positions[q.answerIndex]++;
        }
        for (final n in positions) {
          expect(
            n / pool.length,
            lessThanOrEqualTo(0.45),
            reason: <String>[
              'answer positions are lopsided:',
              positions.join('/'),
            ].join(' '),
          );
        }
      }
    });

    test('options are plain ASCII with no banned all-of-the-above shapes', () {
      final banned = <String>[
        'all of the above',
        'none of the above',
        'cannot be determined',
      ];
      for (final q in extra) {
        final texts = <String>[q.stem, q.explanation, ...q.choices];
        if (q.passage != null) texts.add(q.passage!);
        for (final text in texts) {
          expect(
            RegExp(r'[^\x20-\x7E]').hasMatch(text),
            isFalse,
            reason: <String>[q.id, 'contains a non-ASCII character'].join(' '),
          );
        }
        for (final c in q.choices) {
          expect(
            banned.contains(c.trim().toLowerCase()),
            isFalse,
            reason: q.id,
          );
        }
      }
    });
  });
}
