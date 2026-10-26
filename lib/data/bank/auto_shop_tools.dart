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
    choiceNotes: <String>[
      'The curved forked hook that catches a nail head and pries it out is what the drawing shows.',
      'A ball-peen ends in a round knob for shaping rivets, so the forked hook on the back is missing.',
      'A cross-peen ends in a narrow wedge for starting a punch line, and it has no hook at all.',
      'A riveting hammer carries a short face instead of the long curved claw seen on this head.',
    ],
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
    choiceNotes: <String>[
      'The round knob on the back is a peen, used to spread and round over a rivet head.',
      'A claw hammer ends in a forked hook, so a picture of one would show a split tip instead of a knob.',
      'A sledgehammer is a two-handed tool with a long handle and a plain face at each end.',
      'A soft-face mallet wears a rubber or plastic head, and the drawn head is all steel with a peen.',
    ],
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
    choiceNotes: <String>[
      'The knurled wheel in the neck slides the lower jaw, so one wrench covers a whole range of sizes.',
      'An open-end wrench has two fixed jaws forged at one size, so it would carry no adjusting wheel.',
      'A box-end wrench is a closed ring that surrounds the nut, and nothing here closes into a ring.',
      'A pipe wrench grips with sharp teeth on a hinged jaw, so its teeth are what the drawing would show.',
    ],
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
    choiceNotes: <String>[
      'A thin blade held under tension in a low deep frame is what lets this saw cut metal cleanly.',
      'A crosscut saw carries coarse teeth for wood and is used without a tensioning frame.',
      'A coping saw uses a very fine blade in a deep frame to cut curves, and it is far lighter than this.',
      'A bow saw carries a wide blade for green timber rather than the narrow metal-cutting blade drawn.',
    ],
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
    choiceNotes: <String>[
      'The shallow hardened cone leaves a small round crater that seats a drill point on the mark.',
      'A nail set has a cupped tip that fits over a nail head, which is the opposite of a point.',
      'A cold chisel ends in a wide flat edge for shearing metal rather than a cone.',
      'A scratch awl is thin and sharp because it only scores a line, and it has no striking head.',
    ],
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
    choiceNotes: <String>[
      'Serrated jaws on crossed arms pinch the work while the long handles multiply the gripping force.',
      'Cutting sheet metal along a line needs snips, and pliers tear sheet rather than shear it.',
      'A damaged screw head needs an extractor, and pliers would simply chew what is left of it.',
      'Measuring an outside diameter takes a caliper, and pliers carry no scale to read.',
    ],
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
    choiceNotes: <String>[
      'A blade fixed at a right angle to the stock is a reference for squareness, with any gap showing the error.',
      'It carries no graduations, so it cannot report the depth of a bored hole.',
      'A turned diameter is measured with a caliper or micrometer, and a square reads no size at all.',
      'Setting tool height is done by eye or with a gauge, and squareness is the only thing this checks.',
    ],
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
    choiceNotes: <String>[
      'A worm screw slides one jaw across a span of about fifteen millimetres, covering every nut in that range.',
      'The jaws are not a ring and the body is forged steel, so the opening has to be set rather than sprung on.',
      'These jaws are smooth for nut flats, and toothed jaws belong to a pipe wrench that would crush a hex nut.',
      'The jaw does not pivot on a pin; the sliding jaw rides the worm screw, which is what gives the range.',
    ],
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
