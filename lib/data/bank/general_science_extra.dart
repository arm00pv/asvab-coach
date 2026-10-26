import '../models/catalog.dart';
import '../models/question.dart';

/// General Science expansion bank: 18 items split the way the real subtest is
/// weighted, with 6 life science, 4 chemistry, 3 physics and 5 earth and space
/// science items. Every numeric answer has been recomputed by hand.
const List<Question> generalScienceExtraBank = <Question>[
  Question(
    id: 'gs-x01',
    subtest: Subtest.gs,
    stem:
        'Which plant tissue carries water and dissolved minerals upward from the '
        'roots to the leaves?',
    choices: <String>['Phloem', 'Xylem', 'Cambium', 'Epidermis'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Phloem is the living tissue that carries sugar down from the leaves, the reverse trip from water.',
      'Dead hollow cells stacked into tubes lift water and dissolved minerals from the roots.',
      'Cambium is the growth layer that builds both tissues rather than transporting anything itself.',
      'The epidermis is the outer skin of the plant, not a plumbing system.',
    ],
    explanation:
        'Xylem is made of dead, hollow cells stacked into tubes, and it lifts water and '
        'the minerals dissolved in it from the roots to the leaves, where most of the water '
        'evaporates. Phloem is the living tissue that carries sugar made in the leaves to the '
        'rest of the plant, so it is the trap. Cambium is the thin growth layer that produces '
        'both tissues, and the epidermis is the outer skin of the plant.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.biology'],
  ),
  Question(
    id: 'gs-x02',
    subtest: Subtest.gs,
    stem:
        'Animals with jointed legs, a segmented body and a hard outer skeleton of chitin '
        'are classified as',
    choices: <String>['Mollusks', 'Annelids', 'Echinoderms', 'Arthropods'],
    answerIndex: 3,
    choiceNotes: <String>[
      'Mollusks have soft bodies and often a shell, with no jointed legs or chitin skeleton.',
      'Annelids are segmented worms such as earthworms, and they have no jointed legs.',
      'Echinoderms like starfish have spiny skin and tube feet instead of an exoskeleton.',
      'Jointed legs plus a chitin exoskeleton on a segmented body is the recipe for an arthropod.',
    ],
    explanation:
        'Arthropods include insects, spiders, crabs and centipedes, and the jointed legs plus '
        'a chitin exoskeleton are the identifying features. Mollusks have soft bodies and often '
        'a shell, as snails do. Annelids are segmented worms such as earthworms, which have no '
        'jointed legs, and echinoderms such as starfish have spiny skin and tube feet.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.biology'],
  ),
  Question(
    id: 'gs-x03',
    subtest: Subtest.gs,
    stem:
        'The microscopic structure in the kidney that filters wastes from the blood and '
        'starts the formation of urine is the',
    choices: <String>['Nephron', 'Alveolus', 'Villus', 'Neuron'],
    answerIndex: 0,
    choiceNotes: <String>[
      'About a million per kidney filter wastes and reclaim water and salts before urine leaves.',
      'An alveolus is an air sac in the lung where gases are exchanged, not a filter in the kidney.',
      'A villus is a fold in the small intestine that absorbs nutrients.',
      'A neuron is a nerve cell that carries signals and filters nothing.',
    ],
    explanation:
        'Each kidney holds about a million nephrons, and each one filters the blood and then '
        'returns most of the water and useful salts before the rest leaves as urine. The other '
        'three names belong to different organs, which is the point of the question: an alveolus '
        'is an air sac in the lung, a villus is a fold in the small intestine, and a neuron is a '
        'nerve cell.',
    difficulty: Difficulty.hard,
    skills: <String>['gs.biology'],
  ),
  Question(
    id: 'gs-x04',
    subtest: Subtest.gs,
    stem: 'Which chamber of the heart pumps oxygen-rich blood into the aorta?',
    choices: <String>[
      'Right atrium',
      'Left atrium',
      'Right ventricle',
      'Left ventricle',
    ],
    answerIndex: 3,
    choiceNotes: <String>[
      'The right atrium receives returning blood and empties it into the ventricle below, never into the aorta.',
      'The left atrium passes oxygen-rich blood down to the left ventricle rather than driving it into the aorta.',
      'The right ventricle pumps only to the nearby lungs, so its wall stays thin.',
      'The thickest wall drives blood through the whole body by way of the aorta, which is the left ventricle.',
    ],
    explanation:
        'The left ventricle has the thickest wall in the heart because it drives blood '
        'through the entire body by way of the aorta. The right ventricle pumps blood only to '
        'the nearby lungs, so its wall is thinner. The two atria are receiving chambers that '
        'empty into the ventricles below them rather than pumping to the body.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.biology'],
  ),
  Question(
    id: 'gs-x05',
    subtest: Subtest.gs,
    stem:
        'Two species live closely together and both of them benefit from the relationship. '
        'This relationship is called',
    choices: <String>['Parasitism', 'Commensalism', 'Mutualism', 'Competition'],
    answerIndex: 2,
    choiceNotes: <String>[
      'Parasitism benefits one partner at the expense of the other, the opposite of both gaining.',
      'Commensalism is a one-way benefit, where the second species is neither helped nor harmed.',
      'Both partners gain here, as when a bee feeds while carrying pollen onward.',
      'Competition costs both species something instead of rewarding either of them.',
    ],
    explanation:
        'Mutualism pays both partners, as when a bee feeds on a flower while carrying its '
        'pollen to the next plant. Commensalism is a one-way benefit in which the second species '
        'is neither helped nor harmed, which is why it is the tempting wrong answer. Parasitism '
        'harms the host, and competition costs both species something.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.biology'],
  ),
  Question(
    id: 'gs-x06',
    subtest: Subtest.gs,
    stem:
        'In a food chain, most of the energy taken in at one feeding level is',
    choices: <String>[
      'Passed on to the next level',
      'Lost as heat',
      'Stored as fat for later use',
      'Returned to the Sun',
    ],
    answerIndex: 1,
    choiceNotes: <String>[
      'Only about a tenth reaches the next level, because most is spent on staying alive.',
      'Organisms burn most of what they take in and release the rest as heat, which is why chains stay short.',
      'Some energy is stored as fat, but only a small share rather than most of the intake.',
      'Energy flows one way through an ecosystem; only matter cycles, and nothing returns to the Sun.',
    ],
    explanation:
        'Only about a tenth of the energy in one feeding level reaches the next, because '
        'organisms spend most of it on staying alive and release the rest as heat. That is why '
        'food chains rarely have more than four or five links and why there are far fewer '
        'predators than plants. Energy is not cycled back to the Sun; matter cycles through the '
        'ecosystem, but energy flows through and is lost.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.biology'],
  ),
  Question(
    id: 'gs-x07',
    subtest: Subtest.gs,
    stem: 'Two atoms of the same element that contain different numbers of neutrons are called',
    choices: <String>['Ions', 'Isomers', 'Allotropes', 'Isotopes'],
    answerIndex: 3,
    choiceNotes: <String>[
      'An ion has gained or lost electrons and carries a charge, with the neutron count untouched.',
      'Isomers are molecules with the same formula arranged differently, so they are not single atoms.',
      'Allotropes are different forms of one element, such as diamond and graphite, not differing neutron counts.',
      'Same proton count with different neutron counts is exactly what makes two atoms isotopes of one element.',
    ],
    explanation:
        'Isotopes of an element have the same number of protons, since the proton count '
        'defines the element, but different neutron counts, so carbon-12 and carbon-14 are both '
        'carbon. An ion has gained or lost electrons and carries a charge. Isomers are molecules '
        'with the same formula arranged differently, and allotropes are different forms of one '
        'element, such as diamond and graphite.',
    difficulty: Difficulty.hard,
    skills: <String>['gs.chemistry'],
  ),
  Question(
    id: 'gs-x08',
    subtest: Subtest.gs,
    stem: 'Which of these is a physical change rather than a chemical change?',
    choices: <String>[
      'Iron rusting in damp air',
      'Milk souring on the counter',
      'Sugar dissolving in water',
      'Wood burning in a stove',
    ],
    answerIndex: 2,
    choiceNotes: <String>[
      'Rusting makes a new substance, iron oxide, which cannot be turned back into iron easily.',
      'Souring produces new acids with a different taste and smell, so a new substance has formed.',
      'Dissolving only spreads sugar molecules through water, and evaporating the water recovers the same sugar.',
      'Burning turns wood into ash and gases, so the change is chemical.',
    ],
    explanation:
        'Dissolving only separates the sugar molecules and spreads them through the water, '
        'and evaporating the water recovers the same sugar, so no new substance forms and the '
        'change is physical. Rusting, souring and burning each produce a new substance with '
        'different properties and cannot be undone simply. Dissolving is the change most often '
        'mislabeled as chemical.',
    difficulty: Difficulty.easy,
    skills: <String>['gs.chemistry'],
  ),
  Question(
    id: 'gs-x09',
    subtest: Subtest.gs,
    stem:
        'A substance formed when two or more elements combine chemically in a fixed ratio '
        'is called',
    choices: <String>['A compound', 'A mixture', 'An element', 'A solution'],
    answerIndex: 0,
    choiceNotes: <String>[
      'A fixed ratio, as in water with two hydrogens per oxygen, is what marks out a compound.',
      'A mixture combines materials in any proportion and can be separated by filtering or boiling.',
      'An element cannot be broken down at all, so it cannot be two elements combined.',
      'A solution is one kind of mixture, and its proportions are not fixed.',
    ],
    explanation:
        'A compound has a formula with a fixed ratio, such as water, which has two hydrogen '
        'atoms for every oxygen atom, and it can be broken into simpler substances only by a '
        'chemical reaction. A mixture combines materials in any proportion and can be separated '
        'by physical means such as filtering or boiling. A solution is one kind of mixture, and '
        'an element cannot be broken down at all.',
    difficulty: Difficulty.easy,
    skills: <String>['gs.chemistry'],
  ),
  Question(
    id: 'gs-x10',
    subtest: Subtest.gs,
    stem:
        'How many atoms are in one formula unit of calcium hydroxide, Ca(OH)2?',
    choices: <String>['3', '4', '5', '6'],
    answerIndex: 2,
    choiceNotes: <String>[
      'The 3 count takes one calcium plus two oxygens and ignores the hydrogen entirely.',
      'The 4 count lets the subscript 2 apply only to the oxygen, so the two hydrogens are dropped.',
      'One calcium, two oxygens and two hydrogens add up to five atoms.',
      'The 6 count double-counts, often by reading the subscript against the calcium as well.',
    ],
    explanation:
        'The formula has one calcium atom, and the subscript 2 after the parentheses '
        'multiplies everything inside them, giving two oxygen atoms and two hydrogen atoms. '
        'That makes 1 + 2 + 2 = 5 atoms. Reading the 2 as applying only to the oxygen gives 4, '
        'and ignoring the hydrogen entirely gives 3; the subscript belongs to the whole group '
        'in parentheses.',
    difficulty: Difficulty.hard,
    skills: <String>['gs.chemistry'],
  ),
  Question(
    id: 'gs-x11',
    subtest: Subtest.gs,
    stem: 'A rocket accelerates in the vacuum of space, where there is no air, because',
    choices: <String>[
      'It pushes against the air around it',
      'Exhaust gases are thrown backward',
      'Space has no friction to slow it down',
      'Gravity pulls the rocket forward',
    ],
    answerIndex: 1,
    choiceNotes: <String>[
      'There is no air in space for the exhaust to push against, so this cannot explain thrust.',
      'Throwing mass backward gives the rocket an equal push forward, which is the third law at work.',
      'No friction explains why a moving rocket keeps its speed, not why it speeds up.',
      'Gravity pulls toward masses; it does not push a rocket forward.',
    ],
    explanation:
        'The engine throws hot gas backward, and by the third law of motion the rocket gets '
        'an equal push forward, which is why a rocket needs nothing to push against. The absence '
        'of friction explains why the rocket keeps its speed once moving, not why it speeds up. '
        'There is no air in space, and gravity there does not push a rocket forward.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.physics'],
  ),
  Question(
    id: 'gs-x12',
    subtest: Subtest.gs,
    stem: 'Heat is spread through a pot of soup mainly by',
    choices: <String>['Conduction', 'Radiation', 'Convection', 'Reflection'],
    answerIndex: 2,
    choiceNotes: <String>[
      'Conduction moves heat by direct contact and does most of the work in a solid, not in a liquid.',
      'Radiation carries heat as waves and needs no material at all, which is not how soup heats.',
      'Warmed soup rises as it expands while cooler soup sinks, and that circulation is convection.',
      'Reflection sends heat away from a surface instead of spreading it through the pot.',
    ],
    explanation:
        'Soup warmed at the bottom expands, becomes less dense and rises while cooler soup '
        'sinks to take its place, and that circulating current is convection. Conduction moves '
        'heat by direct contact and does most of the work in a solid. Radiation carries heat as '
        'waves and needs no material at all, and reflection sends heat away rather than '
        'spreading it.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.physics'],
  ),
  Question(
    id: 'gs-x13',
    subtest: Subtest.gs,
    stem:
        'The tip of a sealed syringe is capped and the plunger is pushed in. What happens to '
        'the trapped air?',
    choices: <String>[
      'Its pressure rises as its volume falls',
      'Its pressure falls as its volume falls',
      'Its pressure stays the same',
      'It turns into a liquid under the pressure',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'Squeezing the same gas into less space packs molecules closer, so they strike the walls more often.',
      'This reverses the gas law: shrinking the volume raises the pressure rather than lowering it.',
      'The amount of air is fixed, but that holds the product of pressure and volume steady, not the pressure.',
      'Hand pressure is nowhere near enough to liquefy air at room temperature.',
    ],
    explanation:
        'Squeezing the same amount of gas into a smaller space packs the molecules closer '
        'together, so they strike the walls more often and the pressure rises; pressure times '
        'volume stays constant when the temperature does not change. The mass of air does not '
        'change because none escapes, but that does not hold the pressure steady. Hand pressure '
        'is nowhere near enough to liquefy air at room temperature.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.physics'],
  ),
  Question(
    id: 'gs-x14',
    subtest: Subtest.gs,
    stem:
        'Nearly all weather on Earth occurs in which layer of the atmosphere?',
    choices: <String>[
      'Stratosphere',
      'Mesosphere',
      'Thermosphere',
      'Troposphere',
    ],
    answerIndex: 3,
    choiceNotes: <String>[
      'The stratosphere is dry and stable above the weather, which is why jets cruise there.',
      'The mesosphere is far too thin and cold to hold clouds and rain.',
      'The thermosphere is thinner still, so it cannot support weather at the surface.',
      'The lowest layer holds nearly all the air and water vapour, so clouds and storms form there.',
    ],
    explanation:
        'The troposphere is the lowest layer and holds most of the air and almost all of the '
        'water vapor, so clouds, rain, snow and storms all form there. The stratosphere above it '
        'is dry and stable, which is why jet aircraft cruise in it. The mesosphere and the '
        'thermosphere are far too thin to support the weather we see at the surface.',
    difficulty: Difficulty.easy,
    skills: <String>['gs.earth'],
  ),
  Question(
    id: 'gs-x15',
    subtest: Subtest.gs,
    stem: 'The daily rise and fall of the ocean tides is caused mainly by',
    choices: <String>[
      'Prevailing winds over the ocean',
      'The rotation of the Earth alone',
      'The gravitational pull of the Moon',
      'Melting ice near the poles',
    ],
    answerIndex: 2,
    choiceNotes: <String>[
      'Wind makes waves and pushes surface water, but it does not produce the twice-daily rhythm.',
      'Earth rotation carries coastlines under the tidal bulge, but it does not raise that bulge.',
      'The Moon pulls hardest on the water nearest it, and Earth turns beneath the resulting bulge.',
      'Melting ice raises average sea level over years, not twice a day.',
    ],
    explanation:
        'The Moon pulls hardest on the water on the side of the Earth nearest to it, raising '
        'a bulge, and the Earth turns beneath that bulge so most coastlines get two high tides a '
        'day. The Sun adds a weaker pull that makes the tidal range larger or smaller depending '
        'on how the Sun and Moon line up. Wind makes waves and melting ice raises sea level, but '
        'neither produces the daily rhythm.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.earth'],
  ),
  Question(
    id: 'gs-x16',
    subtest: Subtest.gs,
    stem: 'A lunar eclipse occurs when',
    choices: <String>[
      'The Moon passes into the shadow of the Earth',
      'The Moon passes between the Earth and the Sun',
      'The Earth passes into the shadow of the Moon',
      'The Sun passes between the Earth and the Moon',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'With Earth between Sun and Moon, the Moon slides into the shadow Earth casts, which happens at full moon.',
      'The Moon coming between Earth and Sun hides the Sun from viewers, which is a solar eclipse.',
      'Earth cannot pass into the shadow of the Moon, since the Moon is far smaller than Earth.',
      'The Sun never passes between Earth and the Moon; it stays put while the Moon orbits.',
    ],
    explanation:
        'At a lunar eclipse the Earth is between the Sun and the Moon, and the Moon moves '
        'into the cone of shadow the Earth casts into space, which can only happen at full moon. '
        'The second option describes a solar eclipse, where the Moon hides the Sun from viewers '
        'on Earth. Shadows always fall away from the Sun, so the Moon cannot cast a shadow onto '
        'the Earth that way.',
    difficulty: Difficulty.medium,
    skills: <String>['gs.earth'],
  ),
  Question(
    id: 'gs-x17',
    subtest: Subtest.gs,
    stem:
        'The wearing away of rock and soil and the carrying off of the loose material by '
        'water, wind or ice is called',
    choices: <String>['Deposition', 'Erosion', 'Compaction', 'Weathering'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Deposition is the end of the trip, where moving water or wind drops its load.',
      'Erosion loosens material and carries it away, as a river moves silt downstream.',
      'Compaction presses buried sediment into solid rock and moves nothing.',
      'Weathering breaks rock in place but leaves the pieces where they formed.',
    ],
    explanation:
        'Erosion both loosens material and moves it, as when a river carries silt hundreds of '
        'miles downstream. Weathering is the near miss: it breaks rock in place but leaves the '
        'pieces where they formed. Deposition is the opposite end of the trip, where the moving '
        'water or wind drops its load, and compaction presses buried sediment into solid rock.',
    difficulty: Difficulty.easy,
    skills: <String>['gs.earth'],
  ),
  Question(
    id: 'gs-x18',
    subtest: Subtest.gs,
    stem:
        'The Moon keeps the same face turned toward Earth at all times because',
    choices: <String>[
      'It rotates once during each orbit of Earth',
      'It does not rotate on its axis at all',
      'It rotates once every 24 hours',
      'Sunlight reaches only one side of it',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'One turn per orbit keeps the same hemisphere aimed at Earth while the far side faces away.',
      'A moon that never rotated would show every side to Earth during a single month.',
      'A 24-hour spin would also turn all sides toward us, since one orbit takes about 27 days.',
      'Sunlight reaches both halves of the Moon; the phases come from how much of the lit half we see.',
    ],
    explanation:
        'The Moon turns on its axis exactly once during each trip around the Earth, so one '
        'hemisphere stays aimed at us while the far side stays aimed away. A moon that never '
        'rotated would show every side to Earth during a single month, which is the usual '
        'misconception. A 24-hour spin would also turn all sides toward us, and sunlight reaches '
        'both halves of the Moon.',
    difficulty: Difficulty.hard,
    skills: <String>['gs.earth'],
  ),
];
