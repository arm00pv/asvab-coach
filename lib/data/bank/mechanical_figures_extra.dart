import '../models/catalog.dart';
import '../models/question.dart';

/// Additional figure-based Mechanical Comprehension items.
///
/// The real subtest is figure-led, so these ten items carry a rendered diagram
/// and describe the same setup in words for the caption. Arithmetic is
/// deliberately round and every numeric answer has been recomputed by hand.
const List<Question> mechanicalFigureExtraBank = <Question>[
  Question(
    id: 'mc-f07',
    subtest: Subtest.mc,
    stem:
        'A 600 pound load hangs from a 6 foot beam that rests on two supports, '
        'one at each end. The load hangs 2 feet from the left support. What load '
        'does the right support carry?',
    choices: <String>['200 pounds', '300 pounds', '400 pounds', '600 pounds'],
    answerIndex: 0,
    explanation:
        'The two supports share the load in inverse proportion to distance, so '
        'the far support takes 600 x 2 / 6 = 200 pounds while the near support '
        'takes the larger share. Answering 400 pounds uses the 4 foot arm '
        'instead of the 2 foot one, and 300 pounds is right only for a load '
        'hanging at the midpoint.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.structure'],
    figure: McFigure(
      caption:
          'A 600 pound load hanging 2 feet from the left end of a 6 foot beam '
          'carried on two supports, with the right support marked with a '
          'question mark.',
      prims: <McPrim>[
        McPrim.line(Pt(0.14, 0.50), Pt(0.86, 0.50), weight: 6),
        McPrim.triangle(Pt(0.18, 0.50), Pt(0.12, 0.67), Pt(0.24, 0.67)),
        McPrim.triangle(Pt(0.82, 0.50), Pt(0.76, 0.67), Pt(0.88, 0.67)),
        McPrim.box(Pt(0.33, 0.27), Pt(0.46, 0.41)),
        McPrim.line(Pt(0.393, 0.41), Pt(0.393, 0.50), weight: 3),
        McPrim.text('600 lb', Pt(0.395, 0.19)),
        McPrim.text('2 ft', Pt(0.285, 0.79)),
        McPrim.text('4 ft', Pt(0.605, 0.79)),
        McPrim.text('?', Pt(0.82, 0.79)),
      ],
    ),
  ),
  Question(
    id: 'mc-f08',
    subtest: Subtest.mc,
    stem:
        'A steel beam is built into a wall at its left end and sticks out '
        'unsupported. A heavy load hangs from its free end. Where along the beam '
        'is the bending stress greatest?',
    choices: <String>[
      'At the free end',
      'At the wall end',
      'At the midpoint',
      'It is the same all along',
    ],
    answerIndex: 1,
    explanation:
        'A cantilever carries its whole load at the overhanging end, so the '
        'bending moment grows from zero there to its largest value at the wall, '
        'where the beam must resist the full load times its full length. That is '
        'why such a beam is deepest or braced at the wall. The free end merely '
        'holds the load, and even stress would need the load spread along the '
        'beam.',
    difficulty: Difficulty.hard,
    skills: <String>['mc.structure'],
    figure: McFigure(
      caption:
          'A beam built into a wall at the left and carrying a hanging load at '
          'its free right end, with a question mark over the beam near the wall.',
      prims: <McPrim>[
        McPrim.box(Pt(0.10, 0.14), Pt(0.18, 0.86)),
        McPrim.triangle(Pt(0.18, 0.50), Pt(0.18, 0.68), Pt(0.30, 0.68)),
        McPrim.line(Pt(0.18, 0.50), Pt(0.74, 0.50), weight: 6),
        McPrim.line(Pt(0.70, 0.50), Pt(0.70, 0.60), weight: 3),
        McPrim.box(Pt(0.63, 0.60), Pt(0.77, 0.74)),
        McPrim.text('wall', Pt(0.14, 0.09)),
        McPrim.text('load', Pt(0.70, 0.81)),
        McPrim.text('?', Pt(0.28, 0.38)),
      ],
    ),
  ),
  Question(
    id: 'mc-f09',
    subtest: Subtest.mc,
    stem:
        'A 100 pound crate sits on a concrete floor. A horizontal push of 40 '
        'pounds is applied to its left face and the crate does not move. How '
        'large is the friction force acting on the crate while the push is '
        'applied?',
    choices: <String>['0 pounds', '20 pounds', '40 pounds', '100 pounds'],
    answerIndex: 2,
    explanation:
        'Static friction takes whatever value is needed to oppose the push, up '
        'to its limit, so a crate held in place by a 40 pound push is held by '
        'exactly 40 pounds of friction. The zero answer is the trap for anyone '
        'who thinks friction appears only once something slides, and 100 pounds '
        'is the weight, which sets the limit rather than the force in play.',
    difficulty: Difficulty.easy,
    skills: <String>['mc.motion'],
    figure: McFigure(
      caption:
          'A 100 pound crate on a floor with a 40 pound push arrowed to the '
          'right and an unknown friction force arrowed to the left.',
      prims: <McPrim>[
        McPrim.line(Pt(0.08, 0.70), Pt(0.92, 0.70), weight: 4),
        McPrim.box(Pt(0.34, 0.42), Pt(0.58, 0.70)),
        McPrim.arrow(Pt(0.10, 0.56), Pt(0.32, 0.56)),
        McPrim.arrow(Pt(0.82, 0.56), Pt(0.60, 0.56)),
        McPrim.text('100 lb', Pt(0.46, 0.58)),
        McPrim.text('40 lb push', Pt(0.20, 0.44)),
        McPrim.text('friction ?', Pt(0.72, 0.44)),
      ],
    ),
  ),
  Question(
    id: 'mc-f10',
    subtest: Subtest.mc,
    stem:
        'A stone is released from rest at the mouth of a deep well. It falls 16 '
        'feet during the first second. How far below the release point is the '
        'stone at the end of 2 seconds?',
    choices: <String>['16 feet', '32 feet', '48 feet', '64 feet'],
    answerIndex: 3,
    explanation:
        'A body falling from rest covers distance in proportion to the square of '
        'the time, so twice the time means four times the distance: 16 x 4 = 64 '
        'feet. Doubling to 32 feet assumes a steady speed, and 48 feet is only '
        'the distance covered during the second second, not the total measured '
        'from the release point.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.motion'],
    figure: McFigure(
      caption:
          'A stone marked at the release point, at 1 second where it has fallen '
          '16 feet, and at 2 seconds where the distance is marked with a '
          'question mark.',
      prims: <McPrim>[
        McPrim.dashed(Pt(0.30, 0.10), Pt(0.30, 0.92)),
        McPrim.disc(Pt(0.30, 0.16), 0.04),
        McPrim.disc(Pt(0.30, 0.35), 0.04),
        McPrim.disc(Pt(0.30, 0.86), 0.04),
        McPrim.dashed(Pt(0.22, 0.35), Pt(0.40, 0.35)),
        McPrim.dashed(Pt(0.22, 0.86), Pt(0.40, 0.86)),
        McPrim.text('release', Pt(0.14, 0.16)),
        McPrim.text('1 s', Pt(0.13, 0.35)),
        McPrim.text('2 s', Pt(0.13, 0.86)),
        McPrim.text('16 ft', Pt(0.52, 0.25)),
        McPrim.text('?', Pt(0.52, 0.66)),
      ],
    ),
  ),
  Question(
    id: 'mc-f11',
    subtest: Subtest.mc,
    stem:
        'A hydraulic press has a small piston with an area of 4 square inches '
        'and a large piston with an area of 20 square inches. The large piston '
        'must lift a 600 pound load. What force must be applied to the small '
        'piston?',
    choices: <String>['120 pounds', '150 pounds', '600 pounds', '3000 pounds'],
    answerIndex: 0,
    explanation:
        'A confined liquid passes pressure on unchanged, so the large piston '
        'gets five times the force because 20 square inches is five times 4, and '
        'the input needs only 600 / 5 = 120 pounds. The price is distance: the '
        'small piston travels five times as far. Multiplying by the area ratio '
        'instead of dividing gives 3000 pounds, and 600 pounds ignores the area '
        'difference altogether.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pressure'],
    figure: McFigure(
      caption:
          'A hydraulic press: a 4 square inch piston pushed down on the left, '
          'joined by a fluid passage to a 20 square inch piston lifting a 600 '
          'pound load on the right.',
      prims: <McPrim>[
        McPrim.line(Pt(0.10, 0.30), Pt(0.10, 0.70)),
        McPrim.line(Pt(0.24, 0.30), Pt(0.24, 0.60)),
        McPrim.line(Pt(0.24, 0.60), Pt(0.56, 0.60)),
        McPrim.line(Pt(0.56, 0.20), Pt(0.56, 0.60)),
        McPrim.line(Pt(0.90, 0.20), Pt(0.90, 0.70)),
        McPrim.line(Pt(0.10, 0.70), Pt(0.90, 0.70)),
        McPrim.line(Pt(0.10, 0.38), Pt(0.24, 0.38), weight: 4),
        McPrim.line(Pt(0.17, 0.38), Pt(0.17, 0.26), weight: 3),
        McPrim.arrow(Pt(0.17, 0.10), Pt(0.17, 0.24)),
        McPrim.text('?', Pt(0.32, 0.14)),
        McPrim.line(Pt(0.56, 0.40), Pt(0.90, 0.40), weight: 4),
        McPrim.line(Pt(0.73, 0.40), Pt(0.73, 0.28), weight: 3),
        McPrim.box(Pt(0.62, 0.14), Pt(0.84, 0.28)),
        McPrim.text('600 lb', Pt(0.73, 0.21)),
        McPrim.text('4 sq in', Pt(0.17, 0.52)),
        McPrim.text('20 sq in', Pt(0.73, 0.56)),
        McPrim.text('fluid', Pt(0.40, 0.65)),
      ],
    ),
  ),
  Question(
    id: 'mc-f12',
    subtest: Subtest.mc,
    stem:
        'A hose runs from a drum of water, up over a wall, and down into a tank '
        'whose water surface sits lower than the surface in the drum. Once the '
        'hose is full, water flows through it on its own. What sets the greatest '
        'height of wall that a water siphon can cross?',
    choices: <String>[
      'The weight of the water standing in the hose',
      'The pressure that the atmosphere provides',
      'The strength of the hose walls under vacuum',
      'The friction of the water inside the hose',
    ],
    answerIndex: 1,
    explanation:
        'A siphon is driven by the atmosphere pressing on the surface of the '
        'drum, which pushes water up the short leg while the longer falling leg '
        'keeps the flow moving. Air pressure can hold up a column of water only '
        'about 34 feet tall, so a wall taller than that has nothing left to lift '
        'the water. The weight of the column is exactly what that pressure is '
        'holding, and hose friction slows a siphon without setting a fixed '
        'limit.',
    difficulty: Difficulty.hard,
    skills: <String>['mc.pressure'],
    figure: McFigure(
      caption:
          'A hose running from a drum of water up over a wall and down into a '
          'lower tank, with the wall height marked with a question mark.',
      prims: <McPrim>[
        McPrim.box(Pt(0.08, 0.44), Pt(0.30, 0.84)),
        McPrim.dashed(Pt(0.08, 0.52), Pt(0.30, 0.52)),
        McPrim.box(Pt(0.44, 0.30), Pt(0.50, 0.84)),
        McPrim.line(Pt(0.20, 0.72), Pt(0.20, 0.24), weight: 3),
        McPrim.line(Pt(0.20, 0.24), Pt(0.60, 0.24), weight: 3),
        McPrim.line(Pt(0.60, 0.24), Pt(0.60, 0.72), weight: 3),
        McPrim.arrow(Pt(0.28, 0.24), Pt(0.40, 0.24)),
        McPrim.box(Pt(0.52, 0.60), Pt(0.76, 0.84)),
        McPrim.dashed(Pt(0.52, 0.68), Pt(0.76, 0.68)),
        McPrim.text('water', Pt(0.13, 0.62)),
        McPrim.text('?', Pt(0.545, 0.40)),
        McPrim.text('drum', Pt(0.19, 0.91)),
        McPrim.text('wall', Pt(0.47, 0.91)),
        McPrim.text('tank', Pt(0.64, 0.91)),
      ],
    ),
  ),
  Question(
    id: 'mc-f13',
    subtest: Subtest.mc,
    stem:
        'A wheelbarrow carries a 240 pound load in its tray, 2 feet in front of '
        'the axle of the wheel. The handles are 6 feet behind the axle. What '
        'effort at the handles is needed to hold the load up?',
    choices: <String>['40 pounds', '60 pounds', '80 pounds', '240 pounds'],
    answerIndex: 2,
    explanation:
        'A wheelbarrow is a class 2 lever: the load sits between the axle, which '
        'is the fulcrum, and the hands. The advantage is the effort arm over the '
        'load arm, 6 / 2 = 3, so the hands carry 240 / 3 = 80 pounds. Using the '
        '6 foot arm as if it were the advantage gives 40 pounds, and 240 pounds '
        'ignores the lever, which is why the tray sits close to the wheel.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.levers'],
    figure: McFigure(
      caption:
          'A wheelbarrow with a wheel and axle, a 240 pound load in the tray 2 '
          'feet from the axle, and handles 6 feet from the axle with an upward '
          'effort arrowed and marked with a question mark.',
      prims: <McPrim>[
        McPrim.circle(Pt(0.16, 0.70), 0.11, weight: 4),
        McPrim.disc(Pt(0.16, 0.70), 0.02),
        McPrim.line(Pt(0.16, 0.70), Pt(0.88, 0.70), weight: 4),
        McPrim.box(Pt(0.24, 0.52), Pt(0.56, 0.70)),
        McPrim.box(Pt(0.31, 0.36), Pt(0.47, 0.52)),
        McPrim.text('240 lb', Pt(0.39, 0.28)),
        McPrim.arrow(Pt(0.86, 0.70), Pt(0.86, 0.46)),
        McPrim.text('?', Pt(0.78, 0.56)),
        McPrim.text('2 ft', Pt(0.275, 0.91)),
        McPrim.text('6 ft', Pt(0.70, 0.91)),
      ],
    ),
  ),
  Question(
    id: 'mc-f14',
    subtest: Subtest.mc,
    stem:
        'The thread of a screw jack lifts its load 1/4 inch for every complete '
        'turn. The handle sweeps a circle 40 inches around. Ignoring friction, '
        'what is the mechanical advantage of this jack?',
    choices: <String>['10', '40', '80', '160'],
    answerIndex: 3,
    explanation:
        'Mechanical advantage is the distance moved by the effort divided by the '
        'distance moved by the load, and here that is 40 / 0.25 = 160. A screw '
        'is an inclined plane wrapped round a cylinder, so a fine thread turned '
        'by a long handle buys a very large force at the cost of many turns. '
        'Multiplying the two numbers gives 10, and quoting the 40 inch handle '
        'path alone ignores the thread completely.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pulleys'],
    figure: McFigure(
      caption:
          'A screw jack: a threaded body on a base plate, a rising screw with a '
          'load on top, and a handle across the screw.',
      prims: <McPrim>[
        McPrim.box(Pt(0.26, 0.78), Pt(0.66, 0.88)),
        McPrim.box(Pt(0.32, 0.52), Pt(0.60, 0.78)),
        McPrim.line(Pt(0.32, 0.60), Pt(0.60, 0.60)),
        McPrim.line(Pt(0.32, 0.66), Pt(0.60, 0.66)),
        McPrim.line(Pt(0.32, 0.72), Pt(0.60, 0.72)),
        McPrim.line(Pt(0.46, 0.52), Pt(0.46, 0.28), weight: 5),
        McPrim.line(Pt(0.16, 0.38), Pt(0.74, 0.38), weight: 4),
        McPrim.box(Pt(0.72, 0.32), Pt(0.78, 0.44)),
        McPrim.box(Pt(0.34, 0.14), Pt(0.58, 0.28)),
        McPrim.text('load', Pt(0.46, 0.21)),
        McPrim.text('handle', Pt(0.22, 0.46)),
        McPrim.text('pitch 1/4 in', Pt(0.76, 0.56)),
      ],
    ),
  ),
  Question(
    id: 'mc-f15',
    subtest: Subtest.mc,
    stem:
        'Two pulleys of the same diameter are joined by a flat belt, and the '
        'belt crosses itself between them. The driving pulley turns clockwise at '
        '120 rpm. What does the other pulley do?',
    choices: <String>[
      '120 rpm counterclockwise',
      '120 rpm clockwise',
      '60 rpm counterclockwise',
      '240 rpm counterclockwise',
    ],
    answerIndex: 0,
    explanation:
        'A crossed belt reverses the driven pulley, because the stretch of belt '
        'that leaves the top of the driver arrives at the bottom of the driven '
        'pulley. Equal diameters leave the speed unchanged, so the second pulley '
        'turns at 120 rpm counterclockwise. An open belt would keep the same '
        'direction, and halving or doubling the speed would need pulleys of '
        'different sizes.',
    difficulty: Difficulty.easy,
    skills: <String>['mc.pulleys'],
    figure: McFigure(
      caption:
          'Two equal pulleys joined by a belt that crosses between them: pulley '
          'A is driven clockwise at 120 rpm and pulley B is marked with a '
          'question mark.',
      prims: <McPrim>[
        McPrim.circle(Pt(0.24, 0.46), 0.16, weight: 4),
        McPrim.circle(Pt(0.76, 0.46), 0.16, weight: 4),
        McPrim.line(Pt(0.306, 0.347), Pt(0.694, 0.573), weight: 3),
        McPrim.line(Pt(0.306, 0.573), Pt(0.694, 0.347), weight: 3),
        McPrim.text('A', Pt(0.24, 0.46)),
        McPrim.text('B', Pt(0.76, 0.46)),
        McPrim.text('120 rpm CW', Pt(0.24, 0.75)),
        McPrim.text('?', Pt(0.76, 0.75)),
      ],
    ),
  ),
  Question(
    id: 'mc-f16',
    subtest: Subtest.mc,
    stem:
        'Two blocks of exactly the same size hang from the ends of a balance '
        'beam, one of aluminum and one of steel. The beam is released from '
        'level. What happens?',
    choices: <String>[
      'The beam stays level because both blocks are the same size',
      'The steel side drops because steel is denser for its size',
      'The aluminum side drops because aluminum is lighter',
      'The steel side rises because steel is stiffer than aluminum',
    ],
    answerIndex: 1,
    explanation:
        'Two blocks of the same size have the same volume, so the balance is '
        'really comparing the weight of equal amounts of each metal, and steel '
        'is about three times as dense as aluminum. The steel side therefore '
        'drops. A level beam is the trap for anyone who reads size as weight, '
        'and stiffness has nothing to do with which side of a balance falls.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.materials'],
    figure: McFigure(
      caption:
          'A balance beam on a central fulcrum with an aluminum block on the '
          'left end and a steel block of the same size on the right end, the '
          'tilt marked with a question mark.',
      prims: <McPrim>[
        McPrim.triangle(Pt(0.50, 0.56), Pt(0.43, 0.76), Pt(0.57, 0.76)),
        McPrim.line(Pt(0.10, 0.56), Pt(0.90, 0.56), weight: 5),
        McPrim.line(Pt(0.24, 0.56), Pt(0.24, 0.62), weight: 2),
        McPrim.line(Pt(0.76, 0.56), Pt(0.76, 0.62), weight: 2),
        McPrim.box(Pt(0.16, 0.62), Pt(0.32, 0.80)),
        McPrim.box(Pt(0.68, 0.62), Pt(0.84, 0.80)),
        McPrim.text('?', Pt(0.50, 0.44)),
        McPrim.text('aluminum', Pt(0.24, 0.88)),
        McPrim.text('steel', Pt(0.76, 0.88)),
        McPrim.text('same size', Pt(0.50, 0.88)),
      ],
    ),
  ),
];
