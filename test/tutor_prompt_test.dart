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

void main() {
  group('the prompt', () {
    test(
      'asks for the working and names the option, never the letter first',
      () {
        final prompt = TutorPrompt.forQuestion(
          _question,
          order: <int>[0, 1, 2, 3],
        );
        // The measurement in docs/AI_EVAL.md: asked to open with a letter, this
        // model answered the wrong option on more than half the bank items.
        expect(prompt, contains('CHOICE: <the option text'));
        expect(prompt, isNot(contains('Answer with the letter')));
        expect(prompt, startsWith('<|im_start|>system'));
        expect(prompt, endsWith('<|im_start|>assistant'));
        expect(prompt, contains('A) 12'));
        expect(prompt, contains('C) 16'));
      },
    );

    test('offers the options in the order the screen draws them', () {
      final prompt = TutorPrompt.forQuestion(
        _question,
        order: <int>[3, 2, 1, 0],
      );
      final a = prompt.indexOf('A) 20');
      final d = prompt.indexOf('D) 12');
      expect(a, greaterThan(0));
      expect(d, greaterThan(a));
    });

    test('says what the candidate put, when they put something', () {
      final withAnswer = TutorPrompt.forQuestion(
        _question,
        order: <int>[0, 1, 2, 3],
        candidateAnswer: '14',
      );
      expect(withAnswer, contains('The student answered: 14'));
      final without = TutorPrompt.forQuestion(
        _question,
        order: <int>[0, 1, 2, 3],
      );
      expect(without, isNot(contains('The student answered')));
    });

    test('keeps the language when asked to speak Spanish', () {
      final prompt = TutorPrompt.forQuestion(
        _question,
        order: <int>[0, 1, 2, 3],
        inSpanish: true,
      );
      expect(prompt, contains('Responde en espanol'));
    });
  });

  group('reading the choice back', () {
    const options = <String>['12', '14', '16', '20'];

    test('finds the option the model named', () {
      final choice = TutorPrompt.readChoice(
        'Step by step... 8 + 8 = 16.\n\nCHOICE: 16',
        options,
      );
      expect(choice, isNotNull);
      expect(choice!.index, 2);
    });

    test('survives the quotes and full stops a model adds', () {
      final choice = TutorPrompt.readChoice('CHOICE: "16".', options);
      expect(choice?.index, 2);
    });

    test('prefers a full option text over a bare number', () {
      final choice = TutorPrompt.readChoice(
        'CHOICE: 16 because the squaring is inside the brackets',
        options,
      );
      expect(choice?.index, 2);
    });

    test('falls back to a bare letter', () {
      final choice = TutorPrompt.readChoice('CHOICE: C', options);
      expect(choice?.index, 2);
    });

    test('reads the last CHOICE line when the model repeats itself', () {
      final choice = TutorPrompt.readChoice(
        'CHOICE: 12\non reflection that was wrong\nCHOICE: 16',
        options,
      );
      expect(choice?.index, 2);
    });

    test('returns nothing when the model named no option at all', () {
      final choice = TutorPrompt.readChoice(
        'Add the two numbers together and see what you get.',
        options,
      );
      expect(choice, isNull);
    });

    test('an option with two words still matches', () {
      const words = <String>[
        'It was carrying more tonnage.',
        'A bridge had washed out in a way no map showed.',
        'It started later than planned.',
      ];
      final choice = TutorPrompt.readChoice(
        'CHOICE: A bridge had washed out in a way no map showed.',
        words,
      );
      expect(choice?.index, 1);
    });
  });

  group('the body', () {
    test('drops the CHOICE line and the stop marker', () {
      final body = TutorPrompt.body(
        'Square, multiply, add. That gives 16.\n\nCHOICE: 16<|im_end|>',
      );
      expect(body, 'Square, multiply, add. That gives 16.');
      expect(body, isNot(contains('CHOICE')));
      expect(body, isNot(contains('im_end')));
    });

    test('leaves prose alone when there is no marker', () {
      expect(TutorPrompt.body('Just words.'), 'Just words.');
    });
  });
}
