import '../models/catalog.dart';
import '../models/question.dart';

/// Arithmetic Reasoning bank: 22 items weighted toward the six skill tags the
/// reinforcement engine tracks. Every numeric answer has been checked twice.
const List<Question> arithmeticBank = <Question>[
  Question(
    id: 'ar-001',
    subtest: Subtest.ar,
    stem:
        'A cold-weather jacket is priced at 84.00 dollars and is marked down 25 percent. '
        'What is the sale price?',
    choices: <String>[
      '59.00 dollars',
      '61.00 dollars',
      '63.00 dollars',
      '67.00 dollars',
    ],
    answerIndex: 2,
    explanation:
        'Twenty-five percent of 84 is 0.25 x 84 = 21. Subtract the discount: '
        '84 - 21 = 63 dollars. Multiplying by 0.75 in one step gives the same answer. '
        'The 59 and 61 dollar options come from subtracting a rounded 25 or 30 instead '
        'of computing the discount exactly.',
    difficulty: Difficulty.easy,
    skills: <String>['ar.percent'],
  ),
  Question(
    id: 'ar-002',
    subtest: Subtest.ar,
    stem:
        'A unit spent 2,400 dollars on fuel last quarter and 3,000 dollars this quarter. '
        'What was the percent increase?',
    choices: <String>['20 percent', '25 percent', '30 percent', '17 percent'],
    answerIndex: 1,
    explanation:
        'Percent change is the change divided by the ORIGINAL amount: '
        '(3000 - 2400) / 2400 = 600 / 2400 = 0.25, or 25 percent. Dividing by the new '
        'value instead gives about 20 percent, which is exactly what the first option '
        'tempts you into.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.percent'],
  ),
  Question(
    id: 'ar-003',
    subtest: Subtest.ar,
    stem:
        'A recipe that serves 12 uses 3 cups of rice. How many cups are needed to '
        'serve 20 at the same ratio?',
    choices: <String>['4.5 cups', '5 cups', '5.5 cups', '6 cups'],
    answerIndex: 1,
    explanation:
        'Set up the proportion 3/12 = x/20. Cross multiply: 12x = 60, so x = 5 '
        'cups. Another way: 3 cups for 12 servings is 0.25 cups per serving, and '
        '20 x 0.25 = 5.',
    difficulty: Difficulty.easy,
    skills: <String>['ar.ratio'],
  ),
  Question(
    id: 'ar-004',
    subtest: Subtest.ar,
    stem:
        'Three of every eight vehicles in a convoy are trucks. If there are 120 trucks, '
        'how many vehicles are in the convoy?',
    choices: <String>['320', '300', '288', '360'],
    answerIndex: 0,
    explanation:
        'If 3/8 of the convoy is 120 vehicles, then 1/8 is 40 vehicles and the '
        'whole convoy is 8 x 40 = 320. Dividing 120 by 8 and multiplying by 3 by mistake '
        'produces 45, which is the classic inverted-ratio error.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.ratio'],
  ),
  Question(
    id: 'ar-005',
    subtest: Subtest.ar,
    stem:
        'A convoy covers 270 miles in 4.5 hours. At the same average speed, how far '
        'does it travel in 7 hours?',
    choices: <String>['390 miles', '420 miles', '405 miles', '450 miles'],
    answerIndex: 1,
    explanation:
        'The rate is 270 / 4.5 = 60 miles per hour. In 7 hours the convoy covers '
        '60 x 7 = 420 miles. Using d = rt keeps the units honest: miles divided by hours '
        'gives miles per hour.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.rate'],
  ),
  Question(
    id: 'ar-006',
    subtest: Subtest.ar,
    stem:
        'Working alone, one soldier can finish a task in 10 hours. Two soldiers working '
        'together finish it in 6 hours. How long would the second soldier take alone?',
    choices: <String>['12 hours', '15 hours', '18 hours', '20 hours'],
    answerIndex: 1,
    explanation:
        'Work rates add. The pair completes 1/6 of the task per hour and the first '
        'soldier completes 1/10 per hour, so the second completes 1/6 - 1/10 = 5/30 - 3/30 '
        '= 2/30 = 1/15 per hour. That is 15 hours for the whole task. Subtracting the '
        'times (10 - 6) is the trap that produces 4 or 12.',
    difficulty: Difficulty.hard,
    skills: <String>['ar.rate', 'ar.algebra'],
  ),
  Question(
    id: 'ar-007',
    subtest: Subtest.ar,
    stem:
        'Scores on four tests were 78, 85, 90 and 91. What score is needed on the fifth '
        'test to average 88?',
    choices: <String>['92', '94', '96', '98'],
    answerIndex: 2,
    explanation:
        'An average of 88 over five tests requires a total of 5 x 88 = 440. The '
        'first four total 78 + 85 + 90 + 91 = 344, so the fifth must be 440 - 344 = 96. '
        'The trap is finding the current average (86) and adding the difference to the '
        'target instead of scaling the total.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.average'],
  ),
  Question(
    id: 'ar-008',
    subtest: Subtest.ar,
    stem:
        'Twenty soldiers average 175 pounds and ten soldiers average 160 pounds. What is '
        'the average weight of all thirty?',
    choices: <String>['167.5 pounds', '170 pounds', '171 pounds', '168 pounds'],
    answerIndex: 1,
    explanation:
        'Work with totals, never with the two averages: 20 x 175 = 3,500 and '
        '10 x 160 = 1,600, for 5,100 pounds across 30 soldiers. 5,100 / 30 = 170 pounds. '
        'Simply averaging 175 and 160 gives 167.5, which ignores that twice as many '
        'soldiers are in the heavier group.',
    difficulty: Difficulty.hard,
    skills: <String>['ar.average'],
  ),
  Question(
    id: 'ar-009',
    subtest: Subtest.ar,
    stem:
        'A soldier spends two fifths of a monthly bonus on rent and has 450 dollars '
        'left. How large was the bonus?',
    choices: <String>[
      '750 dollars',
      '675 dollars',
      '900 dollars',
      '1,125 dollars',
    ],
    answerIndex: 0,
    explanation:
        'If two fifths went to rent, three fifths remain: (3/5)x = 450, so '
        'x = 450 x 5/3 = 750 dollars. Adding 450 to two fifths of 450 double counts and '
        'produces 675, the most common wrong answer here.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.algebra', 'ar.percent'],
  ),
  Question(
    id: 'ar-010',
    subtest: Subtest.ar,
    stem:
        'A rectangular training field is 60 feet by 40 feet. Fencing costs 7.50 dollars '
        'per foot. What is the total fence cost?',
    choices: <String>[
      '1,080 dollars',
      '1,500 dollars',
      '2,100 dollars',
      '1,800 dollars',
    ],
    answerIndex: 1,
    explanation:
        'Fencing follows the perimeter: 2(60 + 40) = 200 feet, and 200 x 7.50 = '
        '1,500 dollars. Computing the area (2,400 square feet) and multiplying by the '
        'per-foot price gives 18,000, the classic perimeter-versus-area mix-up.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.geometry'],
  ),
  Question(
    id: 'ar-011',
    subtest: Subtest.ar,
    stem: 'A soldier saves 45 dollars each month. How much is saved in 18 months?',
    choices: <String>[
      '720 dollars',
      '810 dollars',
      '855 dollars',
      '900 dollars',
    ],
    answerIndex: 1,
    explanation:
        '45 x 18 = 45 x 20 - 45 x 2 = 900 - 90 = 810 dollars. Breaking a two-digit '
        'multiplier into a round number plus an adjustment is faster and safer than long '
        'multiplication under time pressure.',
    difficulty: Difficulty.easy,
    skills: <String>['ar.rate'],
  ),
  Question(
    id: 'ar-012',
    subtest: Subtest.ar,
    stem: 'What is 15 percent of 240?',
    choices: <String>['24', '30', '36', '40'],
    answerIndex: 2,
    explanation:
        'Ten percent of 240 is 24 and five percent is 12, so fifteen percent is '
        '24 + 12 = 36. Building a percent from easy pieces beats multiplying 0.15 by 240 '
        'in your head.',
    difficulty: Difficulty.easy,
    skills: <String>['ar.percent'],
  ),
  Question(
    id: 'ar-013',
    subtest: Subtest.ar,
    stem:
        '1,200 dollars is invested at 4.5 percent simple annual interest. How much '
        'interest is earned in 2 years?',
    choices: <String>['54 dollars', '97 dollars', '108 dollars', '216 dollars'],
    answerIndex: 2,
    explanation:
        'Simple interest is I = P x r x t = 1200 x 0.045 x 2. Since 1200 x 0.045 = '
        '54 for one year, two years gives 108 dollars. Applying the rate twice '
        '(compounding by hand) yields 113, which is not what simple interest asks for.',
    difficulty: Difficulty.hard,
    skills: <String>['ar.percent'],
  ),
  Question(
    id: 'ar-014',
    subtest: Subtest.ar,
    stem:
        'Food for 30 soldiers lasts 12 days. If 6 more soldiers join, how long does the '
        'same food last?',
    choices: <String>['9 days', '10 days', '11 days', '15 days'],
    answerIndex: 1,
    explanation:
        'Total food is 30 x 12 = 360 soldier-days. With 36 soldiers, 360 / 36 = '
        '10 days. This is inverse proportion: more people means fewer days, so the answer '
        'must be less than 12. Scaling the days up (12 + 6) is the usual mistake.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.ratio', 'ar.rate'],
  ),
  Question(
    id: 'ar-015',
    subtest: Subtest.ar,
    stem:
        'A map scale is 1 inch to 25 miles. A route measures 3.5 inches on the map. How '
        'long is the actual route?',
    choices: <String>['75 miles', '80 miles', '87.5 miles', '95 miles'],
    answerIndex: 2,
    explanation:
        'Multiply by the scale: 3.5 x 25 = 87.5 miles. Splitting it as 3 x 25 = 75 '
        'plus 0.5 x 25 = 12.5 confirms the total without a calculator.',
    difficulty: Difficulty.easy,
    skills: <String>['ar.ratio'],
  ),
  Question(
    id: 'ar-016',
    subtest: Subtest.ar,
    stem:
        'A vehicle travels 3 hours 45 minutes, stops for 40 minutes, then travels 2 hours '
        '50 minutes. What is the total time from start to finish?',
    choices: <String>[
      '6 hours 35 minutes',
      '7 hours 15 minutes',
      '7 hours 5 minutes',
      '6 hours 55 minutes',
    ],
    answerIndex: 1,
    explanation:
        'Add the driving time first: 3h45m + 2h50m = 5h95m = 6h35m, then add the '
        '40 minute stop for 6h75m, which is 7 hours 15 minutes. Carrying 95 minutes into '
        'one hour and 35 minutes is the step most people skip, and forgetting the stop is '
        'the other trap.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.rate'],
  ),
  Question(
    id: 'ar-017',
    subtest: Subtest.ar,
    stem:
        'Boots cost 1,584 dollars for 24 pairs. What is the price of one pair?',
    choices: <String>['62 dollars', '64 dollars', '66 dollars', '68 dollars'],
    answerIndex: 2,
    explanation:
        'Divide 1,584 by 24. Since 24 x 60 = 1,440 and the remainder is 144, and '
        '24 x 6 = 144, one pair costs 66 dollars. Estimating with 60 first and correcting '
        'with the remainder keeps the division inside two easy steps.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.rate'],
  ),
  Question(
    id: 'ar-018',
    subtest: Subtest.ar,
    stem:
        'A unit buys 500 items at 2.20 dollars each and sells all of them at 3.25 dollars '
        'each. What is the total profit?',
    choices: <String>[
      '425 dollars',
      '500 dollars',
      '525 dollars',
      '575 dollars',
    ],
    answerIndex: 2,
    explanation:
        'Profit per item is 3.25 - 2.20 = 1.05 dollars, and 500 x 1.05 = 525 '
        'dollars. Working per unit first is far safer than computing the two total sales '
        'figures and subtracting them.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.algebra', 'ar.percent'],
  ),
  Question(
    id: 'ar-019',
    subtest: Subtest.ar,
    stem:
        'Two angles are complementary. One measures 3x degrees and the other 2x degrees. '
        'What is the measure of the larger angle?',
    choices: <String>['36 degrees', '45 degrees', '54 degrees', '72 degrees'],
    answerIndex: 2,
    explanation:
        'Complementary angles sum to 90 degrees, so 5x = 90 and x = 18. The angles '
        'are 54 and 36 degrees, and the larger is 54. Answering 18 or 36 reports x or the '
        'smaller angle instead of what was asked.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.geometry', 'ar.algebra'],
  ),
  Question(
    id: 'ar-020',
    subtest: Subtest.ar,
    stem:
        'A 40 foot rope is cut so that one piece is 3 times as long as the other. How long '
        'is the shorter piece?',
    choices: <String>['8 feet', '10 feet', '13 feet', '30 feet'],
    answerIndex: 1,
    explanation:
        'Call the shorter piece x, so the longer is 3x and x + 3x = 40. Then 4x = 40 '
        'and x = 10 feet. Thirty feet is the LONGER piece, the answer the question did not '
        'ask for.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.algebra', 'ar.ratio'],
  ),
  Question(
    id: 'ar-021',
    subtest: Subtest.ar,
    stem:
        'A tank holds 480 gallons and is currently 35 percent full. How many more gallons '
        'are needed to fill it?',
    choices: <String>[
      '168 gallons',
      '288 gallons',
      '312 gallons',
      '336 gallons',
    ],
    answerIndex: 2,
    explanation:
        'The tank already holds 0.35 x 480 = 168 gallons, so 480 - 168 = 312 '
        'gallons are needed. Another route: 65 percent of 480 = 312. Reporting 168 is the '
        'classic mistake of answering the amount present instead of the amount missing.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.percent'],
  ),
  Question(
    id: 'ar-022',
    subtest: Subtest.ar,
    stem:
        'A rectangular room measures 15 feet by 18 feet. Carpet costs 4 dollars per square '
        'foot. What is the cost to carpet the room?',
    choices: <String>[
      '528 dollars',
      '660 dollars',
      '1,080 dollars',
      '1,320 dollars',
    ],
    answerIndex: 2,
    explanation:
        'Carpet covers an area, so multiply the sides: 15 x 18 = 270 square feet, '
        'and 270 x 4 = 1,080 dollars. Using the perimeter of 66 feet gives 264 dollars, and '
        'doubling the area gives 2,160, neither of which matches.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.geometry'],
  ),
];
