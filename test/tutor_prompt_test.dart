import 'package:flutter_test/flutter_test.dart';

import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/lesson.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/engines/tutor_prompt.dart';

const _lesson = Lesson(
  skillId: 'ar.percent',
  title: 'Percents without the panic',
  hook: 'One multiplication solves almost every percent item.',
  whyItMatters:
      'Percent items are the most common word problem on the section.',
  sections: <LessonSection>[
    LessonSection(
      'Translate the words, then compute',
      'Of means multiply, is means equals, more than means add.',
      bullets: <String>['Convert the percent to a decimal first.'],
    ),
  ],
  examples: <WorkedExample>[],
  quickRules: <String>['Percent change divides by the original amount.'],
  pitfalls: <String>['Dividing by the new amount instead of the old one.'],
  minutes: 4,
);

const _question = Question(
  id: 'eval-mk',
  subtest: Subtest.mk,
  stem: 'Simplify: 8 + 2(5 - 3)^2',
  choices: <String>['12', '14', '16', '20'],
  answerIndex: 2,
  explanation: 'Square first, then multiply, then add.',
  difficulty: Difficulty.medium,
  skills: <String>['mk.ops'],
);

String _prompt({
  List<int> order = const <int>[0, 1, 2, 3],
  String? candidateAnswer,
  TutorLanguage language = TutorLanguage.english,
}) => TutorPrompt.forQuestion(
  _question,
  order: order,
  keyedIndex: _question.answerIndex,
  explanation: _question.explanation,
  candidateAnswer: candidateAnswer,
  language: language,
);

void main() {
  group('the prompt is grounded in the app', () {
    test('hands the model the marked answer and the app explanation', () {
      final prompt = _prompt();
      // Left to mark the question itself the model named the wrong option on
      // more than half the bank items (docs/AI_EVAL.md); the app has the key,
      // so the tutor is told it.
      expect(prompt, contains('The correct answer is C) 16'));
      expect(prompt, contains('The explanation this app already gives:'));
      expect(prompt, contains('Square first, then multiply, then add.'));
      expect(prompt, contains('Do not say it is wrong.'));
    });

    test('the marked answer follows the order the screen draws', () {
      // Bank order is 12, 14, 16, 20; drawn reversed, 16 sits in slot B and 12
      // in slot D. The letter in the prompt has to be the letter on the screen.
      final prompt = _prompt(order: <int>[3, 2, 1, 0]);
      expect(prompt, contains('The correct answer is B) 16'));
      expect(prompt, contains('D) 12'));
      expect(prompt, contains('A) 20'));
    });

    test('asks for the working first and one readable line last', () {
      final prompt = _prompt();
      expect(prompt, contains('I GET: <that option text>'));
      expect(prompt, isNot(contains('Answer with the letter')));
      expect(prompt, startsWith('<|im_start|>system'));
      expect(prompt, endsWith('<|im_start|>assistant'));
      // On the phone the model read the last instruction, wrote the marker line
      // and stopped: ten tokens of answer and no teaching. The demand for an
      // explanation now comes before the marker, not after it.
      expect(
        prompt.indexOf('Start straight in with the explanation'),
        lessThan(prompt.indexOf('I GET: <that option text>')),
      );
    });

    test('says what the candidate put, when they put something', () {
      expect(
        _prompt(candidateAnswer: '14'),
        contains('The student answered: 14'),
      );
      expect(_prompt(), isNot(contains('The student answered')));
    });

    test(
      'keeps the option text in English when answering in another language',
      () {
        final spanish = _prompt(language: TutorLanguage.spanish);
        expect(spanish, contains('Answer in Spanish'));
        expect(spanish, contains('Keep the option texts exactly as they are'));
        expect(spanish, contains('C) 16'));
        final italian = _prompt(language: TutorLanguage.italian);
        expect(italian, contains('Answer in Italian'));
        expect(_prompt(), isNot(contains('Answer in ')));
      },
    );
  });

  group('a lesson is taught the same way', () {
    test('hands the model the lesson the app already wrote', () {
      final prompt = TutorPrompt.forLesson(_lesson);
      expect(prompt, contains('Percents without the panic'));
      expect(
        prompt,
        contains('One multiplication solves almost every percent'),
      );
      // The prompt carries the lesson's shape, not its whole body: feeding the
      // model four full sections made it answer with an end-of-turn token and
      // nothing else.
      expect(prompt, contains('Section: Translate the words, then compute'));
      expect(
        prompt,
        contains('Percent change divides by the original amount.'),
      );
      // A lesson is a theme, not an item: there is no key to check and no option
      // to disagree with, so those parts of the question prompt must be absent.
      expect(prompt, isNot(contains('The correct answer is')));
      expect(prompt, isNot(contains('I GET:')));
      expect(prompt, endsWith('<|im_start|>assistant'));
    });

    test('switches language like the question prompt does', () {
      expect(
        TutorPrompt.forLesson(_lesson, language: TutorLanguage.italian),
        contains('Answer in Italian'),
      );
    });
  });

  group('reading the model back', () {
    const options = <String>['12', '14', '16', '20'];

    test('finds the option the model named', () {
      final choice = TutorPrompt.readChoice('...\n\nCHOICE: 16', options);
      expect(choice?.index, 2);
    });

    test('survives quotes and full stops', () {
      expect(TutorPrompt.readChoice('CHOICE: "16".', options)?.index, 2);
    });

    test('falls back to a bare letter', () {
      expect(TutorPrompt.readChoice('CHOICE: c', options)?.index, 2);
    });

    test('reads the model own answer when its working disagrees', () {
      final choice = TutorPrompt.readOwnAnswer(
        'It is 14 because ...\nI GET: 14',
        options,
      );
      expect(choice?.index, 1);
    });

    test('there is no own answer when it agreed', () {
      expect(
        TutorPrompt.readOwnAnswer('All good.\nCHOICE: 16', options),
        isNull,
      );
    });
  });

  group('the body', () {
    test('drops marker lines and stop tokens', () {
      final body = TutorPrompt.body(
        'Square, multiply, add. That gives 16.\nI GET: 14<|im_end|>',
      );
      expect(body, 'Square, multiply, add. That gives 16.');
      expect(body, isNot(contains('I GET')));
      expect(body, isNot(contains('im_end')));
    });

    test('leaves prose alone when there is no marker', () {
      expect(TutorPrompt.body('Just words.'), 'Just words.');
    });

    test('drops an empty think block, which is what the phone produced', () {
      expect(
        TutorPrompt.body('<think></think>I GET: A) 5'),
        '',
        reason: 'the tags were drawn as words on the sheet',
      );
    });

    test('drops a think block and keeps the explanation after it', () {
      expect(
        TutorPrompt.body(
          '<think>add the two hydrogens</think>One calcium, two oxygens, two hydrogens.',
        ),
        'One calcium, two oxygens, two hydrogens.',
      );
    });

    test('a marker on the end of a sentence is removed with it', () {
      expect(
        TutorPrompt.body('Five atoms altogether. I GET: A) 5'),
        'Five atoms altogether.',
      );
    });
  });
}
