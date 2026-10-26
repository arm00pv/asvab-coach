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
    choiceNotes: <String>[
      'The membrane is the selectively permeable boundary that lets some materials through and keeps others out.',
      'The nucleus holds DNA and directs activity, but it sits inside the cell and gates nothing at the surface.',
      'Ribosomes assemble proteins from amino acids, which builds things rather than admitting them.',
      'A vacuole stores water or waste already inside the cell, so it controls no entry or exit.',
    ],
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
    choiceNotes: <String>[
      'Oxygen is the gas photosynthesis gives off, so picking it reverses the direction of the exchange.',
      'Nitrogen is the most plentiful gas in air, but plants do not take it in to build sugar.',
      'Carbon dioxide supplies the carbon that light-driven reactions lock into glucose, so it must be absorbed.',
      'Hydrogen is not absorbed from the atmosphere as a gas, and it supplies no carbon for sugar.',
    ],
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
    choiceNotes: <String>[
      '23 is the count in an egg or sperm cell, which is half a full set rather than the diploid number.',
      'A body cell is diploid, so the 23 pairs add up to 46 chromosomes, half from each parent.',
      '44 counts the 22 autosome pairs and forgets the two sex chromosomes.',
      '92 describes a cell that has already copied its chromosomes and is about to divide.',
    ],
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
    choiceNotes: <String>[
      'Vessels leaving the heart under high pressure need thick muscular walls, and that is what arteries are.',
      'Veins run the other way, returning blood to the heart and relying on valves to stop backflow.',
      'Capillaries are the microscopic exchange vessels linking arteries to veins, not the outflow itself.',
      'Ventricles are pumping chambers inside the heart, so they are not vessels at all.',
    ],
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
    choiceNotes: <String>[
      'The stomach churns food and begins protein digestion but absorbs very little of the nutrient load.',
      'Villi lining the small intestine give an enormous surface area for nutrients to cross into the blood.',
      'The large intestine reclaims water from what is left rather than taking in nutrients.',
      'The esophagus only carries swallowed food down to the stomach, with no absorption along the way.',
    ],
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
    choiceNotes: <String>[
      'Tendons attach muscle to bone, which is the classic swap for the bone-to-bone tissue asked about here.',
      'Cartilage is smooth padding that cushions the ends of bones, not a band holding two bones together.',
      'Nerves carry electrical signals and hold no joint structure in place.',
      'Bone joined to bone by a tough band that stabilises the joint is the definition of a ligament.',
    ],
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
    choiceNotes: <String>[
      'The proton count is the atomic number, and it fixes the identity of the element.',
      'Mass number counts protons plus neutrons, so it comes out larger than the proton count.',
      'Valence count counts electrons in the outermost shell, not particles in the nucleus.',
      'Atomic mass is an average across the isotopes, so it carries neutrons in it too.',
    ],
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
    choiceNotes: <String>[
      'Alkali metals have one outer electron they give up eagerly, which makes them very reactive.',
      'Halogens are one electron short of a full shell, so they grab electrons aggressively.',
      'Alkaline earth metals have two outer electrons they readily lose, so they react too.',
      'A full outer shell leaves these elements no reason to gain, lose or share electrons.',
    ],
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
    choiceNotes: <String>[
      'Metallic bonding is a sea of shared electrons among metal atoms, with no transfer from one atom to another.',
      'A covalent bond shares electrons between atoms instead of handing them over outright.',
      'Giving up an electron and then attracting the two charged ions is precisely what forms an ionic bond.',
      'Hydrogen bonds are weak attractions between molecules, not a bond created by moving an electron.',
    ],
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
    choiceNotes: <String>[
      'The lowest reading here carries the most hydrogen ions, and that is what makes it the strongest acid.',
      'A reading of 6 is only slightly acidic, and each step is tenfold, so it is far weaker than 2.',
      'A reading of 7 is neutral like pure water, so it is neither an acid nor a base.',
      'A reading of 12 sits in the basic range and holds very few hydrogen ions.',
    ],
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
    choiceNotes: <String>[
      'Heating adds energy, so particle motion cannot fall; this choice swaps heating for cooling.',
      'Temperature measures average kinetic energy, so adding heat makes the molecules move faster.',
      'Holding motion constant would need no heat at all, since the added energy has to go somewhere.',
      'Zero kinetic energy would mean the molecules stopped dead, which never happens above absolute zero.',
    ],
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
    choiceNotes: <String>[
      'The figure is just the oxygen mass, which ignores the hydrogen that also becomes part of the water.',
      'This adds only one gram of hydrogen instead of the four grams the reaction consumes.',
      'Mass is conserved, so 4.0 grams of hydrogen plus 32.0 grams of oxygen gives 36.0 grams of water.',
      'This total is larger than the reactants weighed, which conservation of mass forbids.',
    ],
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
    choiceNotes: <String>[
      'The 0.5 figure comes from dividing mass by force, but acceleration is force divided by mass.',
      'The 10 figure is the mass copied down unchanged, as though the force did nothing to it.',
      'The 200 figure multiplies force by mass instead of dividing, inflating the answer a hundredfold.',
      'Force divided by mass, 20 newtons by 10 kilograms, gives 2 meters per second squared.',
    ],
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
    choiceNotes: <String>[
      'The brakes act on the bus, and nothing touches the passenger to push them anywhere.',
      'Inertia keeps the passenger moving at the old speed while the bus slows underneath.',
      'The bus keeps rolling forward while it slows; it never reverses direction.',
      'Gravity pulls downward rather than forward, so it cannot explain the lurch.',
    ],
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
    choiceNotes: <String>[
      'The 10 figure takes the height in meters as the speed, ignoring that falling converts height into motion.',
      'The 14 figure is the square root of 2 times 10 times 10, so it halves the height by misplacing the one-half.',
      'The square root of 2 times 10 times 20 is 20, since all the potential energy becomes kinetic energy.',
      'The 40 figure misses the square root and doubles the answer, which no energy balance supports.',
    ],
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
    choiceNotes: <String>[
      'A vacuum has no particles to pass the vibration along, so sound cannot travel through it at all.',
      'Air is thin and springy, which makes it one of the slowest carriers of sound.',
      'Water is denser than air, so sound moves faster in it, but still far slower than in a solid.',
      'Stiffly bonded particles pass the vibration along fastest, which is why sound outruns air in steel.',
    ],
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
    choiceNotes: <String>[
      'Current through a coil wound on an iron core produces the strong magnetic field this item describes.',
      'A transformer also has coils, but it changes AC voltage instead of producing a usable field.',
      'A capacitor stores charge in the electric field between two plates.',
      'A resistor opposes current and creates no magnetic field at all.',
    ],
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
    choiceNotes: <String>[
      'Floating depends on density against water, not on how heavy the block feels or how big the container is.',
      'A small volume actually raises density, and here it is the low density that makes the block float.',
      'Dividing 50 grams by 100 cubic centimeters gives 0.5, well under the 1 of water, so it floats.',
      'Air pushes up equally on everything; buoyancy in the water is what decides the outcome.',
    ],
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
    choiceNotes: <String>[
      'Plate interiors are quiet, so flat continental middles host few strong quakes and no volcanoes.',
      'Stress builds where plates grind, collide or pull apart, and magma rises at those same seams.',
      'Thick crust near the poles is stable, and the polar regions are not where plates meet.',
      'Ocean islands can be volcanic, but the phrase overlooks the far more active plate boundaries elsewhere.',
    ],
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
    choiceNotes: <String>[
      'Sedimentary rock comes from compacted layers of sediment, which is a different route entirely.',
      'Metamorphic rock forms when existing rock is squeezed and heated, not from melt.',
      'Fossiliferous describes a rock that contains fossils, not how the rock formed.',
      'Cooling magma or lava hardens into igneous rock, coarse below ground and fine at the surface.',
    ],
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
    choiceNotes: <String>[
      'Dense cold air wedges under the warm air, lifts it into storms, and then the temperature falls.',
      'Rising temperatures and clearing skies describe the passage of a warm front, not a cold one.',
      'A front is a boundary between air masses, so it changes the weather rather than parking it.',
      'Steady drizzle is the signature of a warm front, where warm air rides up slowly and gently.',
    ],
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
    choiceNotes: <String>[
      'Distance changes by only a small percentage and does not line up with the seasons at all.',
      'The 23-degree tilt leans one hemisphere sunward for part of the year, giving steeper light and longer days.',
      'The slight oval of the orbit is far too small a change to produce summer and winter.',
      'Solar output is steady; what changes is the angle and duration of light reaching each hemisphere.',
    ],
    explanation:
        'The axis of the Earth stays tilted about 23 degrees as the planet travels '
        'around the Sun, so each hemisphere leans toward the Sun for part of the year and gets '
        'sunlight at a steeper angle and for more hours. Distance from the Sun changes by only a '
        'small percentage and does not line up with the seasons at all.',
    difficulty: Difficulty.hard,
    skills: <String>['gs.earth'],
  ),
];
