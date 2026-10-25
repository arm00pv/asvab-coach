import '../models/catalog.dart';
import '../models/question.dart';
import 'arithmetic.dart';
import 'assembling_objects.dart';
import 'auto_shop.dart';
import 'electronics.dart';
import 'general_science.dart';
import 'mathematics.dart';
import 'mechanical.dart';
import 'paragraph_comprehension.dart';
import 'word_knowledge.dart';

/// The single entry point for question content.
abstract final class QuestionBank {
  static final List<Question> all = List<Question>.unmodifiable(<Question>[
    ...generalScienceBank,
    ...arithmeticBank,
    ...wordKnowledgeBank,
    ...readingBank,
    ...mathematicsBank,
    ...electronicsBank,
    ...autoShopBank,
    ...mechanicalBank,
    ...assemblingObjectsBank,
  ]);

  static final Map<Subtest, List<Question>> _bySubtest = () {
    final map = <Subtest, List<Question>>{};
    for (final q in all) {
      map.putIfAbsent(q.subtest, () => <Question>[]).add(q);
    }
    return map;
  }();

  static final Map<String, Question> _byId = <String, Question>{
    for (final q in all) q.id: q,
  };

  static List<Question> bySubtest(Subtest s) =>
      _bySubtest[s] ?? const <Question>[];

  static Question? byId(String id) => _byId[id];

  static int countFor(Subtest s) => bySubtest(s).length;

  static int get total => all.length;

  /// Skills that have at least one question behind them.
  static Set<String> get coveredSkills => <String>{
    for (final q in all) ...q.skills,
  };

  /// Returns a list of human-readable problems. Empty means the bank is sound.
  /// This runs in the test suite and also powers the in-app QA lab, so a bad
  /// data edit fails loudly instead of shipping a broken item.
  static List<String> validate() {
    final problems = <String>[];
    final seenIds = <String>{};
    for (final q in all) {
      if (!seenIds.add(q.id)) {
        problems.add('Duplicate question id: ${q.id}');
      }
      if (q.choices.length != 4) {
        problems.add('${q.id}: expected 4 choices, found ${q.choices.length}');
      }
      if (q.answerIndex < 0 || q.answerIndex >= q.choices.length) {
        problems.add('${q.id}: answerIndex ${q.answerIndex} out of range');
      }
      if (q.choices.toSet().length != q.choices.length) {
        problems.add('${q.id}: duplicate choice text');
      }
      if (q.explanation.trim().length < 40) {
        problems.add('${q.id}: explanation too short to teach anything');
      }
      if (q.skills.isEmpty) {
        problems.add('${q.id}: no skill tags');
      }
      for (final s in q.skills) {
        if (Skills.maybeById(s) == null) {
          problems.add('${q.id}: unknown skill tag $s');
        } else if (Skills.byId(s).subtest != q.subtest) {
          problems.add('${q.id}: skill $s belongs to a different subtest');
        }
      }
      if (q.subtest == Subtest.pc &&
          (q.passage == null || q.passage!.trim().isEmpty)) {
        problems.add('${q.id}: paragraph comprehension item with no passage');
      }
      if (q.subtest == Subtest.ao) {
        if (q.puzzle == null) {
          problems.add('${q.id}: assembling objects item with no puzzle');
        } else {
          final legal = q.puzzle!.legaltyCount;
          if (legal != 1) {
            problems.add(
              '${q.id}: puzzle has $legal legal options, expected exactly 1',
            );
          } else if (q.puzzle!.correctIndex != q.answerIndex) {
            problems.add(
              '${q.id}: answerIndex ${q.answerIndex} but the only '
              'legal assembly is ${q.puzzle!.correctIndex}',
            );
          }
        }
      }
    }

    // Every declared skill should be exercisable.
    for (final skill in Skills.all) {
      if (!coveredSkills.contains(skill.id)) {
        problems.add('Skill ${skill.id} has no questions behind it');
      }
    }
    return problems;
  }
}
