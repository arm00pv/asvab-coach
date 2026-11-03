import 'package:flutter_test/flutter_test.dart';

import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/engines/tutor_prompt.dart';

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
  });
}
