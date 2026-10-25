import '../models/catalog.dart';
import '../models/question.dart';

/// Auto & Shop Information, second pool: 20 items split the way the real
/// subtest splits it, four hand-tool items and the rest drawn from the engine,
/// drivetrain, materials, construction, automotive electrical and welding
/// topics. None of these stems or option sets repeat auto_shop.dart.
const List<Question> autoShopExtraBank = <Question>[
  Question(
    id: 'as-x01',
    subtest: Subtest.as,
    stem:
        'A drill bit keeps wandering away from the layout mark when a hole is started in a '
        'steel plate. Which tool should have been used on the mark first?',
    choices: <String>[
      'A drift punch',
      'A center punch',
      'A cape chisel',
      'A nail set',
    ],
    answerIndex: 1,
    explanation:
        'A center punch is struck once with a hammer to leave a small conical crater, and '
        'that crater gives the drill point a seat so the bit starts exactly on the mark instead '
        'of skating across the plate. A drift punch has a straight shank and is used to drive '
        'out pins and rivets, a cape chisel cuts a narrow groove, and a nail set sinks a nail '
        'head below a wood surface. None of those three leaves a starting dimple.',
    difficulty: Difficulty.easy,
    skills: <String>['as.tools'],
  ),
  Question(
    id: 'as-x02',
    subtest: Subtest.as,
    stem:
        'The shank of a steel bolt has twisted off flush with the surface of a housing and the '
        'broken piece will not turn. Which tool is made for backing the stump out?',
    choices: <String>['A screw extractor', 'A tap', 'A die', 'A reamer'],
    answerIndex: 0,
    explanation:
        'A screw extractor is a hardened taper with reverse flutes. Drill a hole into the '
        'broken stump, drive the extractor into it, and turn it counterclockwise so the flutes '
        'bite and walk the stump out. A tap cuts new internal threads and would ruin the hole '
        'the bolt came out of, a die cuts external threads on a rod, and a reamer only true up a '
        'hole that is already round.',
    difficulty: Difficulty.medium,
    skills: <String>['as.tools'],
  ),
  Question(
    id: 'as-x03',
    subtest: Subtest.as,
    stem:
        'A rusted nut has begun to round off under an open-end wrench. Which wrench should be '
        'tried next on that nut?',
    choices: <String>[
      'A larger open-end wrench',
      'An adjustable wrench',
      'A six-point box-end wrench',
      'A pair of slip-joint pliers',
    ],
    answerIndex: 2,
    explanation:
        'A box-end wrench or a six-point socket surrounds the nut and presses on all six '
        'flats at once, so the turning force is spread instead of being concentrated on two '
        'corners. That is exactly what a nut needs once the corners have started to give. A '
        'larger open-end wrench, an adjustable wrench and slip-joint pliers all load the '
        'corners again, and the pliers make the damage worse.',
    difficulty: Difficulty.easy,
    skills: <String>['as.tools'],
  ),
  Question(
    id: 'as-x04',
    subtest: Subtest.as,
    stem:
        'A hacksaw is about to be used to cut thin-wall electrical conduit to length. Which '
        'blade should be fitted?',
    choices: <String>[
      'One with 32 teeth per inch',
      'One with 14 teeth per inch',
      'One with 18 teeth per inch',
      'One with 24 teeth per inch',
    ],
    answerIndex: 0,
    explanation:
        'A fine blade keeps several teeth in contact with thin wall at all times, so each '
        'tooth takes a shallow bite and the saw cuts steadily. A coarse blade straddles the '
        'wall, hooks on the far edge and tears the tubing instead of cutting it. Coarse blades '
        'are the right choice for thick solid stock, where the deep gullets between teeth have '
        'room to carry the chips away.',
    difficulty: Difficulty.medium,
    skills: <String>['as.tools'],
  ),
  Question(
    id: 'as-x05',
    subtest: Subtest.as,
    stem: 'Why does a diesel engine run without spark plugs?',
    choices: <String>[
      'A magneto fires a spark at each injector nozzle',
      'The fuel is lit by the glow plug on every stroke',
      'A low-voltage coil lights a small pilot charge first',
      'Air is squeezed so hard that the fuel ignites on its own',
    ],
    answerIndex: 3,
    explanation:
        'A diesel squeezes air alone to a compression ratio high enough that the air itself '
        'reaches several hundred degrees, and fuel sprayed into that hot air lights off with no '
        'spark at all. That is why the process is called compression ignition. A glow plug only '
        'warms the chamber for a cold start and does not fire the charge on every stroke, and no '
        'coil or magneto is used anywhere in the system.',
    difficulty: Difficulty.medium,
    skills: <String>['as.engine'],
  ),
  Question(
    id: 'as-x06',
    subtest: Subtest.as,
    stem: 'Why does the radiator cap on a pressurized cooling system carry a pressure rating?',
    choices: <String>[
      'Holding pressure keeps the rubber hoses from collapsing inward',
      'Holding pressure in the system raises the boiling point of the coolant',
      'Holding pressure is what pushes coolant through the radiator core',
      'Holding pressure keeps the overflow bottle from draining back',
    ],
    answerIndex: 1,
    explanation:
        'Holding the cooling system under pressure raises the boiling point of the coolant, so '
        'a cap rated at 15 psi lets the engine run well above the ordinary boiling point without '
        'the coolant turning to steam and forming a steam pocket around the cylinders. That is '
        'why a cap of the wrong rating can let an otherwise healthy engine boil on a hot day. '
        'Pressure is not what holds a hose open, moves coolant through the core or keeps the '
        'recovery bottle filled; the pump and the thermostat do that work.',
    difficulty: Difficulty.medium,
    skills: <String>['as.engine'],
  ),
  Question(
    id: 'as-x07',
    subtest: Subtest.as,
    stem:
        'An engine holds normal temperature in city traffic but overheats steadily at highway '
        'speed, and the cooling fan can be seen working. Which fault fits those symptoms?',
    choices: <String>[
      'The water pump is slipping on its drive belt',
      'The thermostat opens later than its rating calls for',
      'The radiator core is clogged and cannot pass enough heat',
      'The fan clutch is slipping and the fan turns too slowly',
    ],
    answerIndex: 2,
    explanation:
        'Cruising at highway speed asks the engine for a steady, high output, so it makes far '
        'more heat than it does creeping through traffic. Airflow through the grille is abundant '
        'at speed, so if the core tubes are scaled or clogged the radiator simply cannot pass '
        'the heat to that air, and temperature climbs only under a sustained load. A slipping '
        'water pump belt or a late thermostat would overheat in traffic too, and a slow fan '
        'hardly matters once road speed pushes air through the core.',
    difficulty: Difficulty.hard,
    skills: <String>['as.engine'],
  ),
  Question(
    id: 'as-x08',
    subtest: Subtest.as,
    stem: 'What does the differential in a rear-wheel-drive car do for the two rear wheels?',
    choices: <String>[
      'It lets them turn at different speeds in a turn while driving both',
      'It increases engine torque before the torque reaches the wheels',
      'It locks the two axles together whenever the car runs straight',
      'It changes the final drive ratio as road speed increases',
    ],
    answerIndex: 0,
    explanation:
        'In a turn the outside wheel travels a longer path than the inside wheel, so the two '
        'cannot turn at the same rate while sharing one axle. The differential gears in the '
        'housing allow each wheel to run at its own speed while both still receive drive. '
        'Multiplying torque is the job of the gearbox and final drive, a locking differential is '
        'a separate option that deliberately stops the wheels running at different speeds, and '
        'the ratio in a differential is fixed.',
    difficulty: Difficulty.medium,
    skills: <String>['as.drivetrain'],
  ),
  Question(
    id: 'as-x09',
    subtest: Subtest.as,
    stem:
        'A front-wheel-drive car makes a steady clicking or popping noise from one front corner '
        'while it is turning sharply, and the noise stops as soon as the car straightens out. '
        'What is the likely cause?',
    choices: <String>[
      'A worn front wheel bearing on the same side',
      'A sticking brake caliper on that wheel',
      'An out-of-balance front tire on that wheel',
      'A worn outer constant velocity joint on that half shaft',
    ],
    answerIndex: 3,
    explanation:
        'Each half shaft of a front-wheel-drive car carries a constant velocity joint at both '
        'ends, and the outer joint near the wheel is the one that works through a large angle, '
        'which happens only when the wheels are steered. Wear in its balls and cage converts '
        'that angle into a rhythmic click that vanishes the moment the wheels point straight. A '
        'wheel bearing growls with speed and with load, a dragging caliper pulls to one side and '
        'runs hot, and an out-of-balance tire shakes at a particular road speed.',
    difficulty: Difficulty.medium,
    skills: <String>['as.drivetrain'],
  ),
  Question(
    id: 'as-x10',
    subtest: Subtest.as,
    stem:
        'The brake pedal holds firm at first, then creeps slowly toward the floor while the car '
        'is stopped and steady pressure is kept on it. What does that point to?',
    choices: <String>[
      'Air drawn into the brake lines at the calipers',
      'Fluid bypassing the seals inside the master cylinder',
      'Brake pads worn past their wear indicator',
      'A brake light switch that is out of adjustment',
    ],
    answerIndex: 1,
    explanation:
        'A pedal that firms up and then sinks under a steady push means pressure is escaping '
        'somewhere inside the hydraulic circuit, and the usual path is past the piston seals in '
        'the master cylinder, back into the reservoir. Air in the lines gives a pedal that feels '
        'spongy all the way down and never does get firm. Worn pads change how far the pedal '
        'travels, not whether it holds, and the brake light switch only works the lamps.',
    difficulty: Difficulty.hard,
    skills: <String>['as.drivetrain'],
  ),
  Question(
    id: 'as-x11',
    subtest: Subtest.as,
    stem:
        'Two sheets of aluminum have to be joined where only one side of the joint can be '
        'reached at all. Which fastener suits that job?',
    choices: <String>[
      'A blind rivet set with a hand riveter',
      'A machine bolt with a nut and washer',
      'A wood screw driven into the lower sheet',
      'A dowel pin pressed into a blind hole',
    ],
    answerIndex: 0,
    explanation:
        'A blind rivet carries a mandrel through a hollow body. The riveter pulls the '
        'mandrel, the body mushrooms against the far side of the joint, and the mandrel snaps '
        'off, so the whole joint is closed from the near side alone. A machine bolt needs '
        'someone or something behind the work to hold the nut, a wood screw has no grain to bite '
        'in a thin metal sheet, and a dowel pin in a blind hole holds nothing together.',
    difficulty: Difficulty.medium,
    skills: <String>['as.materials'],
  ),
  Question(
    id: 'as-x12',
    subtest: Subtest.as,
    stem:
        'Why does a galvanized steel fence post last so much longer out of doors than a plain '
        'steel post of the same size?',
    choices: <String>[
      'The zinc coating is harder than the steel it covers',
      'The zinc coating keeps air from ever reaching the steel',
      'The zinc coating corrodes in place of the steel underneath',
      'The zinc coating adds a layer that stiffens the post',
    ],
    answerIndex: 2,
    explanation:
        'Zinc is more reactive than steel, so where both are exposed the zinc gives up its '
        'electrons first and corrodes instead of the steel below, which is why the protection is '
        'called sacrificial and keeps working even at the edge of a deep scratch. Hardness, '
        'stiffness and a perfect air seal are not what the coating provides, and a coating that '
        'is scratched through would fail on all three of those grounds.',
    difficulty: Difficulty.medium,
    skills: <String>['as.materials'],
  ),
  Question(
    id: 'as-x13',
    subtest: Subtest.as,
    stem:
        'A lumberyard sells a two by four that actually measures one and one half inches by '
        'three and one half inches. Why is the piece smaller than its name?',
    choices: <String>[
      'The board shrinks about a quarter inch in each direction as it dries',
      'Planing removes material from each face, so the name is the rough size',
      'The mill rounds every dimension down to the nearest half inch',
      'The stated size is taken while the board is still green and swollen',
    ],
    answerIndex: 1,
    explanation:
        'Sawn lumber leaves the mill at its full rough size and is then surfaced on all four '
        'sides so it comes out straight and of even thickness, and that planing is what turns a '
        'two by four into one and one half by three and one half inches. The name has stayed at '
        'the rough size ever since so that buying and pricing stay simple. Kiln drying does '
        'shrink wood slightly, but not by half an inch, and rounding or green measurement is not '
        'part of the grading rules.',
    difficulty: Difficulty.hard,
    skills: <String>['as.materials'],
  ),
  Question(
    id: 'as-x14',
    subtest: Subtest.as,
    stem: 'In a wood-frame wall, why is a header built across the top of a window opening?',
    choices: <String>[
      'It holds the window frame square until the glass is set',
      'It stops air from leaking around the edge of the opening',
      'It ties the sheathing to the wall on either side',
      'It carries the weight above the opening out to the studs at each side',
    ],
    answerIndex: 3,
    explanation:
        'Cutting an opening removes the studs that once carried their share of the load down '
        'that part of the wall, so a header spans the gap and hands that load to the jack studs '
        'standing on each side of the opening. Without it the wall sags over the window and the '
        'frame racks. Holding the frame square, blocking air leaks and tying the sheathing on '
        'are separate jobs handled by shims, flashing and nails.',
    difficulty: Difficulty.medium,
    skills: <String>['as.construction'],
  ),
  Question(
    id: 'as-x15',
    subtest: Subtest.as,
    stem: 'Why is a concrete footing poured wider than the foundation wall that sits on it?',
    choices: <String>[
      'It spreads the weight over enough soil to carry the load',
      'It gives the masons a ledge to stand on while they work',
      'It keeps groundwater from rising into the wall',
      'It allows the wall to settle without cracking',
    ],
    answerIndex: 0,
    explanation:
        'Soil can carry only so much weight for every square foot of surface, and the '
        'foundation wall concentrates the whole building onto a narrow strip. Widening the '
        'footing spreads that load over enough ground that the pressure drops to what the soil '
        'can hold, which is why footings get wider or thicker on weak ground. A working ledge, '
        'damp proofing and an allowance for settlement are handled some other way.',
    difficulty: Difficulty.medium,
    skills: <String>['as.construction'],
  ),
  Question(
    id: 'as-x16',
    subtest: Subtest.as,
    stem: 'A carpenter says the wall being framed is plumb. That means the wall is:',
    choices: <String>[
      'Exactly level along the top',
      'Square to the floor at the corners',
      'Vertical when checked with a level',
      'Straight along its whole length',
    ],
    answerIndex: 2,
    explanation:
        'Plumb compares a surface with the pull of gravity, so a plumb wall stands exactly '
        'vertical, which is what a spirit level reads when it is held against the stud. Level '
        'means horizontal rather than vertical, square describes the corner angle between two '
        'walls that meet, and straight describes the face of the material itself with no bow or '
        'kink in it.',
    difficulty: Difficulty.easy,
    skills: <String>['as.construction'],
  ),
  Question(
    id: 'as-x17',
    subtest: Subtest.as,
    stem: 'What is the alternator of a car doing while the engine is running?',
    choices: <String>[
      'Turning the engine over until it starts',
      'Charging the battery and running the electrical loads',
      'Stepping up voltage for the spark plugs',
      'Storing electrical energy for the next start',
    ],
    answerIndex: 1,
    explanation:
        'Once the engine is turning, the belt spins the alternator rotor and the alternator '
        'makes current, which runs the lights, ignition and accessories while putting back what '
        'the battery gave up during the start. The starter motor is what cranks the engine, the '
        'ignition coil is what raises voltage for the plugs, and the battery is the part that '
        'stores energy rather than making it.',
    difficulty: Difficulty.easy,
    skills: <String>['as.electrical'],
  ),
  Question(
    id: 'as-x18',
    subtest: Subtest.as,
    stem:
        'The headlights dim sharply and the engine gives one heavy click but does not crank '
        'when the key is turned to start. Which fault fits?',
    choices: <String>[
      'The starter motor has failed and needs replacement',
      'The ignition coil has stopped producing spark',
      'The alternator is charging at too high a voltage',
      'The battery is discharged or a battery cable end is loose',
    ],
    answerIndex: 3,
    explanation:
        'The lights going dim proves the starting circuit is being asked for a large current '
        'and the supply cannot deliver it, which points at the state of the battery or at '
        'resistance in the heavy cables, terminal clamps and ground strap. A starter motor that '
        'has failed still leaves full battery voltage at the lamps, so the lights would stay '
        'bright. A dead coil gives a crank that never fires, and overcharging does not stop the '
        'engine turning over.',
    difficulty: Difficulty.medium,
    skills: <String>['as.electrical'],
  ),
  Question(
    id: 'as-x19',
    subtest: Subtest.as,
    stem:
        'A welder is asked to cut up an empty steel drum that last held gasoline. What is the '
        'safe practice?',
    choices: <String>[
      'Purge the drum of vapor or fill it with water first',
      'Let the drum stand open to the air for an hour, then cut',
      'Sniff the opening and cut if there is no odor of fuel',
      'Rinse once with water and cut while the drum is still damp',
    ],
    answerIndex: 0,
    explanation:
        'An empty drum holds a fuel and air mixture sitting squarely in the explosive range, '
        'and a cutting torch is more than enough to set it off. Filling the drum with water, or '
        'purging it with an inert gas or steam, removes that mixture so the torch has nothing to '
        'ignite. Standing it open leaves an explosive atmosphere inside, a dangerous '
        'concentration of vapor cannot be smelled, and a single rinse leaves residues that can '
        'still flash.',
    difficulty: Difficulty.medium,
    skills: <String>['as.welding'],
  ),
  Question(
    id: 'as-x20',
    subtest: Subtest.as,
    stem:
        'Why must the working pressure of acetylene in a cutting outfit be kept below about '
        '15 psi?',
    choices: <String>[
      'The regulator diaphragm is too thin to hold more pressure',
      'Acetylene is heavier than air and settles in the hose',
      'Acetylene becomes unstable and can decompose violently above that',
      'The torch valves are sized to pass only a low volume of gas',
    ],
    answerIndex: 2,
    explanation:
        'Acetylene is chemically unstable on its own. Above roughly 15 psi it can break down '
        'into carbon and hydrogen in a runaway reaction that needs no oxygen at all, so it is '
        'stored dissolved in acetone inside a cylinder and used at low pressure through a '
        'regulator. The limit comes from the gas itself, not from a thin diaphragm, the density '
        'of the gas or the size of the torch valves.',
    difficulty: Difficulty.hard,
    skills: <String>['as.welding'],
  ),
];
