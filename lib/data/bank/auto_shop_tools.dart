import '../models/catalog.dart';
import '../models/question.dart';
import 'shop_tool_sketches.dart';

/// Auto & Shop Information: eight tool-identification items that carry a
/// drawing, the way the real subtest does.
///
/// The real CAT-ASVAB splits Auto & Shop into an Auto half and a Shop half, and
/// the Shop half shows outline drawings of hand tools and asks the examinee to
/// name them or to say what they are for. A bank of text-only tool items
/// measures vocabulary instead: a candidate can pass them without ever having
/// recognised a tool by its shape. Every item here is decided by the drawing.
///
/// Distractors are always the tools a beginner actually confuses with the one
/// drawn, so a wrong answer says something specific about what is missing.
const List<Question> autoShopToolBank = <Question>[
  Question(
    id: 'as-t01',
    subtest: Subtest.as,
    stem: 'Which hand tool is shown in the drawing?',
    choices: <String>[
      'Claw hammer',
      'Ball-peen hammer',
      'Cross-peen hammer',
      'Riveting hammer',
    ],
    answerIndex: 0,
    explanation:
        'The forked hook on the back of the head is the give-away. It is curved '
        'and split at the tip so it can catch under a nail head and pry the nail out '
        'with the face as the fulcrum. A ball-peen hammer ends in a round knob, a '
        'cross-peen ends in a narrow wedge, and a riveting hammer has a short face '
        'instead of a long curved claw. Only this one is built to pull nails as well '
        'as drive them.',
    difficulty: Difficulty.easy,
    skills: <String>['as.tools'],
    figure: clawHammerSketch,
  ),
  Question(
    id: 'as-t02',
    subtest: Subtest.as,
    stem: 'A tool is shown in the drawing. Which one is it?',
    choices: <String>[
      'Ball-peen hammer',
      'Claw hammer',
      'Sledgehammer',
      'Soft-face mallet',
    ],
    answerIndex: 0,
    explanation:
        'The round knob on the back of the head is the peen, and its job is to '
        'spread and round over the head of a rivet after the flat face has driven '
        'the rivet home. A claw hammer ends in a forked hook instead, a sledgehammer '
        'is a two-handed tool with a long handle and a plain face at each end, and a '
        'soft-face mallet has a rubber or plastic head that will not mark the work.',
    difficulty: Difficulty.easy,
    skills: <String>['as.tools'],
    figure: ballPeenHammerSketch,
  ),
  Question(
    id: 'as-t03',
    subtest: Subtest.as,
    stem: 'Identify the tool shown in the drawing.',
    choices: <String>[
      'Adjustable wrench',
      'Open-end wrench',
      'Box-end wrench',
      'Pipe wrench',
    ],
    answerIndex: 0,
    explanation:
        'The knurled wheel set into the neck behind the jaws is what makes this '
        'tool suit a whole range of sizes: turning it slides the lower jaw in and '
        'out, so one wrench replaces a set. An open-end wrench has two fixed jaws '
        'forged at a single size, a box-end wrench is a closed ring that surrounds '
        'the nut, and a pipe wrench grips round pipe with sharp teeth.',
    difficulty: Difficulty.medium,
    skills: <String>['as.tools'],
    figure: adjustableWrenchSketch,
  ),
  Question(
    id: 'as-t04',
    subtest: Subtest.as,
    stem: 'What is the name of the tool pictured in the drawing?',
    choices: <String>['Hacksaw', 'Crosscut saw', 'Coping saw', 'Bow saw'],
    answerIndex: 0,
    explanation:
        'A thin blade held under tension in a low, deep frame is what lets this '
        'saw cut steel, pipe and bolt stock: the frame keeps the blade straight '
        'while the fine teeth take a shallow bite that suits metal. A crosscut saw '
        'has coarse teeth for wood, a coping saw uses a very fine blade in a deep '
        'frame to cut curves, and a bow saw carries a wide blade for green timber.',
    difficulty: Difficulty.easy,
    skills: <String>['as.tools'],
    figure: hacksawSketch,
  ),
  Question(
    id: 'as-t05',
    subtest: Subtest.as,
    stem: 'Which of these is the tool shown?',
    choices: <String>['Center punch', 'Nail set', 'Cold chisel', 'Scratch awl'],
    answerIndex: 0,
    explanation:
        'The shallow hardened cone on the end is what does the work. Struck once '
        'with a hammer it leaves a small round crater, and that crater seats a drill '
        'point so the bit starts on the mark instead of skating across it. A nail '
        'set has a cupped tip that fits over a nail head, a cold chisel ends in a '
        'wide flat edge, and a scratch awl is thin and sharp because it only scores '
        'a line.',
    difficulty: Difficulty.medium,
    skills: <String>['as.tools'],
    figure: centerPunchSketch,
  ),
  Question(
    id: 'as-t06',
    subtest: Subtest.as,
    stem: 'What is the tool in the drawing designed to do?',
    choices: <String>[
      'Grip and bend stock too wide or too round for a hand to hold',
      'Cut thin sheet metal along a straight line',
      'Loosen a screw whose head has been damaged',
      'Measure the outside diameter of a shaft',
    ],
    answerIndex: 0,
    explanation:
        'Two crossed arms joined by a rivet, with serrated jaws at one end, make a '
        'gripping tool: the jaws pinch the work and the long handles multiply the '
        'force. The second notch at the joint is the slip joint, and it moves the '
        'pivot so the jaws open a step wider for a bigger workpiece. Cutting sheet '
        'needs snips, a damaged screw head needs an extractor, and a diameter needs '
        'a caliper.',
    difficulty: Difficulty.medium,
    skills: <String>['as.tools'],
    figure: slipJointPliersSketch,
  ),
  Question(
    id: 'as-t07',
    subtest: Subtest.as,
    stem: 'The drawing shows a layout tool. What is it used to check?',
    choices: <String>[
      'That a corner has been cut at exactly ninety degrees',
      'That a bored hole has been drilled to the right depth',
      'That a shaft has been turned to the right diameter',
      'That a lathe tool is set at the right height',
    ],
    answerIndex: 0,
    explanation:
        'A thin blade fixed at a right angle across a thick stock is a reference '
        'for squareness. The stock is pressed flat against one face of the work and '
        'the blade is offered to the other face; any gap you can see between blade '
        'and work is how far out of square the cut is. It carries no graduations, so '
        'it cannot report a depth, a diameter or a height.',
    difficulty: Difficulty.medium,
    skills: <String>['as.tools'],
    figure: trySquareSketch,
  ),
  Question(
    id: 'as-t08',
    subtest: Subtest.as,
    stem:
        'A mechanic has to loosen a row of nuts of several different sizes and has '
        'only the tool in the drawing. Why can it do the job?',
    choices: <String>[
      'A worm screw slides one jaw so the opening can be set to each nut',
      'The ring end fits any hex because the ring is spring steel',
      'The jaws carry teeth that bite into any size of nut',
      'The head pivots on a pin so the jaw angle matches the nut',
    ],
    answerIndex: 0,
    explanation:
        'This tool wins on range rather than grip: the worm screw moves the sliding '
        'jaw across a span of roughly fifteen millimetres, which covers every nut in '
        'that range with a proper fit on the flats. A ring wrench is fixed at one '
        'size, and the option describing toothed jaws on a hinged head is the pipe '
        'wrench, which marks and crushes a hex nut instead of gripping it.',
    difficulty: Difficulty.hard,
    skills: <String>['as.tools'],
    figure: adjustableWrenchSketch,
  ),
];
