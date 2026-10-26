import '../models/catalog.dart';
import '../models/question.dart';

/// Depth for the skills the audit reports as thinnest.
///
/// A drill or a mastery check on a skill with two items behind it is a
/// worksheet, not a test: the candidate meets the same two questions, learns
/// their answers, and mistakes recognition for understanding. Each skill below
/// gets two more items, written against the style guide and aimed at the
/// mistake that skill exists to catch.
///
/// Two items per skill is not depth for its own sake: every one of these is a
/// skill a real candidate is weak in, drawn from the test-taker evidence in
/// docs/research.
const List<Question> skillDepthBank = <Question>[
  // --- MC: properties of materials ---------------------------------------
  Question(
    id: 'mc-d01',
    subtest: Subtest.mc,
    stem:
        'A lathe bed is cast in iron rather than built up from steel plate. What '
        'does cast iron give the machine that a steel plate does not?',
    choices: <String>[
      'It damps vibration instead of ringing like a plate',
      'It expands less when the shop warms up',
      'It does not rust, so no paint or oil is needed',
      'It is lighter for the same stiffness',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'Graphite flakes in the iron absorb vibration energy, so a cut that would ring a steel plate dies away.',
      'Thermal expansion is much the same for both metals, so shop warmth affects them alike.',
      'Bare cast iron rusts readily, so paint or oil is still needed on a machine bed.',
      'For the same stiffness iron is heavier than steel, not lighter.',
    ],
    explanation:
        'Cast iron carries its carbon as flakes of graphite, and those flakes '
        'absorb vibration energy, so a cut that would set a steel plate ringing '
        'dies away in an iron bed and the finish stays clean. Thermal expansion is '
        'much the same for both metals, bare cast iron rusts readily, and for the '
        'same stiffness iron is heavier than steel, not lighter.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.materials'],
  ),
  Question(
    id: 'mc-d02',
    subtest: Subtest.mc,
    stem:
        'A galvanised steel guard rail is still protected where the zinc has been '
        'scratched through to bare steel. Why?',
    choices: <String>[
      'Zinc corrodes in preference to the steel',
      'The zinc oxide grows back over the scratch',
      'The steel under the zinc is a different alloy',
      'The scratch is too narrow for water to reach',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'Zinc is the more active metal, so at the damage it becomes the anode and corrodes while the steel stays sound.',
      'Zinc oxide is porous and seals nothing, and the protection comes from corrosion rather than from regrowth.',
      'The steel under the coating is ordinary steel, and only the activity of the zinc protects it.',
      'Water reaches a scratch of any width, so the protection has to work in spite of the water.',
    ],
    explanation:
        'Zinc is the more active metal, so where both are exposed to moisture the '
        'zinc becomes the anode and corrodes while the steel stays cathodic and '
        'untouched: the coating sacrifices itself a little way either side of the '
        'damage. Zinc oxide is porous and does not seal anything, the steel '
        'beneath is ordinary steel, and water reaches a scratch of any width.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.materials'],
  ),

  // --- PC: sequence and technique ----------------------------------------
  Question(
    id: 'pc-d01',
    subtest: Subtest.pc,
    passage:
        'A cylinder head is pulled down in stages rather than at full torque in '
        'one pass. Start at the centre and work outward, bringing every fastener '
        'to a third of the specified figure, then to two thirds, and only then to '
        'the full figure. Torque settings are quoted for clean, lightly oiled '
        'threads: a dry thread reads low on the wrench while the fastener is '
        'already stretched. Where the manual gives a sequence, follow it exactly, '
        'because a head pulled down from one end cocks slightly on its dowels and '
        'leaks at the far end.',
    stem:
        'According to the passage, what happens next once every fastener has '
        'reached two thirds of the specified torque?',
    choices: <String>[
      'They are taken to full torque',
      'The head is lifted to check the gasket for a cocked seal',
      'The threads are dried before the final pass on the wrench',
      'The whole sequence is repeated from the far end',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'The passage sets three passes, a third then two thirds then the full figure.',
      'Nothing is lifted once the sequence has begun, because that undoes the seating already made.',
      'Threads are meant to be lightly oiled, and drying them is never part of the sequence at all.',
      'Every pass runs from the centre outward, and repeating from the far end would cock the head.',
    ],
    explanation:
        'The passage sets out three passes in a fixed order: a third, then two '
        'thirds, then the full figure, always from the centre outward. Nothing is '
        'lifted once the sequence has begun, because that undoes the seating the '
        'first two passes produced, and the threads are supposed to be lightly '
        'oiled rather than dried.',
    difficulty: Difficulty.medium,
    skills: <String>['pc.sequence'],
  ),
  Question(
    id: 'pc-d02',
    subtest: Subtest.pc,
    passage:
        'A cooling system that loses a cupful of coolant a week will not overheat '
        'for months, which is why the loss is easy to ignore. As the level drops, '
        'the top of the radiator core stops being covered, and that metal runs '
        'hotter than the rest of the engine. The hottest metal expands against '
        'the coldest, the solder seam at the tank begins to work, and a small leak '
        'becomes a steady one. By the time the gauge climbs, the original fault is '
        'buried under a much larger one.',
    stem: 'According to the passage, why does the original fault become hard to find?',
    choices: <String>[
      'The heat works the seam until the leak is far larger',
      'The coolant level rises again once the engine is hot',
      'The temperature gauge fails before it can report a change',
      'The solder seals itself as the tank expands',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'The chain runs from the uncovered core running hot to the seam working and the leak growing.',
      'The level keeps dropping, and nothing in the passage has it rising again once the engine is hot.',
      'The gauge is what finally reports the trouble, and no failure of it is described.',
      'The seam works open rather than sealing, and expansion against cold metal is what breaks it.',
    ],
    explanation:
        'The passage traces a chain: the level falls, the uncovered core runs hot, '
        'hot metal works against cold metal, the seam fails, and the leak grows. '
        'The fault a mechanic finally finds is therefore the damaged seam, and the '
        'slow loss that started it has been overtaken by something much more '
        'obvious.',
    difficulty: Difficulty.hard,
    skills: <String>['pc.sequence'],
  ),

  // --- PC: vocabulary in context ------------------------------------------
  Question(
    id: 'pc-d03',
    subtest: Subtest.pc,
    passage:
        'Timber for a door frame is bought seasoned, not green. A green board is '
        'full of water: it is heavy, it cuts woolly, and once it is fixed into a '
        'warm building it shrinks across the grain, so a frame that was tight in '
        'March has opened a gap at the joints by Christmas. Seasoning costs time '
        'and money, which is why it is the first thing a cheap quote leaves out.',
    stem: "As used in the passage, the word 'seasoned' most nearly means",
    choices: <String>[
      'Dried until it is stable',
      'Treated against rot and insects',
      'Cut from a mature tree rather than a young one',
      'Left standing outdoors through one winter',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'The passage explains it by its consequence, since the water is taken out so the timber stops shrinking.',
      'Rot treatment is a different process, and nothing in the passage mentions insects.',
      'The age of the tree is not discussed, and seasoning happens after the timber has been cut.',
      'Standing outdoors is not described, and seasoning here is a deliberate treatment rather than exposure.',
    ],
    explanation:
        'The passage explains the word by its consequence: a green board is full of '
        'water, and seasoning is what takes the water out so the timber stops '
        'shrinking. Rot treatment, the age of the tree and a winter outdoors all '
        'belong to other ideas; nothing in the passage mentions any of them.',
    difficulty: Difficulty.medium,
    skills: <String>['pc.vocabulary'],
  ),
  Question(
    id: 'pc-d04',
    subtest: Subtest.pc,
    passage:
        'The first sign that a plank has been dried too quickly is a set of fine '
        'cracks running along the end grain, which mill hands call checks. They '
        'begin as hair lines and open as the outside of the board shrinks faster '
        'than its core, and once they run the full thickness the plank is fit only '
        'for rough work. A slower kiln schedule costs days; a checked plank costs '
        'the whole board.',
    stem: 'In the passage, the word checks refers to',
    choices: <String>[
      'Small cracks in the wood',
      'Tests of the moisture in the board',
      'Marks left where the saw has passed',
      'Warping across the width of a plank',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'The passage names the cracks first and then gives them the trade name, hair lines opening to full thickness.',
      'Moisture is what caused the cracks, and the word names the cracks themselves.',
      'Saw marks are a different feature, and these lines run along the end grain of the board.',
      'Warping is another failure, and checks are described as cracks running along the grain.',
    ],
    explanation:
        'The passage names the cracks first and then gives them the name the trade '
        'uses, which is all a vocabulary-in-context question needs: they are hair '
        'lines that open to the full thickness. Moisture is what caused them, the '
        'saw leaves marks elsewhere, and warping is a different failure.',
    difficulty: Difficulty.medium,
    skills: <String>['pc.vocabulary'],
  ),

  // --- EI: electrical systems ---------------------------------------------
  Question(
    id: 'ei-d01',
    subtest: Subtest.ei,
    stem: 'Why is the metal case of a shop machine tool bonded to earth?',
    choices: <String>[
      'So a fault to the case trips the supply instead of waiting in the metal',
      'So the case runs cooler when the motor is loaded',
      'So static charge cannot build up on the paintwork',
      'So the motor draws less current when it starts',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'Earth gives fault current a low-resistance path, so a fuse blows or a breaker trips.',
      'Bonding carries no load current, so it cannot change how warm the case runs.',
      'Paint is an insulator and static is not what the earth conductor addresses.',
      'Starting current is set by the motor winding, not by the case connection.',
    ],
    explanation:
        'If a live conductor touches the case, the earth connection gives the '
        'fault current a low-resistance path back to the supply, so enough current '
        'flows to blow the fuse or trip the breaker and the case is never left '
        'sitting at a dangerous potential. Earthing has nothing to do with '
        'temperature, with paint, or with starting current.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.systems'],
  ),
  Question(
    id: 'ei-d02',
    subtest: Subtest.ei,
    stem: 'Two 12 volt 100 ampere-hour batteries are wired in series. What does the pair provide?',
    choices: <String>[
      '24 volts at 100 ampere-hours',
      '12 volts at 200 ampere-hours',
      '24 volts at 200 ampere-hours',
      '6 volts at 100 ampere-hours',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'Series adds the voltages and leaves the capacity alone, since the same current passes both.',
      'The 12 volt 200 ampere-hour pair is the parallel result, which doubles capacity instead.',
      'The 24 volt 200 ampere-hour figure adds both quantities, which no connection does.',
      'The 6 volt figure halves the voltage, as though the batteries opposed each other.',
    ],
    explanation:
        'In series the voltages add and the current capacity does not change, '
        'because the same current passes through both batteries one after the '
        'other: two 12 volt 100 ampere-hour batteries give 24 volts at 100 '
        'ampere-hours. It is parallel connection that doubles the ampere-hours '
        'and leaves the voltage at 12.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.systems'],
  ),

  // --- AS: automotive electrical and ignition -----------------------------
  Question(
    id: 'as-d01',
    subtest: Subtest.as,
    stem: 'What is the alternator doing while the engine is running?',
    choices: <String>[
      'Charging the battery and carrying the electrical loads',
      'Storing the energy that the next start will need',
      'Stepping the battery voltage down for the lamps',
      'Setting the moment of the spark in each cylinder',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'The running alternator feeds the ignition, lamps and accessories and puts back what the starter took.',
      'Storing the energy for the next start is the battery job, and the alternator only makes current.',
      'Stepping voltage down for the lamps happens elsewhere, while the alternator regulates near fourteen volts.',
      'The moment of the spark is set by the ignition system rather than by the charging circuit.',
    ],
    explanation:
        'Once the engine runs, the alternator supplies the ignition, lamps and '
        'accessories and puts back what the starter took, with a regulator holding '
        'its output near fourteen volts. Storing energy is the battery job, any '
        'stepping down for the lamps is done elsewhere, and the spark is timed by '
        'the ignition system.',
    difficulty: Difficulty.medium,
    skills: <String>['as.electrical'],
  ),
  Question(
    id: 'as-d02',
    subtest: Subtest.as,
    stem:
        'A starter motor draws several hundred amperes where a headlamp draws a '
        'few. Why?',
    choices: <String>[
      'It must make a large torque from only twelve volts',
      'It is the only component wired straight to the battery',
      'It runs on alternating current from the alternator',
      'It has no fuse, so the current is not limited',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'With only twelve volts to work from, turning a cold engine takes a very large current to make torque.',
      'Headlamps are wired to the battery as well, so the direct connection explains nothing about the current.',
      'The starter runs on direct current, and the alternator rectifies its own output for the same reason.',
      'Having no fuse limits nothing, and the large current follows from the load the motor drives.',
    ],
    explanation:
        'Electrical power is voltage multiplied by current, and with only twelve '
        'volts available the starter needs a very large current to produce the '
        'torque that turns a cold engine against its compression, which is why its '
        'cables are as thick as a finger. Headlamps are wired to the battery as '
        'well, the starter runs on direct current, and having no fuse limits '
        'nothing.',
    difficulty: Difficulty.hard,
    skills: <String>['as.electrical'],
  ),

  // --- AS: construction and building --------------------------------------
  Question(
    id: 'as-d03',
    subtest: Subtest.as,
    stem:
        'Why are the studs in a wood frame wall set sixteen inches on centre?',
    choices: <String>[
      'Sheathing four feet wide then lands on a stud at every edge',
      'Sixteen inches is the furthest a two-by-four can span',
      'It leaves room for insulation bats one foot wide',
      'Codes count studs rather than measuring the wall',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'Sheet goods come four feet wide, and four feet is three bays of sixteen inches so seams land on a stud.',
      'A two-by-four spans further than sixteen inches in most walls, so the spacing is not a span limit.',
      'Insulation bats are cut to match the spacing, so the spacing is not set by the bats.',
      'Spacing is set for sheathing edges and for load, not for counting the studs in a wall.',
    ],
    explanation:
        'Sheet goods come four feet wide, and four feet is three bays of sixteen '
        'inches, so a sheet breaks on a stud wherever it starts. A two-by-four '
        'will span further than that in most walls, insulation bats are cut to '
        'match the spacing rather than the other way round, and codes set the '
        'spacing for the sheathing and the load, not for counting pieces.',
    difficulty: Difficulty.medium,
    skills: <String>['as.construction'],
  ),
  Question(
    id: 'as-d04',
    subtest: Subtest.as,
    stem: 'Why is a concrete floor slab reinforced with steel near its underside?',
    choices: <String>[
      'Concrete is strong in compression but weak in tension',
      'Steel slows the rate at which the concrete sets',
      'The bars carry the weight of the slab on their own',
      'Steel draws heat out of the slab in winter',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'Concrete resists squeezing far better than pulling, so bars near the lower face take the tension.',
      'Steel does not change curing time, and the bars are placed for what happens under load.',
      'The bars add weight and take tension rather than supporting the slab on their own.',
      'Heat flow has nothing to do with why the bars sit low, where a spanning slab is stretched.',
    ],
    explanation:
        'Concrete resists being squeezed far better than being pulled, and a slab '
        'spanning between supports is stretched across its lower face, so the bars '
        'take the tension the concrete cannot. Steel does not change curing time, '
        'the bars add weight rather than carrying it, and heat flow is not why '
        'they are placed low in the slab.',
    difficulty: Difficulty.medium,
    skills: <String>['as.construction'],
  ),

  // --- AS: drivetrain, brakes and suspension ------------------------------
  Question(
    id: 'as-d05',
    subtest: Subtest.as,
    stem: 'What does the differential do while a car turns a corner?',
    choices: <String>[
      'It lets the outer wheel turn faster than the inner one',
      'It holds both driven wheels at exactly the same speed',
      'It changes the gear ratio as road speed rises',
      'It disconnects the drive whenever a wheel slips',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'The outer wheel travels a longer path, so the gearing lets each wheel turn at its own speed while driving both.',
      'A solid axle would hold both wheels at one speed and scrub a tyre through every turn.',
      'The differential ratio is fixed, and changing ratio as speed rises is the transmission job.',
      'A slipping wheel spins faster rather than being disconnected, and drive stays on both sides.',
    ],
    explanation:
        'The outer wheel travels a longer path than the inner one in a turn, and a '
        'solid axle would make one tyre scrub; the differential gearing lets each '
        'driven wheel run at its own speed while still driving both. Changing the '
        'ratio is the transmission job, and a wheel that slips spins faster rather '
        'than being disconnected.',
    difficulty: Difficulty.medium,
    skills: <String>['as.drivetrain'],
  ),
  Question(
    id: 'as-d06',
    subtest: Subtest.as,
    stem: 'What causes brake fade on a long descent?',
    choices: <String>[
      'Heat builds until the linings lose friction on the drum',
      'The linings wear thin enough to stop touching the drum',
      'The drums expand away from the shoes as they cool',
      'The return springs pull the shoes clear of the drum',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'Heat builds faster than the drums can shed it, and the lining loses friction once it is hot enough.',
      'Worn linings are a separate fault, and fade arrives on a long descent with the pedal still firm.',
      'Drums expand with heat rather than cool on a descent, and fade comes from the lining surface.',
      'The return springs retract the shoes when the pedal is released, and they do not cause fade.',
    ],
    explanation:
        'Repeated braking turns motion into heat faster than the drums and linings '
        'can shed it, and once the lining surface gets hot enough its friction '
        'falls away, so the pedal feels normal and the car keeps rolling. Worn '
        'linings are a different fault, and the springs exist to retract the shoes '
        'when the pedal is released.',
    difficulty: Difficulty.hard,
    skills: <String>['as.drivetrain'],
  ),

  // --- AR: averages and totals --------------------------------------------
  Question(
    id: 'ar-d01',
    subtest: Subtest.ar,
    stem:
        'Jenna has scored 78 and 86 on two practice tests. What must she score on '
        'the third to average exactly 84 across the three?',
    choices: <String>['88', '86', '84', '90'],
    answerIndex: 0,
    choiceNotes: <String>[
      'Three tests at 84 need 252 points, and 252 - 164 = 88 for the third test.',
      'Repeating the second score of 86 leaves the average at 83.3, below the target 84.',
      '84 is the target average itself, assuming the first two scores already average it.',
      '90 overshoots: (78 + 86 + 90) / 3 = 84.67, above the 84 the item asks for.',
    ],
    explanation:
        'Work back from the average to the total the three scores have to reach: '
        '3 x 84 = 252. The first two tests already account for 78 + 86 = 164, so '
        'the third has to be 252 - 164 = 88. Answering 84 averages the target with '
        'the two scores instead of finding the total.',
    difficulty: Difficulty.medium,
    skills: <String>['ar.average'],
  ),
  Question(
    id: 'ar-d02',
    subtest: Subtest.ar,
    stem:
        'Eight soldiers average 92 on a fitness test and twelve average 82. What '
        'is the average score of all twenty?',
    choices: <String>['86', '87', '84', '85'],
    answerIndex: 0,
    choiceNotes: <String>[
      'The totals are 8 x 92 = 736 and 12 x 82 = 984, and 1,720 / 20 = 86.',
      'Averaging 92 and 82 gives 87, weighting the two groups equally despite their sizes.',
      'Mis-adding the group totals to 1,680 instead of 1,720 divides to 84, forty points short.',
      'Losing 20 points across the totals gives 1,700 / 20 = 85, a small arithmetic slip.',
    ],
    explanation:
        'Averaging 92 and 82 gives 87, which is the trap: it weights the two '
        'groups equally when one has twelve soldiers and the other has eight. Find '
        'the totals first, 8 x 92 = 736 and 12 x 82 = 984, add them to 1720, and '
        'divide by the twenty soldiers to get 86.',
    difficulty: Difficulty.hard,
    skills: <String>['ar.average'],
  ),
];
