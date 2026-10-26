import '../models/catalog.dart';
import '../models/question.dart';

/// Arithmetic Reasoning expansion set: 18 word problems spread across the topic
/// weights the real subtest uses (rates and work, percents, ratios, fractions in
/// context, applied geometry, averages). Every numeric answer was recomputed by
/// hand, and the distractors are the intermediate value the question does not
/// ask for.
const List<Question> arithmeticExtraBank = <Question>[
  Question(
    id: 'ar-x01',
    subtest: Subtest.ar,
    stem:
        'A truck carries a load 120 miles to a depot at an average speed of 40 miles '
        'per hour. It makes the 120 mile return trip at an average speed of 60 miles '
        'per hour. What is its average speed for the whole round trip, in miles per hour?',
    choices: <String>['50', '48', '45', '52'],
    answerIndex: 1,
    explanation:
        'Average speed is total distance divided by total time, never the average of '
        'the two speeds. The outbound leg takes 120 / 40 = 3 hours and the return leg '
        'takes 120 / 60 = 2 hours, so 240 miles are covered in 5 hours: 240 / 5 = 48 '
        'miles per hour. The 50 option is the plain average of 40 and 60, which '
        'overweights the short fast leg.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.rate', 'ar.average'],
  ),
  Question(
    id: 'ar-x02',
    subtest: Subtest.ar,
    stem:
        'One pump can empty a sump in 6 hours and a second pump can empty the same '
        'sump in 12 hours. If both pumps run at the same time, how many hours does emptying '
        'the sump take?',
    choices: <String>['9', '18', '6', '4'],
    answerIndex: 3,
    explanation:
        'Add the work rates, not the times. The first pump removes 1/6 of the water '
        'per hour and the second removes 1/12, so together they remove '
        '1/6 + 1/12 = 3/12 = 1/4 of it per hour, which is 4 hours for the whole job. '
        'Averaging the two times gives 9 hours, yet both pumps together cannot be '
        'slower than the faster one alone.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.rate'],
  ),
  Question(
    id: 'ar-x03',
    subtest: Subtest.ar,
    stem:
        'A convoy drives for 2 hours at 45 miles per hour and then for 3 hours at 55 '
        'miles per hour. How many miles does it travel in total?',
    choices: <String>['250', '245', '255', '265'],
    answerIndex: 2,
    explanation:
        'Take each leg separately: 45 x 2 = 90 miles and 55 x 3 = 165 miles, so the '
        'total is 90 + 165 = 255 miles. Multiplying the average of the two speeds, 50, '
        'by 5 hours gives 250, which is the classic error of averaging speeds that were '
        'held for different lengths of time.',
    difficulty: Difficulty.easy,
    skills: <String>['ar.rate'],
  ),
  Question(
    id: 'ar-x04',
    subtest: Subtest.ar,
    stem:
        'A generator burns 2.5 gallons of fuel an hour at full load and half that much '
        'at half load. Its tank holds 45 gallons. After 6 hours at full load and 4 '
        'hours at half load, how many gallons of fuel are left in the tank?',
    choices: <String>['15', '20', '25', '30'],
    answerIndex: 2,
    explanation:
        'Half load burns 2.5 / 2 = 1.25 gallons an hour. The full-load hours use '
        '6 x 2.5 = 15 gallons and the half-load hours use 4 x 1.25 = 5 gallons, so 20 '
        'gallons are gone and 45 - 20 = 25 gallons remain. The 20 gallon option reports '
        'the fuel burned rather than the fuel left.',
    difficulty: Difficulty.hard,
    skills: <String>['ar.rate', 'ar.algebra'],
  ),
  Question(
    id: 'ar-x05',
    subtest: Subtest.ar,
    stem:
        'A truck leaves a depot traveling 50 miles per hour. One hour later a car '
        'leaves the same depot on the same road traveling 70 miles per hour. How many '
        'hours after the car leaves will it overtake the truck?',
    choices: <String>['1.5', '2', '2.5', '3.5'],
    answerIndex: 2,
    explanation:
        'The truck has a 50 mile head start and the car closes that gap at the '
        'difference in speed, 70 - 50 = 20 miles per hour, so the catch-up takes '
        '50 / 20 = 2.5 hours. That clock starts when the car leaves. The 3.5 option is '
        'the time measured from the truck departure, an intermediate value the '
        'question did not ask for.',
    difficulty: Difficulty.hard,
    skills: <String>['ar.rate', 'ar.algebra'],
  ),
  Question(
    id: 'ar-x06',
    subtest: Subtest.ar,
    stem:
        'A patrol vehicle bought for 32,000 dollars loses 15 percent of its value in '
        'the first year. In the second year it loses 10 percent of what it was worth at '
        'the end of the first year. What is the vehicle worth after two years?',
    choices: <String>['\$24,000', '\$27,200', '\$25,600', '\$24,480'],
    answerIndex: 3,
    explanation:
        'Repeated percent decreases compound on the new value, not the original. After '
        'one year the vehicle is worth 32,000 x 0.85 = 27,200 dollars, and after the '
        'second year 27,200 x 0.90 = 24,480 dollars. Taking 25 percent off 32,000 in a '
        'single step gives 24,000, which assumes both losses came off the same '
        'starting amount.',
    difficulty: Difficulty.hard,
    skills: <String>['ar.percent'],
  ),
  Question(
    id: 'ar-x07',
    subtest: Subtest.ar,
    stem:
        'A dress uniform is listed at \$120 and is marked 30 percent off. Sales '
        'tax of 5 percent is then added to the sale price. What does the uniform cost '
        'in total?',
    choices: <String>['\$84.00', '\$88.20', '\$90.00', '\$78.00'],
    answerIndex: 1,
    explanation:
        'Apply the discount first: 120 x 0.70 = 84 dollars, and then apply the tax to '
        'that sale price: 84 x 1.05 = 88.20 dollars. Charging the tax on the original '
        '120 gives 90, the most common error here, because tax is owed only on what '
        'the buyer actually pays.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.percent'],
  ),
  Question(
    id: 'ar-x08',
    subtest: Subtest.ar,
    stem:
        'After a 20 percent pay raise, a soldier takes home \$2,760 a month. What '
        'was the monthly pay before the raise?',
    choices: <String>['\$2,300', '\$2,208', '\$2,484', '\$2,530'],
    answerIndex: 0,
    explanation:
        'The new pay is 120 percent of the old pay, so divide by 1.20 instead of '
        'subtracting 20 percent: 2,760 / 1.20 = 2,300 dollars. Taking 20 percent off '
        'the new figure gives 2,208, but the raise was a share of the smaller original '
        'amount, so that answer is too low.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.percent'],
  ),
  Question(
    id: 'ar-x09',
    subtest: Subtest.ar,
    stem:
        'A savings account pays 3 percent simple annual interest. A soldier deposits '
        '\$2,500 and leaves it untouched for 18 months. How much interest does '
        'the account earn in that time?',
    choices: <String>['\$75.00', '\$112.50', '\$225.00', '\$37.50'],
    answerIndex: 1,
    explanation:
        'Simple interest is P x r x t, and t has to be expressed in years: 18 months '
        'is 1.5 years, so 2,500 x 0.03 x 1.5 = 112.50 dollars. Using one full year '
        'gives the 75 dollar option, which answers a shorter question, and doubling '
        'the rate accounts for the 225 dollar option.',
    difficulty: Difficulty.easy,
    skills: <String>['ar.percent'],
  ),
  Question(
    id: 'ar-x10',
    subtest: Subtest.ar,
    stem:
        'A supply cage holds batteries in two sizes in the ratio 7 to 4. There are 36 '
        'more of the larger size than of the smaller size. How many large batteries '
        'are in the cage?',
    choices: <String>['48', '63', '108', '84'],
    answerIndex: 3,
    explanation:
        'Let one ratio part be x. The difference between the two sizes is '
        '7x - 4x = 3x, and that difference is 36, so x = 12 and the large batteries '
        'number 7 x 12 = 84. The 63 option comes from dividing 36 by the smaller ratio '
        'term instead of by the difference of the two terms.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.ratio', 'ar.algebra'],
  ),
  Question(
    id: 'ar-x11',
    subtest: Subtest.ar,
    stem:
        'A cleaning solution is mixed from 3 parts water and 1 part concentrate. A '
        'sprayer holds 96 ounces of the finished mixture. How many more ounces of '
        'water than of concentrate are in the sprayer?',
    choices: <String>['24', '36', '48', '72'],
    answerIndex: 2,
    explanation:
        'Four parts make up the whole sprayer, so one part is 96 / 4 = 24 ounces. That '
        'gives 72 ounces of water and 24 ounces of concentrate, and the difference is '
        '72 - 24 = 48 ounces. The 72 and 24 options are the two amounts themselves, '
        'both intermediate values.',
    difficulty: Difficulty.easy,
    skills: <String>['ar.ratio'],
  ),
  Question(
    id: 'ar-x12',
    subtest: Subtest.ar,
    stem:
        'A crew of 8 workers can pave 3 miles of road in 5 days. At the same rate, how '
        'many days will 10 workers need to pave 9 miles?',
    choices: <String>['12', '15', '7.5', '9'],
    answerIndex: 0,
    explanation:
        'Find a per-worker rate first. Paving 3 miles in 5 days with 8 workers takes '
        '40 worker-days for those 3 miles, so 9 miles takes 3 x 40 = 120 worker-days. '
        'Split those across 10 workers and the job takes 12 days. Scaling 5 days by '
        '9/3 alone gives 15, which ignores that the crew also grew.',
    difficulty: Difficulty.hard,
    skills: <String>['ar.ratio', 'ar.rate'],
  ),
  Question(
    id: 'ar-x13',
    subtest: Subtest.ar,
    stem:
        'A water trailer holds 48 gallons. A squad fills 96 canteens from the trailer, '
        'and each canteen holds 3/8 of a gallon. How many gallons remain in the '
        'trailer?',
    choices: <String>['12', '36', '18', '24'],
    answerIndex: 0,
    explanation:
        'The canteens take 96 x 3/8 = 36 gallons, since one eighth of 96 is 12 and '
        'three eighths is 3 x 12 = 36. The trailer then holds 48 - 36 = 12 gallons. '
        'The 36 gallon option reports the amount drawn out instead of the amount left.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.algebra'],
  ),
  Question(
    id: 'ar-x14',
    subtest: Subtest.ar,
    stem:
        'Rainfall over three days measured 1 1/2 inches, 2 1/4 inches and 3 3/4 inches. '
        'What was the average daily rainfall over those three days, in inches?',
    choices: <String>['2 1/4', '2 3/4', '2 1/2', '7 1/2'],
    answerIndex: 2,
    explanation:
        'Convert to quarters so the fractions add cleanly: 1 1/2 = 6/4, 2 1/4 = 9/4 '
        'and 3 3/4 = 15/4, which totals 30/4 = 7 1/2 inches. Divide that total by the '
        'three days: 7 1/2 divided by 3 is 2 1/2 inches. The 7 1/2 option is the sum, '
        'the intermediate value before the division.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.average', 'ar.algebra'],
  ),
  Question(
    id: 'ar-x15',
    subtest: Subtest.ar,
    stem:
        'A travel allowance pays \$0.55 per mile for the first 100 miles and '
        '\$0.35 per mile for every mile after that. What is the allowance for a '
        '240 mile trip?',
    choices: <String>['\$132', '\$84', '\$112', '\$104'],
    answerIndex: 3,
    explanation:
        'Split the trip at the 100 mile mark: 0.55 x 100 = 55 dollars for the first '
        'part and 0.35 x 140 = 49 dollars for the rest, for a total of 104 dollars. '
        'Paying the higher rate on all 240 miles gives 132 and the lower rate on all of '
        'it gives 84; neither single rate answers the question.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.algebra', 'ar.rate'],
  ),
  Question(
    id: 'ar-x16',
    subtest: Subtest.ar,
    stem:
        'A rectangular water tank is 3 feet long, 2 feet wide and 1.5 feet deep. One '
        'cubic foot holds 7.5 gallons. How many gallons does the full tank hold?',
    choices: <String>['67.5', '9', '45', '33.75'],
    answerIndex: 0,
    explanation:
        'Volume first: 3 x 2 x 1.5 = 9 cubic feet. Then convert the units once: '
        '9 x 7.5 = 67.5 gallons. The 9 gallon option reports cubic feet as if they '
        'were gallons, and 45 gallons comes from using only the 3 by 2 base, so the '
        'conversion step decides the item.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.geometry'],
  ),
  Question(
    id: 'ar-x17',
    subtest: Subtest.ar,
    stem:
        'A rectangular garden measures 24 feet by 18 feet and is fenced on all four '
        'sides except for a 4 foot gate. Fencing costs \$6 per foot. What is the '
        'cost of the fencing?',
    choices: <String>['\$504', '\$480', '\$576', '\$432'],
    answerIndex: 1,
    explanation:
        'The perimeter is 2(24 + 18) = 84 feet, and the 4 foot gate leaves '
        '84 - 4 = 80 feet of fence. At 6 dollars per foot the cost is '
        '80 x 6 = 480 dollars. Ignoring the gate gives 504, and charging for the 432 '
        'square feet of area buys carpet when the job is fencing.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.geometry'],
  ),
  Question(
    id: 'ar-x18',
    subtest: Subtest.ar,
    stem:
        'A warehouse floor measures 40 yards by 25 yards. Flooring is sold by the '
        'square foot. How many square feet of flooring are needed?',
    choices: <String>['1,000', '3,000', '9,000', '2,700'],
    answerIndex: 2,
    explanation:
        'Convert both dimensions before multiplying: 40 yards is 120 feet and 25 yards '
        'is 75 feet, so the floor is 120 x 75 = 9,000 square feet. Multiplying '
        '40 x 25 gives 1,000 square yards, and scaling that by the linear factor 3 '
        'instead of 9 gives 3,000, the most common slip with area conversions.',
    difficulty: Difficulty.easy,
    skills: <String>['ar.geometry'],
  ),
];
