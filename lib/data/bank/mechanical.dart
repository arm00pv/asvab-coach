import '../models/catalog.dart';
import '../models/question.dart';

/// Mechanical Comprehension bank: 20 items across levers, pulleys and gears,
/// pressure and fluids, and structure and motion. Every numeric answer has
/// been checked by hand.
const List<Question> mechanicalBank = <Question>[
  Question(
    id: 'mc-001',
    subtest: Subtest.mc,
    stem: 'A wheelbarrow is an example of which class of lever?',
    choices: <String>[
      'Class 1',
      'Class 2',
      'Class 3',
      'None, it is not a lever',
    ],
    answerIndex: 1,
    explanation:
        'A wheelbarrow has the wheel, which is the fulcrum, at the front, the '
        'load in the tray between the wheel and your hands, and the effort at the '
        'handles. Load in the middle means a class 2 lever, and that layout always '
        'gives more than one unit of mechanical advantage. A crowbar is class 1 with '
        'the fulcrum in the middle, and tongs are class 3 with the effort in the middle.',
    difficulty: Difficulty.easy,
    skills: <String>['mc.levers'],
  ),
  Question(
    id: 'mc-002',
    subtest: Subtest.mc,
    stem:
        'A 60 lb child sits 3 ft from the fulcrum of a seesaw. How far from the fulcrum must a '
        '20 lb child sit on the other side to balance it?',
    choices: <String>['6 ft', '8 ft', '9 ft', '12 ft'],
    answerIndex: 2,
    explanation:
        'Balance requires equal moments, so 60 lb times 3 ft gives 180 pound-feet on one '
        'side and the 20 lb child must sit where 20 times the distance equals 180, which is '
        '9 ft. The lighter rider always sits farther out. The 6 ft option comes from dividing '
        'the weights and ignoring distance, which is the usual moment mistake.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.levers'],
    figure: McFigure(
      caption:
          'A seesaw with a 60 pound child 3 feet left of the fulcrum and a 20 '
          'pound child on the right arm, whose distance is marked with a '
          'question mark.',
      prims: <McPrim>[
        McPrim.line(Pt(0.14, 0.50), Pt(0.84, 0.50), weight: 5),
        McPrim.triangle(Pt(0.34, 0.50), Pt(0.28, 0.66), Pt(0.40, 0.66)),
        McPrim.box(Pt(0.10, 0.38), Pt(0.18, 0.50)),
        McPrim.text('60 lb', Pt(0.14, 0.30)),
        McPrim.box(Pt(0.78, 0.38), Pt(0.86, 0.50)),
        McPrim.text('20 lb', Pt(0.82, 0.30)),
        McPrim.dashed(Pt(0.14, 0.74), Pt(0.84, 0.74)),
        McPrim.text('3 ft', Pt(0.24, 0.83)),
        McPrim.text('? ft', Pt(0.60, 0.83)),
      ],
    ),
  ),
  Question(
    id: 'mc-003',
    subtest: Subtest.mc,
    stem:
        'Which of these tools works as a lever with a mechanical advantage always less than '
        'one?',
    choices: <String>[
      'A crowbar',
      'A wheelbarrow',
      'A nutcracker',
      'A pair of tongs',
    ],
    answerIndex: 3,
    explanation:
        'In a class 3 lever the effort is applied between the fulcrum and the load, so '
        'the effort arm is the short one and the advantage is always less than one. Tongs, '
        'tweezers and a fishing rod all work that way, and the trade is speed and reach rather '
        'than force. A crowbar is class 1, and a wheelbarrow and a nutcracker are class 2 with '
        'the load in the middle, so both give an advantage above one.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.levers'],
  ),
  Question(
    id: 'mc-004',
    subtest: Subtest.mc,
    stem:
        'A bar is used as a lever with the effort 2 feet from the fulcrum and the load 8 inches '
        'from the fulcrum. What is the mechanical advantage?',
    choices: <String>['2', '2.5', '3', '4'],
    answerIndex: 2,
    explanation:
        'The effort arm is 2 feet, or 24 inches, and the load arm is 8 inches, so the '
        'advantage is 24 divided by 8, which is 3. Each pound of push lifts 3 pounds, though the '
        'load rises only one third as far as your hand moves. Comparing 2 feet directly with 8 '
        'inches without converting the units is what produces a nonsense answer below one.',
    difficulty: Difficulty.hard,
    skills: <String>['mc.levers'],
    figure: McFigure(
      caption:
          'A class 1 lever with a load 8 inches from the fulcrum and a '
          'downward effort 2 feet from it, with both arms marked underneath.',
      prims: <McPrim>[
        McPrim.line(Pt(0.15, 0.52), Pt(0.93, 0.52), weight: 5),
        McPrim.triangle(Pt(0.345, 0.52), Pt(0.285, 0.68), Pt(0.405, 0.68)),
        McPrim.box(Pt(0.115, 0.40), Pt(0.175, 0.52)),
        McPrim.text('load', Pt(0.145, 0.33)),
        McPrim.arrow(Pt(0.86, 0.28), Pt(0.86, 0.50)),
        McPrim.text('effort', Pt(0.86, 0.20)),
        McPrim.dashed(Pt(0.145, 0.76), Pt(0.86, 0.76)),
        McPrim.text('8 in', Pt(0.245, 0.85)),
        McPrim.text('2 ft', Pt(0.60, 0.85)),
      ],
    ),
  ),
  Question(
    id: 'mc-005',
    subtest: Subtest.mc,
    stem:
        'A steering wheel 16 inches across turns a shaft 2 inches across. What is the '
        'mechanical advantage of this wheel and axle?',
    choices: <String>['4', '8', '12', '16'],
    answerIndex: 1,
    explanation:
        'For a wheel and axle the advantage is the wheel radius divided by the axle '
        'radius. A 16 inch wheel has an 8 inch radius and a 2 inch shaft has a 1 inch radius, so '
        'the ratio is 8 to 1. That is why a large wheel lets a driver turn a heavy shaft with '
        'light hand pressure.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.levers'],
    figure: McFigure(
      caption:
          'A steering wheel 16 inches across turning a shaft 2 inches across, '
          'with both diameters marked.',
      prims: <McPrim>[
        McPrim.circle(Pt(0.40, 0.46), 0.28, weight: 4),
        McPrim.disc(Pt(0.40, 0.46), 0.035),
        McPrim.line(Pt(0.40, 0.495), Pt(0.40, 0.74)),
        McPrim.line(Pt(0.3822, 0.4425), Pt(0.2574, 0.32)),
        McPrim.line(Pt(0.4178, 0.4425), Pt(0.5426, 0.32)),
        McPrim.line(Pt(0.43, 0.49), Pt(0.62, 0.62)),
        McPrim.text('wheel', Pt(0.18, 0.21)),
        McPrim.text('2 in across', Pt(0.76, 0.66)),
        McPrim.dashed(Pt(0.235, 0.86), Pt(0.565, 0.86)),
        McPrim.text('16 in across', Pt(0.40, 0.91)),
      ],
    ),
  ),
  Question(
    id: 'mc-006',
    subtest: Subtest.mc,
    stem: 'What does a single fixed pulley do for the person lifting a load?',
    choices: <String>[
      'It changes the direction of the pull without changing its size',
      'It doubles the load that the rope can lift',
      'It halves the effort needed to raise the load',
      'It reduces the effort to one quarter of the load weight',
    ],
    answerIndex: 0,
    explanation:
        'One fixed pulley is only a redirect. A single rope section still '
        'holds the load, so the mechanical advantage is 1 and you pull with the full '
        'weight of the load. The return is a change of direction, letting you pull down '
        'to lift a load up. Effort drops only when a pulley moves along with the load.',
    difficulty: Difficulty.easy,
    skills: <String>['mc.pulleys'],
  ),
  Question(
    id: 'mc-007',
    subtest: Subtest.mc,
    stem:
        'A block and tackle holds a 240 lb load with six rope sections pulling upward on the '
        'movable block. What effort is needed to hold the load?',
    choices: <String>['240 lb', '120 lb', '80 lb', '40 lb'],
    answerIndex: 3,
    explanation:
        'Count only the rope sections that pull upward on the movable block, then divide '
        'the load by that number. Six sections split 240 lb into six 40 lb shares. The trade is '
        'distance: you haul six feet of rope to raise the load one foot. The 120 lb and 80 lb '
        'answers would match only two or three supporting sections.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pulleys'],
    figure: McFigure(
      caption:
          'A block and tackle with a fixed block at the top and a movable '
          'block carrying a 240 pound load, joined by six rope sections, with '
          'the pull marked with a question mark.',
      prims: <McPrim>[
        McPrim.line(Pt(0.22, 0.10), Pt(0.78, 0.10), weight: 4),
        McPrim.line(Pt(0.50, 0.10), Pt(0.50, 0.14)),
        McPrim.box(Pt(0.32, 0.14), Pt(0.68, 0.30)),
        McPrim.box(Pt(0.32, 0.56), Pt(0.68, 0.72)),
        McPrim.line(Pt(0.36, 0.30), Pt(0.36, 0.56)),
        McPrim.line(Pt(0.42, 0.30), Pt(0.42, 0.56)),
        McPrim.line(Pt(0.48, 0.30), Pt(0.48, 0.56)),
        McPrim.line(Pt(0.54, 0.30), Pt(0.54, 0.56)),
        McPrim.line(Pt(0.60, 0.30), Pt(0.60, 0.56)),
        McPrim.line(Pt(0.66, 0.30), Pt(0.66, 0.56)),
        McPrim.box(Pt(0.42, 0.72), Pt(0.58, 0.88)),
        McPrim.text('240 lb', Pt(0.50, 0.80)),
        McPrim.line(Pt(0.68, 0.22), Pt(0.78, 0.22)),
        McPrim.arrow(Pt(0.78, 0.22), Pt(0.78, 0.46)),
        McPrim.text('?', Pt(0.78, 0.56)),
        McPrim.line(Pt(0.26, 0.43), Pt(0.345, 0.43)),
        McPrim.text('6 sections', Pt(0.145, 0.43)),
      ],
    ),
  ),
  Question(
    id: 'mc-008',
    subtest: Subtest.mc,
    stem:
        'Two gears are meshed, and the driving gear turns clockwise. Which way does the driven '
        'gear turn?',
    choices: <String>[
      'Counter-clockwise at the same speed',
      'Clockwise at the same speed',
      'Clockwise at half the speed',
      'Clockwise at twice the speed',
    ],
    answerIndex: 0,
    explanation:
        'Meshed gears turn in opposite directions, because at the contact point the '
        'driving tooth pushes the driven tooth backward relative to its own motion. Two pulleys '
        'joined by a plain flat belt keep turning the same way, and only a crossed belt reverses '
        'them. Speed depends on tooth counts, not on direction.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pulleys'],
    figure: McFigure(
      caption:
          'Two meshed gears: the driving gear is turning clockwise and the '
          'driven gear is marked with a question mark.',
      prims: <McPrim>[
        McPrim.circle(Pt(0.30, 0.50), 0.28, weight: 4),
        McPrim.circle(Pt(0.63, 0.50), 0.28, weight: 4),
        McPrim.disc(Pt(0.30, 0.50), 0.02),
        McPrim.disc(Pt(0.63, 0.50), 0.02),
        McPrim.arrow(Pt(0.25, 0.26), Pt(0.35, 0.26)),
        McPrim.text('A', Pt(0.30, 0.66)),
        McPrim.text('B', Pt(0.63, 0.66)),
        McPrim.text('turns clockwise', Pt(0.30, 0.90)),
        McPrim.text('?', Pt(0.63, 0.90)),
      ],
    ),
  ),
  Question(
    id: 'mc-009',
    subtest: Subtest.mc,
    stem:
        'A motor running at 1,200 rpm drives a 12 tooth sprocket chained to a 36 tooth sprocket. '
        'At what speed does the 36 tooth sprocket turn?',
    choices: <String>['300 rpm', '400 rpm', '1,200 rpm', '3,600 rpm'],
    answerIndex: 1,
    explanation:
        'The speed ratio is the driving tooth count over the driven tooth count, so 12 '
        'over 36 is one third, and 1,200 rpm becomes 400 rpm. Torque is multiplied by the same '
        'factor of three, which is the point of the smaller driving sprocket. The 3,600 rpm '
        'answer multiplies instead of dividing, and 300 rpm would need a 4 to 1 ratio.',
    difficulty: Difficulty.hard,
    skills: <String>['mc.pulleys'],
    figure: McFigure(
      caption:
          'A motor driving a 12 tooth sprocket that is chained to a 36 tooth '
          'sprocket, whose speed is marked with a question mark.',
      prims: <McPrim>[
        McPrim.box(Pt(0.05, 0.39), Pt(0.18, 0.61)),
        McPrim.text('motor', Pt(0.115, 0.50)),
        McPrim.line(Pt(0.18, 0.50), Pt(0.281, 0.50), weight: 3),
        McPrim.circle(Pt(0.34, 0.50), 0.10, weight: 4),
        McPrim.circle(Pt(0.66, 0.50), 0.30, weight: 4),
        McPrim.line(Pt(0.318, 0.407), Pt(0.595, 0.221), weight: 2),
        McPrim.line(Pt(0.362, 0.593), Pt(0.725, 0.779), weight: 2),
        McPrim.text('12 T', Pt(0.34, 0.50)),
        McPrim.text('36 T', Pt(0.66, 0.50)),
        McPrim.text('1200 rpm', Pt(0.34, 0.72)),
        McPrim.text('?', Pt(0.66, 0.90)),
      ],
    ),
  ),
  Question(
    id: 'mc-010',
    subtest: Subtest.mc,
    stem:
        'A screw is basically which simple machine wrapped around a cylinder?',
    choices: <String>[
      'A wheel and axle',
      'A class 1 lever',
      'A movable pulley',
      'An inclined plane',
    ],
    answerIndex: 3,
    explanation:
        'Unwrap one turn of a thread and you have a ramp. Each turn of the screw carries '
        'the load up the slope of the pitch, and a fine thread is a gentler slope with a larger '
        'advantage. No pulley, lever or wheel is involved, so the other choices describe '
        'different machines.',
    difficulty: Difficulty.easy,
    skills: <String>['mc.pulleys'],
  ),
  Question(
    id: 'mc-011',
    subtest: Subtest.mc,
    stem:
        'A force of 300 lb pushes on a piston with an area of 3 square inches. What pressure '
        'does it create?',
    choices: <String>['30 psi', '100 psi', '300 psi', '900 psi'],
    answerIndex: 1,
    explanation:
        'Pressure is force divided by area, so 300 lb spread over 3 square inches is 100 '
        'pounds per square inch. The same force on a smaller piston gives a higher pressure and '
        'on a larger piston a lower one. Multiplying 300 by 3 to reach 900 psi is the common '
        'slip, and 300 psi would be the reading if the piston were exactly one square inch.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pressure'],
    figure: McFigure(
      caption:
          'A piston with an area of 3 square inches pushed with 300 pounds, '
          'with the pressure it creates inside the cylinder marked with a '
          'question mark.',
      prims: <McPrim>[
        McPrim.line(Pt(0.30, 0.34), Pt(0.30, 0.88), weight: 3),
        McPrim.line(Pt(0.56, 0.34), Pt(0.56, 0.88), weight: 3),
        McPrim.line(Pt(0.28, 0.88), Pt(0.58, 0.88), weight: 3),
        McPrim.line(Pt(0.30, 0.46), Pt(0.56, 0.46), weight: 4),
        McPrim.line(Pt(0.43, 0.46), Pt(0.43, 0.26), weight: 4),
        McPrim.arrow(Pt(0.43, 0.10), Pt(0.43, 0.24)),
        McPrim.text('300 lb', Pt(0.33, 0.15)),
        McPrim.line(Pt(0.56, 0.46), Pt(0.64, 0.46)),
        McPrim.text('3 sq in', Pt(0.77, 0.46)),
        McPrim.text('pressure ?', Pt(0.43, 0.62)),
      ],
    ),
  ),
  Question(
    id: 'mc-012',
    subtest: Subtest.mc,
    stem:
        'In a hydraulic lift the input piston has 2 square inches of area, the output piston has '
        '20 square inches, and 50 lb pushes on the input. What force appears at the output?',
    choices: <String>['5 lb', '50 lb', '100 lb', '500 lb'],
    answerIndex: 3,
    explanation:
        'The output piston has ten times the area, so the same pressure acting on it '
        'produces ten times the force and 50 lb becomes 500 lb. The price is distance, since the '
        'output moves only one tenth as far as the input. A 5 lb answer comes from dividing in '
        'the wrong direction, and 100 lb from doubling instead of using the full area ratio.',
    difficulty: Difficulty.hard,
    skills: <String>['mc.pressure'],
    figure: McFigure(
      caption:
          'A hydraulic lift with 50 pounds on a 2 square inch piston feeding a '
          '20 square inch piston, whose output force is marked with a question '
          'mark.',
      prims: <McPrim>[
        McPrim.line(Pt(0.14, 0.26), Pt(0.14, 0.82), weight: 3),
        McPrim.line(Pt(0.28, 0.26), Pt(0.28, 0.68), weight: 3),
        McPrim.line(Pt(0.28, 0.68), Pt(0.58, 0.68), weight: 3),
        McPrim.line(Pt(0.58, 0.26), Pt(0.58, 0.68), weight: 3),
        McPrim.line(Pt(0.86, 0.26), Pt(0.86, 0.82), weight: 3),
        McPrim.line(Pt(0.14, 0.82), Pt(0.86, 0.82), weight: 3),
        McPrim.line(Pt(0.14, 0.42), Pt(0.28, 0.42), weight: 4),
        McPrim.line(Pt(0.21, 0.42), Pt(0.21, 0.26), weight: 3),
        McPrim.arrow(Pt(0.21, 0.10), Pt(0.21, 0.24)),
        McPrim.text('50 lb', Pt(0.30, 0.15)),
        McPrim.text('2 sq in', Pt(0.21, 0.54)),
        McPrim.line(Pt(0.58, 0.38), Pt(0.86, 0.38), weight: 4),
        McPrim.line(Pt(0.72, 0.38), Pt(0.72, 0.26), weight: 3),
        McPrim.box(Pt(0.63, 0.14), Pt(0.81, 0.26)),
        McPrim.text('?', Pt(0.72, 0.20)),
        McPrim.text('20 sq in', Pt(0.72, 0.54)),
        McPrim.text('fluid', Pt(0.43, 0.75)),
      ],
    ),
  ),
  Question(
    id: 'mc-013',
    subtest: Subtest.mc,
    stem:
        'Why does a force applied at one end of a sealed hydraulic line push a piston at the far '
        'end?',
    choices: <String>[
      'Pressure put on a confined fluid is transmitted equally through it',
      'The fluid is squeezed into a smaller volume at the far end',
      'The pump pulls the far piston forward with a vacuum',
      'The fluid gains pressure as it cools inside the line',
    ],
    answerIndex: 0,
    explanation:
        'A confined liquid transmits pressure equally in every direction, so the same '
        'pressure acts on every square inch of the far piston, and a larger area there means a '
        'larger force. Liquids are nearly incompressible, so they are not squeezed smaller at '
        'the far end. A pump pushes rather than pulling a vacuum, and a fluid does not gain '
        'pressure by cooling.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pressure'],
  ),
  Question(
    id: 'mc-014',
    subtest: Subtest.mc,
    stem: 'Why does water boil at a lower temperature in the mountains than at sea level?',
    choices: <String>[
      'Water molecules move faster in the thinner mountain air',
      'Dissolved oxygen leaves the water as altitude increases',
      'Lower air pressure lets water boil at a lower temperature',
      'Mountain water is colder, so it reaches a boil sooner',
    ],
    answerIndex: 2,
    explanation:
        'Boiling starts when the vapor pressure inside the water matches the pressure '
        'pushing down on its surface, and with less air pressing down at altitude that balance '
        'is reached at a lower temperature. Near sea level the figure is about 212 degrees F, '
        'and it drops as you climb. Molecule speed and dissolved oxygen do not set the boiling '
        'point.',
    difficulty: Difficulty.hard,
    skills: <String>['mc.pressure'],
  ),
  Question(
    id: 'mc-015',
    subtest: Subtest.mc,
    stem: 'Why does a steel ship float while a solid steel bar sinks?',
    choices: <String>[
      'The hull displaces water whose weight equals the weight of the ship',
      'The steel plate in a hull is lighter than water',
      'Air trapped inside the hull presses down on the water',
      'Seawater pushes up harder than the ship pushes down',
    ],
    answerIndex: 0,
    explanation:
        'A hull is shaped so the water it pushes aside weighs exactly as much as the ship, '
        'and that upward push balances the weight, so the ship floats. A solid bar of steel '
        'displaces far too little water for its weight and sinks. Steel is several times denser '
        'than water, and air inside a hull helps only because it adds volume, not weight.',
    difficulty: Difficulty.easy,
    skills: <String>['mc.pressure'],
  ),
  Question(
    id: 'mc-016',
    subtest: Subtest.mc,
    stem:
        'A beam sags under a load hung at its middle. Its top surface is in one kind of stress '
        'and its bottom surface in the other. Which is right?',
    choices: <String>[
      'Tension on top and compression on the bottom',
      'Compression on top and tension on the bottom',
      'Shear on top and torsion on the bottom',
      'Torsion on top and shear on the bottom',
    ],
    answerIndex: 1,
    explanation:
        'As the beam bends downward it curves like a frown, so the top surface gets '
        'shorter and is in compression while the bottom surface stretches and is in tension. A '
        'truss carries the same load with separate members, some pushed and some pulled, '
        'arranged in triangles. Shear and torsion are cutting and twisting actions, not what a '
        'sagging beam shows.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.structure'],
    figure: McFigure(
      caption:
          'A beam sagging on two supports under a load hung at its middle, '
          'with the top and bottom surfaces each marked with a question mark.',
      prims: <McPrim>[
        McPrim.line(Pt(0.14, 0.40), Pt(0.29, 0.475), weight: 4),
        McPrim.line(Pt(0.29, 0.475), Pt(0.50, 0.525), weight: 4),
        McPrim.line(Pt(0.50, 0.525), Pt(0.71, 0.475), weight: 4),
        McPrim.line(Pt(0.71, 0.475), Pt(0.86, 0.40), weight: 4),
        McPrim.line(Pt(0.14, 0.44), Pt(0.29, 0.515), weight: 4),
        McPrim.line(Pt(0.29, 0.515), Pt(0.50, 0.565), weight: 4),
        McPrim.line(Pt(0.50, 0.565), Pt(0.71, 0.515), weight: 4),
        McPrim.line(Pt(0.71, 0.515), Pt(0.86, 0.44), weight: 4),
        McPrim.line(Pt(0.14, 0.40), Pt(0.14, 0.44), weight: 4),
        McPrim.line(Pt(0.86, 0.40), Pt(0.86, 0.44), weight: 4),
        McPrim.triangle(Pt(0.14, 0.44), Pt(0.08, 0.60), Pt(0.20, 0.60)),
        McPrim.triangle(Pt(0.86, 0.44), Pt(0.80, 0.60), Pt(0.92, 0.60)),
        McPrim.line(Pt(0.50, 0.565), Pt(0.50, 0.62)),
        McPrim.box(Pt(0.42, 0.62), Pt(0.58, 0.74)),
        McPrim.text('load', Pt(0.50, 0.68)),
        McPrim.text('top ?', Pt(0.66, 0.40)),
        McPrim.text('bottom ?', Pt(0.69, 0.63)),
      ],
    ),
  ),
  Question(
    id: 'mc-017',
    subtest: Subtest.mc,
    stem: 'Why is a hollow tube stiffer in bending than a solid rod of the same weight?',
    choices: <String>[
      'Tube steel is hardened by the way the tube is rolled',
      'The air trapped inside the tube carries part of the load',
      'A tube has less surface area for the load to press against',
      'Its material sits far from the centre, where bending stress is greatest',
    ],
    answerIndex: 3,
    explanation:
        'Bending puts the most stress on material farthest from the centre line, so '
        'moving metal outward does far more for stiffness than piling metal near the middle. '
        'With the same weight as a solid rod, a tube therefore resists bending much better. Air '
        'inside carries no load, and tubing is not automatically a harder grade of steel.',
    difficulty: Difficulty.hard,
    skills: <String>['mc.structure'],
  ),
  Question(
    id: 'mc-018',
    subtest: Subtest.mc,
    stem: 'How does oil reduce friction between two sliding steel surfaces?',
    choices: <String>[
      'It keeps a film between the surfaces so they slide on the film',
      'It roughens the surfaces so that they grip each other better',
      'It carries electricity away so the surfaces stay cool',
      'It removes metal from the surfaces until they are smooth',
    ],
    answerIndex: 0,
    explanation:
        'Oil forms a thin film between the parts so the metal rides on the film instead of '
        'on the other part, which cuts both friction and wear. That film is why an engine seizes '
        'within seconds once oil pressure is lost. Oil does not roughen surfaces, cool by '
        'carrying electricity, or grind metal away.',
    difficulty: Difficulty.easy,
    skills: <String>['mc.structure'],
  ),
  Question(
    id: 'mc-019',
    subtest: Subtest.mc,
    stem: 'A passenger feels thrown forward when a car brakes hard. Which property causes this?',
    choices: <String>['Gravity', 'Friction', 'Inertia', 'Air pressure'],
    answerIndex: 2,
    explanation:
        'Inertia is the tendency of an object to keep doing what it is already doing, so '
        'the passenger keeps moving forward at the old speed while the car slows down. The seat '
        'belt supplies the outside force that changes the passenger motion. Gravity pulls '
        'downward, friction acts along surfaces, and air pressure is not what produces the jolt.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.structure'],
  ),
  Question(
    id: 'mc-020',
    subtest: Subtest.mc,
    stem:
        'Why is a wide, low crate harder to tip over than a tall, narrow one?',
    choices: <String>[
      'A wide base makes the crate weigh more',
      'Friction between the crate and the floor grows with the base width',
      'A low centre of gravity must be raised over the edge before tipping',
      'Wind cannot get underneath a crate that sits low to the floor',
    ],
    answerIndex: 2,
    explanation:
        'A crate tips only once its centre of gravity passes outside the edge of its base. '
        'A low centre over a wide base has to be lifted a long way before that happens, so it '
        'takes a bigger tilt. A tall narrow crate starts with the centre high and the base short, '
        'so a small lean already puts the weight past the edge, and weight alone does not settle '
        'stability.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.structure'],
  ),
];
