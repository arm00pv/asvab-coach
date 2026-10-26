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
    choiceNotes: <String>[
      'A drift punch has a straight shank for driving out pins and rivets, so it leaves no dimple to seat a drill.',
      'A center punch leaves a small conical crater that gives the drill point a seat so it starts on the mark.',
      'A cape chisel cuts a narrow groove, which steers the bit along the groove instead of holding it on the mark.',
      'A nail set has a cupped tip for sinking nail heads below a wood surface, and it is no guide for a drill.',
    ],
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
    choiceNotes: <String>[
      'A screw extractor has reverse flutes that bite a drilled stump and walk it out as it is turned counterclockwise.',
      'A tap cuts fresh internal threads, so it would cut the hole the bolt came from instead of removing the stump.',
      'A die cuts external threads on a rod, and a stump sunk flush in a housing gives it nothing to start on.',
      'A reamer only trues up a hole that is already round, and the broken piece would still sit in the way.',
    ],
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
    choiceNotes: <String>[
      'A larger open-end wrench loads the same two corners, so it rounds the nut faster rather than saving it.',
      'An adjustable wrench still presses on two flats and adds a loose sliding jaw that slips on a damaged nut.',
      'A six-point box end surrounds the nut and presses on all six flats at once, spreading the turning force.',
      'Slip-joint pliers grip with teeth, which chew the corners further and make the nut harder to save.',
    ],
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
    choiceNotes: <String>[
      'A fine blade keeps several teeth in the thin wall so each one takes a shallow bite and the cut stays clean.',
      'A fourteen tooth blade straddles the thin wall, hooks the far edge and tears the tubing instead of cutting.',
      'An eighteen tooth blade is a general purpose pitch that still hooks and snags on thin wall conduit.',
      'A twenty-four tooth blade suits heavier stock and still crowds the wall more than thin tubing allows.',
    ],
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
    choiceNotes: <String>[
      'A magneto or coil fires a spark plug, and a diesel has no plug for one to fire.',
      'A glow plug only warms the chamber for a cold start, and it does not light the charge on every stroke.',
      'No pilot charge or low voltage coil is used, because the diesel has nothing to ignite a charge with.',
      'Squeezing air alone raises it to several hundred degrees, so fuel sprayed in lights off with no spark.',
    ],
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
    choiceNotes: <String>[
      'Hoses are held open by their own construction and by coolant flow, so pressure is not what stops a collapse.',
      'Pressure raises the boiling point, which lets the engine run hotter than steam would allow without trouble.',
      'Coolant is pushed through the core by the water pump, and pressure alone would not move it.',
      'The recovery bottle is filled and drawn by the cap valve as coolant heats and cools, not held by pressure.',
    ],
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
    choiceNotes: <String>[
      'A slipping pump belt would starve the engine at low speed too, so the engine would boil in traffic rather than at speed.',
      'A late thermostat opens slowly everywhere, so the engine would overheat in city traffic rather than on the highway.',
      'Sustained highway load makes far more heat, and a clogged core cannot pass it to the airflow that is plentiful at speed.',
      'A slow fan hardly matters at highway speed, where road speed alone pushes plenty of air through the core.',
    ],
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
    choiceNotes: <String>[
      'It gears the driven wheels to turn at different rates in a turn while both still receive drive.',
      'Multiplying torque is left to the gearbox and final drive, and the differential passes torque on largely unchanged.',
      'Locking the axles together is a separate locking differential, and an ordinary one deliberately allows differing speeds.',
      'The ratio inside a differential is fixed, so road speed cannot change it.',
    ],
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
    choiceNotes: <String>[
      'A wheel bearing growls with road speed and changes with load, and it does not stop the moment the wheels straighten.',
      'A sticking caliper drags and runs hot, pulling to one side instead of clicking only in a sharp turn.',
      'An out-of-balance tire shakes at a particular road speed rather than clicking at a particular steering angle.',
      'The outer constant velocity joint works through a big angle only in a turn, so its wear clicks there and stops when straight.',
    ],
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
    choiceNotes: <String>[
      'Air in the lines leaves the pedal spongy all the way down and it never does firm up.',
      'Pressure escaping past the master cylinder seals bleeds back into the reservoir, so a firm pedal creeps down.',
      'Pads worn past the indicator change how far the pedal travels, not whether it holds under steady pressure.',
      'The brake light switch only works the lamps, and it has no connection to hydraulic pressure in the circuit.',
    ],
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
    choiceNotes: <String>[
      'A blind rivet is set entirely from the near side, because the body mushrooms against a face nobody can reach.',
      'A machine bolt needs someone or something behind the work to hold the nut, and only one side can be reached.',
      'A wood screw needs grain to bite into, and a thin metal sheet gives it nothing to hold.',
      'A dowel pin in a blind hole grips nothing and holds the two sheets together not at all.',
    ],
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
    choiceNotes: <String>[
      'Zinc is softer than steel rather than harder, so the coating would be no protection on hardness alone.',
      'A coating that merely sealed out air would fail the first time a scratch reached the steel underneath.',
      'Zinc is more reactive than steel, so it gives up its electrons first and corrodes in place of the steel.',
      'A thin coating adds almost no stiffness, and a stiff post would still rust once the zinc was spent.',
    ],
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
    choiceNotes: <String>[
      'Kiln drying shrinks wood slightly but never by half an inch, and boards are surfaced before they ship.',
      'Surfacing all four sides of the rough sawn piece removes material, so the name records the rough size.',
      'Nothing rounds the dimensions down; the mill simply planes the piece after sawing it at the named size.',
      'The size is settled after drying and planing, and a green swollen board would measure larger than its name.',
    ],
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
    choiceNotes: <String>[
      'Holding the window frame square is done with shims, and the header carries load rather than holding square.',
      'Blocking air leaks around an opening is a job for flashing and sealant, not for the header above it.',
      'Tying the sheathing to the wall on either side is done with nails through the sheathing into the studs.',
      'Cutting the opening takes away the studs that carried load, so the header hands that load to the jack studs.',
    ],
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
    choiceNotes: <String>[
      'Soil carries only so much weight per square foot, so the footing spreads the building over enough ground.',
      'A ledge for masons is not why footings are poured wide, and the concrete below grade is never a work platform.',
      'Keeping groundwater out of the wall is damp proofing and drainage work rather than a wider footing.',
      'A wider footing spreads the load rather than letting the wall settle, and settlement is what a footing prevents.',
    ],
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
    choiceNotes: <String>[
      'Level describes something horizontal, so it is the wrong word for a wall standing upright.',
      'Square describes the angle where two walls meet, and it says nothing about how vertical one wall stands.',
      'Plumb compares a surface with gravity, so a plumb wall is one that stands exactly vertical against a level.',
      'Straight describes the face of the material with no bow or kink, which is a different check from plumb.',
    ],
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
    choiceNotes: <String>[
      'Cranking the engine until it starts is the starter motor job, and it stops working as soon as the engine runs.',
      'The alternator makes current that runs the loads and puts back what the battery spent on the start.',
      'Stepping voltage up for the plugs is done by the ignition coil, which the alternator does not feed directly.',
      'Storing energy for the next start is the battery job, and the alternator makes energy instead of storing it.',
    ],
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
    choiceNotes: <String>[
      'A failed starter still leaves full battery voltage at the lamps, so the headlights would stay bright while it clicked.',
      'A dead coil gives a healthy crank that never fires, and this engine barely turns at all.',
      'Overcharging does not stop the engine turning over, and it would show as bright lamps rather than dim ones.',
      'Dimming lamps show that the starting current cannot be supplied, which points to a flat battery or a bad cable end.',
    ],
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
    choiceNotes: <String>[
      'Purging the vapor or filling the drum with water leaves the torch nothing explosive to ignite.',
      'Standing the drum open for an hour still leaves an explosive mixture inside, because the vapor is heavy in the drum.',
      'A dangerous concentration of fuel vapor cannot be smelled, so the nose is no test of a safe drum.',
      'A single rinse leaves residues that can still flash, so the drum must be purged or filled instead.',
    ],
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
    choiceNotes: <String>[
      'The limit comes from the gas and not from a thin diaphragm, and regulators are built to hold far more than fifteen.',
      'Acetylene is lighter than air rather than heavier, so settling in a hose is not the concern here.',
      'Above roughly fifteen psi acetylene can break down into carbon and hydrogen in a runaway reaction needing no oxygen.',
      'Torch valves pass far more gas than fifteen psi allows, so the limit is on the gas rather than the valve.',
    ],
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
