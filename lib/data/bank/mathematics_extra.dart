import '../models/catalog.dart';
import '../models/question.dart';

/// Mathematics Knowledge expansion set: 18 pure-computation items (algebra,
/// geometry, number properties, probability). Stems stay short and symbolic;
/// no item is a word problem, and every distractor is a specific algebraic slip
/// rather than a random number.
const List<Question> mathematicsExtraBank = <Question>[
  Question(
    id: 'mk-x01',
    subtest: Subtest.mk,
    stem: 'If 2x + 3y = 12 and x - y = 1, what is the value of x + y?',
    choices: <String>['2', '3', '5', '6'],
    answerIndex: 2,
    choiceNotes: <String>[
      '2 is y alone, the value found halfway through, not the sum the item asks for.',
      '3 is x alone, so the work stops one step before answering the question.',
      'With x = 3 and y = 2 from the two equations, x + y = 3 + 2 = 5.',
      'Multiplying the two values, 3 x 2 = 6, answers a product nobody asked for.',
    ],
    explanation:
        'The second equation gives x = y + 1. Substituting into the first: '
        '2(y + 1) + 3y = 12, so 5y + 2 = 12, y = 2 and x = 3. Then x + y = 5. The 2 '
        'and 3 options report one variable each, which is the usual place to stop '
        'before reading what the item actually asks for.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.algebra'],
  ),
  Question(
    id: 'mk-x02',
    subtest: Subtest.mk,
    stem: 'Factor completely: 2x^2 + 8x + 6',
    choices: <String>[
      '2(x + 1)(x + 3)',
      '2(x - 1)(x - 3)',
      '(x + 1)(x + 3)',
      '2(x + 2)(x + 4)',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'Taking out 2 leaves x^2 + 4x + 3, which factors as (x + 1)(x + 3).',
      'The minus signs expand to 2x^2 - 8x + 6, giving the wrong sign on the middle term.',
      'Dropping the common factor 2 halves the leading coefficient to x^2 instead of 2x^2.',
      '2 and 4 multiply to 8 rather than 3, so the constant term of the expansion is wrong.',
    ],
    explanation:
        'Pull out the common factor 2 first to get 2(x^2 + 4x + 3). The two numbers '
        'that multiply to 3 and add to 4 are 1 and 3, so the factors are '
        '2(x + 1)(x + 3). Dropping the 2 loses the leading coefficient, and the minus '
        'signs in the second option expand to 2x^2 - 8x + 6 instead.',
    difficulty: Difficulty.hard,
    skills: <String>['mk.algebra'],
  ),
  Question(
    id: 'mk-x03',
    subtest: Subtest.mk,
    stem: 'Simplify: (x^2 y^3)^2 divided by (x y)',
    choices: <String>['x^4 y^6', 'x^4 y^5', 'x^3 y^6', 'x^3 y^5'],
    answerIndex: 3,
    choiceNotes: <String>[
      'x^4 y^6 is the squared product before anything is divided by xy.',
      'Dividing only the y term leaves the x exponent at 4 instead of 4 - 1 = 3.',
      'Dividing only the x term leaves the y exponent at 6 instead of 6 - 1 = 5.',
      '(x^2 y^3)^2 is x^4 y^6, and dividing by xy takes one from each exponent.',
    ],
    explanation:
        'A power of a product multiplies every exponent: (x^2 y^3)^2 = x^4 y^6. '
        'Dividing subtracts the exponents: x^4 / x = x^3 and y^6 / y = y^5, so the '
        'simplified form is x^3 y^5. Dividing only the y term is what leaves the x '
        'exponent at 4 in the second option.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.exponents'],
  ),
  Question(
    id: 'mk-x04',
    subtest: Subtest.mk,
    stem: 'Solve for x: x/3 + x/4 = 7',
    choices: <String>['84', '12', '28', '24'],
    answerIndex: 1,
    choiceNotes: <String>[
      '4x + 3x = 84 is only half solved, so 84 is 7x before the division by 7.',
      'Multiplying through by 12 gives 4x + 3x = 84, so 7x = 84 and x = 12.',
      'Dividing 84 by 3, the denominator of one term, gives 28 instead of dividing by 7.',
      'Doubling the correct 12 gives 24, as if each fraction carried its own solution.',
    ],
    explanation:
        'Multiply every term by the common denominator 12: 4x + 3x = 84, so 7x = 84 '
        'and x = 12. Stopping at 84 leaves the equation half solved, and 28 is '
        '84 divided by 3, the coefficient of the wrong term.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.algebra', 'mk.fractions'],
  ),
  Question(
    id: 'mk-x05',
    subtest: Subtest.mk,
    stem: 'Solve: x^2 + 2x - 15 = 0',
    choices: <String>['5 or -3', '-5 or -3', '5 or 3', '-5 or 3'],
    answerIndex: 3,
    choiceNotes: <String>[
      'Reading (x + 5)(x - 3) as x = 5 and x = -3 flips both signs of the roots.',
      'Two negative roots would add to -8, but the middle term here is only 2x.',
      'Two positive roots expand to x^2 - 8x + 15, so the constant would carry a plus sign.',
      '(x + 5)(x - 3) = 0 gives x = -5 or x = 3, which multiply to -15 and add to 2.',
    ],
    explanation:
        'The numbers that multiply to -15 and add to 2 are 5 and -3, so '
        'x^2 + 2x - 15 = (x + 5)(x - 3) and the equation gives x = -5 or x = 3. '
        'Reading the factors themselves as the solutions flips both signs, which is '
        'how 5 or -3 appears.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.algebra'],
  ),
  Question(
    id: 'mk-x06',
    subtest: Subtest.mk,
    stem: 'Simplify: sqrt(50) + sqrt(18)',
    choices: <String>['8sqrt(2)', '2sqrt(2)', 'sqrt(68)', '4sqrt(2)'],
    answerIndex: 0,
    choiceNotes: <String>[
      'The square root of 50 is 5sqrt(2) and that of 18 is 3sqrt(2), so 5 + 3 = 8 gives 8sqrt(2).',
      'Subtracting the coefficients 5 - 3 gives 2sqrt(2), treating like radicals as a difference.',
      'Adding 50 and 18 under one sign gives sqrt(68), which is a different number entirely.',
      'Averaging the coefficients 5 and 3 gives 4sqrt(2), halving a sum that should stay whole.',
    ],
    explanation:
        'Simplify each radical first: sqrt(50) = 5sqrt(2) because 50 = 25 x 2, and '
        'sqrt(18) = 3sqrt(2) because 18 = 9 x 2. Like radicals add by their '
        'coefficients, 5 + 3 = 8, so the sum is 8sqrt(2). Adding what is under the '
        'signs gives sqrt(68), which is a different number entirely.',
    difficulty: Difficulty.hard,
    skills: <String>['mk.exponents'],
  ),
  Question(
    id: 'mk-x07',
    subtest: Subtest.mk,
    stem: 'What is the volume of a cylinder with a radius of 3 and a height of 10?',
    choices: <String>['30pi', '60pi', '90pi', '9pi'],
    answerIndex: 2,
    choiceNotes: <String>[
      'Forgetting to square the radius gives pi x 3 x 10 = 30pi, a linear radius in an area formula.',
      '60pi is 2 pi r h, the lateral surface area of the cylinder, not its volume.',
      'Volume is pi r^2 h, and pi x 9 x 10 = 90pi for this cylinder.',
      '9pi is pi r^2, the area of one circular base, before the height is applied.',
    ],
    explanation:
        'Cylinder volume is pi times the square of the radius times the height: '
        'pi x 3^2 x 10 = 90pi. Forgetting to square the radius gives 30pi, 9pi is only '
        'the area of one circular base, and 60pi is the lateral surface area rather '
        'than the volume.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.geometry'],
  ),
  Question(
    id: 'mk-x08',
    subtest: Subtest.mk,
    stem:
        'Two parallel lines are cut by a transversal. One same-side interior angle '
        'measures 65 degrees. What is the measure of the other same-side interior '
        'angle?',
    choices: <String>['65 degrees', '25 degrees', '115 degrees', '125 degrees'],
    answerIndex: 2,
    choiceNotes: <String>[
      '65 degrees is the given angle itself, which is what alternate interior pairs share.',
      'Subtracting 65 from 90 gives 25, treating supplementary angles as complementary ones.',
      'Same-side interior angles are supplementary, and 180 - 65 = 115 degrees.',
      'Subtracting 55 instead of 65 from 180 gives 125, an arithmetic slip on the given angle.',
    ],
    explanation:
        'Same-side interior angles are supplementary whenever the two lines are '
        'parallel, so they add to 180 degrees and the other one is 180 - 65 = 115. '
        'Equal measures belong to alternate interior or corresponding pairs, and 25 '
        'comes from subtracting from 90 as though the angles were complementary.',
    difficulty: Difficulty.easy,
    skills: <String>['mk.geometry'],
  ),
  Question(
    id: 'mk-x09',
    subtest: Subtest.mk,
    stem:
        'A right triangle has a hypotenuse of 17 and one leg of 8. What is the length '
        'of the other leg?',
    choices: <String>['9', '15', '25', '12'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Subtracting the given numbers, 17 - 8 = 9, skips the squares the theorem requires.',
      '289 - 64 = 225, and the square root of 225 is the 15 unit leg.',
      'Adding 17 + 8 gives 25, but the hypotenuse is already the longest side.',
      '12 belongs to a 5-12-13 triangle, whose hypotenuse is 13 rather than 17.',
    ],
    explanation:
        'With the hypotenuse alone on one side, 8^2 + b^2 = 17^2, so '
        'b^2 = 289 - 64 = 225 and b = 15. Subtracting the given numbers, 17 - 8, gives '
        '9 and adding them gives 25; neither one is a leg of this triangle.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.geometry'],
  ),
  Question(
    id: 'mk-x10',
    subtest: Subtest.mk,
    stem: 'What is the area of a triangle with a base of 14 and a height of 9?',
    choices: <String>['126', '63', '23', '31.5'],
    answerIndex: 1,
    choiceNotes: <String>[
      '14 x 9 = 126 is the parallelogram, so the half that makes it a triangle was never applied.',
      'Triangle area is half of base times height, and (14 x 9) / 2 = 63.',
      'Adding 14 and 9 gives 23, replacing the multiplication with a sum.',
      'Halving twice, as (14 x 9) / 4, gives 31.5, a quarter of the rectangle instead of a half.',
    ],
    explanation:
        'Triangle area is one half of base times height: (14 x 9) / 2 = 63. Leaving '
        'out the half gives 126, the area of the parallelogram the triangle is cut '
        'from, and 23 adds the two lengths instead of multiplying them.',
    difficulty: Difficulty.easy,
    skills: <String>['mk.geometry'],
  ),
  Question(
    id: 'mk-x11',
    subtest: Subtest.mk,
    stem: 'A circle has a circumference of 24pi. What is its area?',
    choices: <String>['24pi', '576pi', '144pi', '48pi'],
    answerIndex: 2,
    choiceNotes: <String>[
      '24pi is the circumference the stem handed over, a length rather than an area.',
      'Squaring the diameter 24 gives 576pi, but area uses the radius of 12.',
      '2 pi r = 24pi means r = 12, and pi r^2 = 144pi for the area.',
      'Doubling the 24pi to 48pi keeps a linear length where an area belongs.',
    ],
    explanation:
        'Circumference is 2 pi r, so 2 pi r = 24pi gives r = 12. The area is then '
        'pi r^2 = 144pi. The 24pi option is the circumference the item handed you, '
        'and 576pi comes from squaring 24, which is the diameter.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.geometry'],
  ),
  Question(
    id: 'mk-x12',
    subtest: Subtest.mk,
    stem: 'Evaluate: -3 + 4(6 - 8) / 2',
    choices: <String>['-1', '-11', '7', '-7'],
    answerIndex: 3,
    choiceNotes: <String>[
      'Combining -3 and 4 before multiplying gives -1, ignoring the parentheses entirely.',
      '-3 + 4(-2) = -11 drops the division by 2 that the expression carries.',
      'Dropping the minus on both the 3 and the parenthetical sign gives 7, a double sign slip.',
      'The parentheses give -2, 4 x -2 / 2 = -4, and -3 + (-4) = -7.',
    ],
    explanation:
        'Parentheses give -2, then multiplication and division run left to right: '
        '4 x -2 = -8 and -8 / 2 = -4. Finally -3 + (-4) = -7. Combining -3 and 4 '
        'before multiplying gives -1, and dropping the division gives -11.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.prealgebra'],
  ),
  Question(
    id: 'mk-x13',
    subtest: Subtest.mk,
    stem: 'What is the greatest common factor of 84 and 126?',
    choices: <String>['6', '14', '21', '42'],
    answerIndex: 3,
    choiceNotes: <String>[
      '6 divides both numbers, but it leaves factors of 7 unclaimed and is far from the greatest.',
      '14 divides both, yet each quotient still shares a factor of 3 afterwards.',
      '21 divides both, and each quotient still shares a factor of 2 that is not taken.',
      'The shared primes are 2, 3 and 7, and 2 x 3 x 7 = 42 is the greatest common factor.',
    ],
    explanation:
        'Factor both numbers: 84 = 2 x 2 x 3 x 7 and 126 = 2 x 3 x 3 x 7. The factors '
        'they share are 2, 3 and 7, so the greatest common factor is 2 x 3 x 7 = 42. '
        'The 21, 14 and 6 options are all common factors, just not the greatest one.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.prealgebra'],
  ),
  Question(
    id: 'mk-x14',
    subtest: Subtest.mk,
    stem: 'Subtract: 5 1/4 - 2 5/6',
    choices: <String>['2 5/12', '2 1/12', '3 5/12', '3 1/12'],
    answerIndex: 0,
    choiceNotes: <String>[
      'Borrowing makes the minuend 4 15/12, so 15/12 - 10/12 = 5/12 and the answer is 2 5/12.',
      'Converting 1/4 to 11/12 instead of 13/12 leaves 1/12 over a whole-number part of 2.',
      'Skipping the borrow keeps 5 - 2 = 3 as the whole number while the fractions differ by 5/12.',
      'Both slips at once give 3 1/12, with no borrow and a wrong conversion of the quarter.',
    ],
    explanation:
        'Borrow one whole from 5 1/4 and rewrite it as 4 15/12, then write 2 5/6 as '
        '2 10/12. Subtracting gives 15/12 - 10/12 = 5/12 and 4 - 2 = 2, so the answer '
        'is 2 5/12. Skipping the borrow turns the fraction difference into a negative '
        'number and pushes the other options to the wrong whole.',
    difficulty: Difficulty.hard,
    skills: <String>['mk.fractions'],
  ),
  Question(
    id: 'mk-x15',
    subtest: Subtest.mk,
    stem: 'What is 0.6 divided by 0.015?',
    choices: <String>['4', '40', '400', '0.04'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Shifting the decimals one place too few gives 4, a quotient ten times too small.',
      '600 / 15 = 40 after both decimals are shifted three places.',
      'Shifting one extra place gives 6,000 / 15 = 400, a quotient ten times too large.',
      'A quotient below 0.6 is impossible here, because dividing by 0.015 must enlarge the number.',
    ],
    explanation:
        'Shift both decimal points three places so the divisor becomes a whole '
        'number: 600 / 15 = 40. A quotient of 0.04 is impossible here, because dividing '
        'by a number smaller than 1 must make the result larger than 0.6. Slips of one '
        'decimal place give 4 or 400.',
    difficulty: Difficulty.easy,
    skills: <String>['mk.fractions'],
  ),
  Question(
    id: 'mk-x16',
    subtest: Subtest.mk,
    stem:
        'A six-sided die is rolled once and a coin is tossed once. What is the '
        'probability of rolling a 3 and getting heads?',
    choices: <String>['1/3', '1/8', '1/12', '2/3'],
    answerIndex: 2,
    choiceNotes: <String>[
      'Adding 1/6 + 1/2 gives 1/3, which treats independent events as interchangeable alternatives.',
      'Using 1/4 for the die instead of 1/6 gives 1/8, a face count the die does not have.',
      'Independent events multiply, and 1/6 x 1/2 = 1/12 covers both outcomes at once.',
      '2/3 is 1 minus the wrong sum of 1/3, so it inherits the addition error.',
    ],
    explanation:
        'The die and the coin are independent, so multiply their probabilities: '
        '1/6 x 1/2 = 1/12. Adding the two probabilities instead gives 1/3, the standard '
        'error with independent events, and 2/3 is simply 1 minus that wrong answer.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.probability'],
  ),
  Question(
    id: 'mk-x17',
    subtest: Subtest.mk,
    stem: 'In how many different orders can 4 different books be arranged on a shelf?',
    choices: <String>['4', '10', '16', '24'],
    answerIndex: 3,
    choiceNotes: <String>[
      '4 counts the books once, as though only the first place on the shelf mattered.',
      'Adding 4 + 3 + 2 + 1 gives 10, but arrangements multiply the choices rather than sum them.',
      'Squaring 4 gives 16, which would let one book occupy every place at once.',
      'The places multiply: 4 x 3 x 2 x 1 = 24 different orders.',
    ],
    explanation:
        'The first place can hold any of the 4 books, the next any of the remaining 3, '
        'and so on, so the number of orders is 4 x 3 x 2 x 1 = 24. Adding 4 + 3 + 2 + 1 '
        'gives the 10 option and squaring 4 gives 16; arrangements always multiply the '
        'number of choices.',
    difficulty: Difficulty.easy,
    skills: <String>['mk.probability'],
  ),
  Question(
    id: 'mk-x18',
    subtest: Subtest.mk,
    stem:
        'A bag holds 5 white socks and 7 black socks. Two socks are drawn without '
        'replacement. What is the probability that both are white?',
    choices: <String>['5/33', '25/144', '5/12', '10/33'],
    answerIndex: 0,
    choiceNotes: <String>[
      'The draws are 5/12 and then 4/11, and 5/12 x 4/11 = 20/132 = 5/33.',
      'Using 5/12 twice assumes the first sock goes back in the bag before the second draw.',
      '5/12 is only the first draw, so a second white sock is never required.',
      'Doubling 5/33 to 10/33 counts both draw orders when the product already does.',
    ],
    explanation:
        'The first sock is white with probability 5/12. Because it is not replaced, '
        'the second draw has only 4 white socks among 11 left, so the events multiply: '
        '5/12 x 4/11 = 20/132 = 5/33. Using 5/12 twice assumes replacement, which is '
        'how the too large 25/144 appears.',
    difficulty: Difficulty.hard,
    skills: <String>['mk.probability'],
  ),
];
