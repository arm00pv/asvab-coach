import '../data/models/catalog.dart';
import '../data/models/exam.dart';
import '../data/models/line_score.dart';
import '../data/models/score.dart';
import 'adaptive_engine.dart';
import 'exam_builder.dart';

/// The practice set behind one line-score route: "raise GT by two points" turned
/// into the questions that would do it.
///
/// The jobs sheet already answers eligibility with arithmetic. A
/// [UnlockRoute] names the line score that is short, by how many points, and
/// whether that one raise opens the job - but it could not start the work, so a
/// candidate read "raise GT by 2" and was left to work out what GT is even made
/// of. This engine answers that from the scoring model rather than from a table
/// kept somewhere else: [LineScore.feedingSubtests] is derived from the same
/// terms [LineScore.compute] applies, so GT is AR, WK and PC because GT is
/// computed from VE and AR, and CO is every reported subtest because the CO
/// composite weights all of them.
///
/// Nothing else here is new machinery. [AdaptiveEngine.priorities] ranks the
/// candidate's skills weakest first, [ExamBuilder.drill] chooses the questions
/// and groups them into sections, and the app's existing practice flow runs the
/// result. The set is labelled with its own size and the line score it aims at.
///
/// What is honest to claim and what is not: the composition is real arithmetic,
/// the subtest standard scores it is arithmetic on are estimates from one
/// attempt. So the label says which questions move the score, never that the
/// score will reach the gate.
abstract final class LineScoreDrillEngine {
  /// The size of the app's other short practice set - [ExamBuilder.drill]'s own
  /// default - so "a short set" means the same thing in both places.
  static const int defaultCount = 12;

  /// A skill count per feeding subtest: two skills are enough for a short
  /// section and keep every question inside the subtests the line score is made
  /// of, rather than letting one strong subtest take the whole set.
  static const int skillsPerSubtest = 2;

  /// The smallest section worth starting: a section a candidate opens the
  /// introduction of and then sits more than one item in, rather than being sent
  /// one question at a time. It also sets how many feeding subtests a short set
  /// can span - twelve questions in sections of three is four subtests.
  static const int minSection = 3;

  /// The subtests whose standard scores move [score], in the order MEPS
  /// administers them so the built set's sections read in a natural order.
  static List<Subtest> feedingSubtests(LineScore score) => <Subtest>[
    for (final s in Subtest.administrationOrder)
      if (score.feedingSubtests.contains(s)) s,
  ];

  /// The label the candidate reads, on the action and on the set itself.
  ///
  /// [questions] is the size of the set that was actually built, not the size
  /// asked for, so the number in the sentence is never an estimate.
  static String labelFor(LineScore score, int questions) =>
      '${score.abbr} practice - $questions '
      '${questions == 1 ? 'question' : 'questions'} that move your '
      '${score.label} score';

  /// Which subtests the set is drawn from, and why those.
  ///
  /// [drawn] is read off the built set, so the sentence cannot claim a section
  /// the candidate will not sit. A drill narrowed to one subtest says so
  /// outright instead of naming the whole composite and then serving arithmetic
  /// for twelve questions.
  static String compositionFor(LineScore score, List<Subtest> drawn) {
    final all = feedingSubtests(score);
    final names = _join(drawn.map((s) => s.abbr).toList(growable: false));
    if (drawn.length == all.length) {
      return 'Drawn from $names, the subtests whose scores are combined into '
          '${score.abbr}.';
    }
    final pool = _join(all.map((s) => s.abbr).toList(growable: false));
    return 'Drawn from $names out of $pool - the subtests whose scores are '
        'combined into ${score.abbr} - because that is where your weakest '
        'skills sit.';
  }

  /// The caveat that belongs under every drill action.
  ///
  /// A line score is arithmetic on subtest scores the app estimates from an
  /// attempt, so working the right subtests is the only lever the app can offer,
  /// and it cannot promise the number moves.
  static const String estimateCaveat =
      'Aim, not a promise: the line score is arithmetic on subtest scores the '
      'app estimates from one attempt, so this set targets the right subtests '
      'without claiming the number will rise.';

