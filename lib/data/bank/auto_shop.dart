import '../models/catalog.dart';
import '../models/question.dart';

/// Auto & Shop Information bank: 20 items covering the four-stroke engine,
/// hand tools, materials and fasteners, and welding and cutting safety.
const List<Question> autoShopBank = <Question>[
  Question(
    id: 'as-001',
    subtest: Subtest.as,
    stem:
        'In a four-stroke engine, which stroke drives the piston down under the force of '
        'burning fuel?',
    choices: <String>['Intake', 'Compression', 'Power', 'Exhaust'],
    answerIndex: 2,
    explanation:
        'Only the power stroke pushes the piston down on its own, because burning '
        'fuel leaves hot gas pressing on the piston while both valves stay shut. The intake '
        'stroke draws mixture in, compression squeezes it as the piston rises, and exhaust '
        'pushes the burned gas out, so those three strokes cost energy instead of making it.',
    difficulty: Difficulty.easy,
    skills: <String>['as.engine'],
  ),
  Question(
    id: 'as-002',
    subtest: Subtest.as,
    stem:
        'How fast does the camshaft turn compared with the crankshaft in a four-stroke '
        'engine?',
    choices: <String>[
      'At four times the crankshaft speed',
      'At twice the crankshaft speed',
      'At the same speed as the crankshaft',
      'At half the crankshaft speed',
    ],
    answerIndex: 3,
    explanation:
        'Each cylinder needs intake, compression, power and exhaust strokes, and those '
        'four strokes take two full turns of the crankshaft. Each valve must open only once in '
        'that time, so the camshaft turns once while the crank turns twice, which is half '
        'speed. Running the cam at crank speed would work every valve twice as often as the '
        'pistons need.',
    difficulty: Difficulty.hard,
    skills: <String>['as.engine'],
  ),
  Question(
    id: 'as-003',
    subtest: Subtest.as,
    stem: 'What does the thermostat do in a liquid-cooled engine?',
    choices: <String>[
      'It switches the water pump on once the engine is warm',
      'It holds coolant back until the engine reaches operating temperature',
      'It lowers the boiling point of the coolant in the block',
      'It measures coolant temperature for the gauge on the dash',
    ],
    answerIndex: 1,
    explanation:
        'The thermostat is a valve worked by a wax pellet: it stays shut while the '
        'engine is cold so the coolant warms quickly, then opens and routes flow through the '
        'radiator at operating temperature. The water pump is belt driven all the time, '
        'boiling is controlled by the radiator and its pressure cap, and a separate sending '
        'unit drives the dash gauge.',
    difficulty: Difficulty.medium,
    skills: <String>['as.engine'],
  ),
  Question(
    id: 'as-004',
    subtest: Subtest.as,
    stem: 'What is the job of the oil pump in a car engine?',
    choices: <String>[
      'It pushes oil under pressure to the bearings and moving parts',
      'It filters dirt out of the oil before the oil is used',
      'It mixes a measured amount of oil into the fuel',
      'It cools the oil before the oil drains back to the pan',
    ],
    answerIndex: 0,
    explanation:
        'The pump draws oil from the pan and forces it through drilled passages to the '
        'bearings, and that pressure is what keeps the bearing surfaces apart. The filter only '
        'cleans the oil and the pan only sheds heat, so neither one moves it. Mixing oil into '
        'the fuel is what a two-stroke engine does, never a four-stroke car engine.',
    difficulty: Difficulty.medium,
    skills: <String>['as.engine'],
  ),
  Question(
    id: 'as-005',
    subtest: Subtest.as,
    stem:
        'If the spark fires too early, while the piston is still rising on the compression '
        'stroke, what is the most likely result?',
    choices: <String>[
      'The engine will refuse to start at all',
      'The exhaust will run cooler than normal',
      'The engine will knock or ping under load',
      'The spark plugs will wear out much faster',
    ],
    answerIndex: 2,
    explanation:
        'Firing early lets the burning charge build full pressure while the piston is '
        'still coming up, so the pressure spike hammers the piston and bearings and makes the '
        'sharp knock called detonation or pinging. Too much retard mostly costs power and sends '
        'heat out the exhaust instead. No timing error makes a healthy engine refuse to start '
        'or makes the plugs wear out quickly.',
    difficulty: Difficulty.hard,
    skills: <String>['as.engine'],
  ),
  Question(
    id: 'as-006',
    subtest: Subtest.as,
    stem: 'What does the clutch do in a vehicle with a manual transmission?',
    choices: <String>[
      'It selects the gear ratio that the road speed calls for',
      'It multiplies engine torque before the torque reaches the wheels',
      'It locks the driven wheels when the driver brakes hard',
      'It lets the engine be joined to the transmission without shock',
    ],
    answerIndex: 3,
    explanation:
        'The clutch is a friction disc squeezed against the flywheel. Pressing the '
        'pedal releases the disc so the engine can spin freely while you pick a gear, and '
        'easing the pedal back joins the two smoothly. Picking ratios is the gearbox job, extra '
        'torque comes from the gears and final drive, and stopping the wheels belongs to the '
        'brakes.',
    difficulty: Difficulty.medium,
    skills: <String>['as.engine'],
  ),
  Question(
    id: 'as-007',
    subtest: Subtest.as,
    stem: 'Why is a torque wrench used on cylinder head bolts instead of a breaker bar?',
    choices: <String>[
      'It turns stiff bolts faster than a breaker bar can',
      'It signals when the bolt has reached a set twisting force',
      'It grips rounded bolt heads that other wrenches slip on',
      'It measures how far the bolt stretches as it tightens',
    ],
    answerIndex: 1,
    explanation:
        'A torque wrench clicks or signals at a set twisting force, so every head bolt '
        'is pulled to the same spec and the gasket seals evenly without stripping threads. '
        'Speed has nothing to do with torque, gripping a rounded head is a job for a special '
        'socket, and bolt stretch is checked with a gauge after the work is done.',
    difficulty: Difficulty.medium,
    skills: <String>['as.tools'],
  ),
  Question(
    id: 'as-008',
    subtest: Subtest.as,
    stem: 'Which tool is used to measure the small gap at a spark plug electrode?',
    choices: <String>[
      'A feeler gauge',
      'An outside micrometer',
      'A steel rule',
      'A depth gauge',
    ],
    answerIndex: 0,
    explanation:
        'A feeler gauge is a fan of steel blades of known thickness. You slide blades '
        'into the gap until one just fits, and that blade thickness is the gap. A micrometer '
        'reads the outside of a part on a screw spindle, a steel rule rounds off to a fraction '
        'of an inch, and a depth gauge measures how deep a hole is.',
    difficulty: Difficulty.easy,
    skills: <String>['as.tools'],
  ),
  Question(
    id: 'as-009',
    subtest: Subtest.as,
    stem:
        'What makes a dial caliper more useful than a steel rule in the shop?',
    choices: <String>[
      'It reads the temperature of a part as the part warms up',
      'It cuts new threads while it measures a diameter',
      'It measures outside, inside and depth with one tool',
      'It measures the twisting force on small fasteners',
    ],
    answerIndex: 2,
    explanation:
        'A dial caliper closes its jaws on the outside of a shaft, opens them inside a '
        'bore, and drops a depth rod into a hole, reading to a thousandth of an inch on the '
        'dial. A steel rule is marked in fractions and cannot reach inside a bore. Calipers do '
        'not sense temperature, cut threads or measure twisting force.',
    difficulty: Difficulty.medium,
    skills: <String>['as.tools'],
  ),
  Question(
    id: 'as-010',
    subtest: Subtest.as,
    stem: 'Which pair of tools cuts a thread inside a hole and a thread on the outside of a rod?',
    choices: <String>[
      'A reamer and a broach',
      'A punch and a chisel',
      'A file and a hacksaw',
      'A tap and a die',
    ],
    answerIndex: 3,
    explanation:
        'A tap cuts internal threads, so it is turned into a drilled hole to leave '
        'threads that a bolt can screw into. A die cuts external threads on a rod. A reamer '
        'only smooths a hole that is already there, a punch and chisel cut and mark metal, and '
        'a file and hacksaw remove metal without forming threads.',
    difficulty: Difficulty.medium,
    skills: <String>['as.tools'],
  ),
  Question(
    id: 'as-011',
    subtest: Subtest.as,
    stem: 'Which wrench should be used to turn a threaded steel pipe in a plumbing repair?',
    choices: <String>[
      'An open-end wrench',
      'A pipe wrench',
      'A box-end wrench',
      'A torque wrench',
    ],
    answerIndex: 1,
    explanation:
        'A pipe wrench has hardened serrated jaws that bite into round pipe and grip '
        'tighter the harder you push on the handle. Open-end, box-end and torque wrenches are '
        'shaped for the flat sides of nuts and bolt heads, so their smooth jaws would simply '
        'slide around a round pipe.',
    difficulty: Difficulty.medium,
    skills: <String>['as.tools'],
  ),
  Question(
    id: 'as-012',
    subtest: Subtest.as,
    stem: 'Which screwdriver fits a screw with a cross-shaped recess that tapers to a point?',
    choices: <String>[
      'A Phillips screwdriver',
      'A slotted screwdriver',
      'An offset screwdriver',
      'A Torx screwdriver',
    ],
    answerIndex: 0,
    explanation:
        'A Phillips tip is a tapered cross that fits the cross-shaped recess and cams '
        'out before it can over-tighten a fastener, which is why it shows up on assembly lines. '
        'A slotted tip is a single flat blade, an offset driver is a flat blade turned by a '
        'crank for tight spaces, and a Torx tip is a six-pointed star.',
    difficulty: Difficulty.easy,
    skills: <String>['as.tools'],
  ),
  Question(
    id: 'as-013',
    subtest: Subtest.as,
    stem: 'Why is plywood built up from thin layers instead of one solid piece of wood?',
    choices: <String>[
      'Thin layers weigh less than a solid board of the same size',
      'Thin layers hold paint better than a solid board does',
      'Thin layers are pre-dried, so the panel can never shrink',
      'Crossed grain directions make the panel strong and stable',
    ],
    answerIndex: 3,
    explanation:
        'Each ply is laid at about ninety degrees to the one below, so one layer resists '
        'splitting lengthwise while the next resists it across the width, and that crossing '
        'grain holds a flat, stable panel. Glue adds weight rather than saving it, paint grip '
        'depends on the face of the panel and not on the layering, and plywood still swells and '
        'shrinks with the seasons.',
    difficulty: Difficulty.easy,
    skills: <String>['as.materials'],
  ),
  Question(
    id: 'as-014',
    subtest: Subtest.as,
    stem: 'Why does concrete get harder and stronger as it cures?',
    choices: <String>[
      'Water evaporates and leaves a hard crust behind',
      'Sand and gravel settle and pack together at the bottom',
      'Cement reacts with water and grows interlocking crystals',
      'Steel mesh rusts and locks the mixture together',
    ],
    answerIndex: 2,
    explanation:
        'Cement powder and water react chemically and grow crystal needles that lock the '
        'sand and gravel into one solid mass, which is why fresh concrete is kept damp instead '
        'of being dried out. Drying alone would leave a crumbly, weak mix, settling gravel '
        'hardens nothing, and rusting mesh weakens a slab instead of holding it together.',
    difficulty: Difficulty.medium,
    skills: <String>['as.materials'],
  ),
  Question(
    id: 'as-015',
    subtest: Subtest.as,
    stem: 'A bolt head is marked 3/8-16. What does the 16 tell you?',
    choices: <String>[
      'The bolt is 16 inches long',
      'The bolt has 16 threads per inch of length',
      'The head takes a 16 mm wrench',
      'The bolt is made of grade 16 steel',
    ],
    answerIndex: 1,
    explanation:
        'In the inch series the second number of the callout is the thread count, so '
        'this bolt is three eighths of an inch across with sixteen threads in every inch of '
        'length. Length is usually listed separately, wrench size is measured across the flats '
        'of the head, and grade is shown by radial lines on the head instead of in the callout.',
    difficulty: Difficulty.hard,
    skills: <String>['as.materials'],
  ),
  Question(
    id: 'as-016',
    subtest: Subtest.as,
    stem: 'What does a higher grit number on a sheet of sandpaper tell you?',
    choices: <String>[
      'A finer abrasive that cuts slowly and leaves a smooth surface',
      'A coarser abrasive that removes material faster',
      'An abrasive that lasts longer before it wears out',
      'An abrasive that must be used with water only',
    ],
    answerIndex: 0,
    explanation:
        'Grit is the size of the abrasive grains. A high number such as 220 cuts slowly '
        'and leaves a smooth surface, while a low number such as 40 removes stock fast and '
        'leaves deep scratches, so sanding normally steps from coarse to fine. Service life '
        'depends on the abrasive and the backing, and wet or dry use is a separate choice.',
    difficulty: Difficulty.easy,
    skills: <String>['as.materials'],
  ),
  Question(
    id: 'as-017',
    subtest: Subtest.as,
    stem: 'What is fed through the gun in metal inert gas welding?',
    choices: <String>[
      'A coated rod pushed into the arc by hand',
      'A tungsten electrode that never melts',
      'A stream of flux powder blown into the joint',
      'A continuous wire that melts and becomes the filler',
    ],
    answerIndex: 3,
    explanation:
        'A MIG gun pulls wire from a spool and feeds it steadily into the arc, where the '
        'wire itself melts into the joint as filler while shielding gas keeps air away from the '
        'puddle. A hand-fed coated rod is stick welding, a non-melting tungsten electrode is '
        'TIG, and blown flux belongs to submerged arc welding.',
    difficulty: Difficulty.medium,
    skills: <String>['as.welding'],
  ),
  Question(
    id: 'as-018',
    subtest: Subtest.as,
    stem:
        'A joint is made at about 1,200 degrees F and only the filler melts while the steel '
        'parts stay solid. This process is best called:',
    choices: <String>[
      'Soldering',
      'Brazing',
      'Fusion welding',
      'Resistance welding',
    ],
    answerIndex: 1,
    explanation:
        'Brazing melts a filler above roughly 800 degrees F but below the melting point '
        'of the parts, so the filler wets the hot surfaces and hardens between them while the '
        'steel never fuses. Soldering follows the same idea below that temperature mark. Fusion '
        'welding melts the base metal itself, and resistance welding uses current and pressure '
        'to fuse it.',
    difficulty: Difficulty.hard,
    skills: <String>['as.welding'],
  ),
  Question(
    id: 'as-019',
    subtest: Subtest.as,
    stem: 'Why must oxygen regulator fittings never be greased or handled with oily gloves?',
    choices: <String>[
      'Oil can ignite and burn fiercely wherever oxygen is present',
      'Oil makes the threads too slippery to tighten properly',
      'Oil freezes inside the regulator at low pressure',
      'Oil stops the gauge needle from reading correctly',
    ],
    answerIndex: 0,
    explanation:
        'Oxygen itself does not burn, but it makes almost anything else burn '
        'fiercely, so a trace of oil on a fitting can ignite the moment the '
        'cylinder valve opens and turn the regulator into a blowtorch. Oily rags and '
        'gloves are banned near oxygen for the same reason. Slippery threads, freezing '
        'and a sticky gauge are minor beside that fire risk.',
    difficulty: Difficulty.hard,
    skills: <String>['as.welding'],
  ),
  Question(
    id: 'as-020',
    subtest: Subtest.as,
    stem: 'Why is the slag chipped off a stick weld before the next pass is laid down?',
    choices: <String>[
      'Slag is heavier than steel and pulls the weld out of shape',
      'Slag is radioactive and has to be buried before welding resumes',
      'Trapped slag leaves weak spots and defects in the next pass',
      'Chipping polishes the weld so paint sticks better to it',
    ],
    answerIndex: 2,
    explanation:
        'The glassy slag left on a stick weld has to be chipped and brushed '
        'away, because anything left in place is buried by the next pass and forms a '
        'weak, crack-prone inclusion. Slag is lighter than steel, it is not radioactive, '
        'and chipping does not polish a weld. Chips fly, so chipping goggles and good '
        'ventilation are still required.',
    difficulty: Difficulty.medium,
    skills: <String>['as.welding'],
  ),
];
