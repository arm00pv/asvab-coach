import '../models/catalog.dart';
import '../models/question.dart';

/// Arithmetic Reasoning bank: 22 items weighted toward the six skill tags the
/// reinforcement engine tracks. Every numeric answer has been checked twice.
const List<Question> arithmeticBank = <Question>[
  Question(
    id: 'ar-001',
    subtest: Subtest.ar,
    stem:
        'A cold-weather jacket is priced at \$84.00 and is marked down 25 percent. '
        'What is the sale price?',
    choices: <String>['\$59', '\$61', '\$63', '\$67'],
    answerIndex: 2,
    choiceNotes: <String>[
      'Treating 25 percent as 25 dollars off gives 59, subtracting a percent as if it were a currency amount.',
      'Taking 25 percent of a rounded 90 and subtracting 23 from 84 gives 61, so the markdown uses the wrong base.',
      'Twenty-five percent of 84 is 21, and 84 - 21 = 63, which is exactly what the markdown leaves.',
      'Dividing 84 by 1.25 to remove the markdown gives 67, but a 25 percent cut multiplies by 0.75.',
    ],
    explanation:
        'Twenty-five percent of 84 is 0.25 x 84 = 21. Subtract the discount: '
        '84 - 21 = 63 dollars. Multiplying by 0.75 in one step gives the same answer. '
        'The \$59 and \$61 options come from subtracting a rounded 25 or 30 instead '
        'of computing the discount exactly.',
    difficulty: Difficulty.easy,
    skills: <String>['ar.percent'],
  ),
  Question(
    id: 'ar-002',
    subtest: Subtest.ar,
    stem:
        'A unit spent \$2,400 on fuel last quarter and \$3,000 this quarter. '
        'What was the percent increase?',
    choices: <String>['20', '25', '30', '17'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Dividing the 600 rise by the new 3,000 gives 20, but percent change always divides by the original 2,400.',
      'A 600 rise on a 2,400 base is 600 / 2,400 = 0.25, which is the 25 percent increase.',
      'Dividing the 600 rise by 2,000 instead of the original 2,400 gives 30, an off-base denominator.',
      'Taking the rise as 500 and dividing by the new 3,000 gives 17, so both the difference and the base are wrong.',
    ],
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
    choices: <String>['4.5', '5', '5.5', '6'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Scaling 3 cups by 1.5 gives 4.5, which treats the new count as 18 servings rather than 20.',
      'Each serving takes 3/12 = 0.25 cups, and 20 x 0.25 = 5 cups keeps the ratio unchanged.',
      'Adding 2.5 cups for the eight extra servings gives 5.5, charging about 0.31 cups per serving.',
      'Doubling the 3 cups serves 24 people, so 6 overshoots a 20 serving recipe by four servings.',
    ],
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
    choiceNotes: <String>[
      'Three eighths of the convoy is 120, so one eighth is 40 and the whole convoy is 8 x 40 = 320.',
      'Reading three of every eight as 40 percent gives 120 / 0.40 = 300, a slightly fatter fraction.',
      'Reading the share as five of every twelve gives 120 / (5/12) = 288, which is more than three eighths.',
      'Multiplying 120 by 3 instead of dividing by the 3/8 fraction gives 360, the inverted-ratio slip.',
    ],
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
        'A convoy covers 270 miles in 4.5 hours. At the same average speed, how many miles '
        'does it travel in 7 hours?',
    choices: <String>['390', '420', '405', '450'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Running 6.5 hours at 60 miles per hour gives 390, so half an hour is missing from the second leg.',
      'The rate is 270 / 4.5 = 60 miles per hour, and 60 x 7 = 420 miles in seven hours.',
      'Scaling 270 by 1.5 gives 405, which treats 7 hours as exactly half again as long as 4.5 hours.',
      'Stretching the leg to 7.5 hours at 60 miles per hour gives 450, an extra half hour of travel.',
    ],
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
        'together finish it in 6 hours. How many hours would the second soldier take working alone?',
    choices: <String>['12', '15', '18', '20'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Doubling the 6 hour joint time gives 12, as if the two soldiers were identical and shared the work.',
      'The second soldier works at 1/6 - 1/10 = 1/15 of the task per hour, so the whole task takes 15 hours.',
      'Tripling the joint time gives 18, a guess that never subtracts the 1/10 rate of the first soldier.',
      'Mirroring the known 10 hour worker gives 20, as though the pair simply split the job into two halves.',
    ],
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
    choiceNotes: <String>[
      'Mis-adding the four scores as 348 instead of 344 leaves 92, four points short of the 440 total.',
      'Aiming at a 438 total instead of 5 x 88 = 440 gives 94, so the slip is two points in the required sum.',
      'Five tests at 88 need 440 points, the first four hold 344, and 440 - 344 = 96 for the fifth.',
      'Taking the 96 point gap and then adding the two point shortfall again gives 98, a double count.',
    ],
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
        'the average weight of all thirty, in pounds?',
    choices: <String>['167.5', '170', '171', '168'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Averaging the two group averages gives 167.5, ignoring that the heavier group holds twice as many soldiers.',
      'The totals are 20 x 175 = 3,500 and 10 x 160 = 1,600, and 5,100 / 30 = 170 pounds.',
      'Totalling the pounds as 5,130 instead of 5,100 gives 171, a thirty pound slip in the group totals.',
      'Treating the 20 and 10 soldier groups as nearly equal weights drags the blended average down to 168.',
    ],
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
        'A soldier spends two fifths of a monthly bonus on rent and has \$450 '
        'left. How large was the bonus?',
    choices: <String>['\$750', '\$675', '\$900', '\$1,125'],
    answerIndex: 0,
    choiceNotes: <String>[
      'Three fifths of the bonus is 450, so the bonus is 450 x 5/3 = 750 dollars.',
      'Adding two fifths of 450 to the 450 left gives 675, which double counts part of the bonus.',
      'Assuming half the bonus was left doubles 450 to 900, but three fifths remains, not one half.',
      'Multiplying 450 by 2.5 gives 1,125, inverting which share of the bonus the remainder is.',
    ],
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
        'A rectangular training field is 60 feet by 40 feet. Fencing costs \$7.50 '
        'per foot. What is the total fence cost?',
    choices: <String>['\$1,080', '\$1,500', '\$2,100', '\$1,800'],
    answerIndex: 1,
    choiceNotes: <String>[
      'A perimeter of 144 feet gives 1,080, but 2(60 + 40) is 200 feet, so the fence length is wrong.',
      'The perimeter is 2(60 + 40) = 200 feet, and 200 x 7.50 = 1,500 dollars of fencing.',
      'Counting the 40 foot sides twice gives 280 feet and 2,100 dollars, which fences more than the field.',
      'Multiplying the 2,400 square feet by 0.75 instead of 7.50 gives 1,800, a misplaced decimal on area.',
    ],
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
    stem: 'A soldier saves \$45 each month. How much is saved in 18 months?',
    choices: <String>['\$720', '\$810', '\$855', '\$900'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Multiplying by 16 months instead of 18 gives 720, two months short of the saving term.',
      '45 x 18 = 45 x 20 - 45 x 2 = 900 - 90 = 810 dollars saved over eighteen months.',
      'Subtracting only one month from 900 gives 855, so the term is being treated as nineteen months.',
      'Multiplying by a round 20 months gives 900, which adds two months of savings that never happened.',
    ],
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
    choiceNotes: <String>[
      '24 is ten percent of 240, one five percent slice short of the fifteen percent asked for.',
      'Dividing 240 by 8 gives 30, which is 12.5 percent rather than the 15 percent requested.',
      'Ten percent of 240 is 24 and five percent is 12, so 24 + 12 = 36 is fifteen percent.',
      'Dividing 240 by 6 gives 40, which is about 16.7 percent, close to but not equal to 15 percent.',
    ],
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
        '\$1,200 is invested at 4.5 percent simple annual interest. How much '
        'interest is earned in 2 years?',
    choices: <String>['\$54', '\$97', '\$108', '\$216'],
    answerIndex: 2,
    choiceNotes: <String>[
      '54 is one year of interest at 4.5 percent, so a two year term needs another 54 on top.',
      'Using 1.8 years instead of two gives about 97, a term that matches neither the year nor the loan.',
      '1200 x 0.045 = 54 a year, and simple interest over two years is 54 x 2 = 108 dollars.',
      'Doubling twice gives 216, which charges the 54 dollars a year for four years instead of two.',
    ],
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
        'Food for 30 soldiers lasts 12 days. If 6 more soldiers join, how many days does the '
        'same food last?',
    choices: <String>['9', '10', '11', '15'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Spreading the 360 soldier-days over 40 soldiers gives 9, as if ten had joined instead of six.',
      'Total food is 30 x 12 = 360 soldier-days, and 360 / 36 = 10 days for the larger group.',
      'Knocking a day off the 12 for the new soldiers gives 11, a linear guess at an inverse proportion.',
      'Adding the six new soldiers to the twelve days gives 15, treating inverse proportion as a plain sum.',
    ],
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
        'many miles long is the actual route?',
    choices: <String>['75', '80', '87.5', '95'],
    answerIndex: 2,
    choiceNotes: <String>[
      'Using only the whole 3 inches gives 75 miles, dropping the half inch the route actually measures.',
      'Rounding 3.5 inches down to 3.2 gives 80 miles, bending the scale to a round number.',
      '3.5 x 25 = 87.5 miles, and 3 x 25 = 75 plus 0.5 x 25 = 12.5 confirms the total.',
      'Treating 3.5 inches as about 3.8 gives 95 miles, overshooting a scale that is a straight multiply.',
    ],
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
    choices: <String>['6:35', '7:15', '7:05', '6:55'],
    answerIndex: 1,
    choiceNotes: <String>[
      '6 hours 35 minutes is the driving time alone, so the 40 minute stop was never added.',
      'The driving adds to 6 hours 35 minutes, and the 40 minute stop brings the total to 7:15.',
      'Rounding the 40 minute stop down to 30 minutes gives 7:05, ten minutes short of the real total.',
      'Carrying 95 minutes as 55 and skipping the stop gives 6:55, losing both an hour and a break.',
    ],
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
    stem: 'Boots cost \$1,584 for 24 pairs. What is the price of one pair?',
    choices: <String>['\$62', '\$64', '\$66', '\$68'],
    answerIndex: 2,
    choiceNotes: <String>[
      '24 x 62 = 1,488 leaves 96 dollars unassigned, so a pair costs more than 62.',
      'Charging 64 a pair gives 24 x 64 = 1,536, which is 48 dollars short of the 1,584 bill.',
      '24 x 66 = 1,584 exactly, so one pair of boots costs 66 dollars.',
      'Rounding the quotient up to 68 overshoots: 24 x 68 = 1,632, forty-eight dollars above the total.',
    ],
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
        'A unit buys 500 items at \$2.20 each and sells all of them at \$3.25 '
        'each. What is the total profit?',
    choices: <String>['\$425', '\$500', '\$525', '\$575'],
    answerIndex: 2,
    choiceNotes: <String>[
      'Using a 0.85 dollar margin instead of 1.05 gives 425, a mis-subtracted unit profit.',
      'A round dollar of profit per item gives 500, but the margin is 3.25 - 2.20 = 1.05 per item.',
      'Profit per item is 3.25 - 2.20 = 1.05, and 500 x 1.05 = 525 dollars across the whole order.',
      'Treating the margin as 1.15 per item gives 575, overstating the real 1.05 difference.',
    ],
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
        'What is the measure of the larger angle, in degrees?',
    choices: <String>['36', '45', '54', '72'],
    answerIndex: 2,
    choiceNotes: <String>[
      '36 degrees is the smaller angle, the 2x piece, which the question does not ask for.',
      'Splitting 90 degrees in half gives 45, ignoring the 3 to 2 split the two angles are in.',
      'Complementary angles sum to 90, so 5x = 90 and x = 18, making the larger angle 3 x 18 = 54.',
      'Using x = 24 gives 72, but those angles would sum to 120 degrees, not the 90 of a complement.',
    ],
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
        'A 40 foot rope is cut so that one piece is 3 times as long as the other. How many feet '
        'is the shorter piece?',
    choices: <String>['8', '10', '13', '30'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Splitting the 40 feet into five parts gives 8, but x + 3x makes four parts, not five.',
      'With x + 3x = 40, 4x = 40, so the shorter piece is 10 feet and the longer is 30.',
      '13 comes from a rounded guess at a third of 40 rather than from solving the 1 to 3 split.',
      '30 feet is the longer piece, the value the question deliberately did not ask for.',
    ],
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
    choices: <String>['168', '288', '312', '336'],
    answerIndex: 2,
    choiceNotes: <String>[
      '168 gallons is what the tank already holds, the amount present rather than the amount missing.',
      'Taking 60 percent of 480 gives 288, so rounding the 65 percent down leaves the tank short.',
      'The tank holds 168 gallons, so 480 - 168 = 312 gallons are needed, and 65 percent of 480 agrees.',
      'Subtracting 30 percent instead of 35 gives 336, assuming the tank is emptier than it is.',
    ],
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
        'A rectangular room measures 15 feet by 18 feet. Carpet costs \$4 per square '
        'foot. What is the cost to carpet the room?',
    choices: <String>['\$528', '\$660', '\$1,080', '\$1,320'],
    answerIndex: 2,
    choiceNotes: <String>[
      'Fencing twice the 66 foot perimeter at 4 dollars gives 528, which prices walls instead of a floor.',
      'Using 11 feet instead of 18 for the width gives 165 square feet and 660 dollars of carpet.',
      'The floor is 15 x 18 = 270 square feet, and 270 x 4 = 1,080 dollars to carpet it.',
      'Charging 330 square feet gives 1,320, an area that does not match a 15 by 18 room.',
    ],
    explanation:
        'Carpet covers an area, so multiply the sides: 15 x 18 = 270 square feet, '
        'and 270 x 4 = 1,080 dollars. Using the perimeter of 66 feet gives 264 dollars, and '
        'doubling the area gives 2,160, neither of which matches.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.geometry'],
  ),
];
