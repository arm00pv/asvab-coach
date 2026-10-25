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
  ),
  Question(
    id: 'mc-008',
    subtest: Subtest.mc,
    stem:
        'Two gears are meshed, and the driving gear turns clockwise. Which way does the driven '
        'gear turn?',
    choices: <String>[
      'Counter-clockwise',
      'Clockwise',
      'Clockwise at half the driving speed',
      'Clockwise at twice the driving speed',
    ],
    answerIndex: 0,
    explanation:
        'Meshed gears turn in opposite directions, because at the contact point the '
        'driving tooth pushes the driven tooth backward relative to its own motion. Two pulleys '
        'joined by a plain flat belt keep turning the same way, and only a crossed belt reverses '
        'them. Speed depends on tooth counts, not on direction.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pulleys'],
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
