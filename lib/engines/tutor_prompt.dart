import '../data/models/question.dart';

/// How the app talks to the on-device tutor, kept pure so it can be tested
/// without a phone, a model or a native library.
///
/// The contract is deliberately narrow, and it comes from what the model was
/// measured doing (docs/AI_EVAL.md):
///
///   * it is asked to work the question out and then to name the option *text*
///     it chose, never a letter. Asked for a letter first it opened "A) ..."
///     and then reasoned its way to a different answer, and it did that on more
///     than half the items;
///   * its choice is mapped back onto the app's own options, and compared with
///     the app's own key. Where they disagree the app says so instead of
///     passing the disagreement to a candidate who cannot check it;
///   * the app's own explanation is never replaced by the model's. One is
///     checked, the other is generated, and the screen keeps them apart.
abstract final class TutorPrompt {
  /// The instruction the model is given. Short on purpose: a long rubric made
  /// this model answer in the rubric's shape rather than in its own words.
  static const system =
      'You are an ASVAB study coach. Work the question out carefully and '
      'honestly. Do not guess.';

  /// Builds the completion prompt for [question].
  ///
  /// The shape is the one that measured best: reason first, name the option
  /// last, and finish with a line the app can read.
  static String forQuestion(
    Question question, {
    required List<int> order,
    String? candidateAnswer,
    bool inSpanish = false,
  }) {
    final choices = <String>[];
    for (var slot = 0; slot < order.length; slot++) {
      final choice = order[slot];
      if (choice < 0 || choice >= question.choices.length) continue;
      choices.add('${_letter(slot)}) ${question.choices[choice]}');
    }
    final buffer = StringBuffer()
      ..writeln('<|im_start|>system')
      ..writeln(
        inSpanish
            ? '$system Eres un entrenador de estudio del ASVAB. Responde en '
                  'espanol. Explica el razonamiento y no inventes datos.'
            : system,
      )
      ..writeln('<|im_end|>')
      ..writeln('<|im_start|>user')
      ..writeln('ASVAB question, ${question.subtest.label}:');
    final passage = question.passage;
    if (passage != null) buffer.writeln(passage);
    buffer
      ..writeln(question.stem)
      ..write(choices.join('\n'))
      ..writeln();
    if (candidateAnswer != null && candidateAnswer.isNotEmpty) {
      buffer.writeln('The student answered: $candidateAnswer');
    }
    buffer
      ..writeln(
        'Talk the student through it: say what the question is really asking, '
        'show the working step by step, and point out the mistake that leads to '
        'one of the wrong options. Keep it under 150 words.',
      )
      ..writeln('Then finish with one final line of exactly this form:')
      ..writeln('CHOICE: <the option text copied word for word from the list>')
      ..writeln('<|im_end|>')
      ..write('<|im_start|>assistant');
    return buffer.toString();
  }

  /// The option the model named, if it named one.
  ///
  /// Matched against the app's own option list, so "the answer is 16" and
  /// "CHOICE: 16" both resolve to the same option and a paraphrase that names
  /// no option resolves to nothing.
  static TutorChoice? readChoice(String answer, List<String> choices) {
    final marker = RegExp(
      r'CHOICE\s*:\s*(.+)$',
      multiLine: true,
      caseSensitive: false,
    ).allMatches(answer);
    String? said;
    if (marker.isNotEmpty) {
      said = marker.last.group(1);
    } else {
      final line = RegExp(
        r'correct (?:answer|option|choice)[^.]*?(?:is|:)\s*(.+)',
        caseSensitive: false,
      ).firstMatch(answer);
      said = line?.group(1);
    }
    if (said == null) return null;

    final cleaned = _clean(said);
    if (cleaned.isEmpty) return null;

    // Exact first, then "contains", because a model that was asked to copy the
    // option word for word still sometimes wraps it in quotes or a sentence.
    for (var i = 0; i < choices.length; i++) {
      if (_clean(choices[i]) == cleaned) {
        return TutorChoice(index: i, said: said);
      }
    }
    for (var i = 0; i < choices.length; i++) {
      final option = _clean(choices[i]);
      if (option.isEmpty) continue;
      if (cleaned.contains(option) || option.contains(cleaned)) {
        return TutorChoice(index: i, said: said);
      }
    }
    // A bare letter, which is what the model falls back to when it is tired.
    final letter = RegExp(
      r'^\(?([A-D])[\).:]?$',
      caseSensitive: false,
    ).firstMatch(said.trim());
    if (letter != null) {
      final index = letter.group(1)!.codeUnitAt(0) - 65;
      if (index >= 0 && index < choices.length) {
        return TutorChoice(index: index, said: said);
      }
    }
    return null;
  }

  /// The answer with any trailing CHOICE line and stop markers removed, which
  /// is what the sheet shows above the app's verdict.
  static String body(String answer) {
    var text = answer;
    final stop = text.indexOf('<|im_end|>');
    if (stop >= 0) text = text.substring(0, stop);
    final choice = RegExp(
      r'^\s*CHOICE\s*:.*$',
      multiLine: true,
    ).firstMatch(text);
    if (choice != null) text = text.substring(0, choice.start);
    return text.trim();
  }

  static String _letter(int slot) =>
      slot >= 0 && slot < 26 ? String.fromCharCode(65 + slot) : '?';

  static String _clean(String value) => value
      .toLowerCase()
      .replaceAll(RegExp('["\u0060*]'), '')
      .replaceAll(RegExp(r'^\s*\(?[a-d][\).:]\s*'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .replaceAll(RegExp(r'[.,;:]+$'), '');
}

/// The option the model pointed at, in the coordinates it was shown.
class TutorChoice {
  const TutorChoice({required this.index, required this.said});

  /// Index into the list of options as they were offered to the model, which is
  /// the order the screen draws them in.
  final int index;

  /// What the model actually wrote, kept for the sheet to quote.
  final String said;
}
