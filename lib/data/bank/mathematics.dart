import '../models/catalog.dart';
import '../models/question.dart';

/// Mathematics Knowledge bank. Choice order is deliberately natural here;
/// the exam builder reshuffles options per session so answer position can
/// never become a shortcut.
const List<Question> mathematicsBank = <Question>[
  Question(
    id: 'mk-001',
    subtest: Subtest.mk,
    stem: 'Simplify: 8 + 2(5 - 3)^2',
    choices: <String>['12', '14', '16', '20'],
    answerIndex: 2,
    explanation:
        'Parentheses first: 5 - 3 = 2. Then the exponent: 2^2 = 4. Then multiply: '
        '2 x 4 = 8. Then add: 8 + 8 = 16. Adding 8 + 2 = 10 before squaring gives 40, and '
        'squaring before subtracting gives 72, so order of operations is the whole item.',
    difficulty: Difficulty.easy,
    skills: <String>['mk.prealgebra'],
  ),
  Question(
    id: 'mk-002',
    subtest: Subtest.mk,
    stem: 'Evaluate: (-3)^2 - (4 - 7)',
    choices: <String>['3', '12', '15', '21'],
    answerIndex: 1,
    explanation:
        '(-3)^2 = 9 because a negative squared is positive. Then 4 - 7 = -3, and '
        'subtracting a negative adds: 9 - (-3) = 9 + 3 = 12. The trap is treating (-3)^2 as '
        '-9, which produces 3.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.prealgebra'],
  ),
  Question(
    id: 'mk-003',
    subtest: Subtest.mk,
    stem: 'Which expression is equal to x^3 multiplied by x^5?',
    choices: <String>['x^2', 'x^8', 'x^15', 'x^16'],
    answerIndex: 1,
    explanation:
        'When multiplying powers of the same base you ADD the exponents: '
        '3 + 5 = 8, so the product is x^8. Multiplying the exponents gives x^15, which is '
        'what you would do for (x^3)^5, not for a product.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.exponents'],
  ),
  Question(
    id: 'mk-004',
    subtest: Subtest.mk,
    stem: 'Simplify the square root of 48.',
    choices: <String>['4sqrt(3)', '3sqrt(6)', '6sqrt(2)', '12sqrt(2)'],
    answerIndex: 0,
    explanation:
        'Factor out the largest perfect square: 48 = 16 x 3, so sqrt(48) = '
        'sqrt(16) x sqrt(3) = 4sqrt(3). The other options multiply back to 54, 72 and 288, '
        'none of which is 48.',
    difficulty: Difficulty.hard,
    skills: <String>['mk.exponents'],
  ),
  Question(
    id: 'mk-005',
    subtest: Subtest.mk,
    stem: 'What is the value of 2 to the power of negative 3?',
    choices: <String>['-8', '-6', '1/6', '1/8'],
    answerIndex: 3,
    explanation:
        'A negative exponent means reciprocal: 2^-3 = 1 / 2^3 = 1/8. The negative '
        'sign flips the fraction, it does not make the result negative, so -8 is the most '
        'common error.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.exponents'],
  ),
  Question(
    id: 'mk-006',
    subtest: Subtest.mk,
    stem: 'Solve for x: 3(x - 4) = 2x + 5',
    choices: <String>['17', '5', '-17', '23'],
    answerIndex: 0,
    explanation:
        'Distribute: 3x - 12 = 2x + 5. Subtract 2x from both sides: x - 12 = 5. '
        'Add 12: x = 17. Forgetting to distribute to both terms inside the parentheses '
        'gives 3x - 4 = 2x + 5 and the wrong answer 9.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.algebra'],
  ),
  Question(
    id: 'mk-007',
    subtest: Subtest.mk,
    stem: 'Factor x^2 - 7x + 12',
    choices: <String>[
      '(x + 3)(x + 4)',
      '(x - 2)(x - 6)',
      '(x - 1)(x - 12)',
      '(x - 3)(x - 4)',
    ],
    answerIndex: 3,
    explanation:
        'You need two numbers that multiply to +12 and add to -7: those are -3 and '
        '-4. So the factors are (x - 3)(x - 4). The pair -2 and -6 multiplies to 12 but adds '
        'to -8, which is why it fails the check.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.algebra'],
  ),
  Question(
    id: 'mk-008',
    subtest: Subtest.mk,
    stem: 'Solve x^2 = 5x - 6',
    choices: <String>['1 or 6', '-2 or -3', '2 or 3', '2 or -3'],
    answerIndex: 2,
    explanation:
        'Get everything on one side: x^2 - 5x + 6 = 0. Then factor: '
        '(x - 2)(x - 3) = 0, so x = 2 or x = 3. Never divide both sides by x here, because '
        'that silently deletes one of the two solutions.',
    difficulty: Difficulty.hard,
    skills: <String>['mk.algebra'],
  ),
  Question(
    id: 'mk-009',
    subtest: Subtest.mk,
    stem: 'What is 2/3 + 3/4?',
    choices: <String>['5/7', '1 1/12', '1 5/12', '6/7'],
    answerIndex: 2,
    explanation:
        'Use a common denominator of 12: 2/3 = 8/12 and 3/4 = 9/12, so the sum is '
        '17/12, which is 1 and 5/12. Adding tops and bottoms (5/7) is the classic fraction '
        'error.',
    difficulty: Difficulty.easy,
    skills: <String>['mk.fractions'],
  ),
  Question(
    id: 'mk-010',
    subtest: Subtest.mk,
    stem: 'What is 5/8 divided by 15/16?',
    choices: <String>['2/3', '3/2', '75/128', '1 1/2'],
    answerIndex: 0,
    explanation:
        'Dividing by a fraction is multiplying by its reciprocal: 5/8 x 16/15 = '
        '80/120 = 2/3. Multiplying straight across instead (75/128) is the usual slip, and '
        'the reciprocal direction errors give 3/2.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.fractions'],
  ),
  Question(
    id: 'mk-011',
    subtest: Subtest.mk,
    stem: 'What is the product of 0.4 and 0.25?',
    choices: <String>['0.01', '0.1', '0.65', '1.0'],
    answerIndex: 1,
    explanation:
        'Multiply the digits: 4 x 25 = 100. There are three decimal places in '
        'total (one in 0.4, two in 0.25), so 100 with three places is 0.100, which is 0.1. '
        'Adding the numbers instead of multiplying gives 0.65.',
    difficulty: Difficulty.easy,
    skills: <String>['mk.fractions'],
  ),
  Question(
    id: 'mk-012',
    subtest: Subtest.mk,
    stem: 'Write 3/8 as a percent.',
    choices: <String>[
      '26.7 percent',
      '3.75 percent',
      '62.5 percent',
      '37.5 percent',
    ],
    answerIndex: 3,
    explanation:
        '3 divided by 8 is 0.375, and multiplying by 100 gives 37.5 percent. '
        'Reading the fraction upside down produces 62.5 percent, and forgetting to multiply '
        'by 100 produces 3.75 percent.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.fractions'],
  ),
  Question(
    id: 'mk-013',
    subtest: Subtest.mk,
    stem:
        'Two supplementary angles are in the ratio 2 to 3. What is the measure of the '
        'larger angle?',
    choices: <String>['72 degrees', '108 degrees', '90 degrees', '120 degrees'],
    answerIndex: 1,
    explanation:
        'Supplementary angles sum to 180 degrees. With parts 2x + 3x = 180, '
        '5x = 180 and x = 36, so the angles are 72 and 108. The larger is 108. Complementary '
        'angles would sum to 90, which is why 54 shows up as a distractor in similar items.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.geometry'],
  ),
  Question(
    id: 'mk-014',
    subtest: Subtest.mk,
    stem:
        'The angles of a triangle are in the ratio 3 to 4 to 5. What is the measure of the '
        'largest angle?',
    choices: <String>['45 degrees', '60 degrees', '75 degrees', '90 degrees'],
    answerIndex: 2,
    explanation:
        'Triangle angles sum to 180. With 3x + 4x + 5x = 180, 12x = 180 and x = 15, '
        'giving 45, 60 and 75 degrees, so the largest is 75. Assuming the largest must be '
        '90 ignores that a right triangle is only one of many possibilities.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.geometry'],
  ),
  Question(
    id: 'mk-015',
    subtest: Subtest.mk,
    stem:
        'A right triangle has legs of length 9 and 12. What is the length of the '
        'hypotenuse?',
    choices: <String>['13', '15', '21', '25'],
    answerIndex: 1,
    explanation:
        'The Pythagorean theorem gives 9^2 + 12^2 = 81 + 144 = 225, and the square '
        'root of 225 is 15. This 9-12-15 triangle is the 3-4-5 triangle scaled by three, a '
        'pattern worth recognising instantly.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.geometry'],
  ),
  Question(
    id: 'mk-016',
    subtest: Subtest.mk,
    stem: 'What is the area of a circle with a radius of 7?',
    choices: <String>['14pi', '21pi', '49pi', '98pi'],
    answerIndex: 2,
    explanation:
        'Area is pi times the radius squared: pi x 7 x 7 = 49pi. Using 2 x pi x r '
        'gives the CIRCUMFERENCE, 14pi, which is the most common mix-up between area and '
        'perimeter.',
    difficulty: Difficulty.easy,
    skills: <String>['mk.geometry'],
  ),
  Question(
    id: 'mk-017',
    subtest: Subtest.mk,
    stem: 'What is the slope of the line passing through (2, 3) and (6, 11)?',
    choices: <String>['1/2', '2', '4', '8'],
    answerIndex: 1,
    explanation:
        'Slope is rise over run: (11 - 3) / (6 - 2) = 8 / 4 = 2. Subtracting in the '
        'wrong order in only one coordinate flips the sign or the reciprocal, so always take '
        'the differences in the same direction for both coordinates.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.geometry'],
  ),
  Question(
    id: 'mk-018',
    subtest: Subtest.mk,
    stem:
        'A rectangle has a perimeter of 44 and its length is 6 more than its width. What is '
        'its area?',
    choices: <String>['80', '96', '112', '140'],
    answerIndex: 2,
    explanation:
        'With width w and length w + 6, the perimeter gives 2(w + w + 6) = 44, so '
        '4w + 12 = 44, w = 8 and the length is 14. The area is 8 x 14 = 112. Stopping at the '
        'perimeter and reporting 44, or mixing up the dimensions, is the usual error.',
    difficulty: Difficulty.hard,
    skills: <String>['mk.geometry', 'mk.algebra'],
  ),
  Question(
    id: 'mk-019',
    subtest: Subtest.mk,
    stem:
        'A bag holds 4 red, 3 blue and 5 green marbles. What is the probability of drawing '
        'a blue marble?',
    choices: <String>['1/12', '1/4', '1/3', '3/5'],
    answerIndex: 1,
    explanation:
        'There are 12 marbles total and 3 are blue, so the probability is 3/12 = '
        '1/4. Using only the other colours in the denominator, or comparing blue to the '
        'remaining colours (3/5), are the common mistakes.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.probability'],
  ),
  Question(
    id: 'mk-020',
    subtest: Subtest.mk,
    stem: 'What is the next term in the sequence 3, 7, 11, 15, ...?',
    choices: <String>['17', '18', '19', '23'],
    answerIndex: 2,
    explanation:
        'Each term increases by 4, so the next is 15 + 4 = 19. The rule is '
        '4n - 1 for n = 1, 2, 3, so the fifth term is 4(5) - 1 = 19. Always test a rule on '
        'two different terms before trusting it.',
    difficulty: Difficulty.easy,
    skills: <String>['mk.algebra'],
  ),
  Question(
    id: 'mk-021',
    subtest: Subtest.mk,
    stem: 'Solve the inequality -2x + 5 > 11',
    choices: <String>['x > -3', 'x < -3', 'x < 3', 'x > 3'],
    answerIndex: 1,
    explanation:
        'Subtract 5: -2x > 6. Dividing both sides by a negative number FLIPS the '
        'inequality: x < -3. Forgetting to flip gives x > -3, which is the single most '
        'common inequality error on the ASVAB.',
    difficulty: Difficulty.hard,
    skills: <String>['mk.algebra'],
  ),
  Question(
    id: 'mk-022',
    subtest: Subtest.mk,
    stem: 'Simplify (2^4)^3 divided by 2^6.',
    choices: <String>['8', '16', '64', '128'],
    answerIndex: 2,
    explanation:
        'A power of a power multiplies exponents: (2^4)^3 = 2^12. Dividing powers '
        'subtracts them: 2^12 / 2^6 = 2^6 = 64. Treating (2^4)^3 as 2^7 and dividing gives '
        '2, which is not among the options for a reason.',
    difficulty: Difficulty.hard,
    skills: <String>['mk.exponents'],
  ),
];
