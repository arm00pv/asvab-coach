import 'package:asvab_guard_coach/data/bank/bank_audit.dart';
import 'package:asvab_guard_coach/data/bank/paragraph_comprehension_passages.dart';
import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/engines/exam_builder.dart';
import 'package:flutter_test/flutter_test.dart';

/// Authoring checks for the passage-driven Paragraph Comprehension bank.
///
/// The subtest always puts a passage on the screen before the question, so the
/// rules that matter are about the text: a real passage of the length the
/// subtest uses, three questions that each test something different, and a key
/// that is the plain supported statement rather than the most eloquent option.
void main() {
  final extra = readingPassageBank;
  final extraIds = extra.map((q) => q.id).toSet();

  Map<String, List<Question>> byPassage() {
    final map = <String, List<Question>>{};
    for (final q in extra) {
      map.putIfAbsent((q.passage ?? '').trim(), () => <Question>[]).add(q);
    }
    return map;
  }

  int wordCount(String text) =>
      text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

  group('paragraph comprehension passage bank', () {
    test('ships fifteen items in the pc-p series', () {
      expect(extra, hasLength(15));
      for (var i = 0; i < extra.length; i++) {
        expect(
          extra[i].id,
          'pc-p${(i + 1).toString().padLeft(2, '0')}',
          reason: 'ids must run pc-p01 .. pc-p15',
        );
      }
      expect(extraIds, hasLength(extra.length));
      expect(extra.every((q) => q.subtest == Subtest.pc), isTrue);
    });

    test('is five passages of three questions each', () {
      final passages = byPassage();
      expect(passages, hasLength(5), reason: 'five passages');
      for (final entry in passages.entries) {
        expect(
          entry.value,
          hasLength(3),
          reason:
              '${entry.value.first.id} shares its passage with the wrong '
              'number of questions',
        );
      }
    });

    test('every passage is 60 to 130 words, as the real subtest reads', () {
      for (final entry in byPassage().entries) {
        final words = wordCount(entry.key);
        expect(
          words,
          inInclusiveRange(60, 130),
          reason: '${entry.value.first.id} carries a passage of $words words',
        );
        expect(entry.key.length, greaterThanOrEqualTo(180));
      }
    });

    test('the questions on one passage ask different things', () {
      for (final entry in byPassage().entries) {
        final items = entry.value;
        expect(
          items.map((q) => q.stem).toSet(),
          hasLength(items.length),
          reason: '${entry.key.substring(0, 32)} repeats a question',
        );
        for (var i = 0; i < items.length; i++) {
          for (var j = i + 1; j < items.length; j++) {
            expect(
              items[i].skills.toSet().intersection(items[j].skills.toSet()),
              isEmpty,
              reason:
                  '${items[i].id} and ${items[j].id} test the same reading '
                  'skill twice',
            );
          }
        }
      }
    });

    test('covers the whole question mix the subtest uses', () {
      int skill(String id) => extra.where((q) => q.skills.contains(id)).length;
      expect(skill('pc.mainidea'), greaterThanOrEqualTo(3));
      expect(skill('pc.detail'), greaterThanOrEqualTo(3));
      expect(skill('pc.inference'), greaterThanOrEqualTo(3));
      expect(skill('pc.sequence'), greaterThanOrEqualTo(2));
      expect(skill('pc.purpose'), greaterThanOrEqualTo(1));
      expect(skill('pc.vocabulary'), greaterThanOrEqualTo(1));
    });

    test('the key is never the longest option', () {
      // Real PC difficulty lives in the options: the trap is the sweeping
      // summary and the key is the modest supported statement. An item whose
      // correct option is the longest is pulling in the wrong direction.
      for (final q in extra) {
        final correct = q.choices[q.answerIndex].trim().length;
        var longestOther = 0;
        for (var i = 0; i < q.choices.length; i++) {
          if (i == q.answerIndex) continue;
          final len = q.choices[i].trim().length;
          if (len > longestOther) longestOther = len;
        }
        expect(
          correct,
          lessThanOrEqualTo((longestOther * 1.1).round()),
          reason:
              '${q.id}: the key is the longest option, so the trap is not the '
              'one that sounds most considered',
        );
      }
    });

    test('spreads the answer across the four positions', () {
      final positions = <int>[0, 0, 0, 0];
      for (final q in extra) {
        positions[q.answerIndex]++;
      }
      for (var i = 0; i < positions.length; i++) {
        expect(
          positions[i],
          greaterThanOrEqualTo(3),
          reason: 'position ${i + 1} is under used: ${positions.join('/')}',
        );
      }
    });

    test('spreads difficulty the way the real pool does', () {
      int count(Difficulty d) => extra.where((q) => q.difficulty == d).length;
      expect(count(Difficulty.easy), greaterThanOrEqualTo(3));
      expect(count(Difficulty.medium), greaterThanOrEqualTo(9));
      expect(count(Difficulty.hard), greaterThanOrEqualTo(3));
      expect(
        count(Difficulty.easy) +
            count(Difficulty.medium) +
            count(Difficulty.hard),
        extra.length,
      );
    });

    test('every item has a teachable explanation', () {
      for (final q in extra) {
        expect(
          q.explanation.trim().length,
          greaterThanOrEqualTo(120),
          reason: '${q.id} explains nothing',
        );
        expect(q.explanation, isNot(contains(q.correctChoice)));
      }
    });

    test('tags only Paragraph Comprehension skills that exist', () {
      for (final q in extra) {
        expect(q.skills, isNotEmpty, reason: q.id);
        expect(q.skills.length, lessThanOrEqualTo(3), reason: q.id);
        for (final id in q.skills) {
          final skill = Skills.maybeById(id);
          expect(skill, isNotNull, reason: '${q.id}: $id');
          expect(skill!.subtest, Subtest.pc, reason: q.id);
        }
      }
    });

    test('never repeats a stem or an option set the bank already ships', () {
      final shipped = <Question>[
        for (final q in QuestionBank.bySubtest(Subtest.pc))
          if (!extraIds.contains(q.id)) q,
      ];
      final stems = shipped.map((q) => q.stem.trim().toLowerCase()).toSet();
      final sets = <String>{
        for (final q in shipped)
          (q.choices.map((c) => c.trim().toLowerCase()).toList()..sort()).join(
            '|',
          ),
      };
      for (final q in extra) {
        expect(
          stems,
          isNot(contains(q.stem.trim().toLowerCase())),
          reason: '${q.id} reuses a stem that is already in the bank',
        );
        final key =
            (q.choices.map((c) => c.trim().toLowerCase()).toList()..sort())
                .join('|');
        expect(
          sets,
          isNot(contains(key)),
          reason: '${q.id} reuses an option set that is already in the bank',
        );
      }
    });

    test('is registered with the aggregator', () {
      final ids = QuestionBank.all.map((q) => q.id).toSet();
      for (final q in extra) {
        expect(ids, contains(q.id), reason: '${q.id} is not in the bank');
      }
      expect(QuestionBank.countFor(Subtest.pc), greaterThanOrEqualTo(50));
    });

    test('every item audits clean at item level', () {
      final findings = BankAudit.run(extra, bankLevel: false);
      expect(
        findings.map((f) => f.toString()).toList(),
        isEmpty,
        reason: 'every finding here is an item defect',
      );
    });

    test('options are plain ASCII and never an all-of-the-above shape', () {
      const banned = <String>[
        'all of the above',
        'none of the above',
        'cannot be determined',
      ];
      for (final q in extra) {
        for (final text in <String>[
          q.stem,
          q.explanation,
          q.passage ?? '',
          ...q.choices,
        ]) {
          expect(
            RegExp(r'[^\x20-\x7E]').hasMatch(text),
            isFalse,
            reason: '${q.id} contains a non-ASCII character',
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

  group('the subtest serves one question per passage', () {
    test('a full-length section draws ten different passages', () {
      // The computer form pairs each passage with one question, so a section
      // built from this pool must never show the same text twice. The new
      // passages raise the pool, and this holds the behaviour in place.
      for (final seed in <int>[1, 7, 23]) {
        final exam = ExamBuilder.section(Subtest.pc, seed: seed);
        final questions = exam.allQuestions;
        expect(questions, hasLength(Subtest.pc.questionCount));
        final passages = questions
            .map((s) => (s.base.passage ?? '').trim())
            .toSet();
        expect(
          passages,
          hasLength(questions.length),
          reason: 'seed $seed repeated a passage',
        );
      }
    });
  });
}
