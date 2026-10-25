import '../models/catalog.dart';
import '../models/question.dart';

/// General Science bank: 22 items balanced across biology, chemistry, physics,
/// and earth and space science to match the ASVAB GS blueprint.
const List<Question> generalScienceBank = <Question>[
  Question(
    id: 'gs-001',
    subtest: Subtest.gs,
    stem: 'Which part of a cell controls which materials are allowed to enter and leave?',
    choices: <String>['Cell membrane', 'Nucleus', 'Ribosome', 'Vacuole'],
    answerIndex: 0,
    explanation:
        'The cell membrane is a thin, flexible boundary that is selectively permeable, '
        'so water and some dissolved materials pass while others are kept out. The nucleus '
        'holds DNA and directs activity, ribosomes build proteins, and a vacuole stores water '
        'or waste, so none of the others guards the cell surface.',
    difficulty: Difficulty.easy,
    skills: <String>['gs.biology'],
  ),
  Question(
    id: 'gs-002',
    subtest: Subtest.gs,
    stem: 'Which gas do green plants absorb from the air to make sugar during photosynthesis?',
    choices: <String>['Oxygen', 'Nitrogen', 'Carbon dioxide', 'Hydrogen'],
    answerIndex: 2,
    explanation:
        'Plants combine carbon dioxide and water, using light energy trapped by '
        'chlorophyll, to build glucose and give off oxygen. Oxygen is the gas released, not '
        'taken in, so it is the classic reversed answer. Nitrogen makes up most of the air but '
        'is not used here, and hydrogen is not absorbed from the atmosphere.',
    difficulty: Difficulty.easy,
    skills: <String>['gs.biology'],
  ),
  Question(
    id: 'gs-003',
    subtest: Subtest.gs,
    stem: 'A normal human body cell contains how many chromosomes?',
    choices: <String>['23', '46', '44', '92'],
    answerIndex: 1,
    explanation:
        'Body cells are diploid, meaning 23 pairs or 46 chromosomes, with half '
        'inherited from each parent. Egg and sperm cells carry only 23 each, which is why that '
        'option appears. The 92 option describes a cell that has just duplicated its '
        'chromosomes and is about to divide.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.biology'],
  ),
  Question(
    id: 'gs-004',
    subtest: Subtest.gs,
    stem: 'Which blood vessels carry blood away from the heart?',
    choices: <String>['Arteries', 'Veins', 'Capillaries', 'Ventricles'],
    answerIndex: 0,
    explanation:
        'Arteries carry blood away from the heart under high pressure, which is why '
        'they have thick, muscular walls. Veins return blood toward the heart and use valves to '
        'stop backflow, while capillaries are the tiny exchange vessels that connect the two. '
        'Ventricles are pumping chambers of the heart, not vessels.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.biology'],
  ),
  Question(
    id: 'gs-005',
    subtest: Subtest.gs,
    stem: 'Most absorption of digested nutrients into the bloodstream takes place in the',
    choices: <String>[
      'Stomach',
      'Small intestine',
      'Large intestine',
      'Esophagus',
    ],
    answerIndex: 1,
    explanation:
        'The small intestine is lined with villi, tiny fingerlike projections that give '
        'an enormous surface area for nutrients to cross into the blood. The stomach mainly '
        'churns food and begins protein digestion, the large intestine mostly reclaims water, '
        'and the esophagus only carries food downward.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.biology'],
  ),
  Question(
    id: 'gs-006',
    subtest: Subtest.gs,
    stem:
        'The tough bands of connective tissue that hold one bone to another at a joint '
        'are called',
    choices: <String>['Tendons', 'Cartilage', 'Nerves', 'Ligaments'],
    answerIndex: 3,
    explanation:
        'Ligaments connect bone to bone and keep a joint stable, while tendons attach '
        'muscle to bone and produce movement. Swapping those two is the classic trap, and this '
        'question asks about bone to bone. Cartilage is smooth padding that cushions the ends of '
        'bones, and nerves carry signals rather than holding structure.',
    difficulty: Difficulty.hard,
    skills: <String>['gs.biology'],
  ),
  Question(
    id: 'gs-007',
    subtest: Subtest.gs,
    stem: 'The number of protons in the nucleus of an atom is called the',
    choices: <String>[
      'Atomic number',
      'Mass number',
      'Valence count',
      'Atomic mass',
    ],
    answerIndex: 0,
    explanation:
        'The atomic number counts protons and fixes the identity of the element, so '
        'every carbon atom has 6. Mass number counts protons plus neutrons, which makes it a '
        'larger number, and atomic mass is an average across isotopes. Valence count refers to '
        'the electrons in the outermost shell.',
    difficulty: Difficulty.easy,
    skills: <String>['gs.chemistry'],
  ),
  Question(
    id: 'gs-008',
    subtest: Subtest.gs,
    stem:
        'Which family of elements on the periodic table almost never reacts with other '
        'elements?',
    choices: <String>[
      'Alkali metals',
      'Halogens',
      'Alkaline earth metals',
      'Noble gases',
    ],
    answerIndex: 3,
    explanation:
        'Noble gases such as helium and neon have full outer electron shells, so they '
        'have no reason to gain, lose, or share electrons. Alkali metals have a single outer '
        'electron they give up eagerly, and halogens are one electron short of a full shell, '
        'which makes both families highly reactive.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.chemistry'],
  ),
  Question(
    id: 'gs-009',
    subtest: Subtest.gs,
    stem:
        'Sodium gives up an electron to chlorine, and the two resulting ions attract each '
        'other. This bond is',
    choices: <String>['Metallic', 'Covalent', 'Ionic', 'Hydrogen'],
    answerIndex: 2,
    explanation:
        'A bond formed by transferring electrons and then holding the oppositely '
        'charged ions together by attraction is ionic, which is what happens in table salt. A '
        'covalent bond shares electrons instead of transferring them. Metallic bonding '
        'describes metal atoms sharing a sea of electrons, and hydrogen bonds are weaker '
        'attractions between molecules.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.chemistry'],
  ),
  Question(
    id: 'gs-010',
    subtest: Subtest.gs,
    stem: 'Four solutions have the pH values listed. Which one is the strongest acid?',
    choices: <String>['pH 2', 'pH 6', 'pH 7', 'pH 12'],
    answerIndex: 0,
    explanation:
        'The pH scale runs from 0 to 14, and each unit is a tenfold change in acidity, '
        'so a lower number means more hydrogen ions in solution. That makes pH 2 far more '
        'acidic than pH 6. A pH of 7 is neutral, like pure water, and pH 12 is a base rather '
        'than an acid.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.chemistry'],
  ),
  Question(
    id: 'gs-011',
    subtest: Subtest.gs,
    stem: 'As a liquid is heated, the average kinetic energy of its molecules',
    choices: <String>[
      'Decreases steadily',
      'Increases',
      'Stays exactly the same',
      'Drops to zero',
    ],
    answerIndex: 1,
    explanation:
        'Temperature measures average kinetic energy, so adding heat makes the '
        'molecules move faster. When they gain enough energy to escape the attractions holding '
        'them together, the liquid boils and becomes a gas. A change of state can pause the '
        'temperature reading, but the added energy still goes into the motion of the particles.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.chemistry'],
  ),
  Question(
    id: 'gs-012',
    subtest: Subtest.gs,
    stem:
        'In a closed container, 4.0 grams of hydrogen reacts completely with 32.0 grams '
        'of oxygen. What mass of water is produced?',
    choices: <String>['32.0 grams', '34.0 grams', '36.0 grams', '40.0 grams'],
    answerIndex: 2,
    explanation:
        'Mass is conserved in a chemical reaction, so the products weigh exactly what '
        'the reactants that combined weighed: 4.0 grams plus 32.0 grams gives 36.0 grams of '
        'water. The first option simply repeats the oxygen, ignoring the hydrogen that also '
        'became part of the water, and no gas escapes from a closed container.',
    difficulty: Difficulty.hard,
    skills: <String>['gs.chemistry'],
  ),
  Question(
    id: 'gs-013',
    subtest: Subtest.gs,
    stem:
        'A 10-kilogram cart is pushed with a net force of 20 newtons. What is the '
        'acceleration of the cart?',
    choices: <String>[
      '0.5 meter per second squared',
      '10 meters per second squared',
      '200 meters per second squared',
      '2 meters per second squared',
    ],
    answerIndex: 3,
    explanation:
        'The second law of motion says force equals mass times acceleration, so '
        'acceleration is force divided by mass: 20 divided by 10 gives 2 meters per second '
        'squared. Multiplying the two numbers instead of dividing gives 200, and dividing mass '
        'by force gives 0.5. The 10 option is just the mass repeated.',
    difficulty: Difficulty.easy,
    skills: <String>['gs.physics'],
  ),
  Question(
    id: 'gs-014',
    subtest: Subtest.gs,
    stem: 'A passenger in a moving bus is thrown forward when the driver brakes suddenly. Why?',
    choices: <String>[
      'The brakes push the passenger forward',
      'The passenger tends to keep moving forward',
      'The bus moves backward as it slows down',
      'Gravity pulls the passenger forward',
    ],
    answerIndex: 1,
    explanation:
        'An object keeps the motion it already has unless a force acts on it, which is '
        'inertia. The bus and the passenger were both moving forward, the brakes slow the bus, '
        'and nothing pushes the passenger. That is why the passenger keeps moving at nearly the '
        'old speed while the bus stops underneath.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.physics'],
  ),
  Question(
    id: 'gs-015',
    subtest: Subtest.gs,
    stem:
        'A car starts from rest at the top of a 20-meter hill and rolls down with no '
        'friction. How fast is it moving at the bottom? Use g = 10 meters per second squared.',
    choices: <String>[
      '10 meters per second',
      '14 meters per second',
      '20 meters per second',
      '40 meters per second',
    ],
    answerIndex: 2,
    explanation:
        'All of the potential energy becomes kinetic energy: mass times g times height '
        'equals one half of mass times speed squared, so speed is the square root of 2 times 10 '
        'times 20, which is 20 meters per second. Forgetting the square root gives 40. The 10 '
        'and 14 options come from using only the height or the wrong rearrangement.',
    difficulty: Difficulty.hard,
    skills: <String>['gs.physics'],
  ),
  Question(
    id: 'gs-016',
    subtest: Subtest.gs,
    stem: 'Sound travels fastest through which material?',
    choices: <String>[
      'A vacuum',
      'Air at room temperature',
      'Fresh water',
      'Steel',
    ],
    answerIndex: 3,
    explanation:
        'Sound is a vibration passed from particle to particle, and stiff, closely '
        'packed material passes that vibration along fastest, so steel wins by a wide margin. '
        'Air is far less dense and much slower, and water falls in between. A vacuum has no '
        'particles to carry the wave, so sound cannot travel through it at all.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.physics'],
  ),
  Question(
    id: 'gs-017',
    subtest: Subtest.gs,
    stem:
        'A coil of wire wrapped around an iron core produces a strong magnetic field when '
        'current flows through it. The device is called',
    choices: <String>[
      'An electromagnet',
      'A transformer',
      'A capacitor',
      'A resistor',
    ],
    answerIndex: 0,
    explanation:
        'This is an electromagnet: current in the coil creates a magnetic field and the '
        'iron core concentrates it. A transformer also uses coils, but it changes AC voltage '
        'rather than producing a usable magnetic field. A capacitor stores charge in an '
        'electric field, and a resistor simply opposes current.',
    difficulty: Difficulty.hard,
    skills: <String>['gs.physics'],
  ),
  Question(
    id: 'gs-018',
    subtest: Subtest.gs,
    stem:
        'A block has a mass of 50 grams and a volume of 100 cubic centimeters. What happens '
        'when it is placed in water?',
    choices: <String>[
      'It sinks, because it is too heavy for the container',
      'It sinks, because its volume is too small',
      'It floats, because its density is 0.5 gram per cubic centimeter',
      'It floats, because the air cancels out its weight',
    ],
    answerIndex: 2,
    explanation:
        'Density is mass divided by volume, so 50 grams divided by 100 cubic '
        'centimeters is 0.5 gram per cubic centimeter, well under the 1 gram per cubic '
        'centimeter of water, and the block floats. Buoyancy supports an object whose density is '
        'lower than the fluid it sits in. Mass alone does not decide floating, which is why the '
        'first option is wrong.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.physics'],
  ),
  Question(
    id: 'gs-019',
    subtest: Subtest.gs,
    stem: 'Most of the strongest earthquakes and volcanoes in the world occur',
    choices: <String>[
      'In the middle of flat continents',
      'Along the boundaries of tectonic plates',
      'Near the poles, where the crust is thickest',
      'Only on islands in the open ocean',
    ],
    answerIndex: 1,
    explanation:
        'The crust is broken into tectonic plates that grind past, collide with, or '
        'pull away from one another. Those boundaries are where stress builds until rock breaks, '
        'producing earthquakes, and where magma rises, producing volcanoes. Plate interiors are '
        'far quieter, so continents and polar regions rarely host the strongest events.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.earth'],
  ),
  Question(
    id: 'gs-020',
    subtest: Subtest.gs,
    stem: 'Rock that forms when melted material cools and hardens is called',
    choices: <String>['Sedimentary', 'Metamorphic', 'Fossiliferous', 'Igneous'],
    answerIndex: 3,
    explanation:
        'Igneous rock forms from cooling magma or lava, and slow cooling underground '
        'makes large crystals while fast cooling at the surface makes fine ones. Sedimentary '
        'rock forms from compacted layers of sediment, and metamorphic rock forms when existing '
        'rock is squeezed and heated. Fossiliferous describes a rock containing fossils, not a '
        'rock class.',
    difficulty: Difficulty.easy,
    skills: <String>['gs.earth'],
  ),
  Question(
    id: 'gs-021',
    subtest: Subtest.gs,
    stem: 'What usually happens as a cold front passes through an area?',
    choices: <String>[
      'Temperatures drop, often with brief heavy rain or storms',
      'Temperatures rise and the sky clears for several days',
      'The weather stays the same for about a week',
      'A long spell of steady drizzle begins',
    ],
    answerIndex: 0,
    explanation:
        'In a cold front, dense cold air wedges under warm air and lifts it quickly, so '
        'tall storm clouds, showers, and thunderstorms form and then the temperature falls. A '
        'warm front behaves differently: warm air rides up slowly over cold air and produces '
        'long, gentle rain, which is where the drizzle option belongs.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.earth'],
  ),
  Question(
    id: 'gs-022',
    subtest: Subtest.gs,
    stem: 'The seasons occur mainly because',
    choices: <String>[
      'The Earth is closer to the Sun during the summer',
      'The axis of the Earth is tilted as it orbits the Sun',
      'The orbit of the Earth is an oval rather than a circle',
      'The Sun gives off more heat during the summer months',
    ],
    answerIndex: 1,
    explanation:
        'The axis of the Earth stays tilted about 23 degrees as the planet travels '
        'around the Sun, so each hemisphere leans toward the Sun for part of the year and gets '
        'sunlight at a steeper angle and for more hours. Distance from the Sun changes by only a '
        'small percentage and does not line up with the seasons at all.',
    difficulty: Difficulty.hard,
    skills: <String>['gs.earth'],
  ),
];
