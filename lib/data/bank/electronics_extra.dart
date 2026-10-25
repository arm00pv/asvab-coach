import '../models/catalog.dart';
import '../models/question.dart';

/// Electronics Information expansion bank: 16 items weighted the way the real
/// subtest is, with 4 Ohm law and power items, 5 series and parallel circuit
/// items, 4 components items, 2 electrical systems items and 1 safety item.
/// Every numeric answer has been recomputed by hand.
const List<Question> electronicsExtraBank = <Question>[
  Question(
    id: 'ei-x01',
    subtest: Subtest.ei,
    stem:
        'A 240-volt air conditioner draws 8 amperes while the compressor is running. How '
        'much power does it use?',
    choices: <String>['30 watts', '192 watts', '240 watts', '1,920 watts'],
    answerIndex: 3,
    explanation:
        'Power is voltage times current, so 240 volts times 8 amperes is 1,920 watts. The 30 '
        'watt option comes from dividing the voltage by the current instead of multiplying, '
        'which produces no meaningful quantity. The 192 watt option is the correct figure with '
        'the decimal point moved, and 240 watts is simply the supply voltage copied down.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.ohms'],
  ),
  Question(
    id: 'ei-x02',
    subtest: Subtest.ei,
    stem:
        'A 1,500-watt space heater is plugged into a 120-volt outlet. How much current does '
        'it draw?',
    choices: <String>[
      '0.08 ampere',
      '1.25 amperes',
      '12.5 amperes',
      '125 amperes',
    ],
    answerIndex: 2,
    explanation:
        'Rearranging the power formula gives current as power divided by voltage, so 1,500 '
        'watts divided by 120 volts is 12.5 amperes. Dividing the voltage by the power instead '
        'gives 0.08, which is the reciprocal of the answer rather than a current. The 1.25 and '
        '125 ampere options are the same digits with the decimal point moved one place either '
        'way.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.ohms'],
  ),
  Question(
    id: 'ei-x03',
    subtest: Subtest.ei,
    stem:
        'A 60-watt light bulb is operating on a 120-volt circuit. What is the resistance of '
        'its filament while it is lit?',
    choices: <String>['2 ohms', '120 ohms', '240 ohms', '7,200 ohms'],
    answerIndex: 2,
    explanation:
        'The current is power divided by voltage, or 60 divided by 120, which gives 0.5 '
        'ampere, and resistance is voltage divided by current, or 120 divided by 0.5, which is '
        '240 ohms. You can also go straight there with voltage squared over power: 14,400 '
        'divided by 60 is also 240 ohms. The 2 ohm option divides the two numbers the wrong way, '
        'and 7,200 comes from multiplying power by voltage.',
    difficulty: Difficulty.hard,
    skills: <String>['ei.ohms'],
  ),
  Question(
    id: 'ei-x04',
    subtest: Subtest.ei,
    stem:
        'A current of 4 amperes flows through a 15-ohm resistor. How much power is given off '
        'as heat?',
    choices: <String>['60 watts', '240 watts', '900 watts', '3,600 watts'],
    answerIndex: 1,
    explanation:
        'Power in a resistor is current squared times resistance: 4 squared is 16, and 16 '
        'times 15 ohms is 240 watts. The 60 watt option multiplies current by resistance, which '
        'gives the voltage across the resistor rather than its power. The 900 watt option '
        'squares the resistance instead of the current, and 3,600 squares both quantities.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.ohms'],
  ),
  Question(
    id: 'ei-x05',
    subtest: Subtest.ei,
    stem:
        'A 6-ohm resistor and a 3-ohm resistor are connected in parallel. What is the '
        'equivalent resistance of the pair?',
    choices: <String>['2 ohms', '0.5 ohm', '4.5 ohms', '9 ohms'],
    answerIndex: 0,
    explanation:
        'For two resistors in parallel, 1/R is 1/6 plus 1/3, which is 1/6 plus 2/6, or 1/2, '
        'so R is 2 ohms; product over sum gives the same result, 18 divided by 9. Adding the '
        'values gives the 9 ohm series answer, and 4.5 ohms is their plain average, which the '
        'formula never produces. The 0.5 ohm option is the reciprocal left unconverted.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.circuits'],
  ),
  Question(
    id: 'ei-x06',
    subtest: Subtest.ei,
    stem: 'Six lamps are wired in parallel to one supply. If one lamp burns out, the other five',
    choices: <String>[
      'Go out as well when the circuit opens',
      'Glow more brightly than before',
      'Keep glowing at about the same brightness',
      'Glow dimly as the voltage drops',
    ],
    answerIndex: 2,
    explanation:
        'Every lamp in a parallel circuit has its own branch wired straight across the '
        'supply, so a dead lamp breaks only its own branch and the rest keep the full supply '
        'voltage across them. Lamps wired in series share a single path, which is why one failure '
        'in that arrangement darkens the whole string. The supply delivers less total current '
        'afterwards, but the voltage on each remaining lamp does not change.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.circuits'],
  ),
  Question(
    id: 'ei-x07',
    subtest: Subtest.ei,
    stem:
        'Resistors of 2, 3, and 5 ohms are connected in series across a 20-volt battery. What '
        'current flows through the circuit?',
    choices: <String>['2 amperes', '0.5 ampere', '4 amperes', '10 amperes'],
    answerIndex: 0,
    explanation:
        'In series the resistances add, so the total is 10 ohms, and 20 volts divided by 10 '
        'ohms gives 2 amperes, which is the same everywhere in the loop. Dividing 10 by 20 '
        'reverses the formula and gives 0.5 ampere. Using only the 2 and 3 ohm resistors gives 4 '
        'amperes, and 10 amperes repeats the total resistance as though it were the current.',
    difficulty: Difficulty.easy,
    skills: <String>['ei.circuits'],
  ),
  Question(
    id: 'ei-x08',
    subtest: Subtest.ei,
    stem: 'In a parallel circuit, the voltage across each branch is',
    choices: <String>[
      'Equal to the supply voltage',
      'Divided equally among the branches',
      'Lower in the branch with less resistance',
      'Zero until a switch is closed',
    ],
    answerIndex: 0,
    explanation:
        'Each branch of a parallel circuit is connected directly across the source terminals, '
        'so every branch sees the full supply voltage no matter what resistance it has. It is '
        'the current that divides, and it divides in inverse proportion to resistance, so the '
        'lowest branch carries the largest share. Dividing the voltage equally is what happens in '
        'a series circuit of equal resistors.',
    difficulty: Difficulty.easy,
    skills: <String>['ei.circuits'],
  ),
  Question(
    id: 'ei-x09',
    subtest: Subtest.ei,
    stem:
        'Two 12-ohm resistors are connected in parallel, and that pair is connected in series '
        'with a 6-ohm resistor. What is the total resistance of the combination?',
    choices: <String>['6 ohms', '12 ohms', '24 ohms', '30 ohms'],
    answerIndex: 1,
    explanation:
        'Two equal resistors in parallel are half the value of one, so the pair is 6 ohms, '
        'and the 6-ohm resistor in series with it brings the total to 12 ohms. The 6 ohm option '
        'stops after the parallel step and forgets the series resistor. The 24 ohm option adds '
        'the two 12-ohm resistors as though they were in series, and 30 ohms treats all three '
        'resistors as one series string.',
    difficulty: Difficulty.hard,
    skills: <String>['ei.circuits'],
  ),
  Question(
    id: 'ei-x10',
    subtest: Subtest.ei,
    stem:
        'Which device uses a small current in a coil to switch a much larger current in a '
        'separate circuit?',
    choices: <String>['A capacitor', 'A relay', 'A transformer', 'A rheostat'],
    answerIndex: 1,
    explanation:
        'In a relay the small current energizes an electromagnet that pulls a set of contacts '
        'closed, so a low-power control circuit can start a motor or a heater without handling '
        'the heavy current itself. A transformer also has two coils but it changes voltage rather '
        'than opening and closing a separate circuit. A capacitor stores charge, while a rheostat '
        'is an adjustable resistor used to vary current.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.components'],
  ),
  Question(
    id: 'ei-x11',
    subtest: Subtest.ei,
    stem: 'On a schematic diagram, a battery is drawn as',
    choices: <String>[
      'Two equal lines with a gap between them',
      'A circle with a cross inside it',
      'Long and short parallel lines in pairs',
      'A zigzag with an arrow through it',
    ],
    answerIndex: 2,
    explanation:
        'Each long and short pair stands for one cell, and the long line marks the positive '
        'terminal, so a battery of several cells is drawn as repeated pairs. Two equal lines with '
        'a gap is the capacitor, a circle with a cross is a lamp, and a zigzag crossed by an arrow '
        'is a variable resistor. Counting the pairs tells you the number of cells in the battery.',
    difficulty: Difficulty.easy,
    skills: <String>['ei.components'],
  ),
  Question(
    id: 'ei-x12',
    subtest: Subtest.ei,
    stem: 'Once a capacitor in a direct-current circuit has fully charged, it',
    choices: <String>[
      'Reverses the current through it',
      'Stores its energy in a magnetic field',
      'Passes steady current without change',
      'Blocks any further steady current',
    ],
    answerIndex: 3,
    explanation:
        'Charge builds on the two plates until the voltage across the capacitor matches the '
        'supply, and after that no more current flows through the circuit at all. A capacitor '
        'stores energy in an electric field between its plates, while the magnetic field belongs '
        'to an inductor or a coil. Reversing the current is not something a capacitor does, and '
        'an uncharged capacitor does pass current briefly while it charges.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.components'],
  ),
  Question(
    id: 'ei-x13',
    subtest: Subtest.ei,
    stem: 'A light-emitting diode produces light only when',
    choices: <String>[
      'The current through it exceeds its rating',
      'Its anode is the more positive terminal',
      'It is connected across alternating current',
      'Its cathode is the more positive terminal',
    ],
    answerIndex: 1,
    explanation:
        'A diode conducts only in the forward direction, so an LED lights when its anode is '
        'positive with respect to its cathode. With the connections reversed the junction is '
        'reverse-biased and almost no current flows. Too much current destroys the junction '
        'instead of making it brighter, and on alternating current the LED is on only during the '
        'forward half of each cycle.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.components'],
  ),
  Question(
    id: 'ei-x14',
    subtest: Subtest.ei,
    stem:
        'In a simple direct-current motor, the part that reverses the current in the coil '
        'every half turn so that the motor keeps spinning is the',
    choices: <String>['Brushes', 'Armature', 'Commutator', 'Field winding'],
    answerIndex: 2,
    explanation:
        'The commutator is a split ring that swaps the coil connections twice per revolution, '
        'so the magnetic push on the coil always acts in the same rotational direction. The '
        'brushes only carry current from the stationary circuit to the spinning commutator, and '
        'the armature is the rotating coil itself. The field winding supplies the magnetic field '
        'that the current in the coil reacts against.',
    difficulty: Difficulty.hard,
    skills: <String>['ei.systems'],
  ),
  Question(
    id: 'ei-x15',
    subtest: Subtest.ei,
    stem: 'Appliances in a house are wired in parallel rather than in series mainly so that',
    choices: <String>[
      'The wiring needs less copper and fewer fuses',
      'Switching one on makes the others brighter',
      'One fuse can control every appliance at once',
      'Each can be switched on by itself at full voltage',
    ],
    answerIndex: 3,
    explanation:
        'A parallel connection puts each appliance straight across the supply, so every one '
        'receives the full line voltage and its own switch can break just its own branch. In a '
        'series string the same current would have to pass through every appliance, so none could '
        'be switched independently and one failure would stop everything. Parallel wiring '
        'actually uses more copper, not less.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.systems'],
  ),
  Question(
    id: 'ei-x16',
    subtest: Subtest.ei,
    stem: 'Before working on a household circuit, the safest first step is to',
    choices: <String>[
      'Turn off the wall switch for that room',
      'Stand on a dry wooden platform',
      'Hold the wires with insulated pliers',
      'Switch off the breaker and test for voltage',
    ],
    answerIndex: 3,
    explanation:
        'A wall switch usually opens only the hot conductor at that one fixture, so other '
        'parts of the box can stay live, and breakers are not always labeled correctly. Opening '
        'the breaker removes the supply, and a tester confirms the circuit is dead before your '
        'hand goes near it. Standing on wood or using insulated pliers is no substitute for '
        'de-energizing the circuit.',
    difficulty: Difficulty.medium,
    skills: <String>['ei.safety'],
  ),
];
