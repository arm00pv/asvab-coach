import '../models/catalog.dart';
import '../models/line_score.dart';
import '../models/mos.dart';
import '../models/question.dart';
import '../models/score.dart';

/// JSON round-tripping for everything that outlives a browser session.
///
/// Convention: [QuestionResponse.selectedIndex] is always expressed in BANK
/// coordinates, never in the shuffled order the candidate saw. The permutation
/// travels separately in [orderByQuestion] so a finished attempt can be
/// replayed exactly as it appeared.
abstract final class Serialization {
  static Map<String, dynamic> responseToJson(QuestionResponse r) =>
      <String, dynamic>{
        'q': r.questionId,
        's': r.selectedIndex,
        't': r.secondsSpent,
        'f': r.flagged,
      };

  static QuestionResponse responseFromJson(Map<String, dynamic> j) =>
      QuestionResponse(
        questionId: j['q'] as String,
        selectedIndex: (j['s'] as num?)?.toInt(),
        secondsSpent: (j['t'] as num?)?.toInt() ?? 0,
        flagged: (j['f'] as bool?) ?? false,
      );

  static Map<String, dynamic> reportToJson(ScoreReport r) => <String, dynamic>{
    'subtests': <String, dynamic>{
      for (final e in r.subtestScores.entries)
        e.key.name: <String, dynamic>{
          'c': e.value.correct,
          'n': e.value.total,
          'ss': e.value.standardScore,
          'sec': e.value.secondsSpent,
          'rate': e.value.difficultyAdjustedRate,
        },
    },
    'skills': <String, dynamic>{
      for (final e in r.skillMastery.entries)
        e.key: <String, dynamic>{
          'c': e.value.correct,
          'n': e.value.total,
          'f': e.value.flags,
        },
    },
    've': r.ve,
    'composite': r.afqtComposite,
    'afqt': r.afqtPercentile,
    'lines': <String, dynamic>{
      for (final e in r.lineScores.entries) e.key.abbr: e.value,
    },
    'elapsed': r.elapsedSeconds,
    'answered': r.totalAnswered,
    'correct': r.totalCorrect,
  };

  static ScoreReport reportFromJson(Map<String, dynamic> j) {
    final subtests = <Subtest, SubtestScore>{};
    final stMap = (j['subtests'] as Map?)?.cast<String, dynamic>() ?? const {};
    for (final entry in stMap.entries) {
      final s = _subtestByName(entry.key);
      if (s == null) continue;
      final m = (entry.value as Map).cast<String, dynamic>();
      subtests[s] = SubtestScore(
        subtest: s,
        correct: (m['c'] as num?)?.toInt() ?? 0,
        total: (m['n'] as num?)?.toInt() ?? 0,
        standardScore: (m['ss'] as num?)?.toInt() ?? 0,
        secondsSpent: (m['sec'] as num?)?.toInt() ?? 0,
        difficultyAdjustedRate: (m['rate'] as num?)?.toDouble() ?? 0,
      );
    }
    final skills = <String, SkillMastery>{};
    final skMap = (j['skills'] as Map?)?.cast<String, dynamic>() ?? const {};
    for (final entry in skMap.entries) {
      final m = (entry.value as Map).cast<String, dynamic>();
      skills[entry.key] = SkillMastery(
        skillId: entry.key,
        correct: (m['c'] as num?)?.toInt() ?? 0,
        total: (m['n'] as num?)?.toInt() ?? 0,
        flags: (m['f'] as num?)?.toInt() ?? 0,
      );
    }
    final lines = <LineScore, int>{};
    final lnMap = (j['lines'] as Map?)?.cast<String, dynamic>() ?? const {};
    for (final entry in lnMap.entries) {
      final ls = LineScore.values.where((x) => x.abbr == entry.key);
      if (ls.isEmpty) continue;
      lines[ls.first] = (entry.value as num).toInt();
    }
    return ScoreReport(
      subtestScores: subtests,
      skillMastery: skills,
      ve: (j['ve'] as num?)?.toInt() ?? 50,
      afqtComposite: (j['composite'] as num?)?.toInt() ?? 0,
      afqtPercentile: (j['afqt'] as num?)?.toInt() ?? 0,
      lineScores: lines,
      elapsedSeconds: (j['elapsed'] as num?)?.toInt() ?? 0,
      totalAnswered: (j['answered'] as num?)?.toInt() ?? 0,
      totalCorrect: (j['correct'] as num?)?.toInt() ?? 0,
    );
  }

  static Subtest? _subtestByName(String name) {
    for (final s in Subtest.values) {
      if (s.name == name) return s;
    }
    return null;
  }

  static Map<String, dynamic> attemptToJson(
    Attempt a,
    Map<String, List<int>> orderByQuestion,
  ) => <String, dynamic>{
    'id': a.id,
    'kind': a.kind.name,
    'started': a.startedAt.toIso8601String(),
    'finished': a.finishedAt.toIso8601String(),
    'questions': a.questionIds,
    'subtests': a.subtests.map((s) => s.name).toList(),
    'responses': a.responses.map(responseToJson).toList(),
    'orders': orderByQuestion,
    'report': reportToJson(a.report),
  };

  static Attempt attemptFromJson(Map<String, dynamic> j) {
    final kind = ExamKind.values.firstWhere(
      (k) => k.name == j['kind'],
      orElse: () => ExamKind.section,
    );
    final subtests = <Subtest>[];
    for (final name in (j['subtests'] as List?) ?? const []) {
      final s = _subtestByName(name as String);
      if (s != null) subtests.add(s);
    }
    return Attempt(
      id: j['id'] as String,
      kind: kind,
      startedAt: DateTime.parse(j['started'] as String),
      finishedAt: DateTime.parse(j['finished'] as String),
      report: reportFromJson((j['report'] as Map).cast<String, dynamic>()),
      responses: ((j['responses'] as List?) ?? const [])
          .map((e) => responseFromJson((e as Map).cast<String, dynamic>()))
          .toList(),
      questionIds: ((j['questions'] as List?) ?? const [])
          .map((e) => e as String)
          .toList(),
      subtests: subtests,
    );
  }

  /// Reads the persisted option permutations for an attempt.
  static Map<String, List<int>> ordersFromJson(Map<String, dynamic> j) {
    final raw = (j['orders'] as Map?)?.cast<String, dynamic>() ?? const {};
    return <String, List<int>>{
      for (final e in raw.entries)
        e.key: (e.value as List).map((x) => (x as num).toInt()).toList(),
    };
  }

  static Map<String, dynamic> goalToJson(GoalProfile g) => g.toJson();
}
