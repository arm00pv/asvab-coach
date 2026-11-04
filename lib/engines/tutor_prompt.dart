import '../data/models/lesson.dart';
import '../data/models/question.dart';

/// The language the tutor answers in.
///
/// The written explanation and every number on the screen stay in English; this
/// only changes the words of the model's own working. It is offered because a
/// candidate who did not follow an English explanation often follows one in the
/// language they think in, and because the evaluation found the model's
/// translation of *numerical* work sound (docs/AI_EVAL.md) - which is most of
/// what an ASVAB explanation is.
enum TutorLanguage {
  english('English', 'English', 'en'),
  spanish('Espanol', 'Spanish', 'es'),
  italian('Italiano', 'Italian', 'it');

  const TutorLanguage(this.label, this.englishName, this.code);

  final String label;
  final String englishName;

  /// The language subtag the phone's voices are filed under, so the answer can
  /// be read out in the language it was written in.
  final String code;
}

/// How the app talks to the on-device tutor, kept pure so it can be tested
/// without a phone, a model or a native library.
///
/// The contract is deliberately narrow, and it comes from what the model was
/// measured doing (docs/AI_EVAL.md):
///
///   * it is **grounded**: the app's marked answer and its authored explanation
///     are put into the prompt, and the model is told to teach *that*. Left to
///     mark the question itself it named the wrong option on more than half the
///     items, and a tutor that argues with the key is worse than no tutor;
///   * it is asked to reason first and to name the option last, never to open
///     with a letter - that shape alone took it from six of sixteen to twelve;
///   * if its own working still reaches a different option it says so in one
///     final line, which the app reads and shows as a warning rather than
///     passing to the candidate as an answer.
abstract final class TutorPrompt {
  /// The instruction the model is given. Short on purpose: a long rubric made
  /// this model answer in the rubric's shape rather than in its own words.
  static const system =
      'You are an ASVAB study coach. The app has already marked this question '
      'and the answer it gives is correct. Teach the student how to reach it.';

  static const _languageLine = <TutorLanguage, String>{
    TutorLanguage.english: '',
    TutorLanguage.spanish:
        ' Answer in Spanish. Keep the option texts exactly as they are.',
    TutorLanguage.italian:
        ' Answer in Italian. Keep the option texts exactly as they are.',
  };

  /// Builds the completion prompt for [question].
  ///
  /// [keyedIndex] is the bank index of the answer the app has already checked;
  /// [explanation] is the app's own authored explanation for it. Both are given
  /// to the model so it explains a known-good answer instead of guessing.
  static String forQuestion(
    Question question, {
    required List<int> order,
    required int keyedIndex,
    String? explanation,
    String? candidateAnswer,
    TutorLanguage language = TutorLanguage.english,
  }) {
    final choices = <String>[];
    final letters = <int, String>{};
    for (var slot = 0; slot < order.length; slot++) {
      final choice = order[slot];
      if (choice < 0 || choice >= question.choices.length) continue;
      final letter = _letter(slot);
      letters[choice] = letter;
      choices.add('$letter) ${question.choices[choice]}');
    }
    final keyedLetter = letters[keyedIndex] ?? '';
    final keyedText = keyedIndex >= 0 && keyedIndex < question.choices.length
        ? question.choices[keyedIndex]
        : '';

    final buffer = StringBuffer()
      ..writeln('<|im_start|>system')
      ..writeln('$system${_languageLine[language] ?? ''}')
      ..writeln('<|im_end|>')
      ..writeln('<|im_start|>user')
      ..writeln('ASVAB question, ${question.subtest.label}:');
    final passage = question.passage;
    if (passage != null) buffer.writeln(passage);
    buffer
      ..writeln(question.stem)
      ..write(choices.join('\n'))
      ..writeln()
      ..writeln(
        'The app has marked this question. The correct answer is '
        '$keyedLetter) $keyedText',
      );
    final why = (explanation ?? question.explanation).trim();
    if (why.isNotEmpty) {
      buffer.writeln('The explanation this app already gives:');
      buffer.writeln(why);
    }
    if (candidateAnswer != null && candidateAnswer.isNotEmpty) {
      buffer.writeln('The student answered: $candidateAnswer');
    }
    buffer
      ..writeln(
        'Teach the marked answer in under 130 words. Start straight in with the '
        'explanation: what the question is really asking, then the working '
        'step by step, then the mistake that leads to the answer the student '
        'gave. Do not open with the answer letter, and do not write tags or '
        'headings.',
      )
      ..writeln(
        'Do not say it is wrong. Only if your own working really reaches a '
        'different option, finish with one line of this form and nothing after '
        'it: I GET: <that option text>',
      )
      ..writeln('<|im_end|>')
      ..write('<|im_start|>assistant');
    return buffer.toString();
  }

