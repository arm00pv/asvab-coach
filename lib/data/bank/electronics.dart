import '../models/catalog.dart';
import '../models/question.dart';

/// Electronics Information bank: 20 items covering Ohm law and power math,
/// series and parallel circuits, components and symbols, and shop safety.
const List<Question> electronicsBank = <Question>[
  Question(
    id: 'ei-001',
    subtest: Subtest.ei,
    stem: 'A 20-ohm resistor carries a current of 3 amperes. What is the voltage across it?',
    choices: <String>['60 volts', '6.7 volts', '23 volts', '0.15 volt'],
    answerIndex: 0,
    choiceNotes: <String>[
      'Ohm law as V equals I times R gives 3 amperes times 20 ohms, or 60 volts.',
      'The 6.7 figure divides the resistance by the current, which is the wrong form of Ohm law here.',
      'The 23 figure adds the two numbers, which has no electrical meaning at all.',
      'The 0.15 figure divides the current by the resistance instead of multiplying them.',
    ],
    explanation:
        'Ohm law in the form V equals I times R gives 3 amperes times 20 ohms, or 60 '
        'volts. Adding the two numbers instead gives a meaningless 23, and dividing 20 by 3 '
        'gives the 6.7 volt option. The tiny 0.15 volt answer comes from dividing the current by '
        'the resistance rather than multiplying.',
    difficulty: Difficulty.easy,
    skills: <String>['ei.ohms'],
  ),
  Question(
    id: 'ei-002',
    subtest: Subtest.ei,
    stem: 'A 12-volt battery is connected across a 4-ohm resistor. What current flows?',
    choices: <String>['48 amperes', '0.33 ampere', '3 amperes', '16 amperes'],
    answerIndex: 2,
    choiceNotes: <String>[
      'The 48 figure multiplies 12 by 4, which is not how current is found.',
      'The 0.33 figure divides 4 by 12 instead of 12 by 4, inverting the ratio.',
      'I equals V over R, so 12 volts divided by 4 ohms is 3 amperes.',
      'The 16 figure adds the two values, which mixes volts with ohms and yields nothing meaningful.',
    ],
    explanation:
        'Rearranging Ohm law gives I equals V divided by R, so 12 volts divided by 4 '
        'ohms is 3 amperes. Multiplying the two values instead gives 48, which is not a current '
        'at all. The 0.33 ampere option comes from dividing 4 by 12 instead of 12 by 4.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.ohms'],
  ),
  Question(
    id: 'ei-003',
    subtest: Subtest.ei,
    stem: 'A small lamp draws 0.5 ampere from a 24-volt supply. What is its resistance?',
    choices: <String>['12 ohms', '48 ohms', '24.5 ohms', '0.02 ohm'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Multiplying 24 by 0.5 gives 12, but that product is the power in watts, not the resistance.',
      'Resistance is voltage over current, so 24 volts divided by 0.5 ampere is 48 ohms.',
      'The 24.5 figure adds the two numbers, which is meaningless because the units differ.',
      'The 0.02 figure divides 0.5 by 24, turning the formula upside down.',
    ],
    explanation:
        'Resistance is voltage divided by current: 24 volts divided by 0.5 ampere is 48 '
        'ohms. Multiplying 24 by 0.5 gives 12, but that is the power in watts, not the '
        'resistance. Dividing 0.5 by 24 gives the 0.02 ohm option, and adding the two numbers is '
        'meaningless because the units differ.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.ohms'],
  ),
  Question(
    id: 'ei-004',
    subtest: Subtest.ei,
    stem: 'A heater plugged into a 120-volt outlet draws 2 amperes. How much power does it use?',
    choices: <String>['60 watts', '122 watts', '480 watts', '240 watts'],
    answerIndex: 3,
    choiceNotes: <String>[
      'The 60 figure is 120 divided by 2, which is the resistance in ohms rather than the power.',
      'The 122 figure adds volts to amperes, and unlike units make the sum meaningless.',
      'The 480 figure doubles the correct power, as though both the volts and the amperes had risen.',
      'Power is voltage times current, so 120 volts times 2 amperes is 240 watts.',
    ],
    explanation:
        'Power in watts is voltage times current, so 120 volts times 2 amperes is 240 '
        'watts. Adding the two numbers gives 122, which has no electrical meaning. The 60 watt '
        'option would be the resistance in ohms, since 120 divided by 2 is 60.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.ohms'],
  ),
  Question(
    id: 'ei-005',
    subtest: Subtest.ei,
    stem: 'A current of 2 amperes flows through a 10-ohm resistor. How much power becomes heat?',
    choices: <String>['40 watts', '20 watts', '80 watts', '5 watts'],
    answerIndex: 0,
    choiceNotes: <String>[
      'Power in a resistor is I squared times R, so 4 times 10 gives 40 watts.',
      'The 20 figure multiplies current by resistance, and that product is the voltage, not the power.',
      'The 80 figure squares the resistance value instead of the current.',
      'The 5 figure divides the resistance by the current, which is not a power law at all.',
    ],
    explanation:
        'Power in a resistor is current squared times resistance: 2 squared is 4, and 4 '
        'times 10 ohms gives 40 watts. The 20 watt option comes from multiplying current by '
        'resistance, but that product is the voltage across the resistor, not the power. '
        'Squaring the resistance instead of the current gives the 80 watt option.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.ohms'],
  ),
  Question(
    id: 'ei-006',
    subtest: Subtest.ei,
    stem:
        'Resistors of 10, 20, and 30 ohms are connected in series. What is the total '
        'resistance?',
    choices: <String>['20 ohms', '60 ohms', '5.5 ohms', '300 ohms'],
    answerIndex: 1,
    choiceNotes: <String>[
      'The 20 figure is just the middle resistor copied down, and a series total exceeds the largest value.',
      'Series resistances simply add, so 10 plus 20 plus 30 is 60 ohms.',
      'The 5.5 figure comes from the reciprocal formula, which applies to these in parallel instead.',
      'The 300 figure multiplies the values together, which no series rule allows.',
    ],
    explanation:
        'In a series circuit the current must pass through each resistor in turn, so '
        'the values simply add: 10 plus 20 plus 30 is 60 ohms. The total is always larger than '
        'the biggest single resistor, which rules out 20 ohms. The 5.5 ohm option is what the '
        'same three resistors would give if they were wired in parallel instead.',
    difficulty: Difficulty.easy,
    skills: <String>['ei.circuits'],
  ),
  Question(
    id: 'ei-007',
    subtest: Subtest.ei,
    stem: 'Two 10-ohm resistors are connected in parallel. What is the equivalent resistance?',
    choices: <String>['20 ohms', '10 ohms', '5 ohms', '2.5 ohms'],
    answerIndex: 2,
    choiceNotes: <String>[
      'The 20 figure adds the two as though they were in series instead of in parallel.',
      'The 10 figure is a single resistor unchanged, but a parallel pair is smaller than either branch.',
      'Two equal resistors in parallel give half of one, so 10 ohms becomes 5 ohms.',
      'The 2.5 figure divides by four, halving the correct answer a second time.',
    ],
    explanation:
        'For two equal resistors in parallel the equivalent resistance is half of one '
        'of them, so 10 ohms becomes 5 ohms. Adding the values as if they were in series gives '
        'the 20 ohm option. A parallel combination is always smaller than the smallest branch '
        'resistor, which rules out both 10 and 20 ohms.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.circuits'],
  ),
  Question(
    id: 'ei-008',
    subtest: Subtest.ei,
    stem: 'In a series circuit, which quantity is the same at every point in the circuit?',
    choices: <String>['Voltage', 'Resistance', 'Power', 'Current'],
    answerIndex: 3,
    choiceNotes: <String>[
      'The supply voltage is shared out across the resistors, so it differs from part to part.',
      'Each resistor has its own value, so resistance is not equal at every point.',
      'Power differs from part to part, because each component has its own resistance and drop.',
      'One path means the same current flows through every component in the loop.',
    ],
    explanation:
        'A series circuit gives the charge only one path to follow, so the same current '
        'flows through every component. The supply voltage is shared out across the resistors, '
        'and the power differs from part to part because each part has its own resistance. That '
        'is why an ammeter reads the same everywhere while a voltmeter reads different values.',
    difficulty: Difficulty.easy,
    skills: <String>['ei.circuits'],
  ),
  Question(
    id: 'ei-009',
    subtest: Subtest.ei,
    stem:
        'A 4-ohm resistor and an 8-ohm resistor are in series across a 12-volt battery. '
        'What is the voltage drop across the 8-ohm resistor?',
    choices: <String>['8 volts', '4 volts', '12 volts', '6 volts'],
    answerIndex: 0,
    choiceNotes: <String>[
      'Total resistance is 12 ohms, so 1 ampere flows and drops 8 volts across the 8-ohm part.',
      'The 4 volt drop is across the other resistor, not the one the stem asks about.',
      'The 12 volt figure is the whole supply, and in series it splits between the two resistors.',
      'The 6 volt figure splits the supply evenly, which ignores that the two resistors are unequal.',
    ],
    explanation:
        'The total resistance is 4 plus 8, which is 12 ohms, so the current is 12 volts '
        'divided by 12 ohms, or 1 ampere. The drop across the 8-ohm resistor is 1 ampere times 8 '
        'ohms, which is 8 volts. Splitting the 12 volts evenly gives the 6 volt trap, and 4 '
        'volts is the drop across the other resistor.',
    difficulty: Difficulty.hard,
    skills: <String>['ei.circuits'],
  ),
  Question(
    id: 'ei-010',
    subtest: Subtest.ei,
    stem: 'Three 1.5-volt dry cells are connected in series. What voltage does the pack supply?',
    choices: <String>['1.5 volts', '3 volts', '4.5 volts', '0.5 volt'],
    answerIndex: 2,
    choiceNotes: <String>[
      'The 1.5 volt figure is what the same three cells give in parallel, adding capacity instead of voltage.',
      'The 3 volt figure counts only two of the three cells.',
      'Cells in series add, so 1.5 plus 1.5 plus 1.5 is 4.5 volts.',
      'The 0.5 volt figure divides 1.5 by three, the reciprocal of what series wiring does.',
    ],
    explanation:
        'Cells in series add their voltages, so 1.5 plus 1.5 plus 1.5 is 4.5 volts. '
        'Wiring the same three cells in parallel would keep the output at 1.5 volts while '
        'increasing the current the pack can deliver and how long it lasts. Voltage adds in '
        'series, while capacity adds in parallel.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.circuits'],
  ),
  Question(
    id: 'ei-011',
    subtest: Subtest.ei,
    stem: 'A resistor is marked with bands of brown, black, and red. What is its resistance?',
    choices: <String>['10 ohms', '100 ohms', '10,000 ohms', '1,000 ohms'],
    answerIndex: 3,
    choiceNotes: <String>[
      'The 10 ohm reading takes brown and black as digits and ignores the red multiplier band.',
      'The 100 ohm reading treats red as a second digit zero rather than as a multiplier of 100.',
      'The 10,000 ohm reading multiplies by 100 twice, once for the digits and once for the band.',
      'Brown is 1, black is 0 and red multiplies by 100, so the value is 1,000 ohms.',
    ],
    explanation:
        'In the color code brown is 1, black is 0, and red means multiply by 100, so '
        'the value is 10 times 100, or 1,000 ohms. Reading the bands as plain digits and '
        'skipping the multiplier gives 10 or 100 ohms. A fourth gold or silver band would show '
        'the tolerance, not another digit.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.components'],
  ),
  Question(
    id: 'ei-012',
    subtest: Subtest.ei,
    stem: 'On a schematic diagram, a capacitor is drawn as the symbol that looks like',
    choices: <String>[
      'A zigzag line',
      'Two parallel plates with a gap',
      'A triangle against a line',
      'An arrow into a circle',
    ],
    answerIndex: 1,
    choiceNotes: <String>[
      'The zigzag is the resistor symbol, which opposes current rather than storing charge.',
      'Two facing plates with a gap show the two conductors separated by an insulator.',
      'A triangle against a line is a diode, which conducts in one direction only.',
      'An arrow into a circle is not a capacitor symbol; it points at a source or a meter.',
    ],
    explanation:
        'Two facing plates with a gap stand for a capacitor, because it is two '
        'conductors separated by an insulator that store charge in an electric field. The '
        'zigzag is a resistor and the triangle against a line is a diode. An electrolytic '
        'capacitor, which has a definite positive and negative side, draws one plate curved.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.components'],
  ),
  Question(
    id: 'ei-013',
    subtest: Subtest.ei,
    stem: 'Which component stores energy in a magnetic field and opposes any change in current?',
    choices: <String>['Inductor', 'Capacitor', 'Resistor', 'Diode'],
    answerIndex: 0,
    choiceNotes: <String>[
      'A coil builds a magnetic field that collapses to oppose any change in current.',
      'A capacitor stores energy in an electric field and opposes changes in voltage.',
      'A resistor turns current into heat and opposes nothing with a stored field.',
      'A diode permits current in one direction only, which is not opposing change.',
    ],
    explanation:
        'A coil wound as an inductor builds a magnetic field as current rises, and that '
        'field collapses to oppose a falling current, which is how it resists sudden changes. A '
        'capacitor opposes changes in voltage and stores energy in an electric field instead. A '
        'resistor turns current into heat and a diode permits current in one direction only.',
    difficulty: Difficulty.hard,
    skills: <String>['ei.components'],
  ),
  Question(
    id: 'ei-014',
    subtest: Subtest.ei,
    stem: 'A diode used in a circuit behaves most like',
    choices: <String>[
      'A resistor that limits current flow',
      'A capacitor that stores charge',
      'A one-way valve for current',
      'A switch that stays permanently open',
    ],
    answerIndex: 2,
    choiceNotes: <String>[
      'A resistor limits current in both directions, while a diode blocks one of them.',
      'Storing charge belongs to a capacitor, which passes no steady current either way.',
      'Forward bias conducts and reverse bias blocks, exactly the behaviour of a valve.',
      'A diode conducts freely in its forward direction, so it is not permanently open.',
    ],
    explanation:
        'A diode conducts freely when it is forward-biased and blocks current when it '
        'is reversed, which is why it is compared to a one-way valve. Four diodes arranged as a '
        'bridge rectifier turn alternating current into the direct current that electronics '
        'need. Nothing about the diode matches a resistor or a capacitor in normal operation.',
    difficulty: Difficulty.hard,
    skills: <String>['ei.components'],
  ),
  Question(
    id: 'ei-015',
    subtest: Subtest.ei,
    stem:
        'A tiny current at the base of a transistor controls a much larger current between '
        'the collector and the emitter. That makes the transistor useful as',
    choices: <String>[
      'A device that stores charge for later use',
      'A device that changes AC into DC',
      'A device that limits current to a safe level',
      'An amplifier or an electronic switch',
    ],
    answerIndex: 3,
    choiceNotes: <String>[
      'Storing charge is the job of a capacitor, which has two plates and no control terminal.',
      'Changing AC to DC is rectification, done by diodes or a rectifier bridge.',
      'Limiting current is the job of a resistor or a fuse, not of an amplifying device.',
      'A small base current controlling a large collector current is what makes amplification and switching possible.',
    ],
    explanation:
        'Because a small base current controls a large collector current, a transistor '
        'can boost a weak signal as an amplifier or turn a load on and off as a switch, which is '
        'why computers and radios are built from them. Storing charge is the job of a capacitor, '
        'changing AC to DC is rectification, and limiting current is the job of a resistor or '
        'fuse.',
    difficulty: Difficulty.hard,
    skills: <String>['ei.components'],
  ),
  Question(
    id: 'ei-016',
    subtest: Subtest.ei,
    stem:
        'A transformer has 100 turns on its primary coil, connected to 120 volts, and 50 '
        'turns on its secondary. What is the secondary voltage?',
    choices: <String>['240 volts', '60 volts', '120 volts', '30 volts'],
    answerIndex: 1,
    choiceNotes: <String>[
      'The 240 volt figure multiplies by the 2-to-1 ratio instead of dividing, stepping the voltage up.',
      'Fewer turns mean lower voltage, so 120 volts divided by 2 is 60 volts.',
      'The 120 volt figure repeats the primary voltage, which only happens when the turn counts match.',
      'The 30 volt figure treats the ratio as 4 to 1, doubling the true two-to-one turns ratio.',
    ],
    explanation:
        'The turns ratio sets the voltage ratio: 100 turns to 50 turns is 2 to 1, so '
        'the secondary voltage is 120 divided by 2, or 60 volts, and this is a step-down '
        'transformer. Fewer turns always means lower voltage. Multiplying instead of dividing '
        'gives the 240 volt option, and a transformer of this kind passes only alternating '
        'current, since steady DC makes no changing field.',
    difficulty: Difficulty.hard,
    skills: <String>['ei.components'],
  ),
  Question(
    id: 'ei-017',
    subtest: Subtest.ei,
    stem: 'The purpose of a fuse in a circuit is to',
    choices: <String>[
      'Raise the voltage supplied to the load',
      'Open the circuit when the current gets too high',
      'Store charge for moments of peak demand',
      'Change alternating current into direct current',
    ],
    answerIndex: 1,
    choiceNotes: <String>[
      'A fuse has no way to raise voltage; transformers are what step voltage up.',
      'A short strip inside melts and opens the circuit when too much current flows.',
      'Storing charge belongs to a capacitor, and a fuse holds no charge.',
      'Changing AC to DC is rectification, which calls for diodes.',
    ],
    explanation:
        'A fuse holds a short strip that melts and opens the circuit when more current '
        'flows than it can safely carry, which protects the wiring from overheating and fire. A '
        'circuit breaker does the same job by tripping instead of melting, so it can be reset. '
        'Raising voltage, storing charge, and converting current belong to transformers, '
        'capacitors, and rectifiers.',
    difficulty: Difficulty.easy,
    skills: <String>['ei.safety'],
  ),
  Question(
    id: 'ei-018',
    subtest: Subtest.ei,
    stem: 'Before testing a wire for continuity with an ohmmeter, you should',
    choices: <String>[
      'Switch off and disconnect the power, then isolate the wire',
      'Set the meter to its highest voltage range',
      'Hold both probes firmly in your bare hands',
      'Turn on the circuit so current can flow',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'The meter supplies its own test voltage, so outside power spoils the reading and can damage it.',
      'An ohmmeter is not measuring voltage, and a high voltage range protects nothing here.',
      'Bare hands add body resistance to the reading and invite a shock.',
      'Live current ruins the resistance reading and puts the technician at risk.',
    ],
    explanation:
        'An ohmmeter supplies its own small test voltage, so any outside power will '
        'spoil the reading and can damage the meter, which is why the circuit must be dead '
        'first. Isolation prevents a backfeed from another breaker. Holding the probes in bare '
        'hands adds body resistance to the reading and invites a shock.',
    difficulty: Difficulty.hard,
    skills: <String>['ei.safety'],
  ),
  Question(
    id: 'ei-019',
    subtest: Subtest.ei,
    stem: 'To measure the current through a circuit, an ammeter is connected',
    choices: <String>[
      'In parallel with the load',
      'Across the battery terminals',
      'Between the load and the ground only',
      'In series with the circuit',
    ],
    answerIndex: 3,
    choiceNotes: <String>[
      'Parallel puts the full supply across a near short circuit and blows the meter fuse.',
      'Across the battery terminals is the same short hazard, since the ammeter has almost no resistance.',
      'Ground-side placement misses the current through the whole loop and offers no complete path.',
      'An ammeter must carry the current it measures, so it goes in series with the load.',
    ],
    explanation:
        'An ammeter has to carry the current it measures, so it goes in series and its '
        'internal resistance is kept very low so it adds almost no voltage drop. Hooking it in '
        'parallel puts the full supply voltage across a near short circuit and blows its fuse. A '
        'voltmeter is the opposite case: high resistance and wired in parallel.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.safety'],
  ),
  Question(
    id: 'ei-020',
    subtest: Subtest.ei,
    stem: 'The round third prong on a three-wire plug connects the metal case of the appliance to',
    choices: <String>[
      'The neutral wire only',
      'The hot wire, so the case carries current',
      'Ground, so a fault has a safe path',
      'A second power source inside the panel',
    ],
    answerIndex: 2,
    choiceNotes: <String>[
      'Neutral carries current in normal operation and is not a safety backup for the case.',
      'Connecting the case to the hot wire would make every touch dangerous.',
      'The ground prong ties the case to earth so a fault rushes to ground and trips the breaker.',
      'There is no second source in the panel; the prong leads to the grounding bar.',
    ],
    explanation:
        'The ground wire ties the case to earth through the service panel, so if a hot '
        'wire touches the case the current rushes to ground and trips the breaker instead of '
        'passing through the person holding it. Neutral carries current during normal operation '
        'and is not a safety backup. Good insulation is the first line of defense, and the '
        'ground prong is the backup path.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.safety'],
  ),
];
