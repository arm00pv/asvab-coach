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
    choiceNotes: <String>[
      'Class 1 puts the fulcrum between load and effort, as a crowbar and a seesaw do.',
      'The wheel is the fulcrum, the load rides between wheel and hands, and the effort goes at the handles.',
      'Class 3 puts the effort in the middle, as tongs and tweezers do, instead of the load.',
      'It pivots on the wheel and is lifted at the handles, so it works as a lever like any other.',
    ],
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
    choiceNotes: <String>[
      'Six feet leaves only 120 pound-feet on the light side, which is what dividing the two weights gives.',
      'Eight feet makes just 160 pound-feet, half of the 180 needed, which comes from halving the moment.',
      'Twenty pounds at nine feet makes 180 pound-feet, matching the sixty pounds three feet out on the other side.',
      'Twelve feet overbalances at 240 pound-feet, which comes from multiplying the arm by the weight ratio twice.',
    ],
    explanation:
        'Balance requires equal moments, so 60 lb times 3 ft gives 180 pound-feet on one '
        'side and the 20 lb child must sit where 20 times the distance equals 180, which is '
        '9 ft. The lighter rider always sits farther out. The 6 ft option comes from dividing '
        'the weights and ignoring distance, which is the usual moment mistake.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.levers'],
    figure: Sketch(
      caption:
          'A seesaw with a 60 pound child 3 feet left of the fulcrum and a 20 '
          'pound child on the right arm, whose distance is marked with a '
          'question mark.',
      prims: <SketchPrim>[
        SketchPrim.line(Pt(0.14, 0.50), Pt(0.84, 0.50), weight: 5),
        SketchPrim.triangle(Pt(0.34, 0.50), Pt(0.28, 0.66), Pt(0.40, 0.66)),
        SketchPrim.box(Pt(0.10, 0.38), Pt(0.18, 0.50)),
        SketchPrim.text('60 lb', Pt(0.14, 0.30)),
        SketchPrim.box(Pt(0.78, 0.38), Pt(0.86, 0.50)),
        SketchPrim.text('20 lb', Pt(0.82, 0.30)),
        SketchPrim.dashed(Pt(0.14, 0.74), Pt(0.84, 0.74)),
        SketchPrim.text('3 ft', Pt(0.24, 0.83)),
        SketchPrim.text('? ft', Pt(0.60, 0.83)),
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
    choiceNotes: <String>[
      'A crowbar is class 1 with the fulcrum in the middle, so its long effort arm gives more than one.',
      'A wheelbarrow is class 2 with the load in the middle, so its advantage is always above one.',
      'A nutcracker is class 2 too, with the load between fulcrum and hand, so it multiplies force.',
      'The effort acts between fulcrum and load, so the effort arm is the short one and the advantage stays below one.',
    ],
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
    choiceNotes: <String>[
      'Two is the bare ratio of feet to inches, which compares 2 ft with 8 in without converting the units.',
      'Two and a half would need an effort arm of twenty inches against the eight inch load arm.',
      'The effort arm is 24 inches and the load arm 8 inches, so 24 divided by 8 gives an advantage of 3.',
      'Four comes from reading the load arm as six inches, a shorter value than the diagram marks.',
    ],
    explanation:
        'The effort arm is 2 feet, or 24 inches, and the load arm is 8 inches, so the '
        'advantage is 24 divided by 8, which is 3. Each pound of push lifts 3 pounds, though the '
        'load rises only one third as far as your hand moves. Comparing 2 feet directly with 8 '
        'inches without converting the units is what produces a nonsense answer below one.',
    difficulty: Difficulty.hard,
    skills: <String>['mc.levers'],
    figure: Sketch(
      caption:
          'A class 1 lever with a load 8 inches from the fulcrum and a '
          'downward effort 2 feet from it, with both arms marked underneath.',
      prims: <SketchPrim>[
        SketchPrim.line(Pt(0.15, 0.52), Pt(0.93, 0.52), weight: 5),
        SketchPrim.triangle(Pt(0.345, 0.52), Pt(0.285, 0.68), Pt(0.405, 0.68)),
        SketchPrim.box(Pt(0.115, 0.40), Pt(0.175, 0.52)),
        SketchPrim.text('load', Pt(0.145, 0.33)),
        SketchPrim.arrow(Pt(0.86, 0.28), Pt(0.86, 0.50)),
        SketchPrim.text('effort', Pt(0.86, 0.20)),
        SketchPrim.dashed(Pt(0.145, 0.76), Pt(0.86, 0.76)),
        SketchPrim.text('8 in', Pt(0.245, 0.85)),
        SketchPrim.text('2 ft', Pt(0.60, 0.85)),
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
    choiceNotes: <String>[
      'Four compares the 8 inch wheel radius with the 2 inch shaft read as a radius, which halves the true ratio.',
      'A 16 inch wheel with an 8 inch radius and a 2 inch shaft with a 1 inch radius give eight to one.',
      'Twelve guesses the hub at an inch and a third across instead of the 2 inches the diagram marks.',
      'Sixteen divides the 16 inch diameter by the 1 inch axle radius, mixing a diameter with a radius.',
    ],
    explanation:
        'For a wheel and axle the advantage is the wheel radius divided by the axle '
        'radius. A 16 inch wheel has an 8 inch radius and a 2 inch shaft has a 1 inch radius, so '
        'the ratio is 8 to 1. That is why a large wheel lets a driver turn a heavy shaft with '
        'light hand pressure.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.levers'],
    figure: Sketch(
      caption:
          'A steering wheel 16 inches across turning a shaft 2 inches across, '
          'with both diameters marked.',
      prims: <SketchPrim>[
        SketchPrim.circle(Pt(0.40, 0.46), 0.28, weight: 4),
        SketchPrim.disc(Pt(0.40, 0.46), 0.035),
        SketchPrim.line(Pt(0.40, 0.495), Pt(0.40, 0.74)),
        SketchPrim.line(Pt(0.3822, 0.4425), Pt(0.2574, 0.32)),
        SketchPrim.line(Pt(0.4178, 0.4425), Pt(0.5426, 0.32)),
        SketchPrim.line(Pt(0.43, 0.49), Pt(0.62, 0.62)),
        SketchPrim.text('wheel', Pt(0.18, 0.21)),
        SketchPrim.text('2 in across', Pt(0.76, 0.66)),
        SketchPrim.dashed(Pt(0.235, 0.86), Pt(0.565, 0.86)),
        SketchPrim.text('16 in across', Pt(0.40, 0.91)),
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
    choiceNotes: <String>[
      'Only one rope section holds the load, so the pull stays the full weight and the gain is direction alone.',
      'Doubling the liftable load needs two supporting sections on a movable block, and a fixed pulley has one.',
      'Halving the effort takes two rope sections sharing the load, which a fixed pulley never provides.',
      'One quarter would need four sections pulling upward on a movable block, and nothing here is movable.',
    ],
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
    choiceNotes: <String>[
      '240 lb is the pull when a single rope section holds the load, which is a plain fixed pulley.',
      '120 lb matches only two supporting sections, so it ignores four of the six shown.',
      '80 lb fits three supporting sections, half the number the tackle actually has.',
      'Six sections split 240 lb into six equal shares, and you haul six feet of rope to raise the load one foot.',
    ],
    explanation:
        'Count only the rope sections that pull upward on the movable block, then divide '
        'the load by that number. Six sections split 240 lb into six 40 lb shares. The trade is '
        'distance: you haul six feet of rope to raise the load one foot. The 120 lb and 80 lb '
        'answers would match only two or three supporting sections.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pulleys'],
    figure: Sketch(
      caption:
          'A block and tackle with a fixed block at the top and a movable '
          'block carrying a 240 pound load, joined by six rope sections, with '
          'the pull marked with a question mark.',
      prims: <SketchPrim>[
        SketchPrim.line(Pt(0.22, 0.10), Pt(0.78, 0.10), weight: 4),
        SketchPrim.line(Pt(0.50, 0.10), Pt(0.50, 0.14)),
        SketchPrim.box(Pt(0.32, 0.14), Pt(0.68, 0.30)),
        SketchPrim.box(Pt(0.32, 0.56), Pt(0.68, 0.72)),
        SketchPrim.line(Pt(0.36, 0.30), Pt(0.36, 0.56)),
        SketchPrim.line(Pt(0.42, 0.30), Pt(0.42, 0.56)),
        SketchPrim.line(Pt(0.48, 0.30), Pt(0.48, 0.56)),
        SketchPrim.line(Pt(0.54, 0.30), Pt(0.54, 0.56)),
        SketchPrim.line(Pt(0.60, 0.30), Pt(0.60, 0.56)),
        SketchPrim.line(Pt(0.66, 0.30), Pt(0.66, 0.56)),
        SketchPrim.box(Pt(0.42, 0.72), Pt(0.58, 0.88)),
        SketchPrim.text('240 lb', Pt(0.50, 0.80)),
        SketchPrim.line(Pt(0.68, 0.22), Pt(0.78, 0.22)),
        SketchPrim.arrow(Pt(0.78, 0.22), Pt(0.78, 0.46)),
        SketchPrim.text('?', Pt(0.78, 0.56)),
        SketchPrim.line(Pt(0.26, 0.43), Pt(0.345, 0.43)),
        SketchPrim.text('6 sections', Pt(0.145, 0.43)),
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
    choiceNotes: <String>[
      'At the contact point the driving tooth pushes the driven tooth backward against its own motion, so the driven gear reverses.',
      'A flat belt between pulleys keeps them turning the same way, but meshed teeth cannot pass direction on unchanged.',
      'Half speed needs a driven gear with twice the teeth, and the drawing shows two gears of equal size.',
      'Twice speed needs a driven gear with half the teeth, and the two drawn gears match tooth for tooth.',
    ],
    explanation:
        'Meshed gears turn in opposite directions, because at the contact point the '
        'driving tooth pushes the driven tooth backward relative to its own motion. Two pulleys '
        'joined by a plain flat belt keep turning the same way, and only a crossed belt reverses '
        'them. Speed depends on tooth counts, not on direction.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pulleys'],
    figure: Sketch(
      caption:
          'Two meshed gears: the driving gear is turning clockwise and the '
          'driven gear is marked with a question mark.',
      prims: <SketchPrim>[
        SketchPrim.circle(Pt(0.30, 0.50), 0.28, weight: 4),
        SketchPrim.circle(Pt(0.63, 0.50), 0.28, weight: 4),
        SketchPrim.disc(Pt(0.30, 0.50), 0.02),
        SketchPrim.disc(Pt(0.63, 0.50), 0.02),
        SketchPrim.arrow(Pt(0.25, 0.26), Pt(0.35, 0.26)),
        SketchPrim.text('A', Pt(0.30, 0.66)),
        SketchPrim.text('B', Pt(0.63, 0.66)),
        SketchPrim.text('turns clockwise', Pt(0.30, 0.90)),
        SketchPrim.text('?', Pt(0.63, 0.90)),
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
    choiceNotes: <String>[
      '300 rpm would need a four to one ratio, so the driven sprocket would have to carry 48 teeth rather than 36.',
      'Twelve teeth over thirty-six is one third, so 1,200 rpm becomes 400 rpm with torque tripled.',
      '1,200 rpm assumes equal sprockets, and a larger driven sprocket must turn slower than its driver.',
      '3,600 rpm multiplies by the three to one ratio where the larger sprocket divides by it.',
    ],
    explanation:
        'The speed ratio is the driving tooth count over the driven tooth count, so 12 '
        'over 36 is one third, and 1,200 rpm becomes 400 rpm. Torque is multiplied by the same '
        'factor of three, which is the point of the smaller driving sprocket. The 3,600 rpm '
        'answer multiplies instead of dividing, and 300 rpm would need a 4 to 1 ratio.',
    difficulty: Difficulty.hard,
    skills: <String>['mc.pulleys'],
    figure: Sketch(
      caption:
          'A motor driving a 12 tooth sprocket that is chained to a 36 tooth '
          'sprocket, whose speed is marked with a question mark.',
      prims: <SketchPrim>[
        SketchPrim.box(Pt(0.05, 0.39), Pt(0.18, 0.61)),
        SketchPrim.text('motor', Pt(0.115, 0.50)),
        SketchPrim.line(Pt(0.18, 0.50), Pt(0.281, 0.50), weight: 3),
        SketchPrim.circle(Pt(0.34, 0.50), 0.10, weight: 4),
        SketchPrim.circle(Pt(0.66, 0.50), 0.30, weight: 4),
        SketchPrim.line(Pt(0.318, 0.407), Pt(0.595, 0.221), weight: 2),
        SketchPrim.line(Pt(0.362, 0.593), Pt(0.725, 0.779), weight: 2),
        SketchPrim.text('12 T', Pt(0.34, 0.50)),
        SketchPrim.text('36 T', Pt(0.66, 0.50)),
        SketchPrim.text('1200 rpm', Pt(0.34, 0.72)),
        SketchPrim.text('?', Pt(0.66, 0.90)),
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
    choiceNotes: <String>[
      'A wheel and axle turns about its centre to move a load on a rim, while a screw travels along its own axis.',
      'A lever tips about a fulcrum, whereas a thread turns rotation into motion along a ramp.',
      'A movable pulley shares a load between rope sections, and a screw has no rope and no sheave.',
      'Unwrap one thread and you have a ramp, because every turn carries the load up the slope of the pitch.',
    ],
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
    choiceNotes: <String>[
      'Thirty psi comes from dividing 300 lb by ten, a misread of the 3 square inch piston.',
      'Force divided by area gives 300 over 3, which is 100 pounds per square inch.',
      'Three hundred psi is what a one square inch piston would give for this same force.',
      'Nine hundred psi multiplies force by area instead of dividing, which inverts the pressure rule.',
    ],
    explanation:
        'Pressure is force divided by area, so 300 lb spread over 3 square inches is 100 '
        'pounds per square inch. The same force on a smaller piston gives a higher pressure and '
        'on a larger piston a lower one. Multiplying 300 by 3 to reach 900 psi is the common '
        'slip, and 300 psi would be the reading if the piston were exactly one square inch.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pressure'],
    figure: Sketch(
      caption:
          'A piston with an area of 3 square inches pushed with 300 pounds, '
          'with the pressure it creates inside the cylinder marked with a '
          'question mark.',
      prims: <SketchPrim>[
        SketchPrim.line(Pt(0.30, 0.34), Pt(0.30, 0.88), weight: 3),
        SketchPrim.line(Pt(0.56, 0.34), Pt(0.56, 0.88), weight: 3),
        SketchPrim.line(Pt(0.28, 0.88), Pt(0.58, 0.88), weight: 3),
        SketchPrim.line(Pt(0.30, 0.46), Pt(0.56, 0.46), weight: 4),
        SketchPrim.line(Pt(0.43, 0.46), Pt(0.43, 0.26), weight: 4),
        SketchPrim.arrow(Pt(0.43, 0.10), Pt(0.43, 0.24)),
        SketchPrim.text('300 lb', Pt(0.33, 0.15)),
        SketchPrim.line(Pt(0.56, 0.46), Pt(0.64, 0.46)),
        SketchPrim.text('3 sq in', Pt(0.77, 0.46)),
        SketchPrim.text('pressure ?', Pt(0.43, 0.62)),
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
    choiceNotes: <String>[
      'Five pounds divides 50 by the ten to one area ratio the wrong way, so the output shrinks instead of growing.',
      'Fifty assumes equal piston areas, yet the output has ten times the area and so ten times the force.',
      'One hundred doubles the force, using a two to one ratio rather than the ten to one the areas give.',
      'Ten times the area under the same pressure turns 50 lb into 500 lb, though the output travels a tenth as far.',
    ],
    explanation:
        'The output piston has ten times the area, so the same pressure acting on it '
        'produces ten times the force and 50 lb becomes 500 lb. The price is distance, since the '
        'output moves only one tenth as far as the input. A 5 lb answer comes from dividing in '
        'the wrong direction, and 100 lb from doubling instead of using the full area ratio.',
    difficulty: Difficulty.hard,
    skills: <String>['mc.pressure'],
    figure: Sketch(
      caption:
          'A hydraulic lift with 50 pounds on a 2 square inch piston feeding a '
          '20 square inch piston, whose output force is marked with a question '
          'mark.',
      prims: <SketchPrim>[
        SketchPrim.line(Pt(0.14, 0.26), Pt(0.14, 0.82), weight: 3),
        SketchPrim.line(Pt(0.28, 0.26), Pt(0.28, 0.68), weight: 3),
        SketchPrim.line(Pt(0.28, 0.68), Pt(0.58, 0.68), weight: 3),
        SketchPrim.line(Pt(0.58, 0.26), Pt(0.58, 0.68), weight: 3),
        SketchPrim.line(Pt(0.86, 0.26), Pt(0.86, 0.82), weight: 3),
        SketchPrim.line(Pt(0.14, 0.82), Pt(0.86, 0.82), weight: 3),
        SketchPrim.line(Pt(0.14, 0.42), Pt(0.28, 0.42), weight: 4),
        SketchPrim.line(Pt(0.21, 0.42), Pt(0.21, 0.26), weight: 3),
        SketchPrim.arrow(Pt(0.21, 0.10), Pt(0.21, 0.24)),
        SketchPrim.text('50 lb', Pt(0.30, 0.15)),
        SketchPrim.text('2 sq in', Pt(0.21, 0.54)),
        SketchPrim.line(Pt(0.58, 0.38), Pt(0.86, 0.38), weight: 4),
        SketchPrim.line(Pt(0.72, 0.38), Pt(0.72, 0.26), weight: 3),
        SketchPrim.box(Pt(0.63, 0.14), Pt(0.81, 0.26)),
        SketchPrim.text('?', Pt(0.72, 0.20)),
        SketchPrim.text('20 sq in', Pt(0.72, 0.54)),
        SketchPrim.text('fluid', Pt(0.43, 0.75)),
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
    choiceNotes: <String>[
      'A liquid is nearly incompressible, so it does not shrink at the far end but pushes on the piston there.',
      'A pump pushes fluid under pressure, and a vacuum behind the far piston would pull it back instead.',
      'A cooling fluid contracts and loses pressure, while the force here arrives with the piston being pushed.',
      'A confined liquid carries the applied pressure equally in every direction, so it acts on the far piston too.',
    ],
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
    choiceNotes: <String>[
      'Molecules move faster only as the water gets hotter, and thin air changes the pressure rather than the speed.',
      'Dissolved gases leave water as it warms, and how much is dissolved does not set the boiling point.',
      'Boiling begins when vapor pressure matches the pressure on the surface, and thin mountain air presses down less.',
      'Colder water takes longer to reach a boil, and the stem asks about the temperature at which it boils.',
    ],
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
    choiceNotes: <String>[
      'Steel is several times denser than water, so no plate of it weighs less than the water it pushes aside.',
      'The air inside adds buoyant volume rather than weight, and air pressing down would sink the hull lower.',
      'Buoyancy pushes up exactly as hard as the ship presses down, so an imbalance would move it instead of floating.',
      'The hull is shaped to displace water weighing as much as the ship, and that upward push balances the weight.',
    ],
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
    choiceNotes: <String>[
      'Bending downward shortens the top surface instead of stretching it, so tension belongs to the underside.',
      'A sagging beam curves like a frown, so the top shortens in compression and the bottom stretches in tension.',
      'Shear and torsion are cutting and twisting actions, and a sagging beam shows bending rather than either.',
      'Torsion comes from turning the beam about its axis, and nothing in this sagging beam twists it.',
    ],
    explanation:
        'As the beam bends downward it curves like a frown, so the top surface gets '
        'shorter and is in compression while the bottom surface stretches and is in tension. A '
        'truss carries the same load with separate members, some pushed and some pulled, '
        'arranged in triangles. Shear and torsion are cutting and twisting actions, not what a '
        'sagging beam shows.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.structure'],
    figure: Sketch(
      caption:
          'A beam sagging on two supports under a load hung at its middle, '
          'with the top and bottom surfaces each marked with a question mark.',
      prims: <SketchPrim>[
        SketchPrim.line(Pt(0.14, 0.40), Pt(0.29, 0.475), weight: 4),
        SketchPrim.line(Pt(0.29, 0.475), Pt(0.50, 0.525), weight: 4),
        SketchPrim.line(Pt(0.50, 0.525), Pt(0.71, 0.475), weight: 4),
        SketchPrim.line(Pt(0.71, 0.475), Pt(0.86, 0.40), weight: 4),
        SketchPrim.line(Pt(0.14, 0.44), Pt(0.29, 0.515), weight: 4),
        SketchPrim.line(Pt(0.29, 0.515), Pt(0.50, 0.565), weight: 4),
        SketchPrim.line(Pt(0.50, 0.565), Pt(0.71, 0.515), weight: 4),
        SketchPrim.line(Pt(0.71, 0.515), Pt(0.86, 0.44), weight: 4),
        SketchPrim.line(Pt(0.14, 0.40), Pt(0.14, 0.44), weight: 4),
        SketchPrim.line(Pt(0.86, 0.40), Pt(0.86, 0.44), weight: 4),
        SketchPrim.triangle(Pt(0.14, 0.44), Pt(0.08, 0.60), Pt(0.20, 0.60)),
        SketchPrim.triangle(Pt(0.86, 0.44), Pt(0.80, 0.60), Pt(0.92, 0.60)),
        SketchPrim.line(Pt(0.50, 0.565), Pt(0.50, 0.62)),
        SketchPrim.box(Pt(0.42, 0.62), Pt(0.58, 0.74)),
        SketchPrim.text('load', Pt(0.50, 0.68)),
        SketchPrim.text('top ?', Pt(0.66, 0.40)),
        SketchPrim.text('bottom ?', Pt(0.69, 0.63)),
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
    choiceNotes: <String>[
      'Rolling does not harden tube steel as a rule, and a tube wins on shape at the same weight.',
      'Trapped air carries no load, and the stiffness comes from where the metal sits rather than from what fills it.',
      'Surface area does not resist bending, so having less of it explains nothing about stiffness.',
      'Bending stress is greatest far from the centre line, so metal moved outward does the most for stiffness.',
    ],
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
    choiceNotes: <String>[
      'Roughening the surfaces would raise friction and wear, the exact opposite of what oil does.',
      'Carrying electricity away is not how a lubricant works, and the friction drop follows from the film alone.',
      'Oil does not grind metal away, and surfaces worn smooth that way would soon lose their fit.',
      'A thin film keeps the surfaces apart so the metal rides on the oil instead of on the other part.',
    ],
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
    choiceNotes: <String>[
      'Gravity pulls the passenger downward, and nothing about that throws them forward as the car slows.',
      'Friction acts along surfaces in contact, and nobody has touched the passenger when the lurch begins.',
      'The passenger keeps moving at the old speed while the car slows, and that tendency is inertia.',
      'Air pressure pushes evenly in every direction, so it cannot carry anyone forward in a stop.',
    ],
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
    choiceNotes: <String>[
      'Weight follows from mass, and widening the base of the same material only adds mass without steadying it.',
      'Friction resists sliding rather than tipping, and a crate tips over its edge while the base stays put.',
      'A crate tips once its centre of gravity passes the edge of the base, and a low centre must be raised a long way.',
      'Wind under a low crate is a separate worry, and the question is about tipping from a push.',
    ],
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
