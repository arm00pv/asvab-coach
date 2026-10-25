import '../models/catalog.dart';
import '../models/question.dart';
import 'arithmetic.dart';
import 'arithmetic_extra.dart';
import 'assembling_objects.dart';
import 'assembling_objects_connection.dart';
import 'auto_shop.dart';
import 'auto_shop_extra.dart';
import 'auto_shop_tools.dart';
import 'bank_audit.dart';
import 'electronics.dart';
import 'electronics_extra.dart';
import 'general_science.dart';
import 'general_science_extra.dart';
import 'mathematics.dart';
import 'mathematics_extra.dart';
import 'mechanical.dart';
import 'mechanical_extra.dart';
import 'mechanical_figures.dart';
import 'mechanical_figures_extra.dart';
import 'paragraph_comprehension.dart';
import 'skill_depth.dart';
import 'paragraph_comprehension_extra.dart';
import 'word_knowledge.dart';
import 'word_knowledge_extra.dart';

/// The single entry point for question content.
abstract final class QuestionBank {
  static final List<Question> all = List<Question>.unmodifiable(<Question>[
    ...generalScienceBank,
    ...generalScienceExtraBank,
    ...arithmeticBank,
    ...arithmeticExtraBank,
    ...wordKnowledgeBank,
    ...wordKnowledgeExtraBank,
    ...readingBank,
    ...readingExtraBank,
    ...mathematicsBank,
    ...mathematicsExtraBank,
    ...electronicsBank,
    ...electronicsExtraBank,
    ...autoShopBank,
    ...autoShopExtraBank,
    ...autoShopToolBank,
    ...mechanicalBank,
    ...mechanicalExtraBank,
    ...mechanicalFigureBank,
    ...mechanicalFigureExtraBank,
    ...assemblingObjectsBank,
    ...assemblingObjectsConnectionBank,
    ...skillDepthBank,
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

  /// Every audit finding, warnings included. Used by the QA lab.
  static List<AuditFinding> get audit => BankAudit.run(all);

  /// Release-blocking problems only. Empty means the bank is sound.
  ///
  /// This runs in the test suite and powers the in-app QA lab, so a bad data
  /// edit fails loudly instead of shipping a broken item. Item-quality rules
  /// live in [BankAudit].
  static List<String> validate() => audit
      .where((finding) => finding.isError)
      .map((finding) => finding.toString())
      .toList(growable: false);

  /// Non-blocking authoring notes, surfaced for review rather than failure.
  static List<String> get warnings => audit
      .where((finding) => !finding.isError)
      .map((finding) => finding.toString())
      .toList(growable: false);

  /// Questions behind each skill, for targeting authoring gaps.
  static Map<String, int> get skillCoverage => BankAudit.coverage(all);
}
