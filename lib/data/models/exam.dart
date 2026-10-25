import 'catalog.dart';
import 'question.dart';
import 'score.dart';

/// A question as actually served to the candidate: the bank item plus the
/// per-session ordering of its four options.
///
/// Options are reshuffled on every attempt so answer position can never be
/// learned as a shortcut. The permutation is persisted with the response, so a
/// finished attempt can be replayed exactly as it was seen.
class ServedQuestion {
  const ServedQuestion({required this.base, required this.order});

  final Question base;

  /// order[displayIndex] = index in [Question.choices].
  final List<int> order;

  String get id => base.id;
  Subtest get subtest => base.subtest;

  List<String> get displayChoices =>
      order.map((i) => base.choices[i]).toList(growable: false);

  /// The correct option expressed in display coordinates.
  int get displayAnswerIndex => order.indexOf(base.answerIndex);

  bool isCorrect(int? displaySelected) =>
      displaySelected != null && displaySelected == displayAnswerIndex;

  /// Maps a display index back to the bank index.
  int toBankIndex(int displayIndex) => order[displayIndex];

  factory ServedQuestion.identity(Question q) => ServedQuestion(
    base: q,
    order: List<int>.generate(q.choices.length, (i) => i, growable: false),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'order': order};
}

/// One timed block of an exam.
class ExamSection {
  const ExamSection({
    required this.subtest,
    required this.questions,
    required this.minutes,
  });

  final Subtest subtest;
  final List<ServedQuestion> questions;
  final int minutes;

  int get seconds => minutes * 60;
}

/// A built exam, ready to run.
class Exam {
  const Exam({
    required this.id,
    required this.kind,
    required this.sections,
    required this.title,
  });

  final String id;
  final ExamKind kind;
  final List<ExamSection> sections;
  final String title;

  int get questionCount =>
      sections.fold(0, (sum, s) => sum + s.questions.length);

  int get minutes => sections.fold(0, (sum, s) => sum + s.minutes);

  List<ServedQuestion> get allQuestions => <ServedQuestion>[
    for (final s in sections) ...s.questions,
  ];

  List<Subtest> get subtests =>
      sections.map((s) => s.subtest).toList(growable: false);

  /// Total questions available in this exam per subtest.
  int countFor(Subtest s) => sections
      .where((sec) => sec.subtest == s)
      .fold(0, (n, sec) => n + sec.questions.length);
}
