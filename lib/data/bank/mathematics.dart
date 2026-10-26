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
    choiceNotes: <String>[
      'Ignoring the exponent and computing 8 + 2 x 2 gives 12, so the squaring is dropped entirely.',
      'Subtracting to 3 inside the parentheses and then doubling gives 14, an error before the square.',
      'Parentheses give 2, squaring gives 4, doubling gives 8, and 8 + 8 = 16.',
      'Multiplying the 8 + 2 sum by 2 gives 20, attaching the factor 2 to the wrong quantity.',
    ],
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
    choiceNotes: <String>[
      'Subtracting the 3 instead of adding it gives 3, forgetting that a minus times a minus is a plus.',
      '(-3) squared is 9, 4 - 7 is -3, and 9 - (-3) = 12.',
      '9 plus 6 double counts the 3 that subtracting a negative adds, so 15 overshoots by one 3.',
      'Reading 4 - 7 as -12 instead of -3 gives 21, a mis-subtraction inside the parentheses.',
    ],
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
    choiceNotes: <String>[
      'Subtracting the exponents gives x^2, the rule for dividing powers rather than multiplying them.',
      'Multiplying powers of the same base adds the exponents, and 3 + 5 = 8 gives x^8.',
      'Multiplying 3 by 5 gives x^15, which is the rule for a power of a power like (x^3)^5.',
      'Doubling the summed exponent to 16 applies the power rule twice to a plain product.',
    ],
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
    choiceNotes: <String>[
      '48 = 16 x 3, so the square root of 48 is 4 times the square root of 3.',
      '3sqrt(6) squares back to 54, six more than the 48 under the original sign.',
      '6sqrt(2) squares back to 72, so it simplifies a number larger than 48.',
      '12sqrt(2) squares to 288, six times the value of the square root of 48.',
    ],
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
    choiceNotes: <String>[
      'Attaching a minus sign to the value 8 treats a negative exponent as a negative result.',
      '-6 comes from multiplying the base 2 by the exponent -3, mixing the two roles.',
      'Putting 6 in the denominator multiplies 2 by 3 instead of cubing the 2.',
      'A negative exponent takes the reciprocal, and 2^-3 = 1 / 2^3 = 1/8.',
    ],
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
    choiceNotes: <String>[
      'Distributing gives 3x - 12 = 2x + 5, and adding 12 to both sides makes x = 17.',
      '5 is the constant sitting on the right, grabbed as the answer instead of solving for x.',
      'Dropping a sign while moving the 12 across gives -17, which fits none of the original terms.',
      'Adding the 12 to both sides twice gives 23, counting the same constant more than once.',
    ],
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
    choiceNotes: <String>[
      'Both plus signs expand to +7x in the middle, the opposite of the -7x the expression carries.',
      'The pair -2 and -6 multiplies to 12 but adds to -8, so the middle term comes out wrong.',
      'The pair -1 and -12 multiplies to 12 but adds to -13, far from the -7 required.',
      'The numbers -3 and -4 multiply to 12 and add to -7, which is what factors this expression.',
    ],
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
    choiceNotes: <String>[
      '1 and 6 multiply to 6 but add to 7, so they solve x^2 - 7x + 6 = 0 instead.',
      'Two negative roots add to -5 in the wrong direction, giving a middle term of +5x.',
      'Rearranged to x^2 - 5x + 6 = 0, the factors (x - 2)(x - 3) make x = 2 or 3.',
      'Mixing one sign gives roots whose product is -6, but the constant here is +6.',
    ],
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
    choiceNotes: <String>[
      'Adding tops and bottoms gives 5/7, skipping the common denominator the fractions need.',
      'Using twelfths but adding 8 + 5 instead of 8 + 9 gives 13/12, which is 1 1/12.',
      'In twelfths the parts are 8/12 and 9/12, and 17/12 is 1 5/12.',
      'Summing one numerator with a denominator gives 6/7, a cross addition with no rule behind it.',
    ],
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
    choiceNotes: <String>[
      'Multiplying by the reciprocal gives 5/8 x 16/15 = 80/120, which reduces to 2/3.',
      'Flipping the wrong fraction gives 8/5 x 15/16 = 3/2, the reciprocal of the true quotient.',
      'Multiplying straight across gives 75/128, which divides nothing by anything.',
      '1 1/2 is 3/2 written as a mixed number, carrying the same flipped-fraction error as its twin.',
    ],
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
    choiceNotes: <String>[
      'Setting the decimal three places too far left gives 0.01, one place short of the product.',
      '4 x 25 = 100 with three decimal places is 0.100, which is the 0.1 asked for.',
      'Adding 0.4 and 0.25 gives 0.65, the sum of the numbers instead of their product.',
      'Treating the 100 as a whole and ignoring the three decimal places gives 1.0.',
    ],
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
    choiceNotes: <String>[
      'Inverting the fraction to 8/3 gives 2.67, and 26.7 percent follows that flipped division.',
      '3 divided by 8 is 0.375, and calling that 3.75 percent forgets to multiply by 100.',
      'Dividing 5 by 8 gives 0.625, so 62.5 percent answers the fraction 5/8 rather than 3/8.',
      '3 divided by 8 is 0.375, and moving the decimal two places makes it 37.5 percent.',
    ],
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
    choiceNotes: <String>[
      '72 degrees is the smaller angle, the 2x share, not the 3x share the question asks for.',
      'Parts total 5x = 180, so x = 36 and the larger angle is 3 x 36 = 108 degrees.',
      '90 degrees would leave the other angle at 90, breaking the 2 to 3 ratio the pair is in.',
      '2x and 3x with x = 40 sums to 200 degrees, so 120 cannot be half of 180.',
    ],
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
    choiceNotes: <String>[
      '45 degrees is the smallest of the three angles, the 3x share rather than the 5x one.',
      '60 degrees is the middle angle, which the question never asks for.',
      'The ratio parts total 12x = 180, so x = 15 and the largest angle is 5 x 15 = 75 degrees.',
      'Assuming a right triangle gives 90, but the ratio 3 to 4 to 5 leaves 75 as the largest angle.',
    ],
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
    choiceNotes: <String>[
      '13 belongs to a 5-12-13 triangle, whose legs are 5 and 12 rather than 9 and 12.',
      '81 + 144 = 225, and the square root of 225 is 15, the 3-4-5 triangle scaled by three.',
      'Adding the legs 9 + 12 gives 21, but the hypotenuse is a square root, not a sum.',
      '25 squared is 625, far beyond the 225 the legs give, so the root was rounded up wrongly.',
    ],
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
    choiceNotes: <String>[
      '14pi is 2 pi r, the circumference of the circle, not the area inside it.',
      '21pi multiplies the radius by 3, an area formula that never uses the square.',
      'Area is pi r^2, and 7 squared is 49, so the area is 49pi.',
      'Squaring the diameter 14 and halving it gives 98pi, a doubled version of the real area.',
    ],
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
    choiceNotes: <String>[
      'Inverting the slope gives 1/2, dividing the run by the rise instead of the rise by the run.',
      'Rise over run is (11 - 3) / (6 - 2) = 8 / 4 = 2.',
      '4 is only the run, 6 - 2, reported as though it were the slope.',
      '8 is only the rise, 11 - 3, left undivided by the run.',
    ],
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
    choiceNotes: <String>[
      'A width of 8 with a length of 10 gives 80, ignoring the 6 foot gap between the sides.',
      'Dimensions of 8 by 12 give 96, but the length is 6 more than the width, not 4 more.',
      'The width is 8 and the length 14, so the area is 8 x 14 = 112.',
      'A width of 10 and length 14 gives 140, but those sides make the perimeter 48, not 44.',
    ],
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
    choiceNotes: <String>[
      '1/12 counts a single blue marble against all twelve, but three of them are blue.',
      'There are 12 marbles in all and 3 are blue, so 3/12 reduces to 1/4.',
      '1/3 compares the three blue marbles with the nine that are not, which is odds, not probability.',
      '3/5 compares blue marbles to the five green ones, leaving the red ones out of the count.',
    ],
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
    choiceNotes: <String>[
      '17 adds only 2 to 15, as if the step shrank between the last two terms.',
      'Rounding the step down to 3 gives 18, but every term in the list rises by 4.',
      'The common difference is 4, so the next term is 15 + 4 = 19.',
      'Adding 8, or skipping one term, gives 23, which is two steps beyond 15.',
    ],
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
    choiceNotes: <String>[
      'Dividing by -2 without flipping the sign leaves x > -3, the classic inequality error.',
      'After -2x > 6, dividing by a negative flips the sign, so x < -3.',
      'Dropping the minus sign on the 3 gives x < 3, which solves 2x + 5 > 11 instead.',
      'Ignoring both the negative coefficient and the flip gives x > 3, wrong on two counts.',
    ],
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
    choiceNotes: <String>[
      '8 is 2^3, the result of dividing 2^12 by 2^9 instead of by 2^6.',
      '16 is 2^4, as if the outer cube never applied and the inner exponent survived.',
      'A power of a power gives 2^12, and 12 - 6 = 6, so 2^6 = 64.',
      'Doubling 2^6 to 2^7 gives 128, adding exponents where a quotient subtracts them.',
    ],
    explanation:
        'A power of a power multiplies exponents: (2^4)^3 = 2^12. Dividing powers '
        'subtracts them: 2^12 / 2^6 = 2^6 = 64. Treating (2^4)^3 as 2^7 and dividing gives '
        '2, which is not among the options for a reason.',
    difficulty: Difficulty.hard,
    skills: <String>['mk.exponents'],
  ),
];
