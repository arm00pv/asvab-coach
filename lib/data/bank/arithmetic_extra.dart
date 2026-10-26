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
    choiceNotes: <String>[
      'Averaging 40 and 60 gives 50, which weights the fast leg as heavily as the slow one.',
      'The trip is 240 miles in 3 + 2 = 5 hours, so the average speed is 240 / 5 = 48 miles per hour.',
      'Weighting the slow leg three times as heavily as the fast one gives 45, but both legs cover 120 miles.',
      'Giving the 60 mile per hour leg half again the weight of the slower one gives 52, the opposite bias.',
    ],
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
    choiceNotes: <String>[
      'Averaging the two pump times gives 9 hours, which is slower than the faster pump working alone.',
      'Adding the times gives 18, as though the pumps emptied the sump one after the other.',
      'Keeping the faster pump 6 hour time ignores that the second pump also removes water.',
      'Rates add: 1/6 + 1/12 = 1/4 of the sump per hour, so both pumps finish the job in 4 hours.',
    ],
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
    choiceNotes: <String>[
      'Averaging the speeds to 50 and multiplying by 5 hours gives 250, ignoring how long each leg lasted.',
      'Swapping the legs, 3 hours at 45 and 2 hours at 55, gives 245 miles, a swapped-rate slip.',
      'Each leg separately: 45 x 2 = 90 and 55 x 3 = 165, for 255 miles in total.',
      'Averaging the two speeds to 53 and multiplying by 5 hours gives 265, a halfway guess between rates.',
    ],
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
    choiceNotes: <String>[
      '15 gallons is only the full-load burn, so the four half-load hours are dropped.',
      '20 gallons is the fuel burned, so the option reports consumption rather than what is left.',
      'The engine burns 15 + 5 = 20 gallons, and 45 - 20 leaves 25 gallons in the tank.',
      'Charging 1.5 gallons an hour for all ten hours leaves 30, a rate that matches neither load.',
    ],
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
    choiceNotes: <String>[
      '1.5 hours closes only 30 of the 50 mile gap at the 20 mile per hour closing rate.',
      '2 hours closes 40 of the 50 mile head start, so the car is still ten miles behind.',
      'The gap is 50 miles and closes at 70 - 50 = 20 miles per hour, so 50 / 20 = 2.5 hours.',
      '3.5 hours is measured from the truck departure, an extra hour the question never asked for.',
    ],
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
    choiceNotes: <String>[
      'Taking a flat 25 percent off 32,000 gives 24,000, applying both losses to the original price.',
      '27,200 is the value after one year only, before the second year loss is applied.',
      'Losing 20 percent in one step gives 25,600, which merges the two cuts into a single decrease.',
      '32,000 x 0.85 = 27,200 and 27,200 x 0.90 = 24,480, so the two decreases compound.',
    ],
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
    choiceNotes: <String>[
      '84.00 dollars is the sale price, before the 5 percent sales tax is added at the register.',
      'After the 30 percent discount the price is 84, and 84 x 1.05 = 88.20 dollars with tax.',
      'Subtracting 30 dollars instead of 30 percent gives 90, and the sales tax is then forgotten.',
      'Taking 35 percent off in one step gives 78, folding the tax into the discount instead of adding it.',
    ],
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
    choiceNotes: <String>[
      '2,760 / 1.20 = 2,300, because the new pay is 120 percent of the old pay, not 80 percent of it.',
      'Taking 20 percent off the new figure gives 2,208, but the raise was a share of the smaller old pay.',
      'Taking a flat 10 percent off the new figure gives 2,484, a cut smaller than the raise that was given.',
      'Subtracting a rounded 230 dollars gives 2,530, guessing at the raise instead of dividing by 1.20.',
    ],
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
    choiceNotes: <String>[
      '75 dollars is one full year of interest, so the extra six months are left out of the term.',
      '2,500 x 0.03 x 1.5 = 112.50 dollars, with the 18 month term written as 1.5 years.',
      'Charging 3 percent for three full years gives 225, so the term is doubled instead of 1.5 times.',
      'Half a year at 3 percent gives 37.50, covering only a third of the eighteen month term.',
    ],
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
    choiceNotes: <String>[
      '48 is the smaller size, 4 x 12, not the larger one the item asks for.',
      'Dividing 36 by the smaller ratio term gives 63, but 36 is the difference between the two terms.',
      'Multiplying the difference 36 by the ratio gap 3 gives 108, using a difference as a multiplier.',
      '7x - 4x = 3x = 36 makes x = 12, and the large batteries number 7 x 12 = 84.',
    ],
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
    choiceNotes: <String>[
      '24 ounces is the concentrate alone, one of the four parts, not the surplus over it.',
      'Taking three eighths of 96 gives 36, splitting the sprayer into eight parts instead of four.',
      'Four parts put 72 ounces of water against 24 of concentrate, and the difference is 48 ounces.',
      '72 ounces is the water alone, the larger of the two amounts rather than the difference.',
    ],
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
    choiceNotes: <String>[
      'Nine miles takes 120 worker-days, and 120 / 10 workers = 12 days for the bigger crew.',
      'Scaling the 5 days by 9/3 gives 15, but the crew also grows from 8 to 10 workers.',
      'Halving the 15 day answer gives 7.5, effectively counting the crew increase twice.',
      'Reading the 9 miles of road as the answer gives 9, a mix-up between distance and days.',
    ],
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
    choiceNotes: <String>[
      'The canteens take 96 x 3/8 = 36 gallons, and 48 - 36 = 12 gallons remain in the trailer.',
      '36 gallons is what the squad drew out, so it answers the wrong half of the question.',
      'Halving the 36 gallon draw gives 18, a guess that the trailer gave up only half its water.',
      '24 gallons is half the trailer, adopted as the answer instead of the 36 gallon draw.',
    ],
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
    choiceNotes: <String>[
      '2 1/4 inches is the middle day reading, not the mean of three days that also include 3 3/4.',
      'Misreading the 3 3/4 day as 4 1/2 raises the total to 8 1/4, and dividing by three gives 2 3/4.',
      'In quarters the total is 6/4 + 9/4 + 15/4 = 30/4, and 7 1/2 divided by 3 is 2 1/2 inches.',
      '7 1/2 inches is the three day total, the intermediate value before the division by three.',
    ],
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
    choiceNotes: <String>[
      'Charging 55 cents for all 240 miles gives 132, ignoring the lower rate after the first 100.',
      'Charging 35 cents for all 240 miles gives 84, paying nothing at the higher first-tier rate.',
      'Multiplying the 140 post-100 miles by 0.35 as 57 instead of 49 gives 112, so the slip sits in the second tier.',
      '0.55 x 100 = 55 plus 0.35 x 140 = 49 gives 104 dollars for the 240 mile trip.',
    ],
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
    choiceNotes: <String>[
      'The volume is 3 x 2 x 1.5 = 9 cubic feet, and 9 x 7.5 = 67.5 gallons in the full tank.',
      '9 is the volume in cubic feet, so the gallon conversion was never applied.',
      'Using only the 3 by 2 base gives 6 cubic feet and 45 gallons, dropping the depth.',
      'Halving the correct total to 33.75 treats the tank as half full, which the stem never says.',
    ],
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
    choiceNotes: <String>[
      'Fencing the full 84 foot perimeter gives 504, charging for the four foot gate anyway.',
      'The perimeter is 2(24 + 18) = 84 feet, and 84 - 4 = 80 feet at 6 dollars is 480 dollars.',
      'Fencing 96 feet gives 576, as if the gate opened two gaps of four feet each.',
      '432 square feet is the area of the garden, priced as fencing when the work runs along the edges.',
    ],
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
    choiceNotes: <String>[
      '40 x 25 = 1,000 is square yards, the area before any unit conversion happens.',
      'Converting only one dimension, as if 3 feet covered the whole area, gives 3,000 square feet.',
      'In feet the floor is 120 by 75, and 120 x 75 = 9,000 square feet of flooring.',
      'Scaling the 1,000 square yards by 2.7 gives 2,700, applying a partial factor to an area.',
    ],
    explanation:
        'Convert both dimensions before multiplying: 40 yards is 120 feet and 25 yards '
        'is 75 feet, so the floor is 120 x 75 = 9,000 square feet. Multiplying '
        '40 x 25 gives 1,000 square yards, and scaling that by the linear factor 3 '
        'instead of 9 gives 3,000, the most common slip with area conversions.',
    difficulty: Difficulty.easy,
    skills: <String>['ar.geometry'],
  ),
];
