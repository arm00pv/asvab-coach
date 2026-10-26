import '../models/lesson.dart';

/// Reinforcement lessons for the AFQT-critical skills.
const List<Lesson> lessonsA = <Lesson>[
  Lesson(
    skillId: 'ar.percent',
    title: 'Percents without the panic',
    hook: 'One multiplication solves almost every percent item on the ASVAB.',
    whyItMatters: 'Arithmetic Reasoning is one of the four subtests that build your AFQT, and percent items are the most common word problem on it.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Translate the words, then compute',
        'Percent items are translation problems. The word of means multiply, is means equals, and more than means add. Convert the percent to a decimal first, because 25 percent is not a number you can multiply by until it becomes 0.25.',
        bullets: <String>[
          'of means multiply: 25 percent of 84 is 0.25 x 84.',
          'A discount subtracts from the original price; a markup adds to it.',
          'Percent CHANGE always divides by the ORIGINAL amount, never the new one.',
        ],
      ),
      LessonSection(
        'Build awkward percents from easy ones',
        'You get ten percent for free by shifting the decimal one place to the left. Every other friendly percent is a small sum away from it.',
        bullets: <String>[
          'Ten percent of 84 is 8.4, so five percent is 4.2, so fifteen percent is 12.6.',
          'Twenty-five percent is a quarter: halve, then halve again.',
          'Seven percent means seven per hundred, so 0.07 x 300 = 21.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A cold-weather jacket costs 84 dollars and is marked down 25 percent. What is the sale price?',
        steps: <String>[
          'Find the discount: 0.25 x 84 = 21.',
          'Subtract: 84 - 21 = 63.',
        ],
        answer: '63 dollars',
      ),
      WorkedExample(
        prompt: 'A unit spent 2,400 dollars on fuel last quarter and 3,000 dollars this quarter. What was the percent increase?',
        steps: <String>[
          'Find the change: 3,000 - 2,400 = 600.',
          'Divide by the ORIGINAL amount: 600 / 2,400 = 0.25.',
          'Convert to a percent: 0.25 becomes 25 percent.',
        ],
        answer: '25 percent',
      ),
      WorkedExample(
        prompt: 'A replacement part costs 250 dollars and the shop marks it up 12 percent. What does the part sell for?',
        steps: <String>[
          'Turn the percent into a decimal: 12 percent is 0.12.',
          'Find the markup: 0.12 x 250 = 30.',
          'A markup is added, so 250 + 30 = 280.',
        ],
        answer: '280 dollars',
      ),
    ],
    quickRules: <String>[
      'Percent means per hundred, so 37 percent is 0.37 before you touch the numbers.',
      'Percent change = change / original, never change / new.',
      'Ten percent is a decimal shift; build 15 percent as 10 plus 5.',
      'To undo a markup, divide: a 60 dollar price after a 20 percent markup started at 60 / 1.2 = 50 dollars.',
    ],
    pitfalls: <String>[
      'Dividing the change by the new value: 600 / 3,000 gives 20 percent, and 20 percent is sitting right there as a choice.',
      'Subtracting the percent as if it were a dollar amount: 84 - 25 = 59 dollars instead of 63.',
      'Answering the discount when the question asked for the price, so you report 21 dollars and walk away from a correct calculation.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: '30 dollars, having stopped once the markup was calculated.',
        why: 'The markup is not the price. A markup adds to the original, so 250 + 30 = 280 dollars, while 30 is only the amount of the increase.',
      ),
      CommonMistake(
        answer: '2,083 dollars, dividing 250 by 0.12.',
        why: 'A percent of a price multiplies, it does not divide. Division is for undoing a markup when the final price is the thing you were given.',
      ),
    ],
  ),
  Lesson(
    skillId: 'ar.ratio',
    title: 'Set the proportion, then cross multiply',
    hook: 'Every ratio item is the same two-column table with one box missing.',
    whyItMatters: 'Arithmetic Reasoning counts toward your AFQT, and ratio items hide in recipes, convoys, maps and fuel mixes where the setup decides the answer.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Two columns, matched units',
        'Write what you know as a fraction, then write the same fraction again with the unknown in the matching spot. Cups go over servings on both sides, or the proportion is already wrong.',
        bullets: <String>[
          'Match the units vertically: cups over servings stays cups over servings.',
          'Cross multiply by multiplying the diagonal you can compute, then divide by what is left.',
          'If you can see the multiplier, use it: 12 servings doubling to 24 doubles the cups too.',
        ],
      ),
      LessonSection(
        'Part to part is not part to whole',
        'A ratio of 3 to 5 describes two pieces, so the whole is 8 parts. Half of the mistakes on this skill come from using 5 as if it were the total.',
        bullets: <String>[
          'Two to three means five total parts, so each part is the total divided by five.',
          'Three of every eight is a part-to-whole statement: three parts out of eight, not three out of five.',
          'Simplify the ratio before you scale and the arithmetic gets small.',
        ],
      ),
      LessonSection(
        'Scale up by a single factor',
        'Once you know one part, the rest of the problem is multiplication. Find the per-unit value and the whole problem collapses to one line.',
        bullets: <String>[
          '3 cups for 12 servings is 0.25 cups per serving.',
          'A map scale of 1 inch to 50 miles turns 3.5 inches into 175 miles.',
          'Check the direction: more servings should mean more cups, never fewer.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A recipe that serves 12 uses 3 cups of rice. How many cups are needed to serve 20 at the same ratio?',
        steps: <String>[
          'Set the proportion 3 cups over 12 servings equals x cups over 20 servings.',
          'Cross multiply: 12x = 3 x 20 = 60.',
          'Divide: x = 60 / 12 = 5.',
        ],
        answer: '5 cups',
      ),
      WorkedExample(
        prompt: 'Three of every eight vehicles in a convoy are trucks. If there are 120 trucks, how many vehicles are in the convoy?',
        steps: <String>[
          'Write the ratio as a part-to-whole fraction: 3/8 of the convoy is trucks.',
          'If 3/8 is 120, then 1/8 is 120 / 3 = 40 vehicles.',
          'The whole convoy is 8 parts: 8 x 40 = 320.',
        ],
        answer: '320 vehicles',
      ),
      WorkedExample(
        prompt: 'A coolant mix is five parts water to three parts antifreeze. A drum holds 64 litres of the finished mix. How much water is in it?',
        steps: <String>[
          'Add the parts: 5 + 3 = 8 parts in total.',
          'One part is 64 / 8 = 8 litres.',
          'Water is five parts: 5 x 8 = 40 litres.',
        ],
        answer: '40 litres of water',
      ),
    ],
    quickRules: <String>[
      'Keep matching units in matching positions, or the proportion answers a question you were not asked.',
      'Part-to-whole: part / whole = part / whole. Part-to-part: convert to parts of the whole first.',
      'Simplify the ratio before scaling: 3 to 12 is the same problem as 1 to 4.',
      'Sanity-check the direction: a bigger group needs a bigger share.',
    ],
    pitfalls: <String>[
      'Inverting the ratio: dividing 120 by 8 and multiplying by 3 gives 45 vehicles instead of 320.',
      'Reading 2 to 3 as 2 out of 3, which splits 60 dollars into 20 and 40 instead of the correct 24 and 36.',
      'Putting servings on top on one side and cups on top on the other, which silently inverts the answer.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: '8 litres, stopping at the size of one part.',
        why: 'One part is 8 litres, but the water is five of those parts, so the answer is 5 x 8 = 40 litres.',
      ),
      CommonMistake(
        answer: '24 litres, which is the antifreeze share.',
        why: '24 litres is 3 parts, the antifreeze. The question asks for water, the 5 part of the ratio, which is 40 litres.',
      ),
    ],
  ),
  Lesson(
    skillId: 'ar.rate',
    title: 'Distance, rate, time, and the work fraction',
    hook:
        'Two formulas cover this whole skill, and both survive on units alone.',
    whyItMatters: 'Rates and combined work are the classic two-step Arithmetic Reasoning items, and that subtest feeds your AFQT directly.',
    minutes: 9,
    sections: <LessonSection>[
      LessonSection(
        'd equals r times t, three ways',
        'Memorise one line and rearrange it: distance equals rate times time. If you know distance and time you divide to get the rate. If you know distance and rate you divide to get the time.',
        bullets: <String>[
          'miles divided by hours gives miles per hour, so the units tell you which division to use.',
          'Minutes must become hours before you multiply: 30 minutes is 0.5 hours.',
          'Two legs of a trip add their distances and add their times, never their speeds.',
        ],
      ),
      LessonSection(
        'Work rates add as fractions of one job',
        'Write each worker as the fraction of the job they finish per hour. The fractions add. Then flip the total back into hours.',
        bullets: <String>[
          'A soldier who takes 10 hours finishes 1/10 of the job per hour.',
          'Together at 1/6 per hour means the whole job takes 6 hours.',
          'The unknown worker is the difference: subtract the known rate from the combined rate.',
        ],
      ),
      LessonSection(
        'Convert units before you compute',
        'Rate problems fail on units far more often than on arithmetic. Get every quantity into the same family first, then run the formula once.',
        bullets: <String>[
          '1 hour is 60 minutes, 1 mile is 5,280 feet, 1 kilometer is about 0.62 miles.',
          'Feet per second and miles per hour are different animals; pick one and convert.',
          'If the answer choices are in hours, do not leave the working in minutes.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A convoy covers 270 miles in 4.5 hours. At the same average speed, how far does it travel in 7 hours?',
        steps: <String>[
          'Find the rate: 270 / 4.5 = 60 miles per hour.',
          'Apply it: 60 x 7 = 420 miles.',
        ],
        answer: '420 miles',
      ),
      WorkedExample(
        prompt: 'Working alone, one soldier finishes a task in 10 hours. Two soldiers working together finish it in 6 hours. How long would the second soldier take alone?',
        steps: <String>[
          'Write the pair as a rate: together they finish 1/6 of the task per hour.',
          'Subtract the known soldier: 1/6 - 1/10 = 5/30 - 3/30 = 2/30 = 1/15 per hour.',
          'Flip the fraction into time: 15 hours for the whole task.',
        ],
        answer: '15 hours',
      ),
      WorkedExample(
        prompt: 'A supply truck averages 56 miles per hour over a 210 mile run. How long does the run take?',
        steps: <String>[
          'Rearrange distance equals rate times time: t = d / r.',
          'Divide: 210 / 56 = 3.75 hours.',
          'Convert the fraction of an hour: 0.75 x 60 = 45 minutes.',
        ],
        answer: '3 hours and 45 minutes',
      ),
    ],
    quickRules: <String>[
      'd = rt, r = d/t, t = d/r. Only one formula exists.',
      'Work rates add in jobs per hour; times do not add at all.',
      'For a round trip at two speeds, the average speed is total distance over total time, not the midpoint of the speeds.',
      'Convert minutes to hours by dividing by 60 before multiplying.',
    ],
    pitfalls: <String>[
      'Subtracting the times in a combined-work problem: 10 - 6 gives 4 hours instead of 15.',
      'Averaging two speeds: 120 miles at 60 mph and back at 40 mph is 240 miles in 5 hours, so 48 mph, not 50.',
      'Leaving the time in minutes, which turns the answer into a number sixty times too large.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: '3 hours and 75 minutes, reading 0.75 as minutes.',
        why: '0.75 of an hour is 45 minutes, because a minute is one sixtieth of an hour and not one hundredth.',
      ),
      CommonMistake(
        answer: '4 hours, rounding 3.75 up to a whole number.',
        why: 'Rounding the time falsifies the trip: 3.75 hours at 56 miles per hour is exactly 210 miles, while 4 hours would be 224 miles.',
      ),
    ],
  ),
  Lesson(
    skillId: 'ar.average',
    title: 'Averages are totals wearing a disguise',
    hook: 'The average is never the tool. The total is the tool.',
    whyItMatters: 'Average items appear in almost every Arithmetic Reasoning set, and AR is one of the four subtests feeding your AFQT.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Average times count equals total',
        'An average of 88 over five tests means the five scores add to 440. Write the total down and most average questions stop being average questions.',
        bullets: <String>[
          'total = average x count, and that total is the only thing you can add or subtract.',
          'Subtract the known scores from the required total to get the missing one.',
          'When a new value joins the group, the count goes up by one as well as the total.',
        ],
      ),
      LessonSection(
        'Weighted averages use totals, not averages',
        'Two groups with different sizes cannot be averaged by averaging their averages. Convert each group to a total, add the totals, then divide by the combined count.',
        bullets: <String>[
          '20 soldiers at 175 pounds is 3,500 pounds of soldier.',
          '10 soldiers at 160 pounds is 1,600 pounds.',
          'Combined: 5,100 pounds across 30 soldiers, which is 170 pounds.',
        ],
      ),
      LessonSection(
        'Read what is being averaged',
        'Some items average a speed, some average a score, some average money per person. Name the quantity in the units of the answer before you start.',
        bullets: <String>[
          'Money per person means total money divided by total people.',
          'Miles per hour over several legs means total miles divided by total hours.',
          'If the count is not stated, it is hidden in the phrase per day, per soldier or per hour.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'Scores on four tests were 78, 85, 90 and 91. What score is needed on the fifth test to average 88?',
        steps: <String>[
          'The required total for five tests is 5 x 88 = 440.',
          'The four known scores total 78 + 85 + 90 + 91 = 344.',
          'The fifth score is 440 - 344 = 96.',
        ],
        answer: '96',
      ),
      WorkedExample(
        prompt: 'Twenty soldiers average 175 pounds and ten soldiers average 160 pounds. What is the average weight of all thirty?',
        steps: <String>[
          'Convert each group to a total: 20 x 175 = 3,500 and 10 x 160 = 1,600.',
          'Add the totals and the counts: 5,100 pounds across 30 soldiers.',
          'Divide: 5,100 / 30 = 170.',
        ],
        answer: '170 pounds',
      ),
      WorkedExample(
        prompt: 'Five soldiers average 172 pounds. A sixth soldier joins the squad and the average becomes 174 pounds. How much does the sixth soldier weigh?',
        steps: <String>[
          'Old total: 5 x 172 = 860 pounds.',
          'New total: 6 x 174 = 1,044 pounds.',
          'The difference is the newcomer: 1,044 - 860 = 184 pounds.',
        ],
        answer: '184 pounds',
      ),
    ],
    quickRules: <String>[
      'average = total / count, so total = average x count. Work backwards from the total.',
      'For a target average, multiply the target by the NEW count, not the old one.',
      'Weighted average: multiply each group average by its count, add, divide by the total count.',
      'Never average two averages unless the groups are exactly the same size.',
    ],
    pitfalls: <String>[
      'Averaging the group averages: (175 + 160) / 2 = 167.5 pounds, which ignores that twice as many soldiers are in the heavier group.',
      'Finding the current average of 86 and adding the 2 point gap to reach 88 instead of the 96 that is actually required.',
      'Using the old count when a new score is added, so you divide the required total by 4 instead of 5.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer:
            '174 pounds, reporting the new average instead of the newcomer.',
        why: 'The average is a summary, not a weight. The sixth soldier adds 184 pounds, and that is what lifts the average to 174.',
      ),
      CommonMistake(
        answer: '12 pounds, reporting only the rise in the total.',
        why: 'The total rose by 12 pounds, and that rise sits on top of the average the squad already carried: 172 + 12 = 184 pounds.',
      ),
    ],
  ),
  Lesson(
    skillId: 'ar.algebra',
    title: 'Turn the sentence into an equation',
    hook: 'The variable is the unknown, and the sentence is already the equation.',
    whyItMatters: 'Word problems that need an equation are the ones most soldiers skip, and skipped items are the cheapest points to recover on an AFQT subtest.',
    minutes: 9,
    sections: <LessonSection>[
      LessonSection(
        'Name the unknown out loud',
        'Before you write a single number, say what the letter stands for. Let x be the bonus, let m be the miles. A wrong definition produces a perfect equation answering the wrong question.',
        bullets: <String>[
          'Define the thing the last sentence asks for whenever you can.',
          'If two quantities are compared, define the smaller one and build the other from it.',
          'Write the definition on your scratch paper; it costs four seconds and saves whole items.',
        ],
      ),
      LessonSection(
        'Translate word by word, in order',
        'Move through the sentence left to right and replace each phrase with a symbol. Is becomes equals, more than becomes plus, of becomes times, per becomes divide.',
        bullets: <String>[
          'A flat fee stays a number; the per-unit charge gets multiplied by the variable.',
          'Two fifths of something is (2/5)x, not 2 divided by 5x.',
          'The word left or remains means the part you still have after a subtraction.',
        ],
      ),
      LessonSection(
        'Undo the operations in reverse',
        'The flat fee was added last, so it comes off first. Then divide by the per-unit rate. Working in that order keeps every step clean.',
        bullets: <String>[
          'Subtract the constant, then divide by the coefficient.',
          'If the variable appears on both sides, collect it on one side first.',
          'Substitute your answer back into the original sentence and read it as English.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A soldier spends two fifths of a monthly bonus on rent and has 450 dollars left. How large was the bonus?',
        steps: <String>[
          'Let x be the bonus. Rent is (2/5)x, so the remainder is (3/5)x.',
          'Set (3/5)x = 450.',
          'Multiply both sides by 5/3: x = 450 x 5/3 = 750.',
        ],
        answer: '750 dollars',
      ),
      WorkedExample(
        prompt: 'A rental truck costs 45 dollars plus 0.30 dollars per mile. A soldier is billed 96 dollars. How many miles did she drive?',
        steps: <String>[
          'Let m be the miles. Build the equation 45 + 0.30m = 96.',
          'Subtract the flat fee: 0.30m = 51.',
          'Divide by the rate: m = 51 / 0.30 = 170.',
        ],
        answer: '170 miles',
      ),
      WorkedExample(
        prompt: 'A convoy has twice as many trucks as trailers, and 48 vehicles in all. How many trucks are in the convoy?',
        steps: <String>[
          'Let t be the trailers, so the trucks are 2t.',
          'Write the total: t + 2t = 48, which is 3t = 48.',
          'Solve: t = 16 trailers, so trucks are 2 x 16 = 32.',
        ],
        answer: '32 trucks',
      ),
    ],
    quickRules: <String>[
      'Define the variable before writing the equation, and define the thing the question asks for.',
      'is means equals, more than means plus, of means times, per means divide.',
      'Undo in reverse order: constants first, then coefficients.',
      'Reread the final sentence after solving; it often wants a total, not the variable.',
    ],
    pitfalls: <String>[
      'Solving for the variable and reporting it when the question asked for one part: 750 dollars when the rent was 300.',
      'Reversing the equation so the flat fee is subtracted from the rate, which produces a negative mileage.',
      'Dropping the flat fee entirely: 96 / 0.30 = 320 miles instead of 170.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: '16, solving for the trailers and stopping there.',
        why: 'The letter stood for the count you were not asked for. There are 16 trailers, so there are 2 x 16 = 32 trucks.',
      ),
      CommonMistake(
        answer: '24 trucks, splitting 48 evenly between the two kinds.',
        why: 'An even split ignores the doubling. A ratio of 2 to 1 splits 48 into 32 and 16, not into two halves.',
      ),
    ],
  ),
  Lesson(
    skillId: 'ar.geometry',
    title: 'Geometry in a story problem',
    hook: 'No diagram is coming. You have to sketch the shape from the words.',
    whyItMatters: 'Geometry items on Arithmetic Reasoning are usually one formula plus one unit decision, and AR counts toward your AFQT.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Draw the shape from the wording',
        'A fifteen second sketch prevents almost every error on this skill. A pad, a lot, a field and a floor are all rectangles; a tank and a pipe are cylinders.',
        bullets: <String>[
          'Fence, trim, border and edging ask for perimeter.',
          'Paint, carpet, tile and seed ask for area.',
          'Fill, capacity and gravel ask for volume.',
        ],
      ),
      LessonSection(
        'The three formulas you actually need',
        'Rectangles, triangles and circles cover the overwhelming majority of items. Add the cylinder volume for fill problems and you are done.',
        bullets: <String>[
          'Rectangle: area is length x width, perimeter is 2(length + width).',
          'Triangle: area is one half base x height.',
          'Circle: area is pi x radius squared, circumference is 2 x pi x radius.',
          'Cylinder: volume is pi x radius squared x height.',
        ],
      ),
      LessonSection(
        'Units decide the final answer',
        'Square feet is an area, feet is a length, cubic feet is a volume. If the units in the answer choices do not match the thing you computed, you computed the wrong thing.',
        bullets: <String>[
          'Twelve inches is one foot, so 2 feet by 3 feet is 24 by 36 inches.',
          'Tiles sold by the square foot divide the area, not the perimeter.',
          'A cost per square yard means converting square feet by dividing by 9.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A rectangular motor pool pad measures 24 feet by 15 feet. How many one-foot square tiles cover it exactly?',
        steps: <String>[
          'Tile count is an area question, so compute 24 x 15 = 360 square feet.',
          'Each tile covers one square foot, so the count equals the area.',
        ],
        answer: '360 tiles',
      ),
      WorkedExample(
        prompt: 'A circular parade ground has a diameter of 20 feet. What is its area to the nearest square foot? Use 3.14 for pi.',
        steps: <String>[
          'Halve the diameter to get the radius: 20 / 2 = 10 feet.',
          'Square the radius: 10 x 10 = 100.',
          'Multiply by pi: 3.14 x 100 = 314 square feet.',
        ],
        answer: '314 square feet',
      ),
      WorkedExample(
        prompt: 'A rectangular lot measures 36 feet by 24 feet. How many feet of fence close it in?',
        steps: <String>[
          'Fencing runs around the edge, so the quantity asked for is a perimeter.',
          'Perimeter of a rectangle is 2 x (length + width).',
          'Compute: 2 x (36 + 24) = 2 x 60 = 120 feet.',
        ],
        answer: '120 feet of fence',
      ),
    ],
    quickRules: <String>[
      'Area is squared units, perimeter is plain units, volume is cubed units.',
      'Diameter is twice the radius; halve it before you square anything.',
      'A rectangle perimeter is 2(length + width), never length x width.',
      'Convert every measurement to one unit before computing.',
    ],
    pitfalls: <String>[
      'Reporting the area when the question asked for fencing: 1,000 square feet when the answer was 130 feet of fence.',
      'Squaring the diameter: 3.14 x 400 = 1,256 square feet for a ground whose real area is 314.',
      'Adding measurements without converting: 24 inches plus 2 feet answered as 26 instead of 4 feet.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: '864 square feet, the area of the lot.',
        why: 'Area measures the surface inside; fence measures the edge. The answer is the perimeter, 2 x (36 + 24) = 120 feet.',
      ),
      CommonMistake(
        answer: '60 feet, adding the two sides once.',
        why: 'A rectangle has two of each side, so 36 + 24 = 60 has to be doubled to 120 feet.',
      ),
    ],
  ),
  Lesson(
    skillId: 'mk.prealgebra',
    title: 'Signed numbers and the order of operations',
    hook: 'No calculator, so the rules have to be reflexes rather than reminders.',
    whyItMatters: 'Mathematics Knowledge is one of the four AFQT subtests, and order of operations errors bleed points out of every section of it.',
    minutes: 7,
    sections: <LessonSection>[
      LessonSection(
        'PEMDAS, with one correction',
        'Parentheses, exponents, then multiplication and division as one rank, then addition and subtraction as one rank. Inside a rank you work left to right, which is the part most people forget.',
        bullets: <String>[
          'Parentheses first, and work from the inside out.',
          'Multiplication and division share a rank: 12 / 4 x 3 is 3 x 3 = 9, not 12 / 12 = 1.',
          'A fraction bar or a radical sign acts like parentheses around everything under it.',
        ],
      ),
      LessonSection(
        'Signs behave predictably',
        'Two signs multiplied give a positive, mixed signs give a negative, and subtracting a negative is the same as adding. Those three facts carry the whole skill.',
        bullets: <String>[
          'Negative times negative is positive: -3 x -4 = 12.',
          'Subtracting a negative adds: 7 - (-4) = 11.',
          'In -(3 squared) the minus is outside the exponent, so the answer is negative.',
        ],
      ),
      LessonSection(
        'Absolute value is a distance',
        'Bars around a number ask how far it sits from zero, so the result is never negative. It only matters when a sign is trapped inside.',
        bullets: <String>[
          'The absolute value of -8 is 8.',
          'Absolute value is applied after whatever is inside the bars is computed.',
          'The negative of an absolute value can be negative: -|8| is -8.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'Evaluate (8 - 3) squared divided by 5, plus 4.',
        steps: <String>[
          'Parentheses: 8 - 3 = 5.',
          'Exponent: 5 x 5 = 25.',
          'Divide: 25 / 5 = 5, then add 4.',
        ],
        answer: '9',
      ),
      WorkedExample(
        prompt: 'Evaluate -2 + 3 x (-4) - 6 / (-2).',
        steps: <String>[
          'Multiply: 3 x (-4) = -12.',
          'Divide: 6 / (-2) = -3.',
          'Rewrite carefully, since subtracting a negative adds: -2 - 12 + 3 = -11.',
        ],
        answer: '-11',
      ),
      WorkedExample(
        prompt: 'Evaluate -3 x (4 - 7) + (-2) squared.',
        steps: <String>[
          'Parentheses first: 4 - 7 = -3.',
          'Multiply: -3 x -3 = 9, because two negatives give a positive.',
          'Square the second term: (-2) x (-2) = 4.',
          'Add: 9 + 4 = 13.',
        ],
        answer: '13',
      ),
    ],
    quickRules: <String>[
      'Multiplication and division are one rank, so work them left to right.',
      'Negative times negative is positive; negative times positive is negative.',
      'Subtracting a negative is adding: a - (-b) = a + b.',
      'Absolute value is distance from zero and is never negative.',
    ],
    pitfalls: <String>[
      'Adding before multiplying: 3 + 4 x 6 becomes 42 instead of 27.',
      'Treating -3 squared and (-3) squared as the same, so you answer 9 where -9 is correct.',
      'Returning -8 for the absolute value of -8, which is why choices containing the raw negative exist.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: '-5, keeping a minus on the product of two negatives.',
        why: 'Negative times negative is positive, so -3 x -3 is 9, and 9 + 4 = 13.',
      ),
      CommonMistake(
        answer: '5, treating (-2) squared as -4.',
        why: 'The brackets put the minus inside the power, so (-2) x (-2) = 4. The second term adds 4, and 9 + 4 = 13.',
      ),
    ],
  ),
  Lesson(
    skillId: 'mk.fractions',
    title: 'Fractions without the denominator stall',
    hook: 'You can only add things that are the same size, so make them the same size.',
    whyItMatters: 'Mathematics Knowledge feeds your AFQT, and fraction arithmetic underlies a large share of the algebra items on that subtest.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Find a common denominator, then add numerators',
        'The denominator names the size of the pieces. Thirds and quarters are different sizes, so convert both to twelfths before you count anything.',
        bullets: <String>[
          'The least common denominator is the smallest number both denominators divide into.',
          'Multiply top and bottom by the same number; the value does not change.',
          'Add or subtract only the numerators and keep the denominator.',
        ],
      ),
      LessonSection(
        'Mixed numbers need converting or borrowing',
        'Turn every mixed number into an improper fraction, do the work, and convert back. If you subtract instead, borrow one whole as a fraction when the top fraction is smaller.',
        bullets: <String>[
          '3 1/4 becomes 13/4 because 3 x 4 + 1 = 13.',
          'Borrow as many pieces as the denominator: 1 whole is 3/3 or 4/4.',
          'Reduce the final answer by dividing top and bottom by their largest common factor.',
        ],
      ),
      LessonSection(
        'Decimals and fractions are the same number',
        'Convert whichever way makes the problem shorter. Comparing fractions is usually fastest in decimals; multiplying is usually fastest in fractions.',
        bullets: <String>[
          'To go from fraction to decimal, divide the top by the bottom.',
          'To go from decimal to fraction, count decimal places: 0.375 is 375/1000, which reduces to 3/8.',
          'To compare two fractions, cross multiply and compare the products.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'Add 2/3 and 3/4.',
        steps: <String>[
          'The least common denominator of 3 and 4 is 12.',
          'Convert both: 2/3 = 8/12 and 3/4 = 9/12.',
          'Add numerators: 8 + 9 = 17, so the sum is 17/12, or 1 5/12.',
        ],
        answer: '17/12, which is 1 5/12',
      ),
      WorkedExample(
        prompt: 'Subtract 1 2/3 from 3 1/4.',
        steps: <String>[
          'Convert to improper fractions: 3 1/4 = 13/4 and 1 2/3 = 5/3.',
          'Use the common denominator 12: 39/12 - 20/12.',
          'Subtract: 19/12, which is 1 7/12.',
        ],
        answer: '1 7/12',
      ),
      WorkedExample(
        prompt: 'Multiply 2 1/2 by 1 3/5.',
        steps: <String>[
          'Convert both mixed numbers: 2 1/2 = 5/2 and 1 3/5 = 8/5.',
          'Multiply straight across: (5 x 8) / (2 x 5) = 40/10.',
          'Reduce: 40/10 = 4.',
        ],
        answer: '4',
      ),
    ],
    quickRules: <String>[
      'Same denominators before you add or subtract, no exceptions.',
      'Multiply fractions straight across; there is no common denominator for multiplication.',
      'Any mixed number multiplied or divided must become an improper fraction first.',
      'Reduce at the end by dividing top and bottom by their largest common factor.',
    ],
    pitfalls: <String>[
      'Adding across: 1/2 + 1/3 answered as 2/5 instead of 5/6.',
      'Ignoring the sign when subtracting fractions, so 3 1/4 - 1 2/3 comes out as 2 5/12 instead of 1 7/12.',
      'Multiplying mixed numbers without converting: 1 1/2 x 2/3 answered as 2 1/3 instead of 1.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: '2 3/10, multiplying the whole numbers and the fractions separately.',
        why: 'Mixed numbers become improper fractions first, and 5/2 x 8/5 = 40/10 = 4, not 2 3/10.',
      ),
      CommonMistake(
        answer: '10/4, flipping the second fraction before multiplying.',
        why: 'Flipping is the rule for division. Multiplication goes straight across, so the answer is 40/10 = 4.',
      ),
    ],
  ),
  Lesson(
    skillId: 'mk.exponents',
    title: 'Exponent rules you can rebuild from scratch',
    hook: 'Every rule is just counting how many times the base appears.',
    whyItMatters: 'Mathematics Knowledge is an AFQT subtest, and exponent and radical items are among the most reliable points on it once the rules are automatic.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Product and quotient rules',
        'Multiplying like bases stacks copies of the base, so you add the exponents. Dividing cancels copies, so you subtract them. The base must be identical for either rule to work.',
        bullets: <String>[
          '2 cubed times 2 to the fourth is seven copies of 2, so 2 to the seventh.',
          'x to the fifth over x squared leaves x cubed.',
          'Different bases do not combine: 3 squared times 4 squared stays as it is.',
        ],
      ),
      LessonSection(
        'Powers of powers and negatives',
        'A power raised to a power repeats the whole group, so you multiply. A negative exponent means reciprocal, not a negative answer. Anything nonzero to the zero power is 1.',
        bullets: <String>[
          '(x cubed) squared is x to the sixth.',
          '2 to the negative 3 is 1 over 8, not -8.',
          'An exponent outside parentheses touches everything inside: (2x) cubed is 8x cubed.',
        ],
      ),
      LessonSection(
        'Simplify roots by hunting perfect squares',
        'Split the number under the root into the largest perfect square you can find times what is left. The square root of the perfect square comes out front.',
        bullets: <String>[
          'Perfect squares to recognise: 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144.',
          'Square root of 50 is 5 times the square root of 2, because 50 is 25 x 2.',
          'Square roots add only when the radicands are alike, exactly like fractions.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'Simplify (2 cubed x 2 to the fourth) / 2 to the fifth.',
        steps: <String>[
          'Add the exponents on top: 3 + 4 = 7, so the numerator is 2 to the seventh.',
          'Subtract the exponent on the bottom: 7 - 5 = 2.',
          'Evaluate: 2 squared = 4.',
        ],
        answer: '4',
      ),
      WorkedExample(
        prompt: 'Simplify the square root of 72.',
        steps: <String>[
          'Find the largest perfect square dividing 72: it is 36.',
          'Write 72 as 36 x 2.',
          'Take the root of each factor: the square root of 36 is 6, so the answer is 6 times the square root of 2.',
        ],
        answer: '6 times the square root of 2, about 8.49',
      ),
      WorkedExample(
        prompt: 'Simplify (2x squared) cubed.',
        steps: <String>[
          'The exponent outside the bracket applies to everything inside it.',
          'Cube the coefficient: 2 x 2 x 2 = 8.',
          'Multiply the exponents on x: 2 x 3 = 6, giving x to the sixth.',
        ],
        answer: '8x to the sixth power',
      ),
    ],
    quickRules: <String>[
      'Multiplying like bases adds exponents; dividing subtracts them.',
      'A power raised to a power multiplies the exponents.',
      'A negative exponent flips the base into the denominator; it is not a negative value.',
      'Break a root into the largest perfect square times the remainder.',
    ],
    pitfalls: <String>[
      'Multiplying exponents where you should add: 2 cubed times 2 to the fourth answered as 2 to the twelfth, which is 4,096 instead of 128.',
      'Distributing a square over addition: (x + 3) squared answered as x squared + 9 instead of x squared + 6x + 9.',
      'Reading a negative exponent as a negative answer: 2 to the negative 3 answered as -8 instead of 1/8.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: '2x to the sixth, cubing only the x.',
        why: 'The power outside the bracket reaches the coefficient too, so 2 cubed is 8 and the answer is 8x to the sixth.',
      ),
      CommonMistake(
        answer: '6x to the sixth, multiplying the coefficient by the exponent.',
        why: 'A power repeats the coefficient as a factor: 2 x 2 x 2 = 8, not 2 x 3 = 6.',
      ),
    ],
  ),
  Lesson(
    skillId: 'mk.algebra',
    title: 'Solve it, then factor it',
    hook: 'Undo the equation one operation at a time, and the algebra stops being mysterious.',
    whyItMatters: 'Mathematics Knowledge is one of the four AFQT subtests, and linear equations plus factoring make up the bulk of its algebra items.',
    minutes: 9,
    sections: <LessonSection>[
      LessonSection(
        'Isolate x by undoing operations backwards',
        'The variable has been built up by a sequence of operations. Undo them in reverse: addition and subtraction first, then multiplication and division, then exponents.',
        bullets: <String>[
          'Whatever you do to one side, do to the whole other side, every term.',
          'Collect variables on one side and numbers on the other before dividing.',
          'A coefficient stuck to a variable is multiplication, so divide it away.',
        ],
      ),
      LessonSection(
        'Systems: substitute or eliminate',
        'Two equations with two unknowns need one unknown removed. Solve one equation for a variable and substitute, or add the equations so a variable cancels.',
        bullets: <String>[
          'Substitution is fastest when one equation already has x or y alone.',
          'Elimination is fastest when one variable has matching coefficients with opposite signs.',
          'After finding one value, back-substitute to get the other.',
        ],
      ),
      LessonSection(
        'Quadratics become two binomials',
        'For x squared plus bx plus c, you need two numbers that multiply to c and add to b. Those numbers become the two constants in the parentheses.',
        bullets: <String>[
          'x squared + 5x + 6 needs numbers multiplying to 6 and adding to 5: 2 and 3.',
          'Opposite signs in the factors mean the constant c is negative.',
          'Set each factor to zero to read off the solutions, then check one in the original.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'Solve 5x - 3 = 2x + 12.',
        steps: <String>[
          'Subtract 2x from both sides: 3x - 3 = 12.',
          'Add 3 to both sides: 3x = 15.',
          'Divide by 3: x = 5.',
        ],
        answer: 'x = 5',
      ),
      WorkedExample(
        prompt: 'Solve x squared - 5x + 6 = 0.',
        steps: <String>[
          'Find two numbers that multiply to 6 and add to -5: that is -2 and -3.',
          'Factor: (x - 2)(x - 3) = 0.',
          'Set each factor to zero, then check: 4 - 10 + 6 = 0 and 9 - 15 + 6 = 0.',
        ],
        answer: 'x = 2 or x = 3',
      ),
      WorkedExample(
        prompt: 'Solve 2(x - 3) = 18 - 4x.',
        steps: <String>[
          'Distribute the 2 across the bracket: 2x - 6 = 18 - 4x.',
          'Add 4x to both sides: 6x - 6 = 18.',
          'Add 6: 6x = 24, so x = 4.',
        ],
        answer: 'x = 4',
      ),
    ],
    quickRules: <String>[
      'Undo addition and subtraction before multiplication and division.',
      'Distribute a minus sign across every term inside its parentheses.',
      'For a system, get one variable alone and substitute it into the other equation.',
      'To factor x squared + bx + c, find two numbers multiplying to c that add to b.',
    ],
    pitfalls: <String>[
      'Dividing only part of a side, so 3x + 6 = 12 becomes x + 6 = 4 instead of x = 2.',
      'Losing a sign when distributing: 5x - (x - 3) simplified to 4x - 3 instead of 4x + 3.',
      'Factoring with the wrong signs: x squared + 5x + 6 written as (x - 2)(x - 3), which actually expands to x squared - 5x + 6.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'x = 3.5, distributing the 2 only to the x.',
        why: 'The 2 multiplies both terms inside the bracket, so the equation is 2x - 6 = 18 - 4x, which gives x = 4.',
      ),
      CommonMistake(
        answer: 'x = -12, subtracting 4x from the left instead of adding it.',
        why: 'Moving a negative term across the equals sign changes its sign: 2x + 4x = 24, so x = 4.',
      ),
    ],
  ),
  Lesson(
    skillId: 'mk.geometry',
    title: 'Angles, triangles and the theorem that pays',
    hook: 'A handful of fixed numbers does most of the work on this subtest.',
    whyItMatters: 'Mathematics Knowledge builds your AFQT, and its geometry items are formula recall plus one clean substitution, which makes them fast points.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Angle rules are constant',
        'Angles on a straight line add to 180, and angles all the way around a point add to 360. Vertical angles, formed by two crossing lines, are always equal.',
        bullets: <String>[
          'Two angles that form a straight line are supplementary and total 180.',
          'Complementary angles total 90 and usually appear as the corner of a right angle.',
          'Vertical angles sit opposite each other and are equal, not supplementary.',
        ],
      ),
      LessonSection(
        'Every triangle totals 180',
        'Two known angles give you the third by subtraction. Equilateral triangles are 60, 60, 60, and the two acute angles of a right triangle always total 90.',
        bullets: <String>[
          'The largest angle faces the longest side, which catches reversed answers.',
          'An exterior angle equals the sum of the two interior angles opposite it.',
          'In a right triangle the hypotenuse is the side opposite the right angle and is always longest.',
        ],
      ),
      LessonSection(
        'Circles and the Pythagorean theorem',
        'Right triangles obey a squared plus b squared equals c squared, with c the hypotenuse. Circles run on radius, so halve any diameter before you start.',
        bullets: <String>[
          'The 3-4-5 and 6-8-10 triangles are right triangles worth recognising on sight.',
          'Circumference is 2 x pi x radius; area is pi x radius squared.',
          'Volume of a cylinder is pi x radius squared x height.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A right triangle has legs of 6 feet and 8 feet. How long is the hypotenuse?',
        steps: <String>[
          'Apply the theorem: 6 squared + 8 squared = 36 + 64 = 100.',
          'Take the square root: c = 10.',
        ],
        answer: '10 feet',
      ),
      WorkedExample(
        prompt: 'A circular running track has a radius of 35 feet. How far is one lap, using 3.14 for pi?',
        steps: <String>[
          'A lap is the circumference, so use 2 x pi x radius.',
          'Double the radius first: 2 x 35 = 70 feet across the whole circle.',
          'Multiply by pi: 3.14 x 70 = 219.8.',
        ],
        answer: '219.8 feet',
      ),
      WorkedExample(
        prompt: 'A right triangle has one leg of 9 feet and a hypotenuse of 15 feet. How long is the other leg?',
        steps: <String>[
          'The theorem says leg squared plus leg squared equals hypotenuse squared.',
          'Square what you have: 15 squared is 225 and 9 squared is 81.',
          'Subtract, because the missing side is a leg: 225 - 81 = 144.',
          'Take the root: the square root of 144 is 12.',
        ],
        answer: '12 feet',
      ),
    ],
    quickRules: <String>[
      'Straight line is 180 degrees, full turn is 360 degrees, triangle is 180 degrees.',
      'Exterior angle of a triangle equals the sum of the two opposite interior angles.',
      'a squared + b squared = c squared, and c is always the longest side.',
      'Circumference is 2 pi r, area is pi r squared, cylinder volume is pi r squared h.',
    ],
    pitfalls: <String>[
      'Using the diameter where the formula wants the radius: a 35 foot radius gives 109.9 feet per lap instead of 219.8.',
      'Adding the legs instead of squaring them: 6 + 8 = 14 feet for a hypotenuse that is 10.',
      'Stopping after adding the two known angles and reporting 113 when the question asked for the third angle, 67.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'About 17.5 feet, adding 81 and 225 under the root.',
        why: 'Adding finds the hypotenuse. With the hypotenuse already given, the leg comes from subtracting, and the root of 144 is 12 feet.',
      ),
      CommonMistake(
        answer: '6 feet, subtracting the sides as plain lengths, 15 - 9.',
        why: 'The theorem squares the sides first, so the step is the square root of 144, which is 12 feet, not 6.',
      ),
    ],
  ),
  Lesson(
    skillId: 'mk.probability',
    title: 'Probability is a ratio you build',
    hook: 'Count the outcomes you want, count all of them, divide. That is the whole engine.',
    whyItMatters: 'Mathematics Knowledge contributes to your AFQT, and probability items are short once you stop guessing and start counting.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Favourable over total',
        'Probability is a fraction: the outcomes you want over all the outcomes possible. Its value always sits between 0 and 1, so anything above 1 is a counting error, not an answer.',
        bullets: <String>[
          'Build the denominator from the total count, not from one group.',
          'A probability of 5/12 is about 0.42, so just under half; that estimate catches inverted answers.',
          'The probability of something not happening is 1 minus the probability that it does.',
        ],
      ),
      LessonSection(
        'And multiplies, or adds',
        'Two independent events both happening means multiply their probabilities. Either of two mutually exclusive events means add them. Read the connector in the question.',
        bullets: <String>[
          'A die and a coin are independent: the coin does not care what the die did.',
          'Rolling a 4 and flipping heads is 1/6 x 1/2 = 1/12.',
          'Rolling a 2 or a 3 on one die is 1/6 + 1/6 = 2/6.',
        ],
      ),
      LessonSection(
        'Counting arrangements',
        'When order matters, the number of ways to line up n distinct items is n factorial: multiply down to 1. Three items give 6 orders, four give 24.',
        bullets: <String>[
          'Three distinct items line up in 3 x 2 x 1 = 6 ways.',
          'Four distinct items line up in 4 x 3 x 2 x 1 = 24 ways.',
          'If order does not matter, the count is much smaller; read the question for the word order.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A bag holds 5 red markers and 7 blue markers. What is the probability of drawing a red marker?',
        steps: <String>[
          'Count the total: 5 + 7 = 12 markers.',
          'Count the favourable outcomes: 5 red.',
          'Write the fraction: 5/12, which is a little under one half.',
        ],
        answer: '5/12',
      ),
      WorkedExample(
        prompt: 'A soldier rolls a standard six-sided die and flips a fair coin. What is the probability of rolling a 4 and flipping heads?',
        steps: <String>[
          'The two events are independent, so multiply.',
          'Probability of a 4 is 1/6 and of heads is 1/2.',
          'Multiply: 1/6 x 1/2 = 1/12.',
        ],
        answer: '1/12',
      ),
      WorkedExample(
        prompt: 'Two fair dice are rolled. What is the probability that the two numbers add to 7?',
        steps: <String>[
          'Count the equally likely outcomes: 6 x 6 = 36 ordered pairs.',
          'List the pairs totalling 7: 1 and 6, 2 and 5, 3 and 4, and each pair reversed.',
          'That is 6 favourable pairs, so the probability is 6/36.',
          'Reduce: 6/36 = 1/6.',
        ],
        answer: '1/6',
      ),
    ],
    quickRules: <String>[
      'Probability = favourable / total, and it always falls between 0 and 1.',
      'Independent events joined by and: multiply. Exclusive events joined by or: add.',
      'The complement is 1 minus the probability, useful when counting the opposite is easier.',
      'Arrangements of n distinct items in order is n factorial.',
    ],
    pitfalls: <String>[
      'Building the denominator from one group instead of the total: 5/7 instead of the true 5/12.',
      'Adding where you should multiply: 1/6 + 1/2 = 2/3 instead of 1/12.',
      'Counting arrangements linearly: 3 distinct items answered as 3 orders instead of 6.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: '1/11, counting the eleven possible totals.',
        why: 'Totals are not equally likely, so they cannot be the denominator. The outcomes to count are the 36 ordered pairs, of which 6 total 7.',
      ),
      CommonMistake(
        answer: '3/36, counting only the pairs 1 and 6, 2 and 5, 3 and 4.',
        why: 'Each of those pairs can land in either order, so there are 6 favourable outcomes, giving 6/36 = 1/6.',
      ),
    ],
  ),
  Lesson(
    skillId: 'wk.synonym',
    title: 'Define first, then match',
    hook: 'Write your own definition before your eyes ever reach the four choices.',
    whyItMatters: 'Word Knowledge feeds Verbal Expression, which is weighted double in the AFQT composite, so synonym recall is some of the most valuable vocabulary work you can do.',
    minutes: 7,
    sections: <LessonSection>[
      LessonSection(
        'Cover the choices and predict',
        'The choices are written to pull you off a definition you already know. Say the word in your own words first, then look for the choice that matches it.',
        bullets: <String>[
          'State a five word definition before reading the options.',
          'If no choice matches your definition, your definition is the thing to recheck, not the choices.',
          'The correct option is usually the plainest word of the same meaning.',
        ],
      ),
      LessonSection(
        'Charge comes before precision',
        'Decide whether the word is positive or negative before you compare shades of meaning. That single judgement usually eliminates two options immediately.',
        bullets: <String>[
          'Tenacious and obstinate share a meaning but differ in approval, so read the register.',
          'If the word sounds negative, eliminate every choice that sounds pleasant.',
          'The opposite is a planted distractor on nearly every synonym item.',
        ],
      ),
      LessonSection(
        'Near misses are not matches',
        'Test writers build one distractor that is related but too strong, too weak, or only a consequence. Match meaning exactly, not vaguely.',
        bullets: <String>[
          'Curtail means shorten, not cancel; something shortened still exists.',
          'Meticulous means careful, and slow is only a possible side effect.',
          'A choice that is merely true of the situation is not a definition.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'OBSTINATE most nearly means which of: flexible, stubborn, cautious, curious.',
        steps: <String>[
          'Define before looking: obstinate means refusing to change position.',
          'Match the charge: it is a negative trait, which rules out neither by itself, so compare meaning.',
          'Stubborn is the exact match; flexible is the direct opposite and is planted deliberately.',
        ],
        answer: 'stubborn',
      ),
      WorkedExample(
        prompt: 'CURTAIL most nearly means which of: extend, postpone, cancel, shorten.',
        steps: <String>[
          'Define it: to curtail is to cut something short.',
          'Check the near misses: cancel removes the thing entirely, which is too strong.',
          'Extend is the opposite and postpone only moves the timing.',
        ],
        answer: 'shorten',
      ),
      WorkedExample(
        prompt: 'RELUCTANT most nearly means which of: eager, unwilling, reliable, confused.',
        steps: <String>[
          'Define the stem word before looking at the choices: reluctant means holding back, not keen to act.',
          'Compare each choice against that definition, not against how the word sounds.',
          'Reliable is a sound-alike and eager is the opposite, so both lose.',
        ],
        answer: 'unwilling',
      ),
    ],
    quickRules: <String>[
      'Predict the meaning before you read the options, every single time.',
      'Decide positive or negative first; precision is the second question.',
      'Eliminate the antonym on sight, because it is there on purpose.',
      'Pick the least dramatic word that still carries the meaning.',
    ],
    pitfalls: <String>[
      'Choosing the antonym because it is the only familiar word: obstinate answered as flexible instead of stubborn.',
      'Choosing a related but stronger word: curtail answered as cancel instead of shorten.',
      'Choosing a consequence rather than a meaning: meticulous answered as slow instead of very careful.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'Reliable, because reluctant sounds like reliant.',
        why: 'A sound-alike is not a meaning. Reluctant means unwilling, while reliant means depending on something else.',
      ),
      CommonMistake(
        answer: 'Eager, choosing the strongest feeling on the list.',
        why: 'Eager is the opposite of reluctant. The word describes someone who hesitates, not someone who rushes forward.',
      ),
    ],
  ),
  Lesson(
    skillId: 'wk.context',
    title: 'Let the sentence pick the meaning',
    hook: 'The underlined word is doing a job in that sentence. Find the job.',
    whyItMatters: 'Word Knowledge builds Verbal Expression, which is weighted double in your AFQT composite, and most real items put the word inside a sentence.',
    minutes: 7,
    sections: <LessonSection>[
      LessonSection(
        'Read past the word to the result',
        'The rest of the sentence usually reports what happened because of the word. A squad that repeats a task twice was given instructions they could not follow, so the word meant unclear.',
        bullets: <String>[
          'Read the whole sentence before you look at the choices.',
          'Find the consequence clause; it converts the word into plain English.',
          'Substitute each choice back in and listen for the sentence breaking.',
        ],
      ),
      LessonSection(
        'Signal words point the direction',
        'Conjunctions tell you whether the sentence is agreeing or contrasting. But, although and however mean the second half reverses the first, which flips the meaning you need.',
        bullets: <String>[
          'Because and so announce a cause and effect pair.',
          'But and although signal contrast, so the word is probably the opposite of the nearby description.',
          'And and also signal agreement, so the word points the same direction as its neighbours.',
        ],
      ),
      LessonSection(
        'A familiar sense is not automatically the right one',
        'Many test words have several senses. The sentence, not your memory of the word in another setting, decides which one is live here.',
        bullets: <String>[
          'Check the part of speech implied by the sentence position.',
          'A word can be neutral in one sense and negative in another; the sentence picks.',
          'Military association is a trap when the sentence is neutral about it.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'The commander was CANDID about the unit shortfalls during the briefing. CANDID most nearly means which of: dishonest, hesitant, frank, confused.',
        steps: <String>[
          'Read the job: the commander is saying what is wrong with the unit, openly.',
          'Hesitant would mean avoiding the subject, which contradicts the sentence.',
          'Frank means direct and honest, which fits; dishonest is the exact opposite.',
        ],
        answer: 'frank',
      ),
      WorkedExample(
        prompt: 'The instructions were AMBIGUOUS, so the squad completed the task twice. AMBIGUOUS most nearly means which of: unclear, incorrect, lengthy, insulting.',
        steps: <String>[
          'Use the consequence: the squad redid the work because the instructions let them read it two ways.',
          'Lengthy instructions would not force a second attempt on their own.',
          'Unclear matches the cause exactly.',
        ],
        answer: 'unclear',
      ),
      WorkedExample(
        prompt: 'The supply clerk was FRUGAL, reusing every crate and repairing gear rather than replacing it. FRUGAL most nearly means which of: wasteful, thrifty, dishonest, generous.',
        steps: <String>[
          'Read the clue the sentence supplies: reusing and repairing instead of buying.',
          'Turn the clue into a meaning: careful with money, getting full use from what is already there.',
          'Match it: thrifty, while generous and dishonest have no support in the sentence.',
        ],
        answer: 'thrifty',
      ),
    ],
    quickRules: <String>[
      'Read the full sentence first, then the options.',
      'But, although and however reverse the direction of the meaning.',
      'Because, so and therefore build a cause and effect you can read backwards.',
      'Substitute the choice into the sentence and check it still makes sense.',
    ],
    pitfalls: <String>[
      'Answering the military sense out of habit when the sentence is asking about something else entirely.',
      'Choices that describe the mood of the situation rather than the word: answering dangerous for an ambiguous order that was merely unclear.',
      'Picking a true statement about the scenario, such as lengthy, when the sentence needs the word itself defined.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer:
            'Wasteful, because crates are being kept rather than thrown away.',
        why: 'Keeping and repairing is the opposite of waste. The sentence describes saving money, which is thrifty.',
      ),
      CommonMistake(
        answer: 'Generous, because the gear is used to help the unit.',
        why: 'Nothing in the sentence spends anything on other people. The clue is reuse for the sake of cost, not giving.',
      ),
    ],
  ),
  Lesson(
    skillId: 'wk.roots',
    title: 'Decode the word from its parts',
    hook: 'A prefix and a root can rescue a word you have never seen before.',
    whyItMatters: 'Word Knowledge feeds Verbal Expression, which is weighted double in the AFQT, and morphemes let you answer items on words nobody taught you.',
    minutes: 7,
    sections: <LessonSection>[
      LessonSection(
        'Prefixes flip or aim the meaning',
        'A short list covers most of the prefix questions you will meet. Negating prefixes are the highest-value ones because they invert the answer completely.',
        bullets: <String>[
          'in-, un-, non- and a- mean not: inaudible, unusual, nonstandard, atypical.',
          'pre- means before, post- after, re- again, circum- around, sub- under.',
          'bene- means good and mal- means bad, as in benevolent and malicious.',
        ],
      ),
      LessonSection(
        'Roots carry the core meaning',
        'Learn ten roots well and you can decode several hundred words. The root tells you the subject; the prefix tells you the direction.',
        bullets: <String>[
          'aud means hear: audio, audience, inaudible.',
          'spect means look: inspect, spectator, circumspect.',
          'dict means say, port means carry, ten means hold, cred means believe.',
        ],
      ),
      LessonSection(
        'Suffixes tell you the job in the sentence',
        'The ending tells you whether the word is a thing, an action or a description. That is often enough to eliminate two choices before you even decode the root.',
        bullets: <String>[
          '-able and -ible mean able to be, as in audible and visible.',
          '-tion and -ment name an act or a thing, as in retention and movement.',
          '-ous means full of, and -ity turns an adjective into a noun.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'The warning siren was INAUDIBLE from the motor pool. INAUDIBLE most nearly means which of: not able to be heard, not able to be seen, difficult to repeat, spoken in anger.',
        steps: <String>[
          'Split the word: in- means not, aud means hear, -ible means able to be.',
          'Assemble the pieces: not able to be heard.',
          'Confirm with a familiar word sharing the root: audio and audience both concern hearing.',
        ],
        answer: 'not able to be heard',
      ),
      WorkedExample(
        prompt: 'The sergeant was TENACIOUS in her pursuit of the missing gear. TENACIOUS most nearly means which of: weak, persistent, generous, quiet.',
        steps: <String>[
          'Identify the root ten, meaning to hold, the same root as tenant and retain.',
          'Assemble: holding on, and -ous marks it as a description full of that quality.',
          'Persistent matches; weak is the opposite and belongs to a different word.',
        ],
        answer: 'persistent',
      ),
      WorkedExample(
        prompt: 'The medics managed to REVIVE the collapsed runner. REVIVE most nearly means which of: bring back to life, recall to duty, record in writing, reduce in size.',
        steps: <String>[
          'Split the word: re means again, and viv means life.',
          'Join the pieces: to give life again, which is to bring back to life.',
          'Check against the sentence: medics acting on a collapsed runner fit restoring life, not paperwork.',
        ],
        answer: 'bring back to life',
      ),
    ],
    quickRules: <String>[
      'Read the prefix first, because in-, un- and non- invert the entire answer.',
      'aud hear, spect look, dict say, port carry, ten hold, cred believe, vid see.',
      '-able means able to be, -tion names an act, -ous means full of.',
      'Decode the parts, then choose the option the assembled meaning allows.',
    ],
    pitfalls: <String>[
      'Ignoring a negating prefix, so inaudible gets answered as loud or easy to hear instead of not able to be heard.',
      'Swapping similar roots: aud heard as vid, which turns inaudible into invisible.',
      'Reading a familiar chunk into an unfamiliar word, such as taking the ten in tenacious as the number ten instead of the root meaning to hold.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'Record in writing, matching the re in revive with the re in report.',
        why: 'Take the root with the prefix: viv means life, so revive is to restore life, not to write something down.',
      ),
      CommonMistake(
        answer: 'Recall to duty, using only the prefix re.',
        why: 'A prefix is half the word. Re means again and viv means life, which rules out a summons back to work.',
      ),
    ],
  ),
  Lesson(
    skillId: 'wk.academic',
    title: 'The school-English words that repeat',
    hook: 'A short list of ordinary academic words accounts for a large share of these items.',
    whyItMatters: 'Word Knowledge drives your Verbal Expression score, which carries double weight in the AFQT composite, so vocabulary you already half know is the cheapest score you can add.',
    minutes: 7,
    sections: <LessonSection>[
      LessonSection(
        'Build a shortlist you can actually hold',
        'These items repeat the same register: words an English teacher would use, not words from a novel. Learn twenty well rather than two hundred badly.',
        bullets: <String>[
          'abundant, candid, meticulous, ambiguous, tenacious, arduous, concise, impartial.',
          'Each one has a plain one-word synonym that is usually the correct option.',
          'Learn the definition in five words or fewer so it survives time pressure.',
        ],
      ),
      LessonSection(
        'Learn words in opposing pairs',
        'A pair fixes both words at once and pre-loads the elimination step. If you know the pair, the antonym distractor is dead on arrival.',
        bullets: <String>[
          'abundant and scarce, candid and evasive, meticulous and careless.',
          'ambiguous and clear, tenacious and yielding, impartial and biased.',
          'Ask which half of the pair the sentence demands before you look at the options.',
        ],
      ),
      LessonSection(
        'Use each word once, in your own life',
        'A word you have said out loud about your own week is a word you will not lose in a testing room. Recognition alone fades under pressure.',
        bullets: <String>[
          'Write one sentence per word about your own squad, shift or commute.',
          'Say the synonym, not the original word, when you test yourself.',
          'Review the pairs the night before rather than learning new ones.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'The supply sergeant kept an ABUNDANT stock of batteries in the conex. ABUNDANT most nearly means which of: plentiful, damaged, borrowed, outdated.',
        steps: <String>[
          'Define it plainly: present in large quantity.',
          'Match: plentiful means exactly that.',
          'Reject outliers: surplus stock is often old and damaged, but neither word means a lot of it.',
        ],
        answer: 'plentiful',
      ),
      WorkedExample(
        prompt: 'The inspector was METICULOUS during the vehicle check. METICULOUS most nearly means which of: careless, very careful, very slow, overconfident.',
        steps: <String>[
          'Define it: showing great attention to detail.',
          'Match: very careful.',
          'Reject the consequence: being meticulous may make someone slow, but slow is not the meaning.',
        ],
        answer: 'very careful',
      ),
      WorkedExample(
        prompt: 'The inspector gave a SUPERFICIAL look at the vehicle, glancing at the tyres before walking away. SUPERFICIAL most nearly means which of: thorough, shallow, hurried, detailed.',
        steps: <String>[
          'Find the root: superficial comes from surface.',
          'Build the meaning: on the surface only, without depth.',
          'Compare: thorough and detailed are opposites, and hurried describes the pace rather than the depth.',
        ],
        answer: 'shallow',
      ),
    ],
    quickRules: <String>[
      'Learn the pair, not the single word; the antonym is a planted distractor.',
      'Keep every definition to five words or fewer.',
      'When two choices both fit, the simpler and less dramatic one is right.',
      'Academic words mean ordinary things; reject any choice that feels extreme.',
    ],
    pitfalls: <String>[
      'Recognising the word but guessing at its register: abundant answered as outdated because old surplus comes to mind.',
      'Confusing near neighbours: ambiguous answered as conflicted, which is ambivalent, when the sentence needed unclear.',
      'Overshooting the meaning: meticulous answered as obsessive instead of very careful.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'Hurried, because the inspector walked away quickly.',
        why: 'Speed is the symptom, not the meaning. Superficial says the inspection never went below the surface, whatever its pace.',
      ),
      CommonMistake(
        answer: 'Thorough, because the word is long and formal.',
        why: 'Length is not meaning. Superficial comes from surface and means without depth, the opposite of thorough.',
      ),
    ],
  ),
];
