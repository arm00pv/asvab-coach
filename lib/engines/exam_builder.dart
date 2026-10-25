import 'dart:math' as math;

import '../data/bank/question_bank.dart';
import '../data/models/catalog.dart';
import '../data/models/exam.dart';
import '../data/models/question.dart';
import '../data/models/score.dart';

/// Deterministic option shuffling. The seed is derived from the question id
/// and the attempt seed, so the same attempt always reproduces the same layout
/// while different attempts look different.
ServedQuestion _serve(Question q, int attemptSeed) {
  final rng = math.Random(q.id.hashCode ^ attemptSeed);
  final order = List<int>.generate(q.choices.length, (i) => i);
  for (var i = order.length - 1; i > 0; i--) {
    final j = rng.nextInt(i + 1);
    final t = order[i];
    order[i] = order[j];
    order[j] = t;
  }
  return ServedQuestion(base: q, order: order);
}

abstract final class ExamBuilder {
  /// Three questions per subtest, times scaled from the official limits.
  /// This is the placement test that seeds every later recommendation.
  static Exam diagnostic({required int seed}) {
    const perSubtest = 3;
    final sections = <ExamSection>[];
    for (final s in Subtest.administrationOrder) {
      final pool = QuestionBank.bySubtest(s);
      final picked = _balancedPick(pool, perSubtest, seed + s.index);
      if (picked.isEmpty) continue;
      final scaled = math.max(
        2,
        (s.minutes * perSubtest / s.questionCount).ceil(),
      );
      sections.add(
        ExamSection(
          subtest: s,
          questions: picked.map((q) => _serve(q, seed)).toList(growable: false),
          minutes: scaled,
        ),
      );
    }
    return Exam(
      id: 'diagnostic-$seed',
      kind: ExamKind.diagnostic,
      sections: sections,
      title: 'Placement Diagnostic',
    );
  }

  /// Every subtest at the official CAT-ASVAB question count and time limit.
  static Exam fullMock({required int seed}) {
    final sections = <ExamSection>[];
    for (final s in Subtest.administrationOrder) {
      final pool = QuestionBank.bySubtest(s);
      if (pool.isEmpty) continue;
      if (s == Subtest.as) {
        // The computer form administers Auto Information and Shop Information
        // as two separate blocks, so the mock does too.
        sections.addAll(_autoShopSections(pool, seed));
        continue;
      }
      final n = math.min(s.questionCount, pool.length);
      final picked = _balancedPick(pool, n, seed + s.index * 7);
      sections.add(
        ExamSection(
          subtest: s,
          questions: picked.map((q) => _serve(q, seed)).toList(growable: false),
          minutes: s.minutes,
        ),
      );
    }
    return Exam(
      id: 'fullmock-$seed',
      kind: ExamKind.fullMock,
      sections: sections,
      title: 'Full Mock ASVAB',
    );
  }

  /// One subtest, official question count, official time limit.
  static Exam section(Subtest subtest, {required int seed, bool timed = true}) {
    final pool = QuestionBank.bySubtest(subtest);
    final n = math.min(subtest.questionCount, pool.length);
    final picked = _balancedPick(pool, n, seed);
    return Exam(
      id: 'section-${subtest.abbr}-$seed',
      kind: ExamKind.section,
      sections: <ExamSection>[
        ExamSection(
          subtest: subtest,
          questions: picked.map((q) => _serve(q, seed)).toList(growable: false),
          minutes: timed ? subtest.minutes : 999,
        ),
      ],
      title: '${subtest.label} Practice',
    );
  }

  /// Pulls questions that exercise the given skills, weakest skills first.
  static Exam drill({
    required List<String> skillIds,
    required int seed,
    int count = 12,
  }) {
    final wanted = skillIds.toSet();
    final picked =
        QuestionBank.all.where((q) => q.skills.any(wanted.contains)).toList()
          ..sort((a, b) => _overlap(b, wanted).compareTo(_overlap(a, wanted)));
    final limited = picked.take(count).toList(growable: false);
    final bySubtest = <Subtest, List<Question>>{};
    for (final q in limited) {
      bySubtest.putIfAbsent(q.subtest, () => <Question>[]).add(q);
    }
    final sections = <ExamSection>[];
    for (final s in Subtest.administrationOrder) {
      final list = bySubtest[s];
      if (list == null || list.isEmpty) continue;
      final scaled = math.max(
        2,
        (s.minutes * list.length / s.questionCount).ceil(),
      );
      sections.add(
        ExamSection(
          subtest: s,
          questions: list.map((q) => _serve(q, seed)).toList(growable: false),
          minutes: scaled,
        ),
      );
    }
    return Exam(
      id: 'drill-$seed',
      kind: ExamKind.drill,
      sections: sections,
      title: 'Targeted Drill',
    );
  }

  /// A short mastery check for one skill, used at the end of a lesson.
  static Exam lessonQuiz(String skillId, {required int seed, int count = 4}) {
    final pool = QuestionBank.all
        .where((q) => q.skills.contains(skillId))
        .toList();
    final picked = _balancedPick(pool, math.min(count, pool.length), seed);
    if (picked.isEmpty) {
      return Exam(
        id: 'quiz-$skillId-$seed',
        kind: ExamKind.lessonQuiz,
        sections: const <ExamSection>[],
        title: 'Mastery Check',
      );
    }
    final sub = picked.first.subtest;
    return Exam(
      id: 'quiz-$skillId-$seed',
      kind: ExamKind.lessonQuiz,
      sections: <ExamSection>[
        ExamSection(
          subtest: sub,
          questions: picked.map((q) => _serve(q, seed)).toList(growable: false),
          minutes: 999,
        ),
      ],
      title: 'Mastery Check',
    );
  }

