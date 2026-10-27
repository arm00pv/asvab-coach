import 'catalog.dart';
import 'sketch.dart';
import 'polyomino.dart';

export 'sketch.dart';

export 'polyomino.dart'
    show AoConnection, AoFlaw, AoFlawCode, AoLabel, AoPuzzle, GridCell, Poly;

class Question {
  const Question({
    required this.id,
    required this.subtest,
    required String stem,
    required this.choices,
    required this.answerIndex,
    required this.explanation,
    required this.difficulty,
    required this.skills,
    this.choiceNotes = const <String>[],
    this.passage,
    this.puzzle,
    this.figure,
    this.source,
  }) : _rawStem = stem;

  final String id;
  final Subtest subtest;

  /// Reading passage, only used by Paragraph Comprehension.
  final String? passage;

  /// The stem exactly as the item was written. Every screen draws [stem]
  /// instead; nothing reads this one directly.
  final String _rawStem;

  /// The stem as it is drawn, with its terminal punctuation made consistent.
  ///
  /// The bank ships three item shapes and punctuated them three ways: a
  /// question ends in "?", a fill-in that the four options finish ("... is
  /// called") ends in nothing, and a computation that gives its work after a
  /// colon ("Simplify: 8 + 2(5 - 3)^2") also ends in nothing. Side by side in
  /// one practice set that reads as a typo, and a stem that stops dead at "is
  /// caused mainly by" gives the reader no signal that the options finish the
  /// sentence for them.
  ///
  /// The rule is applied when the stem is drawn and never written back to the
  /// item: a question keeps its "?"; a stem that stops on a word gets the colon
  /// that says the options complete it; a stem that stops on a symbol - the
  /// tail of a computation - is a finished sentence and takes a full stop; and
  /// a single-word stem ("ADEPT") is the word to be defined, which the Word
  /// Knowledge items set without a mark, exactly as the real test does.
  String get stem => punctuateStem(_rawStem);

  final List<String> choices;
  final int answerIndex;

  /// Worked explanation shown in review and reused inside reinforcement
  /// lessons.
  final String explanation;

  /// One short line per choice, in bank coordinates, saying why that choice
  /// is wrong (or, for the keyed one, why it holds). This is where a
  /// candidate who picked B learns something: telling them only that A is
  /// correct teaches nothing.
  ///
  /// Empty means the item has not been annotated yet; an annotated item must
  /// carry exactly one note per choice, which the bank audit enforces.
  final List<String> choiceNotes;

  /// The note for the choice at [index] in bank coordinates, if annotated.
  String? noteFor(int index) {
    if (index < 0 || index >= choiceNotes.length) return null;
    final String note = choiceNotes[index].trim();
    return note.isEmpty ? null : note;
  }

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

/// Draws [raw] with the terminal mark its shape calls for, leaving a stem that
/// already ends in one untouched. See [Question.stem] for why.
String punctuateStem(String raw) {
  final String stem = raw.trim();
  if (stem.isEmpty) return stem;
  if ('?.!:;'.contains(stem[stem.length - 1])) return stem;
  // A single word is the thing to be defined, not a sentence: a colon on
  // "ADEPT" would ask a question the item is not asking.
  if (!stem.contains(' ')) return stem;
  final bool endsOnLetter = RegExp(r'[A-Za-z]').hasMatch(stem[stem.length - 1]);
  return endsOnLetter ? '$stem:' : '$stem.';
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
