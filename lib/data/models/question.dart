import 'catalog.dart';
import 'sketch.dart';
import 'polyomino.dart';

export 'sketch.dart';

export 'polyomino.dart' show AoConnection, AoLabel, AoPuzzle, GridCell, Poly;

class Question {
  const Question({
    required this.id,
    required this.subtest,
    required this.stem,
    required this.choices,
    required this.answerIndex,
    required this.explanation,
    required this.difficulty,
    required this.skills,
    this.passage,
    this.puzzle,
    this.figure,
    this.source,
  });

  final String id;
  final Subtest subtest;

  /// Reading passage, only used by Paragraph Comprehension.
  final String? passage;

  final String stem;
  final List<String> choices;
  final int answerIndex;

  /// Worked explanation shown in review and reused inside reinforcement
  /// lessons.
  final String explanation;

  final Difficulty difficulty;
  final List<String> skills;
  final AoPuzzle? puzzle;

  /// Optional diagram, used by Mechanical Comprehension items.
  final Sketch? figure;

  /// Optional short attribution / knowledge reference shown in review.
  final String? source;

  bool isCorrectChoice(int index) => index == answerIndex;

  String get correctChoice => choices[answerIndex];
}

/// A single recorded answer.
class QuestionResponse {
  const QuestionResponse({
    required this.questionId,
    required this.selectedIndex,
    required this.secondsSpent,
    this.flagged = false,
  });

  final String questionId;
  final int? selectedIndex;
  final int secondsSpent;
  final bool flagged;

  bool get isAnswered => selectedIndex != null;
}