  static int _overlap(Question q, Set<String> wanted) =>
      q.skills.where(wanted.contains).length;

  /// Auto skills identify the Auto Information half of Auto & Shop.
  static const Set<String> _autoSkills = <String>{
    'as.engine',
    'as.drivetrain',
    'as.electrical',
  };

  static bool _isAuto(Question q) => q.skills.any(_autoSkills.contains);

  /// Builds the Auto Information and Shop Information blocks: ten items each,
  /// seven minutes and six minutes, matching the computer form.
  static List<ExamSection> _autoShopSections(List<Question> pool, int seed) {
    final auto = pool.where(_isAuto).toList();
    final shop = pool.where((q) => !_isAuto(q)).toList();
    const half = 10;

    final autoPick = _balancedPick(
      auto,
      math.min(half, auto.length),
      seed + 91,
    );
    final shopPick = _balancedPick(
      shop,
      math.min(half, shop.length),
      seed + 97,
    );

    // Top up from whatever is left so each block reaches its official size.
    final used = <String>{
      for (final q in autoPick) q.id,
      for (final q in shopPick) q.id,
    };
    final spare = pool.where((q) => !used.contains(q.id)).toList();
    final autoFill = <Question>[];
    final shopFill = <Question>[];
    for (final q in spare) {
      if (autoPick.length + autoFill.length < half) {
        autoFill.add(q);
      } else if (shopPick.length + shopFill.length < half) {
        shopFill.add(q);
      }
    }

    final sections = <ExamSection>[];
    if (autoPick.isNotEmpty || autoFill.isNotEmpty) {
      sections.add(
        ExamSection(
          subtest: Subtest.as,
          label: 'Auto Information',
          questions: <Question>[
            ...autoPick,
            ...autoFill,
          ].map((q) => _serve(q, seed)).toList(growable: false),
          minutes: 7,
        ),
      );
    }
    if (shopPick.isNotEmpty || shopFill.isNotEmpty) {
      sections.add(
        ExamSection(
          subtest: Subtest.as,
          label: 'Shop Information',
          questions: <Question>[
            ...shopPick,
            ...shopFill,
          ].map((q) => _serve(q, seed)).toList(growable: false),
          minutes: 6,
        ),
      );
    }
    return sections;
  }

  /// Picks [n] Paragraph Comprehension items that each use a different passage,
  /// matching the computer form where every reading item has its own text.
  /// Returns null when the pool cannot supply that many distinct passages, so
  /// the caller can fall back to the normal pick.
  static List<Question>? _distinctPassages(
    List<Question> pool,
    int n,
    int seed,
  ) {
    final byPassage = <String, List<Question>>{};
    for (final q in pool) {
      final key = (q.passage ?? '').trim();
      if (key.isEmpty) continue;
      byPassage.putIfAbsent(key, () => <Question>[]).add(q);
    }
    if (byPassage.length < n) return null;
    final rng = math.Random(seed);
    final passages = byPassage.keys.toList()..shuffle(rng);
    final picked = <Question>[];
    for (final key in passages.take(n)) {
      final options = byPassage[key]!;
      picked.add(options[rng.nextInt(options.length)]);
    }
    picked.shuffle(math.Random(seed ^ 0x1f2e));
    return picked;
  }

  /// Picks [n] questions spread across difficulties: roughly a fifth easy,
  /// three fifths medium, a fifth hard, then fills from whatever is left.
  /// Deterministic for a given seed so an attempt is reproducible.
  static List<Question> _balancedPick(List<Question> pool, int n, int seed) {
    if (pool.isEmpty || n <= 0) return const <Question>[];
    if (n >= pool.length) {
      final all = List<Question>.of(pool);
      all.shuffle(math.Random(seed));
      return all;
    }
    // Paragraph Comprehension is one question per passage on the computer test,
    // so a section built from this pool must never repeat a passage.
    if (pool.first.subtest == Subtest.pc) {
      final distinct = _distinctPassages(pool, n, seed);
      if (distinct != null) return distinct;
    }

    final rng = math.Random(seed);
    final easy = pool.where((q) => q.difficulty == Difficulty.easy).toList()
      ..shuffle(rng);
    final medium = pool.where((q) => q.difficulty == Difficulty.medium).toList()
      ..shuffle(rng);
    final hard = pool.where((q) => q.difficulty == Difficulty.hard).toList()
      ..shuffle(rng);
    final targetEasy = math.max(1, (n * 0.25).round());
    final targetHard = math.max(1, (n * 0.2).round());
    final out = <Question>[];
    void take(List<Question> src, int want) {
      for (final q in src) {
        if (out.length >= n || want <= 0) break;
        if (out.any((o) => o.id == q.id)) continue;
        out.add(q);
        want--;
      }
    }

    take(easy, targetEasy);
    take(hard, targetHard);
    take(medium, n - out.length);
    // Fill from anything remaining at any difficulty.
    for (final q in <Question>[...easy, ...hard, ...medium]) {
      if (out.length >= n) break;
      if (out.any((o) => o.id == q.id)) continue;
      out.add(q);
    }
    out.shuffle(math.Random(seed ^ 0x5f3a));
    return out;
  }
}