  /// Builds the completion prompt for a whole lesson.
  ///
  /// A lesson is a theme rather than an item: there is no key to ground the model
  /// on, so the prompt hands it the lesson's own hook, headings and rules and asks
  /// it to say the same thing another way. It is told not to add facts the lesson
  /// does not contain, because the written lesson is the audited text and the
  /// model's version is a second voice for it, not a second source.
  static String forLesson(
    Lesson lesson, {
    TutorLanguage language = TutorLanguage.english,
  }) {
    // Kept deliberately short. The first version fed the model four full
    // sections and five rules - well over a thousand tokens - and it answered
    // with an end-of-turn token and nothing else. On a 2 B model the lesson's
    // shape is enough to talk from; the whole body is not.
    final buffer = StringBuffer()
      ..writeln('<|im_start|>system')
      ..writeln(
        'You are an ASVAB study coach. The app has already written the lesson '
        'below and it is correct. Explain it another way, in plain words, for a '
        'student who did not follow the written version. Do not contradict it.',
      )
      ..writeln(_languageLine[language] ?? '')
      ..writeln('<|im_end|>')
      ..writeln('<|im_start|>user')
      ..writeln('Lesson: ${lesson.title} (${lesson.subtest.label}).')
      ..writeln('Opening idea: ${lesson.hook}')
      ..writeln('Why it matters: ${lesson.whyItMatters}');
    for (final section in lesson.sections.take(3)) {
      buffer.writeln('Section: ${section.heading}');
    }
    for (final rule in lesson.quickRules.take(3)) {
      buffer.writeln('Rule: $rule');
    }
    // The instruction is a task line and then a cue, never a sentence that runs
    // into the end of the prompt. Asked in Spanish with the brief last, the model
    // parroted the brief back - "En menos de 120 palabras, como un profesor
    // hablando con un estudiante: la idea en..." - which is words in an answer
    // that was supposed to be the explanation.
    buffer
      ..writeln(
        'Task: explain the lesson above in your own words, as a teacher talking '
        'to one student, in under 120 words. Cover the idea in plain words, one '
        'worked step, and the mistake people make. Write plain prose - no '
        'markdown, no asterisks, no headings - and never repeat these '
        'instructions.',
      )
      ..writeln('Explanation:')
      ..writeln('<|im_end|>')
      ..write('<|im_start|>assistant');
    return buffer.toString();
  }

  /// The option the model named, if it named one.
  ///
  /// Kept for a model that volunteers its own choice; the grounded prompt puts
  /// the answer in front of it, so this is the exception rather than the rule.
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
    return _match(said, choices);
  }

  /// The option the model's own working reached, when it disagrees with the
  /// marked one. Shown as a warning, never as an answer.
  static TutorChoice? readOwnAnswer(String answer, List<String> choices) {
    final line = RegExp(
      r'^\s*I\s+GET\s*:\s*(.+)$',
      multiLine: true,
      caseSensitive: false,
    ).allMatches(answer);
    if (line.isEmpty) return null;
    return _match(line.last.group(1), choices);
  }

  static TutorChoice? _match(String? said, List<String> choices) {
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
      final index = letter.group(1)!.toUpperCase().codeUnitAt(0) - 65;
      if (index >= 0 && index < choices.length) {
        return TutorChoice(index: index, said: said);
      }
    }
    return null;
  }

  /// The answer with any trailing marker line and stop tokens removed, which is
  /// what the sheet shows.
  ///
  /// A reasoning model opens with a think block. On the phone it wrote an empty
  /// one - `<think></think>` in front of the answer - and the sheet drew the tags
  /// as if they were words. The block is the model's working, not the
  /// explanation the student asked for, so it is dropped whole.
  static String body(String answer) {
    var text = answer
        .replaceAll(
          RegExp(r'<think>[\s\S]*?</think>', caseSensitive: false),
          '',
        )
        .replaceAll(RegExp(r'</?think>', caseSensitive: false), '')
        .replaceAll(RegExp(r'<\|[^>]*\|>'), '');
    final marker = RegExp(
      r'^\s*(?:CHOICE|I\s+GET)\s*:.*$',
      multiLine: true,
      caseSensitive: false,
    ).firstMatch(text);
    if (marker != null) text = text.substring(0, marker.start);
    // A 2 B model reaches for markdown even when it is told not to. The phone
    // drew "**Idea en palabras sencillas:**" as if the asterisks were words, and
    // the read-aloud voice then said "asterisk asterisk". Emphasis markers,
    // heading hashes and backticks are punctuation the reader does not want;
    // bullet stars are dropped too, because the sheet draws its own lists.
    text = text
        .replaceAll(RegExp(r'\*\*|__|`'), '')
        .replaceAll(RegExp(r'^\s{0,3}#{1,6}\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^\s{0,3}\*\s+', multiLine: true), '');
    // A stray marker on the same line as prose, which is how a tired model
    // writes it, leaves the sentence that came before it.
    text = text.replaceAll(
      RegExp(
        r'\s*(?:CHOICE|I\s+GET)\s*:.*$',
        multiLine: true,
        caseSensitive: false,
      ),
      '',
    );
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
