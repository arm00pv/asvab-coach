import '../models/catalog.dart';
import '../models/question.dart';

/// Figure-based Mechanical Comprehension items.
///
/// Every officially published sample item in this subtest shows a diagram, so a
/// verbal-only bank trains the wrong skill. These items carry a rendered figure
/// and the arithmetic is deliberately round.
const List<Question> mechanicalFigureBank = <Question>[
  Question(
    id: 'mc-f01',
    subtest: Subtest.mc,
    stem:
        'A 60 pound load rests 3 feet from the fulcrum of a lever. How much '
        'effort must be applied 9 feet from the fulcrum to balance it?',
    choices: <String>['20 pounds', '15 pounds', '60 pounds', '180 pounds'],
    answerIndex: 0,
    explanation:
        'A lever balances when load times its arm equals effort times '
        'its arm. Here 60 x 3 = effort x 9, so effort = 180 / 9 = 20 pounds. '
        'Multiplying the load by the ratio the wrong way round gives 180, which '
        'is the answer to a question nobody asked.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.levers'],
    figure: McFigure(
      caption:
          'A class 1 lever: a 60 pound load 3 feet left of the fulcrum and '
          'an upward effort 9 feet right of it.',
      prims: <McPrim>[
        McPrim.line(Pt(0.14, 0.60), Pt(0.88, 0.60), weight: 5),
        McPrim.triangle(Pt(0.38, 0.60), Pt(0.32, 0.76), Pt(0.44, 0.76)),
        McPrim.box(Pt(0.20, 0.44), Pt(0.30, 0.60)),
        McPrim.text('60 lb', Pt(0.25, 0.37)),
        McPrim.arrow(Pt(0.76, 0.34), Pt(0.76, 0.5700)),
        McPrim.text('?', Pt(0.76, 0.27)),
        McPrim.text('3 ft', Pt(0.31, 0.86)),
        McPrim.text('9 ft', Pt(0.57, 0.86)),
      ],
    ),
  ),
  Question(
    id: 'mc-f02',
    subtest: Subtest.mc,
    stem:
        'A 240 pound crate is pushed up a frictionless ramp 12 feet long that '
        'rises 3 feet. How much effort does the ramp save?',
    choices: <String>['60 pounds', '80 pounds', '720 pounds', '20 pounds'],
    answerIndex: 0,
    explanation:
        'An inclined plane trades distance for force: effort equals the '
        'load multiplied by the height and divided by the length, so 240 x 3 / 12 '
        '= 60 pounds. Dividing by the height instead of the length gives 960, and '
        'simply adding the two gives 720.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pulleys'],
    figure: McFigure(
      caption:
          'A right triangle with a 3 foot rise on the left and a 12 foot '
          'sloping face, with a crate resting on the slope.',
      prims: <McPrim>[
        McPrim.line(Pt(0.18, 0.80), Pt(0.86, 0.80), weight: 4),
        McPrim.line(Pt(0.18, 0.80), Pt(0.18, 0.34), weight: 4),
        McPrim.line(Pt(0.18, 0.34), Pt(0.86, 0.80), weight: 4),
        McPrim.box(Pt(0.36, 0.34), Pt(0.48, 0.49)),
        McPrim.text('240 lb', Pt(0.61, 0.35)),
        McPrim.text('3 ft', Pt(0.09, 0.57)),
        McPrim.text('12 ft', Pt(0.47, 0.68)),
      ],
    ),
  ),
  Question(
    id: 'mc-f03',
    subtest: Subtest.mc,
    stem:
        'Gear A has 30 teeth and turns 90 rpm clockwise. It drives a 15 tooth '
        'idler, which drives gear B with 45 teeth. What does gear B do?',
    choices: <String>[
      '60 rpm clockwise',
      '60 rpm counterclockwise',
      '135 rpm clockwise',
      '90 rpm clockwise',
    ],
    answerIndex: 0,
    explanation:
        'The idler changes direction but not speed, so only A and B '
        'matter for ratio: 90 x 30 / 45 = 60 rpm. Two meshes reverse the '
        'direction twice, so B turns the same way as A, clockwise. Forgetting the '
        'idler makes the direction wrong, and inverting the ratio gives 135 rpm.',
    difficulty: Difficulty.hard,
    skills: <String>['mc.pulleys'],
    figure: McFigure(
      caption:
          'Gear A with 30 teeth driving a 15 tooth idler, which drives gear '
          'B with 45 teeth.',
      prims: <McPrim>[
        McPrim.circle(Pt(0.22, 0.50), 0.20, weight: 3),
        McPrim.circle(Pt(0.50, 0.50), 0.11, weight: 3),
        McPrim.circle(Pt(0.78, 0.50), 0.26, weight: 3),
        McPrim.text('A 30', Pt(0.22, 0.50)),
        McPrim.text('idler 15', Pt(0.50, 0.50)),
        McPrim.text('B 45', Pt(0.78, 0.50)),
        McPrim.text('90 rpm CW', Pt(0.22, 0.90)),
      ],
    ),
  ),
  Question(
    id: 'mc-f04',
    subtest: Subtest.mc,
    stem:
        'An 800 pound load hangs at the midpoint of a beam carried on two '
        'supports placed equal distances from each end. What load does each '
        'support carry?',
    choices: <String>['400 pounds', '800 pounds', '200 pounds', '1600 pounds'],
    answerIndex: 0,
    explanation:
        'A centred load on a symmetric beam splits evenly between the '
        'supports, so each carries 800 / 2 = 400 pounds. Giving each support the '
        'whole load doubles it, and splitting it into quarters forgets that there '
        'are only two supports.',
    difficulty: Difficulty.easy,
    skills: <String>['mc.structure'],
    figure: McFigure(
      caption:
          'A beam on two supports with an 800 pound load hanging at the '
          'centre.',
      prims: <McPrim>[
        McPrim.line(Pt(0.12, 0.52), Pt(0.88, 0.52), weight: 6),
        McPrim.triangle(Pt(0.24, 0.52), Pt(0.18, 0.68), Pt(0.30, 0.68)),
        McPrim.triangle(Pt(0.76, 0.52), Pt(0.70, 0.68), Pt(0.82, 0.68)),
        McPrim.box(Pt(0.44, 0.26), Pt(0.56, 0.40)),
        McPrim.text('800 lb', Pt(0.50, 0.19)),
        McPrim.line(Pt(0.50, 0.40), Pt(0.50, 0.52), weight: 3),
        McPrim.text('?', Pt(0.24, 0.80)),
        McPrim.text('?', Pt(0.76, 0.80)),
      ],
    ),
  ),
  Question(
    id: 'mc-f05',
    subtest: Subtest.mc,
    stem:
        'A wheel with a radius of 18 inches turns an axle with a radius of 3 '
        'inches. A 180 pound load is raised on the axle. What effort is needed at '
        'the rim of the wheel?',
    choices: <String>['30 pounds', '60 pounds', '15 pounds', '180 pounds'],
    answerIndex: 0,
    explanation:
        'A wheel and axle multiplies force by the ratio of the radii: '
        '18 / 3 = 6, so the effort is 180 / 6 = 30 pounds. Dividing by the '
        'difference of the radii instead of the ratio gives 12, and 60 pounds '
        'comes from using a ratio of 3.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pulleys'],
    figure: McFigure(
      caption:
          'An 18 inch wheel on a 3 inch axle, with a 180 pound load hanging '
          'from the axle.',
      prims: <McPrim>[
        McPrim.circle(Pt(0.48, 0.46), 0.34, weight: 4),
        McPrim.circle(Pt(0.48, 0.46), 0.09, weight: 4),
        McPrim.text('r = 18 in', Pt(0.74, 0.16)),
        McPrim.text('r = 3 in', Pt(0.48, 0.46)),
        McPrim.line(Pt(0.57, 0.46), Pt(0.66, 0.46), weight: 2),
        McPrim.box(Pt(0.62, 0.60), Pt(0.72, 0.74)),
        McPrim.text('180 lb', Pt(0.67, 0.83)),
        McPrim.text('? effort', Pt(0.20, 0.84)),
      ],
    ),
  ),
  Question(
    id: 'mc-f06',
    subtest: Subtest.mc,
    stem:
        'A single fixed pulley has a 300 pound load on one end of its rope and '
        'a soldier pulling the other. What force must the soldier apply to hold '
        'the load steady?',
    choices: <String>['300 pounds', '150 pounds', '600 pounds', '100 pounds'],
    answerIndex: 0,
    explanation:
        'A fixed pulley changes the direction of a force but not its '
        'size, so the soldier must pull with 300 pounds. Halving it to 150 is the '
        'movable-pulley rule applied to the wrong machine, and doubling it to 600 '
        'confuses the load with the tension in both rope ends together.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pulleys'],
    figure: McFigure(
      caption:
          'A single fixed pulley with a 300 pound load on the left rope and '
          'an unknown pull on the right.',
      prims: <McPrim>[
        McPrim.line(Pt(0.34, 0.12), Pt(0.66, 0.12), weight: 4),
        McPrim.circle(Pt(0.50, 0.30), 0.10, weight: 4),
        McPrim.line(Pt(0.50, 0.20), Pt(0.50, 0.12), weight: 2),
        McPrim.line(Pt(0.40, 0.30), Pt(0.40, 0.66), weight: 2),
        McPrim.line(Pt(0.60, 0.30), Pt(0.60, 0.66), weight: 2),
        McPrim.box(Pt(0.34, 0.66), Pt(0.46, 0.80)),
        McPrim.text('300 lb', Pt(0.40, 0.89)),
        McPrim.arrow(Pt(0.66, 0.52), Pt(0.66, 0.70)),
        McPrim.text('?', Pt(0.72, 0.66)),
      ],
    ),
  ),
];
