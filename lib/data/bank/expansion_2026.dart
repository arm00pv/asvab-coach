import '../models/catalog.dart';
import '../models/question.dart';

/// Compact helpers for authoring spatial items.
///
/// A piece is written as a bitmap of rows separated by a slash, where a 1 is a
/// cell, so '10/10/11' is an L tetromino and '11' is a domino.
Poly _p(String art) => Poly.parse(art);

extension _PiecePlacement on Poly {
  Poly at(int dx, int dy) => offset(dx, dy);
}

/// The 2026 expansion pass: forty new items, five in each of the eight subtests
/// a candidate drills on the way to the AFQT and the technical line scores.
///
/// Ids carry the y stem (ar-y01 .. ao-y05) so this pass stays separable from the
/// first expansion, which uses x, and from the skill depth bank, which uses d.
/// Every item follows docs/ITEM-STYLE-GUIDE.md: Arithmetic Reasoning options are
/// bare numerals or currency with the unit named in the stem, Mathematics
/// Knowledge stays symbolic, Paragraph Comprehension always carries a passage,
/// Mechanical Comprehension is figure-led wherever the figure cannot print the
/// key, and every Assembling Objects item is rendered from polyominoes so its
/// answer is computed by AoPuzzle rather than declared.
final List<Question> expansionItems = <Question>[
  // --- AR: arithmetic reasoning ------------------------------------------
  Question(
    id: 'ar-y01',
    subtest: Subtest.ar,
    stem:
        'A rucksack is priced at \$85 and is marked down 20 percent. What is the '
        'sale price in dollars?',
    choices: <String>['\$17', '\$65', '\$68', '\$70'],
    answerIndex: 2,
    choiceNotes: <String>[
      '17 dollars is the discount itself, answering a question the stem never asked.',
      'Taking a flat 20 dollars off gives 65, treating the percent as a currency amount.',
      '0.20 x 85 = 17, and 85 - 17 = 68 dollars as the sale price after the markdown.',
      'Rounding the sale price up to a multiple of ten gives 70, two dollars over the exact 68.',
    ],
    explanation:
        'Twenty percent of 85 is 0.20 x 85 = 17, and 85 - 17 = 68 dollars. '
        'Multiplying by 0.80 in a single step gives the same figure. The 17 '
        'dollar option is the discount itself, which the question never asks '
        'for, and 65 comes from taking a round 20 off the price instead of 20 '
        'percent of it.',
    difficulty: Difficulty.easy,
    skills: <String>['ar.percent'],
  ),
  Question(
    id: 'ar-y02',
    subtest: Subtest.ar,
    stem:
        'In a battalion of 480 soldiers, 5 out of every 8 are assigned to field '
        'duties. How many soldiers are assigned to field duties?',
    choices: <String>['180', '240', '300', '360'],
    answerIndex: 2,
    choiceNotes: <String>[
      '180 is the other three eighths of 480, the soldiers who are not on field duties.',
      '240 halves the battalion, but five eighths is more than half of it.',
      'One eighth of 480 is 60, and five eighths is 5 x 60 = 300 soldiers on field duties.',
      'Taking two thirds of 480 gives 360, a larger share than the five eighths stated.',
    ],
    explanation:
        'Five eighths of 480 is found in two steps: one eighth is 480 / 8 = 60 '
        'soldiers, and five eighths is 5 x 60 = 300. The 180 option is the '
        'other three eighths, which is the part NOT on field duties, and 360 '
        'comes from taking two thirds of the battalion instead of five eighths.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.ratio'],
  ),
  Question(
    id: 'ar-y03',
    subtest: Subtest.ar,
    stem:
        'The first four tests of a course averaged 82 points. What must the '
        'fifth test score be for all five tests to average 84 points?',
    choices: <String>['80', '84', '86', '92'],
    answerIndex: 3,
    choiceNotes: <String>[
      '80 is four points below the target, the mirror image of the lift the fifth paper needs.',
      '84 is the target average itself, not the score the fifth paper has to reach.',
      'Adding just two points to 84 gives 86, but the two point lift applies to four earlier papers.',
      'Five papers need 5 x 84 = 420 points and the first four hold 328, so the fifth is 92.',
    ],
    explanation:
        'Work back from the average to the total it requires: five tests at 84 '
        'points means 5 x 84 = 420, and the first four account for 4 x 82 = '
        '328, so the fifth paper must be 420 - 328 = 92. The fifth paper has to '
        'lift four earlier papers by 2 points each, which is 84 + 8. The 86 '
        'option allows for only one such lift, and 80 is the current average '
        'with its sign reversed.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.average'],
  ),
  Question(
    id: 'ar-y04',
    subtest: Subtest.ar,
    stem:
        'A vehicle covers 180 miles in 3 hours and then 100 miles in 2 hours. '
        'What is its average speed for the whole trip in miles per hour?',
    choices: <String>['50', '55', '56', '60'],
    answerIndex: 2,
    choiceNotes: <String>[
      '50 is the second leg speed alone, the slower half of the trip.',
      'Averaging 60 and 50 gives 55, which weights the unequal legs as though they matched.',
      '280 miles over 5 hours is 56 miles per hour for the whole trip.',
      '60 is the first leg speed, kept as if the second leg never happened.',
    ],
    explanation:
        'Average speed is total distance divided by total time: 280 miles in 5 '
        'hours is 56 miles per hour. Averaging the two speeds, 60 and 50, gives '
        '55, which is the usual trap because it weights the fast hour and the '
        'slow hour equally even though the legs are different lengths. The 50 '
        'option is the second leg on its own.',
    difficulty: Difficulty.hard,
    skills: <String>['ar.rate', 'ar.average'],
  ),
  Question(
    id: 'ar-y05',
    subtest: Subtest.ar,
    stem:
        'A tool kit costs \$45 at wholesale, is marked up 40 percent for sale, '
        'and then sells at a 25 percent discount off the marked price. What is '
        'the final price in dollars?',
    choices: <String>['\$45', '\$47.25', '\$51.75', '\$63'],
    answerIndex: 1,
    choiceNotes: <String>[
      '45 is the wholesale cost, unchanged, so neither the mark-up nor the discount is applied.',
      '45 x 1.40 = 63 and 63 x 0.75 = 47.25, so the two changes compound in the order given.',
      'Treating the pair of changes as a flat 15 percent mark-up gives 51.75 dollars.',
      '63 is the marked price before the discount, which the question never asks for.',
    ],
    explanation:
        'Apply the two changes in the order they happen: 45 x 1.40 = 63 dollars '
        'marked, and 63 x 0.75 = 47.25 dollars after the discount. The '
        'percentages do not cancel, because the discount is taken from the '
        'marked price and not from the wholesale one. The 63 option is that '
        'unasked marked price, and 51.75 treats the whole thing as a flat 15 '
        'percent added to 45.',
    difficulty: Difficulty.hard,
    skills: <String>['ar.percent', 'ar.algebra'],
  ),

  // --- MK: mathematics knowledge -----------------------------------------
  Question(
    id: 'mk-y01',
    subtest: Subtest.mk,
    stem: 'What is the value of 2 + 3 x 4 - 6/2?',
    choices: <String>['5', '8', '11', '17'],
    answerIndex: 2,
    choiceNotes: <String>[
      'Stopping at 2 + 3 gives 5, before the multiplication and division are carried out.',
      'Reading 6/2 as a plain 6 gives 2 + 12 - 6 = 8, so the division was dropped.',
      '3 x 4 = 12 and 6/2 = 3, so 2 + 12 - 3 = 11 by order of operations.',
      'Adding first, as (2 + 3) x 4 - 3, gives 17, reversing the order of operations.',
    ],
    explanation:
        'Multiplication and division are done before addition and subtraction, '
        'so 3 x 4 = 12 and 6/2 = 3, leaving 2 + 12 - 3 = 11. Giving the addition '
        'priority instead, as in (2 + 3) x 4 - 3, gives 17, and treating 6/2 as a '
        'plain 6 gives 8. Stopping as soon as 2 + 3 appears gives 5.',
    difficulty: Difficulty.easy,
    skills: <String>['mk.prealgebra'],
  ),
  Question(
    id: 'mk-y02',
    subtest: Subtest.mk,
    stem: 'Simplify: (2x^3)(4x^5)',
    choices: <String>['6x^8', '8x^8', '6x^15', '8x^15'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Adding the coefficients 2 + 4 gives 6x^8, using a sum where the coefficients multiply.',
      'The coefficients multiply to 8 and the exponents add to 8, which gives 8x^8.',
      'Multiplying the exponents to 15 and adding the coefficients to 6 is wrong in two places.',
      'Multiplying 3 by 5 gives x^15, the rule for (x^3)^5 rather than for a product.',
    ],
    explanation:
        'Multiply the coefficients and add the exponents of the common base: '
        '2 x 4 = 8 and x^3 times x^5 = x^8, so the product is 8x^8. The 8x^15 '
        'option multiplies the exponents instead of adding them, which is the '
        'slip the product rule exists to prevent, and 6x^8 adds the '
        'coefficients instead of multiplying them.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.exponents'],
  ),
  Question(
    id: 'mk-y03',
    subtest: Subtest.mk,
    stem: 'A circle has a diameter of 10. What is its area?',
    choices: <String>['10pi', '25pi', '50pi', '100pi'],
    answerIndex: 1,
    choiceNotes: <String>[
      '10pi is pi times the diameter, which is the circumference, not the area.',
      'The diameter of 10 gives a radius of 5, and pi x 5^2 = 25pi.',
      '50pi multiplies the radius by the diameter, combining two lengths where an area is wanted.',
      'Squaring the diameter 10 gives 100pi, four times the true area.',
    ],
    explanation:
        'Area is pi times the square of the radius, and a diameter of 10 means a '
        'radius of 5, so the area is pi x 5^2 = 25pi. Squaring the diameter '
        'instead of the radius gives 100pi, four times too large, and 10pi is '
        'the circumference rather than the area.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.geometry'],
  ),
  Question(
    id: 'mk-y04',
    subtest: Subtest.mk,
    stem: 'Solve for x: x^2 - 5x - 14 = 0',
    choices: <String>['7 and -2', '-7 and 2', '7 and 2', '-7 and -2'],
    answerIndex: 0,
    choiceNotes: <String>[
      '(x - 7)(x + 2) multiplies to -14 and adds to -5, so the roots are 7 and -2.',
      'The numbers -7 and 2 are the factors, so taking them as roots flips both signs.',
      'Two positive roots multiply to +14, which needs a plus sign on the constant term.',
      'Two negative roots add to -9, so that pair would carry a middle term of 9x.',
    ],
    explanation:
        'Find two numbers that multiply to -14 and add to -5: they are -7 and '
        '2, so the quadratic factors as (x - 7)(x + 2) = 0 and the roots are 7 '
        'and -2. The -7 and 2 option flips both signs, and taking the roots as '
        '7 and 2 forgets that a negative product needs one negative factor.',
    difficulty: Difficulty.medium,
    skills: <String>['mk.algebra'],
  ),
  Question(
    id: 'mk-y05',
    subtest: Subtest.mk,
    stem:
        'A bag holds 5 red marbles and 3 blue marbles. Two marbles are drawn '
        'without replacement. What is the probability that both are red?',
    choices: <String>['5/14', '25/64', '5/8', '4/7'],
    answerIndex: 0,
    choiceNotes: <String>[
      'The draws are 5/8 and then 4/7, and 5/8 x 4/7 = 20/56, which reduces to 5/14.',
      'Using 5/8 twice assumes the first marble goes back into the bag.',
      '5/8 is the first draw only, so a second red marble is never required.',
      '4/7 is the second draw alone, already conditional on the first marble being red.',
    ],
    explanation:
        'The first draw is red with probability 5/8. One red marble is now out '
        'of the bag, so the second draw is red with probability 4/7. Multiply '
        'the two: 5/8 x 4/7 = 20/56 = 5/14. The 25/64 option is the same '
        'question WITH replacement, where the bag never shrinks, and 5/8 and '
        '4/7 are each a single draw on its own.',
    difficulty: Difficulty.hard,
    skills: <String>['mk.probability'],
  ),

  // --- WK: word knowledge -------------------------------------------------
  Question(
    id: 'wk-y01',
    subtest: Subtest.wk,
    stem: 'FRUGAL',
    choices: <String>['humble', 'stingy', 'hungry', 'thrifty'],
    answerIndex: 3,
    choiceNotes: <String>[
      'Humble describes modesty, and frugality is about how resources are spent.',
      'Stingy is the near miss that carries a judgement, naming meanness where frugal names economy.',
      'Hungry is a different word entirely, and careful spending does not mean going without food.',
      'Frugal means careful with money and resources, and this option is the nearest synonym.',
    ],
    explanation:
        'Frugal means careful with money and resources, so thrifty is the '
        'nearest synonym. Stingy is the near miss that carries a judgement: it '
        'names meanness, while frugal names economy, and a frugal person can '
        'still be generous with what is saved.',
    difficulty: Difficulty.easy,
    skills: <String>['wk.synonym'],
  ),
  Question(
    id: 'wk-y02',
    subtest: Subtest.wk,
    stem:
        'The supply sergeant had to SCRAP the bent panel and draw a new one from '
        'stores.',
    choices: <String>['inspect', 'repair', 'return', 'discard'],
    answerIndex: 3,
    choiceNotes: <String>[
      'Inspecting a bent panel would not need a replacement drawn from stores.',
      'Repair is the opposite, and the sentence has the sergeant throwing the panel away.',
      'Returning it is what is being replaced, since the new panel is drawn from those same stores.',
      'Scrap as a verb means to throw something away as beyond use, which is what this option says.',
    ],
    explanation:
        'Here scrap works as a verb and means to throw something away as beyond '
        'use, so discard fits. Repair is the opposite of what the sentence '
        'describes, and neither returning nor inspecting a panel would require a '
        'replacement to be drawn from stores.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.context'],
  ),
  Question(
    id: 'wk-y03',
    subtest: Subtest.wk,
    stem:
        'The after-action report was so LURID that the commander ordered it '
        'rewritten before it left the unit.',
    choices: <String>['confidential', 'lengthy', 'sensational', 'accurate'],
    answerIndex: 2,
    choiceNotes: <String>[
      'Confidential concerns who may read a report, and this commander objected to its tone.',
      'Lengthy is the tempting confusion, but the objection here is to tone rather than to page count.',
      'Lurid means shockingly vivid, so a report ordered to be toned down is sensational.',
      'Accurate describes a quality a commander would want to keep rather than rewrite away.',
    ],
    explanation:
        'Lurid means shockingly vivid, so a report ordered to be toned down is '
        'sensational. Lengthy is the tempting confusion because a vivid account '
        'is often a long one, but the objection here is to the tone rather than '
        'to the number of pages, and accurate describes a quality the commander '
        'would want to keep.',
    difficulty: Difficulty.hard,
    skills: <String>['wk.context'],
  ),
  Question(
    id: 'wk-y04',
    subtest: Subtest.wk,
    stem: 'AUTONOMY',
    choices: <String>['independence', 'efficiency', 'obedience', 'accuracy'],
    answerIndex: 0,
    choiceNotes: <String>[
      'Autos means self and nomos means law, so self rule is exactly this option.',
      'Efficiency is about doing work well, and these two roots say nothing about output per hour.',
      'Obedience is the opposite, since ruling yourself is not following another rule.',
      'Accuracy is about correctness, and autonomy is about who decides.',
    ],
    explanation:
        'Autos means self and nomos means law, so autonomy is literally self '
        'rule, which is independence. Automation shares the first root but '
        'names machine operation instead, and obedience is its opposite, which '
        'is exactly what the two roots rule out.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.roots'],
  ),
  Question(
    id: 'wk-y05',
    subtest: Subtest.wk,
    stem: 'ADEQUATE',
    choices: <String>['sufficient', 'equal', 'excellent', 'careful'],
    answerIndex: 0,
    choiceNotes: <String>[
      'Adequate means enough for the purpose at hand, which is what sufficient says.',
      'Equal is the trap in the Latin root, since adequate work meets a standard instead of matching another.',
      'Excellent overshoots, because adequate work is acceptable rather than outstanding.',
      'Careful describes the manner of the work, and adequacy is about meeting the requirement.',
    ],
    explanation:
        'Adequate means enough for the purpose at hand, so sufficient is the '
        'match. Equal is the trap built into the word, since the Latin root '
        'means level, but adequate work meets a standard rather than matching '
        'another thing exactly.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.academic'],
  ),

  // --- PC: paragraph comprehension ----------------------------------------
  Question(
    id: 'pc-y01',
    subtest: Subtest.pc,
    passage:
        'The DUKW was a two and a half ton truck with a boat-shaped hull, '
        'designed in a hurry in 1942 by a civilian who bolted a standard drive '
        'train into a welded steel body. Drivers were taught one rule above all '
        'others: respect the tyre pressures. The tyres ran soft on land so that '
        'they would grip a beach, and they were inflated from a compressor '
        'under the bonnet to cross water, then deflated again on the far side. '
        'Landing craft could not always reach a shore, so the vehicle that '
        'could swim the last mile carried more cargo inland than any '
        'ship-to-shore crane.',
    stem:
        'According to the passage, what was done with the tyres once the '
        'vehicle reached the far side of the water?',
    choices: <String>[
      'They were replaced with fresh ones',
      'They were left hard for the return trip',
      'They were checked for water damage',
      'They were let down again',
    ],
    answerIndex: 3,
    choiceNotes: <String>[
      'Nothing is said about replacement, and the same tyres are inflated and deflated repeatedly.',
      'Leaving them hard contradicts the sequence, since deflating on the far side is the final step.',
      'Water damage never appears, and the tyres are let down for grip rather than inspected.',
      'The passage says they were deflated again on the far side, which is letting them down.',
    ],
    explanation:
        'The passage states the sequence plainly: run soft on land, inflated to '
        'cross water, then deflated again on the far side. Replacing them, '
        'leaving them hard for the return and inspecting them for water are all '
        'plausible workshop habits, but none of them is on the page.',
    difficulty: Difficulty.medium,
    skills: <String>['pc.detail'],
  ),
  Question(
    id: 'pc-y02',
    subtest: Subtest.pc,
    passage:
        'The electric locomotives that guide ships through the Panama Canal are '
        'called mules, and they do not tow. A ship in a lock is held by cables '
        'to mules running on racks beside the walls, and the mules keep the hull '
        'centred in a chamber with about two feet to spare on either side. '
        'Propellers are stopped for the transit, so the mules do the steering as '
        'well as the braking. Each pair can hold a vessel against the surge when '
        'the gates open, paying cable in and out to keep the tension steady. '
        'Working both banks at once is faster than waiting for rope handlers on '
        'deck.',
    stem: 'The passage is chiefly concerned with',
    choices: <String>[
      'why locks are built in pairs',
      'how canal pilots learn to steer',
      'why ships carry their own cables',
      'what the canal mules actually do',
    ],
    answerIndex: 3,
    choiceNotes: <String>[
      'Locks in pairs are never discussed, and the only pairing mentioned is one mule on each bank.',
      'Nothing is said about training pilots, and the passage has the mules doing the steering.',
      'Who supplies the cables is not stated, so that fact belongs to the world rather than the passage.',
      'Every detail serves the point that the mules centre, steer and brake rather than merely tow.',
    ],
    explanation:
        'Every detail in the passage serves the point that the mules neither tow '
        'nor merely pull: they centre, steer and brake the hull. Nothing is said '
        'about building locks in pairs, about how pilots are trained, or about '
        'who supplies the cables, so those options are true of the world rather '
        'than of this passage.',
    difficulty: Difficulty.medium,
    skills: <String>['pc.mainidea'],
  ),
  Question(
    id: 'pc-y03',
    subtest: Subtest.pc,
    passage:
        'A shelf-stable meal is only as good as its package. The military retort '
        'pouch was devised as a replacement for the tin can: flat, flexible, and '
        'quick to heat through in the hands of a soldier. The pouch is not one '
        'sheet of plastic. It is a web of four layers, a polyester skin for '
        'printing, an aluminium barrier against oxygen and light, a nylon layer '
        'for strength, and an inner layer that can be heat-sealed and will not '
        'react with the food. Each layer earns its place, because no single '
        'plastic can do all four jobs at once.',
    stem:
        'The passage suggests that the pouch is built from four layers because',
    choices: <String>[
      'the layers are cheaper to buy as a set',
      'sealing a pouch is the hardest job of all',
      'regulations demand a metal barrier in every pack',
      'no single material does all four jobs well',
    ],
    answerIndex: 3,
    choiceNotes: <String>[
      'Cost is never mentioned, so price cannot explain why the pouch is a composite.',
      'Sealing is described as one job among four, and the passage never ranks the jobs by difficulty.',
      'The aluminium is given a technical reason, and no regulation is cited anywhere.',
      'The passage says outright that no single plastic can do all four jobs at once.',
    ],
    explanation:
        'The passage lists a job for each layer and then says outright that no '
        'single plastic can do all four at once, which is the only reason the '
        'package is a composite. Cost is never mentioned, sealing is described '
        'as one job among four rather than the hardest, and the aluminium is '
        'given a technical reason rather than a legal one.',
    difficulty: Difficulty.hard,
    skills: <String>['pc.inference'],
  ),
  Question(
    id: 'pc-y04',
    subtest: Subtest.pc,
    passage:
        'Before automation, a light was a post rather than a building. The '
        'keeper climbed at sunset, wound the clockwork that turned the lens, '
        'trimmed the wick, and recorded the weather every two hours until dawn. '
        'The work was dull, and the log shows how dull: one keeper in Maine '
        'counted barrels of oil because there was nothing else to count. When '
        'the relief boat was late by a week, the light still had to burn on the '
        'hour, so the keeper carried the duty through the night the fever went '
        'through the house.',
    stem: 'In the passage, the relief boat is the boat that',
    choices: <String>[
      'repairs the clockwork of the lens',
      'carries the oil to the light',
      'brings the next keeper out',
      'takes the weather log ashore',
    ],
    answerIndex: 2,
    choiceNotes: <String>[
      'No repair party appears, and the clockwork was wound by the keeper at sunset.',
      'Oil may travel on the same boat, but the word names the change of keeper rather than the cargo.',
      'A relief is a replacement, so the boat brings the keeper who takes over the watch.',
      'The log may go ashore on that boat, and the passage never says that it did.',
    ],
    explanation:
        'A relief is a replacement, so the relief boat brings the keeper who '
        'takes over the watch, and its lateness by a week is what forces the '
        'keeper to stay. Oil and the log may well travel on the same boat, but '
        'the word names the change of keeper, and no repair party is described.',
    difficulty: Difficulty.easy,
    skills: <String>['pc.vocabulary'],
  ),
  Question(
    id: 'pc-y05',
    subtest: Subtest.pc,
    passage:
        'The helmet worn by infantry for four decades was two helmets in one. '
        'The steel shell stopped fragments, and the liner inside it, moulded '
        'from laminated cloth, was the part that sat on the head. Crews behind '
        'the line wore the liner alone. The shell was given a rough textured '
        'finish because a smooth steel bowl caught the light and told an '
        'observer where the line was. The two parts were not designed together: '
        'the shell came first, and the liner was adopted afterwards to make a '
        'heavy steel bowl sit on a human head.',
    stem: 'What is the main purpose of the passage?',
    choices: <String>[
      'to explain why the helmet came in two parts',
      'to argue that steel is better than laminate',
      'to compare the helmet with modern designs',
      'to describe how the helmet was painted',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'Each part is given a job and the two were not designed together, which explains the arrangement.',
      'No argument about which material is better is made, and the liner is cloth inside steel.',
      'Modern designs are never mentioned, and the passage stays with the older helmet.',
      'The rough textured finish is mentioned as camouflage, not as a description of paintwork.',
    ],
    explanation:
        'The passage gives a job to each part and then says the two were not '
        'designed together, which explains the arrangement rather than praising '
        'it. The rough finish and the liner worn alone are details in service of '
        'that explanation, and no argument is made about which material is '
        'better.',
    difficulty: Difficulty.medium,
    skills: <String>['pc.purpose'],
  ),

  // --- EI: electronics information ----------------------------------------
  Question(
    id: 'ei-y01',
    subtest: Subtest.ei,
    stem:
        'Three 12 ohm resistors are connected in parallel across a 24 volt '
        'supply. What total current does the supply deliver?',
    choices: <String>['0.67 ampere', '2 amperes', '6 amperes', '18 amperes'],
    answerIndex: 2,
    choiceNotes: <String>[
      'The 0.67 figure treats the three 12-ohm resistors as a series string of 36 ohms.',
      'The 2 ampere figure is the current in a single branch, not the total the supply delivers.',
      'Each branch carries 24 volts over 12 ohms, or 2 amperes, and the three add to 6 amperes.',
      'The 18 ampere figure counts the 6-ampere total once per resistor, tripling the answer.',
    ],
    explanation:
        'In parallel every resistor sees the full 24 volts, so each branch '
        'carries 24 / 12 = 2 amperes and the three add to 6 amperes. The same '
        'figure comes from the equivalent resistance of 12 / 3 = 4 ohms and '
        '24 / 4. The 18 ampere option takes that same 6 amperes and counts it once '
        'for each resistor, 2 amperes is a single branch, and 0.67 ampere treats '
        'the three as a series string of 36 ohms.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.ohms', 'ei.circuits'],
  ),
  Question(
    id: 'ei-y02',
    subtest: Subtest.ei,
    stem:
        'Two 20 ohm resistors are connected in parallel across a 10 volt '
        'supply. How much current flows through each resistor?',
    choices: <String>['0.25 ampere', '0.5 ampere', '1 ampere', '2 amperes'],
    answerIndex: 1,
    choiceNotes: <String>[
      'The 0.25 figure halves the branch current again, as though the supply voltage were shared out.',
      'Each parallel branch sees the whole 10 volts, so each carries 10 over 20, or 0.5 ampere.',
      'The 1 ampere figure is the total the supply delivers, the sum of both branch currents.',
      'The 2 ampere figure divides 10 volts by the 5-ohm equivalent instead of the 20-ohm branch.',
    ],
    explanation:
        'Each parallel branch sees the whole supply voltage, so each resistor '
        'carries 10 / 20 = 0.5 ampere no matter what the other one is doing. '
        'The 1 ampere option is the total the supply delivers, found by adding '
        'the two branch currents, and 2 amperes comes from dividing 10 volts by '
        'the 5 ohm equivalent resistance as though the whole current passed '
        'through a single resistor.',
    difficulty: Difficulty.hard,
    skills: <String>['ei.circuits', 'ei.ohms'],
  ),
  Question(
    id: 'ei-y03',
    subtest: Subtest.ei,
    stem:
        'Which component stores energy in an electric field and blocks steady '
        'direct current while passing a changing signal?',
    choices: <String>['A resistor', 'A capacitor', 'A diode', 'An inductor'],
    answerIndex: 1,
    choiceNotes: <String>[
      'A resistor conducts steady current and changing current alike, storing nothing.',
      'Two plates separated by an insulator store charge in an electric field and pass only change.',
      'A diode conducts in one direction only, which is not the same as blocking steady current.',
      'An inductor also blocks steady current, but it stores energy in a magnetic field.',
    ],
    explanation:
        'A capacitor holds charge on two plates separated by an insulator, so a '
        'steady direct voltage charges it once and then stops, while a changing '
        'signal keeps charging and discharging it and appears to pass straight '
        'through. An inductor also stores energy and also blocks steady direct '
        'current, but it stores it in a magnetic field rather than an electric '
        'one, which is the distinction the item turns on. A resistor conducts in '
        'both cases, and a diode conducts in one direction only.',
    difficulty: Difficulty.easy,
    skills: <String>['ei.components'],
  ),
  Question(
    id: 'ei-y04',
    subtest: Subtest.ei,
    stem:
        'Before probing inside a power supply that has been switched off and '
        'unplugged, a technician bleeds the filter capacitor through a '
        'resistor. Why is this done?',
    choices: <String>[
      'A capacitor can hold a dangerous charge after power is removed',
      'The resistor shows whether the capacitor is still good',
      'It stops the capacitor drawing a surge on the next start',
      'It keeps the capacitor electrolyte from leaking out',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'A large electrolytic capacitor stays charged for minutes, and a hand across it can injure someone.',
      'The resistor is a bleeder, not a test instrument, and it proves nothing about the part.',
      'Limiting inrush on the next start is a different job from draining stored charge now.',
      'Bleeding charge has nothing to do with keeping electrolyte inside the can.',
    ],
    explanation:
        'A large electrolytic capacitor stays charged after the supply is dead, '
        'sometimes for many minutes, and a hand across its terminals is enough '
        'to injure someone. Bleeding it through a resistor releases that energy '
        'slowly instead of in a spark or through the body. The resistor is not '
        'there to test the part, to limit inrush current on the next start, or '
        'to prevent a leak.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.safety'],
  ),
  Question(
    id: 'ei-y05',
    subtest: Subtest.ei,
    stem:
        'A transformer has 200 turns on its primary winding and 50 turns on its '
        'secondary. If the primary is connected to 120 volts, what is the '
        'secondary voltage?',
    choices: <String>['30 volts', '60 volts', '240 volts', '480 volts'],
    answerIndex: 0,
    choiceNotes: <String>[
      'Fifty turns against 200 is a quarter, so 120 volts becomes 30 volts.',
      'The 60 volt figure treats the turns ratio as one half instead of one quarter.',
      'The 240 volt figure doubles the primary voltage, which ignores the step-down ratio entirely.',
      'The 480 volt figure multiplies by four, which is the turns ratio upside down.',
    ],
    explanation:
        'Voltage follows the turns ratio directly: 50 turns against 200 turns is '
        'one quarter, so 120 volts becomes 30 volts. The 480 volt option '
        'multiplies by four instead of dividing, which is the ratio upside down, '
        'and 60 volts treats the ratio as a half. A transformer trades voltage '
        'for current, so the secondary cannot deliver more energy than the '
        'primary supplied.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.systems'],
  ),

  // --- AS: auto and shop information --------------------------------------
  Question(
    id: 'as-y01',
    subtest: Subtest.as,
    stem: 'Why does a diesel engine ignite its fuel without a spark plug?',
    choices: <String>[
      'A glow plug fires on every stroke in each cylinder',
      'The injector adds a chemical igniter to the fuel',
      'The piston crown is shaped to throw a spark',
      'Compressed air is hot enough to ignite the fuel',
    ],
    answerIndex: 3,
    choiceNotes: <String>[
      'A glow plug warms the chamber for a cold start only, and it does not fire on every stroke.',
      'An injector meters and sprays the fuel, and it adds no igniter of any kind to it.',
      'Nothing in the cylinder makes a spark, and the crown is shaped to swirl the charge rather than strike one.',
      'Squeezing air alone heats it past the ignition point of the fuel, so the spray lights with no spark at all.',
    ],
    explanation:
        'A diesel draws in air alone and squeezes it far tighter than a petrol '
        'engine does, and that compression heats the air well above the ignition '
        'point of the fuel, which is sprayed in near the top of the stroke and '
        'lights as it meets the hot air. Glow plugs warm the chamber for a cold '
        'start only, an injector meters fuel rather than igniting it, and no '
        'spark is produced anywhere in the cylinder.',
    difficulty: Difficulty.medium,
    skills: <String>['as.engine'],
  ),
  Question(
    id: 'as-y02',
    subtest: Subtest.as,
    stem: 'What does the master cylinder do when the brake pedal is pressed?',
    choices: <String>[
      'It pulls the brake shoes away from the drums',
      'It lets air into the lines so the brakes apply',
      'It locks the driveshaft so the wheels cannot turn',
      'It pushes hydraulic fluid towards the wheel cylinders',
    ],
    answerIndex: 3,
    choiceNotes: <String>[
      'Pulling the shoes back is what the return springs do once the pedal is released.',
      'Air in the lines leaves the pedal spongy rather than applying the brakes harder.',
      'Locking the driveshaft is a parking brake or transmission pawl, not the master cylinder.',
      'The pedal piston forces fluid through the lines to the wheel cylinders, where pressure applies the brakes.',
    ],
    explanation:
        'The pedal drives a piston in the master cylinder, which forces fluid '
        'through the lines to the wheel cylinders, and there the pressure pushes '
        'the shoes or pads against the drum or disc. Pulling the shoes back is '
        'what the return springs do when the pedal is released, air in the lines '
        'makes the pedal spongy rather than applying the brakes, and locking the '
        'driveshaft is the job of a parking brake or a transmission pawl.',
    difficulty: Difficulty.medium,
    skills: <String>['as.drivetrain'],
  ),
  Question(
    id: 'as-y03',
    subtest: Subtest.as,
    stem:
        'Which fastener cuts its own thread as it is driven into sheet metal or '
        'plastic?',
    choices: <String>[
      'A carriage bolt',
      'A lag screw',
      'A machine screw',
      'A self-tapping screw',
    ],
    answerIndex: 3,
    choiceNotes: <String>[
      'A carriage bolt has a smooth shank with a square neck and needs a nut, so it cuts no thread.',
      'A lag screw is a heavy wood fastener driven into a pilot hole in timber rather than into sheet metal.',
      'A machine screw needs a pre-cut thread or a nut, so it cannot cut its own way in.',
      'A hardened point and coarse thread cut a matching thread in thin metal or plastic as it turns.',
    ],
    explanation:
        'A self-tapping screw has a hardened point and a coarse thread that cuts '
        'a matching thread in thin metal or plastic as it turns, so no nut or '
        'pre-cut thread is needed. A machine screw needs a threaded hole or a '
        'nut, a carriage bolt is a smooth-shanked bolt for wood and steel '
        'assemblies, and a lag screw is a heavy wood fastener driven into a '
        'pilot hole.',
    difficulty: Difficulty.easy,
    skills: <String>['as.materials'],
  ),
  Question(
    id: 'as-y04',
    subtest: Subtest.as,
    stem:
        'Which process joins two copper pipes by melting filler metal into the '
        'joint without melting the pipe ends?',
    choices: <String>[
      'Resistance welding',
      'Arc welding',
      'Brazing',
      'Oxy-acetylene welding',
    ],
    answerIndex: 2,
    choiceNotes: <String>[
      'Resistance welding passes current through the parts and fuses the parent metal itself.',
      'Arc welding melts the pipe ends along with the filler, which is exactly what this joint avoids.',
      'The filler melts below the melting point of the pipes and flows into the gap, leaving them solid.',
      'Oxy-acetylene welding fuses the parent metal, while this joint needs a filler that melts first.',
    ],
    explanation:
        'Brazing heats the joint until the filler flows into the gap by capillary '
        'action, and the filler melts at a lower temperature than the metals '
        'being joined, so the pipe ends stay solid throughout. Every welding '
        'process listed melts the parent metal as well, and that is exactly what '
        'separates welding from brazing and soldering.',
    difficulty: Difficulty.medium,
    skills: <String>['as.welding'],
  ),
  Question(
    id: 'as-y05',
    subtest: Subtest.as,
    stem:
        'Why is a foundation footing poured wider than the wall that stands on '
        'it?',
    choices: <String>[
      'It spreads the load over a larger area of soil',
      'It keeps groundwater out of the wall above',
      'It gives the masons a level surface to work from',
      'It lets the wall move when the ground freezes',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'Soil accepts only so much weight per square foot, so widening the bearing area cuts the pressure.',
      'Keeping groundwater out of the wall above is waterproofing and drainage work rather than a wider footing.',
      'A level surface is a convenience for the masons, and the footing is poured before they arrive.',
      'A footing is meant to hold the wall still, and letting frost move it is the fault it prevents.',
    ],
    explanation:
        'A wall carries its load down to the soil, and soil can only accept so '
        'much weight per square foot, so the footing widens the bearing area '
        'until the pressure falls within what the ground will support. '
        'Waterproofing is a separate detail, a level surface is a convenience '
        'rather than the purpose, and a footing is meant to hold the wall still '
        'instead of letting frost lift it.',
    difficulty: Difficulty.medium,
    skills: <String>['as.construction'],
  ),

  // --- MC: mechanical comprehension ---------------------------------------
  Question(
    id: 'mc-y01',
    subtest: Subtest.mc,
    stem:
        'A wheelbarrow carries a 240 pound load whose centre is 2 feet from the '
        'axle. The handles are 6 feet from the axle. What upward effort must be '
        'applied to the handles to hold the load clear of the ground?',
    choices: <String>['80 pounds', '120 pounds', '240 pounds', '480 pounds'],
    answerIndex: 0,
    choiceNotes: <String>[
      'The load sits between the axle and the hands, so 240 lb times 2 ft over the 6 ft arm gives 80 lb.',
      'One hundred twenty divides the load by its own 2 ft arm instead of by the 6 ft handle arm.',
      'Two hundred forty applies no lever at all, as if the loaded tray rested over the hands.',
      'Four hundred eighty multiplies 240 lb by the 2 ft arm and leaves the handle arm out of the sum.',
    ],
    explanation:
        'The axle is the pivot and the load sits between the pivot and the '
        'effort, so effort times its arm equals load times its arm: effort x 6 = '
        '240 x 2, and the effort is 80 pounds. The 120 pound option divides the '
        'load by its own arm instead of by the longer handle arm, 480 pounds '
        'multiplies the load by that arm, which is the ratio the wrong way up, '
        'and 240 pounds ignores the lever altogether.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.levers'],
    figure: Sketch(
      caption:
          'A bar carried on a small wheel at its left end, with a 240 pound load '
          'standing two feet from the wheel and an upward effort arrow at the '
          'handles six feet from it.',
      prims: <SketchPrim>[
        SketchPrim.line(Pt(0.12, 0.56), Pt(0.90, 0.56), weight: 6),
        SketchPrim.circle(Pt(0.12, 0.68), 0.07),
        SketchPrim.box(Pt(0.24, 0.36), Pt(0.42, 0.54)),
        SketchPrim.arrow(Pt(0.80, 0.50), Pt(0.80, 0.28)),
        SketchPrim.text('240 lb', Pt(0.33, 0.28)),
        SketchPrim.text('2 ft', Pt(0.26, 0.82)),
        SketchPrim.text('6 ft', Pt(0.60, 0.82)),
        SketchPrim.text('?', Pt(0.80, 0.21)),
      ],
    ),
  ),
  Question(
    id: 'mc-y02',
    subtest: Subtest.mc,
    stem:
        'A single movable pulley carries a 200 pound load and the free end of '
        'its rope is pulled straight up. What effort holds the load steady?',
    choices: <String>['50 pounds', '100 pounds', '200 pounds', '400 pounds'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Fifty divides by four, as though two movable pulleys shared the load between four sections.',
      'Two rope sections both point upward on this block, so the load is shared and the effort is half of it.',
      'Two hundred ignores the second section, which is what a single fixed pulley would demand.',
      'Four hundred doubles the load, which comes from adding the tension in both rope ends into one pull.',
    ],
    explanation:
        'A movable pulley hangs on two rope sections that both point upward, so '
        'the load is shared between them and the effort is half of it, or 100 '
        'pounds. The 200 pound option ignores the second section, which is what '
        'a fixed pulley would demand, and 50 pounds divides by four as though '
        'there were two movable pulleys in the system.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pulleys'],
    figure: Sketch(
      caption:
          'A movable pulley with two rope sections rising to a fixed support, a '
          'load hanging from the pulley block and an effort arrow on the free '
          'end of the rope.',
      prims: <SketchPrim>[
        SketchPrim.line(Pt(0.10, 0.10), Pt(0.90, 0.10), weight: 4),
        SketchPrim.line(Pt(0.34, 0.10), Pt(0.34, 0.44)),
        SketchPrim.line(Pt(0.50, 0.10), Pt(0.50, 0.44)),
        SketchPrim.circle(Pt(0.42, 0.50), 0.09),
        SketchPrim.line(Pt(0.42, 0.59), Pt(0.42, 0.66), weight: 3),
        SketchPrim.box(Pt(0.33, 0.66), Pt(0.51, 0.82)),
        SketchPrim.arrow(Pt(0.62, 0.32), Pt(0.62, 0.14)),
        SketchPrim.text('200 lb', Pt(0.42, 0.88)),
        SketchPrim.text('?', Pt(0.72, 0.24)),
      ],
    ),
  ),
  Question(
    id: 'mc-y03',
    subtest: Subtest.mc,
    stem:
        'A loaded truck needs a longer distance to stop than the same truck '
        'empty at the same speed because',
    choices: <String>[
      'its brakes are hotter and less effective',
      'its greater mass carries more momentum',
      'its tyres have more rubber touching down',
      'its engine is still pushing it forward',
    ],
    answerIndex: 1,
    choiceNotes: <String>[
      'Hot brakes follow repeated stops and do not explain a longer stop from the same speed.',
      'Momentum grows with mass, so the heavier truck needs more braking work spread over a longer distance.',
      'A larger contact patch does not raise the grip available, so it cannot explain the extra distance.',
      'The engine is off the drive while braking, and coasting does not stretch the stop this way.',
    ],
    explanation:
        'Stopping distance is set by the work the brakes must do to take the '
        'motion away, and momentum grows with mass, so the heavier truck at the '
        'same speed needs a larger braking force applied over a longer distance. '
        'Hot brakes are a consequence of repeated stops rather than the cause '
        'here, and a larger contact patch does not change the grip available.',
    difficulty: Difficulty.easy,
    skills: <String>['mc.motion'],
  ),
  Question(
    id: 'mc-y04',
    subtest: Subtest.mc,
    stem:
        'A 12 tooth gear drives a 36 tooth gear. How many complete turns does '
        'the larger gear make for every three turns of the smaller one?',
    choices: <String>['1', '3', '9', '12'],
    answerIndex: 0,
    choiceNotes: <String>[
      'The large gear runs at a third of the small gear speed, so three turns of the 12 tooth gear make one.',
      'Three copies the small gear tooth count across, as though the pair turned together.',
      'Nine multiplies three turns by the three to one ratio where the larger gear divides by it.',
      'Twelve copies the small gear tooth count as if it were a number of turns.',
    ],
    explanation:
        'Meshed gears turn at speeds in inverse proportion to their tooth '
        'counts, so the large gear runs at a third of the small gear speed: '
        'three turns of the 12 tooth gear turn the 36 tooth gear just once. The '
        '9 option multiplies three by the three to one ratio instead of '
        'dividing, 3 hands the small gear count straight across as though the '
        'pair turned together, and 12 copies the tooth count of the small gear '
        'as though it were a number of turns.',
    difficulty: Difficulty.hard,
    skills: <String>['mc.pulleys'],
    figure: Sketch(
      caption:
          'Two meshed gears, a small gear with twelve teeth on the left driving '
          'a large gear with thirty-six teeth on the right, with a question mark '
          'above the large gear.',
      prims: <SketchPrim>[
        SketchPrim.circle(Pt(0.30, 0.50), 0.12),
        SketchPrim.circle(Pt(0.62, 0.50), 0.20),
        SketchPrim.text('12', Pt(0.24, 0.84)),
        SketchPrim.text('36', Pt(0.62, 0.90)),
        SketchPrim.text('?', Pt(0.62, 0.20)),
      ],
    ),
  ),
  Question(
    id: 'mc-y05',
    subtest: Subtest.mc,
    stem:
        'A 500 pound crate rests on a 10 foot skid carried at both ends. Its '
        'centre of gravity is 4 feet from the left end. What load does the left '
        'end carry?',
    choices: <String>['200 pounds', '250 pounds', '300 pounds', '500 pounds'],
    answerIndex: 2,
    choiceNotes: <String>[
      'Two hundred is the far end share, which comes from using the 6 ft distance instead of the nearer 4 ft.',
      'Two hundred fifty is right only when the crate sits exactly in the middle of the skid.',
      'Taking moments about the right end, 500 lb times the 6 ft distance over 10 ft gives 300 lb at the near end.',
      'Five hundred puts the whole load on one end, which leaves the other support carrying nothing.',
    ],
    explanation:
        'The two ends share the load in inverse proportion to the distance, so '
        'the end nearer the crate takes the larger share: 500 x 6 / 10 = 300 '
        'pounds, taking moments about the right end. The 200 pound option is the '
        'far end, produced by using the nearer distance by mistake, and 250 '
        'pounds is right only when the crate sits exactly in the middle.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.structure'],
    figure: Sketch(
      caption:
          'A 500 pound crate standing on a 10 foot skid that rests on supports at '
          'both ends, with the centre of gravity marked four feet from the left '
          'support and a question mark under it.',
      prims: <SketchPrim>[
        SketchPrim.line(Pt(0.10, 0.48), Pt(0.90, 0.48), weight: 6),
        SketchPrim.triangle(Pt(0.14, 0.48), Pt(0.09, 0.62), Pt(0.19, 0.62)),
        SketchPrim.triangle(Pt(0.86, 0.48), Pt(0.81, 0.62), Pt(0.91, 0.62)),
        SketchPrim.box(Pt(0.34, 0.24), Pt(0.56, 0.44)),
        SketchPrim.text('?', Pt(0.14, 0.74)),
        SketchPrim.text('4 ft', Pt(0.28, 0.74)),
        SketchPrim.text('6 ft', Pt(0.66, 0.74)),
        SketchPrim.text('500 lb', Pt(0.45, 0.15)),
      ],
    ),
  ),

  // --- AO: assembling objects ---------------------------------------------
  Question(
    id: 'ao-y01',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 1,
    explanation:
        'Only the second figure can be built. Figure A lays the two-cell piece '
        'across the square so the pieces share a cell, Figure C replaces the '
        'two-cell piece with a three-cell bar that is not in the set, and Figure '
        'D sets the two-cell piece two cells clear of the square so the parts '
        'never join.',
    difficulty: Difficulty.easy,
    skills: <String>['ao.assembly', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('11/11'), _p('11')],
      options: <List<Poly>>[
        <Poly>[_p('11/11'), _p('11').at(1, 0)],
        <Poly>[_p('11/11'), _p('11').at(2, 0)],
        <Poly>[_p('11/11'), _p('111').at(2, 0)],
        <Poly>[_p('11/11'), _p('11').at(3, 0)],
      ],
    ),
  ),
  Question(
    id: 'ao-y02',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 2,
    explanation:
        'Figure C seats the square against the flat side of the L, so the two '
        'share an edge and nothing overlaps. Figure A swaps the L for its mirror '
        'image, which no rotation can produce, Figure B drops the square onto '
        'cells the L already fills, and Figure D parks it beyond the end of the '
        'L foot, leaving two separate bodies.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.rotation', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('11/11'), _p('10/10/11')],
      options: <List<Poly>>[
        <Poly>[_p('01/01/11'), _p('11/11').at(1, 0)],
        <Poly>[_p('10/10/11'), _p('11/11').at(0, 1)],
        <Poly>[_p('10/10/11'), _p('11/11').at(1, 0)],
        <Poly>[_p('10/10/11'), _p('11/11').at(2, 0)],
      ],
    ),
  ),
  Question(
    id: 'ao-y03',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 3,
    explanation:
        'Figure D tucks the two-cell piece against the low end of the zig-zag, '
        'and the two pieces join with no overlap. Figure A drops it a row clear '
        'so the parts never touch, Figure B lays it across cells the zig-zag '
        'already uses, and Figure C puts a single cell in place of the two-cell '
        'piece.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.assembly', 'ao.rotation'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('011/110'), _p('11')],
      options: <List<Poly>>[
        <Poly>[_p('011/110'), _p('11').at(0, 3)],
        <Poly>[_p('011/110'), _p('11').at(2, 0)],
        <Poly>[_p('011/110'), _p('10').at(0, 2)],
        <Poly>[_p('011/110'), _p('11').at(2, 1)],
      ],
    ),
  ),
  Question(
    id: 'ao-y04',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 1,
    explanation:
        'Figure B builds one solid block: the bar lies across the middle with a '
        'two-cell piece above it and the other below. Figure A stacks a two-cell '
        'piece onto a cell the bar already occupies, Figure C substitutes a '
        'three-cell corner, and Figure D leaves the third piece two cells clear '
        'of the rest.',
    difficulty: Difficulty.hard,
    skills: <String>['ao.pieces', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('111'), _p('11'), _p('11')],
      options: <List<Poly>>[
        <Poly>[_p('111').at(0, 1), _p('11').at(0, 2), _p('11').at(1, 1)],
        <Poly>[_p('111').at(0, 1), _p('11').at(0, 2), _p('11').at(0, 0)],
        <Poly>[_p('111').at(0, 1), _p('11').at(0, 2), _p('10/11').at(0, 0)],
        <Poly>[_p('111').at(0, 1), _p('11').at(0, 2), _p('11').at(4, 1)],
      ],
    ),
  ),
  Question(
    id: 'ao-y05',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 1,
    explanation:
        'Figure B hangs the square under one end of the long bar, so the pieces '
        'join along a full edge with nothing doubled up. Figure A puts the '
        'square three cells clear of the bar and the figure falls into two '
        'parts, Figure C drives the square into the middle of the bar, and '
        'Figure D substitutes a T-shaped piece for the square.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.assembly', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('1111'), _p('11/11')],
      options: <List<Poly>>[
        <Poly>[_p('1111').at(0, 1), _p('11/11').at(5, 1)],
        <Poly>[_p('1111').at(0, 1), _p('11/11').at(0, 2)],
        <Poly>[_p('1111').at(0, 1), _p('11/11').at(1, 0)],
        <Poly>[_p('1111').at(0, 1), _p('111/010').at(0, 2)],
      ],
    ),
  ),
];