  /// The set aimed at [score], or null when the bank cannot supply one.
  ///
  /// A null answer is the honest one for a line score with no feeding subtest in
  /// this bank: a button that opens an empty exam is worse than no button, and
  /// the caller shows nothing instead.
  static LineScoreDrill? forScore({
    required LineScore score,
    required ScoreReport report,
    required int seed,
    int count = defaultCount,
  }) {
    final subtests = feedingSubtests(score);
    if (subtests.isEmpty || count <= 0) return null;

    // The candidate's own ranking, kept only where the subtest feeds this line
    // score: a skill with leverage on the composite, not merely a skill with
    // room to improve.
    final ranked = AdaptiveEngine.priorities(report);
    final urgency = <String, double>{
      for (final priority in ranked) priority.skill.id: priority.urgency,
    };
    final skills = <Subtest, List<String>>{};
    for (final priority in ranked) {
      final s = priority.skill.subtest;
      if (!subtests.contains(s)) continue;
      (skills[s] ??= <String>[]).add(priority.skill.id);
    }
    // A skill the candidate has never met cannot be ranked, so the taxonomy
    // fills in behind the ranked ones: an unmeasured subtest is still worth
    // practising rather than being dropped out of its own drill.
    for (final s in subtests) {
      final list = skills.putIfAbsent(s, () => <String>[]);
      for (final skill in Skills.forSubtest(s)) {
        if (list.length >= skillsPerSubtest) break;
        if (!list.contains(skill.id)) list.add(skill.id);
      }
      if (list.length > skillsPerSubtest) {
        list.removeRange(skillsPerSubtest, list.length);
      }
    }

    final quotas = _quotas(
      subtests: subtests,
      skills: skills,
      urgency: urgency,
      count: count,
    );
    if (quotas.isEmpty) return null;

    // One drill per feeding subtest, merged in administration order: the same
    // [ExamBuilder.drill] the weak-spot card uses, asked a narrower question.
    // Building the set subtest by subtest is what makes the composition a fact
    // rather than a hope - a single call over the whole skill list would sort by
    // skill overlap and could serve twelve arithmetic questions to a candidate
    // who tapped CO.
    final sections = <ExamSection>[];
    final drawn = <Subtest>[];
    final skillIds = <String>[];
    for (final s in subtests) {
      final quota = quotas[s] ?? 0;
      final picks = skills[s] ?? const <String>[];
      if (quota <= 0 || picks.isEmpty) continue;
      final part = ExamBuilder.drill(
        skillIds: picks,
        seed: seed + s.index,
        count: quota,
      );
      final mine = part.sections
          .where((section) => section.subtest == s)
          .toList(growable: false);
      if (mine.isEmpty) continue;
      sections.addAll(mine);
      drawn.add(s);
      skillIds.addAll(picks);
    }
    if (sections.isEmpty) return null;

    // The label is built from the set that exists rather than from the set that
    // was asked for, so the count the candidate reads is the count they sit.
    return LineScoreDrill(
      score: score,
      subtests: subtests,
      drawn: List<Subtest>.unmodifiable(drawn),
      skillIds: List<String>.unmodifiable(skillIds),
      exam: Exam(
        id: 'line-${score.abbr}-$seed',
        kind: ExamKind.drill,
        sections: sections,
        title: labelFor(
          score,
          sections.fold<int>(0, (n, section) => n + section.questions.length),
        ),
      ),
    );
  }

  /// How the set's questions are divided between the subtests that feed it.
  ///
  /// The weakest subtests are chosen first - a subtest is as weak as the skills
  /// this drill would draw from it - so the areas costing the candidate the most
  /// points are the ones with a section. What is left is split as evenly as the
  /// count allows. When the count is smaller than [minSection], only the weakest
  /// subtest is drilled rather than starting several one-question sections.
  static Map<Subtest, int> _quotas({
    required List<Subtest> subtests,
    required Map<Subtest, List<String>> skills,
    required Map<String, double> urgency,
    required int count,
  }) {
    double weightOf(Subtest s) => (skills[s] ?? const <String>[]).fold<double>(
      0,
      (sum, id) => sum + (urgency[id] ?? 0),
    );
    final order = <Subtest>[
      for (final s in subtests)
        if (skills[s] != null && skills[s]!.isNotEmpty) s,
    ];
    final index = <Subtest, int>{
      for (var i = 0; i < order.length; i++) order[i]: i,
    };
    order.sort((a, b) {
      final byWeight = weightOf(b).compareTo(weightOf(a));
      if (byWeight != 0) return byWeight;
      return index[a]!.compareTo(index[b]!);
    });

    final spread = count ~/ minSection;
    final used = spread < 1
        ? 1
        : (spread > order.length ? order.length : spread);
    final base = count ~/ used;
    final extra = count - base * used;
    return <Subtest, int>{
      for (var i = 0; i < used; i++) order[i]: base + (i < extra ? 1 : 0),
    };
  }

  /// "AR", "AR and WK", "AR, WK and PC" - no Oxford comma, matching the rest of
  /// the app's sentences.
  static String _join(List<String> parts) {
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first;
    return '${parts.sublist(0, parts.length - 1).join(', ')} and ${parts.last}';
  }
}

/// One built practice set, with everything a screen needs to explain it.
class LineScoreDrill {
  const LineScoreDrill({
    required this.score,
    required this.subtests,
    required this.drawn,
    required this.skillIds,
    required this.exam,
  });

  /// The line score the route raises, and so the one the set aims at.
  final LineScore score;

  /// The subtests that compose [score], in administration order.
  final List<Subtest> subtests;

  /// The subtests this particular set actually draws questions from.
  final List<Subtest> drawn;

  /// The skills aimed at, weakest first.
  final List<String> skillIds;

  /// The set itself, ready to hand to the practice flow.
  final Exam exam;

  /// The size the label claims, read back off the built exam.
  int get questionCount => exam.questionCount;

  /// "GT practice - 12 questions that move your General Technical score".
  String get label => exam.title;

  /// Why these subtests: the composition, named.
  String get composition => LineScoreDrillEngine.compositionFor(score, drawn);
}
