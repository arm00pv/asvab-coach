import '../models/lesson.dart';

/// Reinforcement lessons for the technical and spatial subtests.
const List<Lesson> lessonsB = <Lesson>[
  Lesson(
    skillId: 'pc.mainidea',
    title: 'The point, not the paint',
    hook: 'Almost every main idea item is a cover test: hide the passage and say what it was about in one breath.',
    whyItMatters: 'Paragraph Comprehension feeds Verbal Expression, which counts double in the AFQT, so four reading skills pay better than four skills anywhere else.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Read the question before the passage',
        'The stem tells you what to hunt. For a main idea item you are not hunting one sentence, you are hunting the umbrella that covers all of them. Read the stem, read the passage once, and keep asking which sentence the other sentences exist to support.',
        bullets: <String>[
          'The phrases main idea, mainly about and best title all mean the same job.',
          'The point often sits first or last, but in a short paragraph the load bearing sentence is frequently in the middle.',
          'A passage full of examples is proving something, and the point is the sentence being proved.',
          'If two choices both feel true, one of them is a detail. Delete detail answers first.',
        ],
      ),
      LessonSection(
        'The cover test',
        'When the choices look alike, cover the passage and state its point in your own words, one sentence, no examples. Then go back and pick the choice closest to your sentence. Your sentence is a filter, not the answer itself.',
        bullets: <String>[
          'One sentence, no numbers, no names. If your sentence needs a list, you are describing details.',
          'Match your sentence to the choice, not the choice to the passage.',
          'A main idea answer that names one example is too narrow, and one that is bigger than the passage is too broad.',
          'Words like all, always, never and every usually mark the too broad choice.',
        ],
      ),
      LessonSection(
        'Scope, the quiet killer',
        'Wrong main idea answers fail in three ways: too narrow, too broad, or true but not the point. Naming the failure makes elimination fast and calm instead of a coin flip.',
        bullets: <String>[
          'Too narrow: it repeats a supporting example, usually with a number lifted from the passage.',
          'Too broad: it drags in a topic the passage mentions in passing or never reaches at all.',
          'Right topic, wrong claim: it borrows the passage vocabulary but reverses the relationship the passage stated.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A worker who tightens bolts by feel is not being careful, only lucky. Field failures come from over tightened fasteners far more often than from loose ones. A torque wrench takes the guess out of the job: it signals the moment the fastener reaches the load the engineer specified. Skipping it saves two minutes and costs a rework. Which choice states the main idea?',
        steps: <String>[
          'Read the stem first, so I know I am hunting an umbrella and not a fact.',
          'Ask which sentence the others serve. The first is an attitude and the last is a consequence; the third, about the wrench signalling a specified load, is the claim both of them hang on.',
          'State it myself: a torque wrench turns tightening into a measured job instead of a guess.',
          'Delete any choice that is only about bolts by feel, because that is the example, not the point.',
        ],
        answer: 'A torque wrench replaces guesswork with the load the engineer specified.',
      ),
      WorkedExample(
        prompt: 'Reef systems are built by tiny animals that live in colonies. Each colony leaves behind a skeleton of calcium carbonate, and the next generation grows on top of it. That is why a reef is a record of its own history: every layer in the structure marks a span of years the colony survived. What is the passage mainly about?',
        steps: <String>[
          'The stem says mainly, so the answer must cover all three sentences.',
          'Sentence one is the builder, sentence two is the mechanism, and sentence three starts with that is why, which is a signpost pointing straight at the point.',
          'Phrase it myself: a reef grows upward in layers, so the structure records how long it has grown.',
          'A choice that only names the builder or the skeleton is a detail, because it does not cover the record described at the end.',
        ],
        answer: 'The layered growth of a reef records how long it has been growing.',
      ),
      WorkedExample(
        prompt: 'A hydraulic press can crush a bearing in seconds if it is set wrong, so the shop rule is that the operator set the press against a test block before every shift. The rule costs ninety seconds. A crushed bearing costs four hours and a new part. The block is not a formality; it is the cheapest insurance on the floor. Which choice states the main idea?',
        steps: <String>[
          'Ask what the whole passage is doing, not what the first sentence mentions.',
          'The passage weighs a ninety second cost against a four hour loss, which is an argument.',
          'The claim being argued is that the test block is cheap insurance, and the figures exist to support it.',
        ],
        answer: 'Setting the press against a test block is cheap insurance against a costly mistake.',
      ),
    ],
    quickRules: <String>[
      'Read the question, then the passage, then the question again.',
      'The point is the sentence the other sentences serve.',
      'A choice that repeats a number from the passage is almost certainly a detail.',
      'Write your own one line summary before you touch the answer choices.',
    ],
    pitfalls: <String>[
      'Picking the most interesting fact in the passage. It is a detail, so you choose a true statement and still miss the item.',
      'Choosing the broadest sounding answer because it feels safe. It usually names a topic the passage never develops, which is the too broad error.',
      'Skipping the sentence that begins with that is why or therefore, which is where short passages usually hide the main point.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'A hydraulic press can crush a bearing in seconds.',
        why: 'That is the detail that sets up the warning. The passage is arguing about the test block, not reporting on press speed.',
      ),
      CommonMistake(
        answer: 'A crushed bearing costs four hours and a new part.',
        why: 'The figure is evidence for the rule. A main idea states the claim the evidence serves, which is that the block pays for itself.',
      ),
    ],
  ),
  Lesson(
    skillId: 'pc.detail',
    title: 'Detail items: hunt, do not remember',
    hook: 'A stated detail is on the page. Your job is to find it, not to recall it.',
    whyItMatters: 'Detail items are the most answerable questions in Paragraph Comprehension, and Paragraph Comprehension counts double in the AFQT through Verbal Expression.',
    minutes: 7,
    sections: <LessonSection>[
      LessonSection(
        'Name your search term',
        'Read the stem and pick the one word you will hunt: a name, a number, a tool, an animal. Then run your eyes back through the passage looking only for that word or a close cousin of it. You are scanning a list, not re-reading for pleasure.',
        bullets: <String>[
          'Numbers are the easiest search terms, so use them whenever the stem gives one.',
          'The passage may use a synonym: if the stem says cost, hunt for price, fee or charge too.',
          'Synonym tolerant scanning beats slow line by line reading when the clock is running.',
          'Ten items in twenty two minutes means you cannot afford to read every passage twice.',
        ],
      ),
      LessonSection(
        'Read the whole sentence, not the word',
        'The moment your eye lands on the term, read the entire sentence that holds it plus the sentence after. Detail items are usually lost by answering from a fragment, because the passage often names the old part and the new part in the same breath.',
        bullets: <String>[
          'The answer frequently sits in the same sentence as the term but at the far end of it.',
          'Watch for before and after: a passage will describe an old method and a new one together.',
          'A date or a quantity in a neighbouring sentence may belong to a different item in the passage.',
          'If two choices are both mentioned, the one that answers the exact question asked wins.',
        ],
      ),
      LessonSection(
        'Match wording, then commit',
        'Correct detail answers restate the passage closely, and the writers paraphrase rather than copy. When a choice adds a cause, a comparison or a number the passage never gave, it is wrong no matter how sensible it sounds.',
        bullets: <String>[
          'A choice with a stronger word than the passage, such as most or always, is a trap.',
          'Once a choice matches a sentence you found, commit and move. Second guessing detail items is how people run out of time.',
          'If nothing matches, you scanned the wrong paragraph, so go back to the term rather than to the whole passage.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'The shop keeps three torque wrenches, each in its own case. The quarter inch drive tool is for small fasteners and is checked every ninety days. The half inch drive tool handles lug nuts and is calibrated twice a year because it sees the heaviest use. The three quarter inch tool is reserved for suspension work. Which wrench is checked most often?',
        steps: <String>[
          'Search term: checked. The stem asks which is checked most often, so I hunt the calibration sentences.',
          'Read both whole sentences, not the fragment. The half inch tool is done twice a year, and the quarter inch tool is checked every ninety days.',
          'Compare honestly: ninety days divides a year into four, so four checks beat two.',
          'Answer the question asked, which is the most often, not the one that works hardest.',
        ],
        answer: 'The quarter inch drive tool, checked every ninety days.',
      ),
      WorkedExample(
        prompt: 'The old radiator used a brass core and was repaired by soldering. The new radiator uses an aluminium core and is repaired by brazing, because the aluminium needs a hotter joining process than solder can supply. Why is the new radiator brazed rather than soldered?',
        steps: <String>[
          'Search: brazed. It appears in the last sentence attached to a because.',
          'A because clause in the passage is almost always the answer to a why question, so read it whole.',
          'Solder cannot reach the temperature the aluminium join needs, and brazing supplies it.',
          'Choices claiming aluminium is cheaper or lighter are inventions, because the passage never compares cost or weight.',
        ],
        answer: 'Brazing supplies a hotter process than solder can deliver.',
      ),
      WorkedExample(
        prompt: 'The shop holds three grades of hydraulic oil. The light grade serves the press and is changed every 250 hours. The medium grade serves the forklift and runs 400 hours between changes. The heavy grade fills the crane reservoir and is changed once a year, at the annual inspection. Which grade is changed on a calendar interval rather than on the hour meter?',
        steps: <String>[
          'The question names the distinction: hours on a meter against time on a calendar.',
          'Scan for the two hour figures: 250 and 400 belong to the press and the forklift.',
          'The heavy grade is changed once a year, at the inspection, so it is the calendar one.',
        ],
        answer: 'The heavy grade in the crane reservoir.',
      ),
    ],
    quickRules: <String>[
      'Hunt a search term first and never try to memorise the passage.',
      'Read the full sentence holding the match, plus the one after it.',
      'Paraphrase is normal, new information is fatal.',
      'A stated detail is answerable from the text alone, so refusing to use outside knowledge is the whole skill.',
    ],
    pitfalls: <String>[
      'Answering from half a sentence, which produces the choice that fits the first clause and ignores the correction in the second.',
      'Picking a true sounding choice the passage never states, because the answer is on the page and outside knowledge is a wrong answer wearing good manners.',
      'Re-reading the whole passage instead of rescanning for the term, which burns a minute a question in a twenty two minute section.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'The light grade, because 250 hours is the shortest interval.',
        why: 'The question asks which grade is set by the calendar. 250 hours is an hour meter figure, however short it is.',
      ),
      CommonMistake(
        answer: 'The grade in the largest machine, the crane.',
        why: 'The answer is not the crane because of its size. The heavy grade is the calendar one because it is changed once a year at the inspection.',
      ),
    ],
  ),
  Lesson(
    skillId: 'pc.inference',
    title: 'Inference: one step, no more',
    hook: 'An inference is what the passage forces you to believe, not what it lets you imagine.',
    whyItMatters: 'Inference items are where reading scores usually leak away, and Paragraph Comprehension counts double in the AFQT through Verbal Expression.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Find the evidence before you read the choices',
        'Treat the stem as a question about one part of the passage. Locate the sentence the question hangs on and state what it implies in plain words before you look at a single answer. Choices are built to feel right, so reading them early hands them the power.',
        bullets: <String>[
          'There is usually a because, so, or which means nearby that points at the logic.',
          'Keep your own sentence cautious: it may, it must, it suggests. Nothing absolute yet.',
          'If you cannot point at the sentence, you are guessing rather than inferring.',
          'Two step inferences are wrong even when they are true, because the passage never took the second step for you.',
        ],
      ),
      LessonSection(
        'The three ways wrong answers fail',
        'Incorrect inference choices fail predictably. Spot the failure instead of arguing about plausibility.',
        bullets: <String>[
          'Too far: the conclusion needs one more fact the passage never supplied.',
          'Reversal: it flips cause and effect, or swaps which of two groups is larger.',
          'Outside world: it is true in real life but not established here.',
        ],
      ),
      LessonSection(
        'Cautious wording wins',
        'Test writers reward hedged answers. A choice that says some, often or tends to is far more likely to be supportable than one that says all, never or proves.',
        bullets: <String>[
          'The most cautious choice that still answers the question is usually correct.',
          'Do not pick a choice because it is the only one you understand; pick the one the evidence permits.',
          'When two choices survive, ask which one the passage could survive cross examination on.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'When the shop switched from hand tools to a hydraulic press, fitting bearings that used to take two hours began to finish in fifteen minutes. Overtime on that bench disappeared within a month, and the press rarely needed the maintenance the shop had budgeted for. What can you infer about the cost of that bench before the press arrived?',
        steps: <String>[
          'Evidence sentence: overtime on that bench disappeared within a month.',
          'Plain statement of the implication: the bench was regularly working overtime, and that overtime was being paid for.',
          'Second piece: if overtime disappeared, that spending was a standing cost rather than a one off surprise.',
          'Reject any choice claiming the shop was losing money overall, because the passage never says that.',
        ],
        answer: 'Overtime on that bench was an expected, regular cost.',
      ),
      WorkedExample(
        prompt: 'A chain is only as strong as its weakest link, and inspection records show that most field failures of this hoist happen at the swivel rather than anywhere along the chain body. What is the most reasonable inference about where an inspector should look first?',
        steps: <String>[
          'Evidence: most field failures happen at the swivel.',
          'One step: if that is where breaks happen, that is where a defect is most likely to be found before it breaks.',
          'Stay cautious: most likely first, not the only place worth checking.',
          'Reject the choice saying the chain body never fails, which turns a most into a never.',
        ],
        answer: 'At the swivel, because that is where failures concentrate.',
      ),
      WorkedExample(
        prompt: 'The shop logs every torque wrench calibration. In the eighteen months since the log began, no wrench has drifted more than two percent, and every failed fastener trace has landed on a bolt that was tightened by hand. What is the most reasonable inference?',
        steps: <String>[
          'Notice where the evidence points twice: the wrenches held, the hand work failed.',
          'Take one step from that: the failures come from hand tightening rather than from wrench drift.',
          'Stop there, and reject anything about training budgets or new tools, which the log cannot show.',
        ],
        answer: 'Hand tightening, not wrench drift, is where the fastener failures come from.',
      ),
    ],
    quickRules: <String>[
      'Locate the evidence sentence first and read the choices second.',
      'One step beyond the text, never two.',
      'Cautious wording beats confident wording.',
      'True in real life is not the same as supported by this passage.',
    ],
    pitfalls: <String>[
      'Choosing the most dramatic conclusion. It usually needs a second step and it usually flips a cause, which is a double failure.',
      'Picking a real world fact that never appears in the passage, which is a correct statement answering the wrong question.',
      'Letting only may or tends to talk you out of the right answer because it sounds weak; that weak wording is how the passage protects itself.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'Every wrench in the shop is brand new.',
        why: 'The log shows that drift stayed small, not that the tools are new. Nothing in the passage mentions their age.',
      ),
      CommonMistake(
        answer: 'Hand tightening should be banned in the shop.',
        why: 'That is a policy decision, two steps past the evidence. An inference states what the evidence implies, not what should be done about it.',
      ),
    ],
  ),
  Lesson(
    skillId: 'pc.purpose',
    title: 'Why did the author bother',
    hook: 'Every passage had a job: to explain, to persuade, to narrate or to instruct. Name the job and the item collapses.',
    whyItMatters: 'Purpose and tone items are short, frequent and quick points, and Paragraph Comprehension counts double in the AFQT through Verbal Expression.',
    minutes: 7,
    sections: <LessonSection>[
      LessonSection(
        'Classify the passage in five seconds',
        'Purpose questions are answered at the level of the whole passage, so classify before you analyse. The verbs the author chooses are the tell.',
        bullets: <String>[
          'Explain: is, works, causes, consists. The author wants you to understand a mechanism.',
          'Persuade: should, must, ought, needlessly. The author wants agreement or action.',
          'Narrate: happened, then, after. The author wants the sequence.',
          'Instruct: first, then, use, avoid. The author wants you to do something.',
        ],
      ),
      LessonSection(
        'Hunt tone in the adjectives',
        'Tone lives in word choice, not in topic. Two passages about the same machine can be admiring, alarmed or neutral, and purpose items often pair the purpose with the attitude. Read for loaded words and mark them.',
        bullets: <String>[
          'Words like careless, reckless and shoddy mark a critical tone.',
          'Words like remarkable, careful and proved mark an approving tone.',
          'A passage of nothing but measurements and dates is usually neutral and informative.',
          'Irony hides in a compliment that the next clause takes back.',
        ],
      ),
      LessonSection(
        'Match the purpose to the audience',
        'Ask who the passage was written for. A safety bulletin and a sales brochure can describe the same ladder with the same facts and opposite purposes. The final sentence usually gives it away.',
        bullets: <String>[
          'A closing warning or instruction points at an instructional purpose.',
          'A closing recommendation points at persuasion.',
          'A closing summary with no request attached points at explanation.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'Three times this quarter, crews have set ladders against live conduit. A fibreglass ladder would not have helped, because the hazard is the contact point rather than the rail. Before any ladder goes up near a panel, de energise it and lock it out. What is the purpose of this passage?',
        steps: <String>[
          'Classify: the closing sentence is an instruction, and the middle sentences explain why it is needed.',
          'Scan for loaded words. Counting three incidents is a warning shot, and the passage never hedges.',
          'Audience: crews who set ladders, so this is a safety direction rather than a general explanation.',
          'Therefore the purpose is to get one specific action taken, with reasons attached.',
        ],
        answer: 'To persuade crews to de energise and lock out before using a ladder near a panel.',
      ),
      WorkedExample(
        prompt: 'A capstan winch multiplies force by wrapping the rope around a powered drum, and a skilled operator can hold a heavy load with light hand pressure. The drum surface matters more than the motor: a worn drum slips under load, which is why the surface is inspected before every shift. What is the purpose of the second sentence?',
        steps: <String>[
          'The stem targets one sentence rather than the whole passage, so classify that sentence alone.',
          'It states a fact and then supplies a because, so it explains a mechanism and a practice.',
          'Its effect on the reader is understanding rather than action, so persuasive language is absent.',
          'Answer at the sentence level, not the passage level, because the stem asked for the sentence.',
        ],
        answer: 'To explain why the drum surface is inspected every shift.',
      ),
      WorkedExample(
        prompt: 'A new bench procedure has halved the time to fit a bearing, but it has also doubled the scrap rate, and the parts it wastes cost more than the hours it saves. Before the procedure is written into the shop order, both sides of that sum need another quarter of figures. What is the purpose of the last sentence?',
        steps: <String>[
          'The passage puts a saving against a cost, which is a weighing up.',
          'The last sentence draws the conclusion from that weighing: wait for the rest of the figures.',
          'A sentence that tells the reader what to do before deciding is a recommendation.',
        ],
        answer: 'To recommend delaying the decision until the cost of the procedure is measured.',
      ),
    ],
    quickRules: <String>[
      'Classify first: explain, persuade, narrate or instruct.',
      'Tone is in the adjectives, never in the topic.',
      'Read the last sentence, because the request usually sits there.',
      'Answer at the level asked: whole passage or named sentence.',
    ],
    pitfalls: <String>[
      'Answering with the topic instead of the purpose, which gives you a choice that says what the passage is about rather than what it does.',
      'Missing a persuasive purpose because the passage sounds calm and factual; calm is a persuasive technique, and a recommendation is still persuasion.',
      'Reading only the first sentence and guessing the job, which turns a cautionary bulletin into a neutral explanation.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'To describe the new procedure step by step.',
        why: 'The procedure is described only enough to weigh it. The last sentence asks for time, which is a recommendation and not a description.',
      ),
      CommonMistake(
        answer: 'To state that the new procedure is faster.',
        why: 'The speed is in the first sentence. The last sentence is about when to decide, which is a different job.',
      ),
    ],
  ),
  Lesson(
    skillId: 'gs.biology',
    title: 'Biology: cells, energy, inheritance',
    hook: 'Three ideas cover most life science items: what a cell part does, where the energy came from, and which trait is dominant.',
    whyItMatters: 'General Science does not feed your AFQT, but it sits inside the line scores that decide which jobs you can be slotted into at MEPS.',
    minutes: 9,
    sections: <LessonSection>[
      LessonSection(
        'Cell parts, by job',
        'General Science rarely asks you to label a diagram. It asks which part does a job, so learn one job per part and you are covered.',
        bullets: <String>[
          'The nucleus holds the DNA and acts as the control centre of the cell.',
          'Mitochondria release energy from food, which is why muscle cells are dense with them.',
          'Ribosomes build protein, and the cell membrane controls what crosses in and out.',
          'Chloroplasts capture light, and a plant cell wall is something an animal cell does not have.',
        ],
      ),
      LessonSection(
        'Energy goes one way',
        'Photosynthesis stores energy from sunlight in sugar, and respiration releases it again. Neither belongs only to plants or only to animals, and the exam likes that exact confusion.',
        bullets: <String>[
          'Photosynthesis: carbon dioxide plus water plus light becomes glucose plus oxygen.',
          'Respiration: glucose plus oxygen becomes carbon dioxide, water and usable energy.',
          'Plants respire as well as photosynthesise, so a plant consumes oxygen around the clock.',
          'A producer makes its own food, a consumer eats something else, and a decomposer breaks down dead material.',
        ],
      ),
      LessonSection(
        'Inheritance in one square',
        'For one trait with a dominant and a recessive allele, a Punnett square answers everything the exam can ask. Write the parent alleles along the edges and fill four boxes.',
        bullets: <String>[
          'Dominant and recessive describe which allele shows, not which one is better or stronger.',
          'A recessive trait shows only when both alleles are recessive.',
          'Two mixed parents give three dominant looking offspring to one recessive out of four boxes.',
          'Human body cells carry 46 chromosomes in 23 pairs, and each parent contributes one chromosome to each pair.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'Two pea plants that are each mixed for tallness, one tall allele and one short allele, are crossed. What fraction of the offspring are expected to be short?',
        steps: <String>[
          'Set the square. Each parent can pass either T or t, so the four boxes read TT, Tt, tT and tt.',
          'Short needs two recessive alleles, and only the tt box supplies them.',
          'One box out of four is one quarter. The other three boxes are tall because a single T shows.',
        ],
        answer: 'One quarter, or 25 percent, are expected to be short.',
      ),
      WorkedExample(
        prompt: 'A sample of muscle tissue and a sample of skin tissue are compared under the microscope. The muscle sample shows far more of one organelle. Which one, and why?',
        steps: <String>[
          'Muscle contraction is constant work, so the tissue needs a large and steady supply of usable energy.',
          'The organelle that releases energy from food is the mitochondrion.',
          'So the muscle sample shows far more mitochondria, while the skin sample manages with fewer.',
        ],
        answer:
            'More mitochondria, because muscle work demands energy on demand.',
      ),
      WorkedExample(
        prompt: 'A plant is left in a dark cupboard for three days. The starch in its leaves falls to almost nothing and it stops growing, though it recovers when it is returned to a window. Why did the starch disappear?',
        steps: <String>[
          'Starch is built from the sugar that photosynthesis makes, and photosynthesis needs light.',
          'With no light there is no new sugar, so the plant draws on the starch it stored.',
          'Recovery in the window proves the machinery was never destroyed, only starved of light.',
        ],
        answer: 'With no light there was no photosynthesis, so the plant used up its stored starch.',
      ),
    ],
    quickRules: <String>[
      'One job per organelle: nucleus controls, mitochondrion releases energy, ribosome builds protein.',
      'Photosynthesis stores energy and respiration releases it.',
      'Dominant shows, recessive hides, and a recessive trait needs two recessive alleles.',
      'Plants respire too, day and night.',
    ],
    pitfalls: <String>[
      'Claiming plants only photosynthesise, which makes you choose the answer that a plant releases oxygen only by day; it respires continuously.',
      'Treating dominant as meaning more common, which flips a correct allele count into a wrong one.',
      'Reading the three tall boxes as three halves of the total, which produces the two in three answer that appears in nearly every square item.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer:
            'The plant stopped respiring for lack of oxygen in the cupboard.',
        why: 'Respiration carries on in the dark, and it is the process that consumes the starch. What stops is photosynthesis, which needs light.',
      ),
      CommonMistake(
        answer: 'The darkness destroyed the chlorophyll for good.',
        why: 'The plant recovered at the window, so nothing was destroyed permanently. The pigment was simply given nothing to work with.',
      ),
    ],
  ),
  Lesson(
    skillId: 'gs.chemistry',
    title: 'Chemistry: atoms, bonds, reactions',
    hook: 'Count protons, then check both sides of the arrow, and most chemistry items fall in one line.',
    whyItMatters: 'Chemistry is a steady slice of the General Science subtest, which feeds line scores even though it does not feed the AFQT.',
    minutes: 9,
    sections: <LessonSection>[
      LessonSection(
        'The atom in three numbers',
        'Every atom question is answered by three quantities: protons, neutrons and electrons. Get the definitions straight once and they never change.',
        bullets: <String>[
          'The atomic number is the proton count, and it is what makes an element that element.',
          'The mass number is protons plus neutrons, so neutrons equal the mass number minus the atomic number.',
          'A neutral atom has as many electrons as protons, and an ion has gained or lost electrons.',
          'Electrons occupy shells, and the outer shell drives how the element reacts.',
        ],
      ),
      LessonSection(
        'Bonds and the periodic table in one habit',
        'Find where the two elements sit. Metals live on the left, nonmetals on the right, and that split answers most bond questions.',
        bullets: <String>[
          'A metal plus a nonmetal usually means ionic: electrons are transferred and the solid conducts when melted or dissolved.',
          'Two nonmetals usually mean covalent: electrons are shared and the result is often a gas or a liquid at room temperature.',
          'Column one metals react hardest because they give up a single electron.',
          'Noble gases already have full outer shells, so they barely react at all.',
        ],
      ),
      LessonSection(
        'Balance the arrow, then read the pH',
        'Mass is conserved. The number of each kind of atom must be identical on both sides, and that single check answers the balancing items.',
        bullets: <String>[
          'A coefficient multiplies every atom in the formula after it, while a subscript multiplies only the atom it follows.',
          'A pH below 7 is acidic, above 7 is basic, and 7 is neutral.',
          'Each whole step on the pH scale is ten times the hydrogen ion concentration, so 4 is ten times more acidic than 5.',
          'Neutralisation forms water plus a salt, which is why an acid and a base together lose their sharp behaviour.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'An atom of carbon has 6 protons and a mass number of 12. How many neutrons and how many electrons does the neutral atom carry?',
        steps: <String>[
          'Neutrons are the mass number minus the atomic number: 12 minus 6 is 6.',
          'A neutral atom matches its electron count to its proton count, so 6 electrons.',
        ],
        answer: '6 neutrons and 6 electrons.',
      ),
      WorkedExample(
        prompt: 'Balance this equation: Fe plus O2 gives Fe2O3.',
        steps: <String>[
          'Count as it stands: one iron and two oxygen on the left, two iron and three oxygen on the right.',
          'Six is the smallest number both oxygen counts fit, so work from there: three O2 molecules give six oxygen.',
          'Three O2 also needs two Fe2O3 on the right, which uses four iron, so put 4 in front of Fe.',
          'Check both sides: iron 4 and 4, oxygen 6 and 6.',
        ],
        answer: '4Fe plus 3O2 gives 2Fe2O3.',
      ),
      WorkedExample(
        prompt: 'Twelve grams of carbon burns completely in thirty-two grams of oxygen, leaving nothing but carbon dioxide. What mass of carbon dioxide is formed?',
        steps: <String>[
          'In a closed reaction no mass is created or lost, it only changes partners.',
          'Every gram of carbon and of oxygen ends up in the product.',
          'Add: 12 + 32 = 44 grams.',
        ],
        answer: '44 grams of carbon dioxide',
      ),
    ],
    quickRules: <String>[
      'Atomic number is protons, and neutrons are mass number minus atomic number.',
      'Metal plus nonmetal is ionic, two nonmetals is covalent.',
      'Count every kind of atom on both sides before you touch a coefficient.',
      'Below 7 acid, above 7 base, 7 neutral.',
    ],
    pitfalls: <String>[
      'Confusing the mass number with the atomic number, which doubles the proton count and sends you to the wrong element entirely.',
      'Balancing by editing a subscript instead of a coefficient, which turns water into hydrogen peroxide and produces an equation nobody asked for.',
      'Calling a strong base a strong acid because the number is large, which reverses every pH item on the test.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: '20 grams, subtracting the smaller number from the larger.',
        why: 'The reactants combine rather than cancel, and 12 + 32 = 44 grams of carbon dioxide leaves the reaction.',
      ),
      CommonMistake(
        answer: 'A mass between 12 and 32 grams, depending on the flame.',
        why: 'Mass conservation does not depend on how fast the burn is. Every gram of the two reactants appears in the product, so it is 44 grams.',
      ),
    ],
  ),
  Lesson(
    skillId: 'gs.physics',
    title: 'Physics: force, energy, waves',
    hook: 'Four formulas and three laws answer nearly every physics item you will see.',
    whyItMatters: 'Physics shares General Science with three other topics, and force and energy items are the most formulaic points available in the section.',
    minutes: 10,
    sections: <LessonSection>[
      LessonSection(
        'Motion and force',
        'The three laws of motion are not philosophy on this test. They are three sentences that each predict an outcome.',
        bullets: <String>[
          'Force equals mass times acceleration, so doubling the mass halves the acceleration for the same push.',
          'An object at rest stays at rest until a net force acts, and that property is inertia.',
          'Every action has an equal and opposite reaction, which is why a rifle kicks into your shoulder.',
          'Weight is a force and mass is an amount of matter, so weight changes with gravity while mass does not.',
        ],
      ),
      LessonSection(
        'Energy and work',
        'Work has a strict definition on this test: a force moving something through a distance. That definition settles most of the trick items.',
        bullets: <String>[
          'Work equals force times distance in the direction of the force.',
          'Holding a heavy box still does no work on it in the physics sense, however tired your arms get.',
          'Lifting a mass stores gravitational potential energy equal to mass times gravity times height.',
          'Friction turns mechanical energy into heat, which is why brakes get hot and fade when they overheat.',
        ],
      ),
      LessonSection(
        'Waves and current',
        'Wave items are one multiplication, and electrical items are one definition.',
        bullets: <String>[
          'Wave speed equals frequency times wavelength, so a shorter wavelength at the same speed means a higher frequency.',
          'Light travels about 300,000 kilometres per second in a vacuum, far faster than sound.',
          'Sound needs a medium, so it cannot cross a vacuum while light can.',
          'Current is the flow of charge and voltage is the push that drives it.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A 10 kilogram crate is pushed across a floor with a net force of 20 newtons. What is its acceleration?',
        steps: <String>[
          'Rearrange force equals mass times acceleration into acceleration equals force divided by mass.',
          '20 newtons divided by 10 kilograms is 2 metres per second squared.',
          'Check the units: newtons over kilograms gives metres per second squared, which is acceleration.',
        ],
        answer: '2 metres per second squared.',
      ),
      WorkedExample(
        prompt: 'A 50 newton force moves a crate 4 metres in the direction of the push. How much work is done, and where does that energy go when friction stops the crate?',
        steps: <String>[
          'Work equals force times distance: 50 newtons times 4 metres is 200 joules.',
          'No work is counted in the vertical direction here, because the crate did not rise.',
          'When friction stops the crate, the 200 joules leaves the motion and reappears as heat in the crate and the floor.',
        ],
        answer: '200 joules, which friction converts to heat.',
      ),
      WorkedExample(
        prompt: 'A radio station broadcasts at 100 megahertz. Radio waves travel at about 300,000 kilometres per second. What is the wavelength of the signal?',
        steps: <String>[
          'The rule is speed equals frequency times wavelength, so wavelength is speed divided by frequency.',
          'Put the speed into metres: 300,000 kilometres per second is 300,000,000 metres per second.',
          'Write the frequency as a number: 100 megahertz is 100,000,000 cycles per second.',
          'Divide: 300,000,000 / 100,000,000 = 3 metres.',
        ],
        answer: 'About 3 metres',
      ),
    ],
    quickRules: <String>[
      'Force equals mass times acceleration, and work equals force times distance.',
      'Weight is a force, mass is not.',
      'Energy changes form and never vanishes.',
      'Wave speed equals frequency times wavelength.',
    ],
    pitfalls: <String>[
      'Reporting weight in kilograms, which makes a force answer wrong by a factor of gravity.',
      'Counting the force you use to hold a crate against a wall as work, which produces a large joule figure for something that never moved.',
      'Multiplying frequency by wavelength but treating a shorter wavelength as a lower frequency, which reverses the answer.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'About 300 metres, multiplying the speed by the frequency.',
        why: 'Speed and frequency are divided, not multiplied. Multiplying them produces a number that is not a length at all.',
      ),
      CommonMistake(
        answer:
            'About 3 kilometres, leaving the speed in kilometres per second.',
        why: 'The units have to agree before dividing. In metres per second the answer is 3 metres, which is 0.003 kilometres.',
      ),
    ],
  ),
  Lesson(
    skillId: 'gs.earth',
    title: 'Earth science: rocks, plates, sky',
    hook: 'Most earth science items ask one of three things: what made this rock, what the plates are doing, or why the sky looks like that.',
    whyItMatters: 'Earth and space science is one quarter of General Science, and its items are the most predictable in the section.',
    minutes: 9,
    sections: <LessonSection>[
      LessonSection(
        'The rock cycle in three moves',
        'Three rock types, three origins. Learn the origin and you can classify any sample the exam describes.',
        bullets: <String>[
          'Igneous rock forms when molten material cools and hardens, and slow cooling makes larger crystals.',
          'Sedimentary rock forms from layers of sediment pressed and cemented, and it is the type that holds fossils.',
          'Metamorphic rock forms when existing rock is changed by heat and pressure without melting.',
          'Melting any rock restarts the cycle, which is why the cycle has no first step.',
        ],
      ),
      LessonSection(
        'Plates explain the map',
        'Every earthquake and volcano belt on a map is a plate boundary, so the boundary type tells you the feature.',
        bullets: <String>[
          'Plates that pull apart build ridges and new crust.',
          'Plates that collide build mountains, trenches and volcanoes.',
          'Plates that slide past each other build faults and shallow earthquakes rather than volcanoes.',
          'Earth has a solid inner core, a liquid outer core, a mantle and a thin crust, and the slowly flowing mantle drags the plates.',
        ],
      ),
      LessonSection(
        'Sky and seasons',
        'The sky questions are geometry: where is each body, and at what angle is the ground.',
        bullets: <String>[
          'Seasons come from the tilt of the axis, not from distance, so the northern hemisphere leans sunward in June and away in December.',
          'The moon completes its full cycle of phases in about a month.',
          'A solar eclipse needs the moon between Earth and the sun, and a lunar eclipse needs Earth between the sun and the moon.',
          'Weather happens in the troposphere, the lowest layer, where most of the water vapour sits.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A rock sample shows distinct horizontal layers and contains a fossil shell. What type of rock is it, and what does the shell tell you?',
        steps: <String>[
          'Layers of sediment cemented together are the signature of sedimentary rock.',
          'Heat and pressure would have destroyed the layering and usually the shell, so metamorphic is out.',
          'A shell means the material was laid down in water, so the area was once under water.',
        ],
        answer: 'Sedimentary rock, laid down underwater.',
      ),
      WorkedExample(
        prompt: 'A region has frequent shallow earthquakes and a line of volcanoes just inland from a deep ocean trench. What are the plates doing?',
        steps: <String>[
          'A trench is where one plate dives beneath another, so this is a collision with subduction.',
          'Subduction carries water and rock down, melts it, and pushes magma up behind the trench, which builds the volcanoes.',
          'Shallow earthquakes on that contact fit a sticking, sliding boundary rather than a ridge pulling apart.',
        ],
        answer: 'One plate is diving beneath another, and the melting feeds the volcanoes inland.',
      ),
      WorkedExample(
        prompt: 'Fossils of the same shallow water shellfish are found in rock on two continents that an ocean now separates. What does that most reasonably tell you?',
        steps: <String>[
          'Establish what the animals needed: shallow water on a sea floor, not an open ocean crossing.',
          'The same species on two coasts is easier to explain if the coasts were once one piece of land.',
          'The ocean then opened after the shellfish were buried, which is why the fossils now sit far apart.',
        ],
        answer: 'The two continents were joined by shallow water when those animals were alive.',
      ),
    ],
    quickRules: <String>[
      'Igneous cools, sedimentary layers, metamorphic cooks without melting.',
      'Tilt causes seasons, not distance from the sun.',
      'Ridges mean pulling apart and trenches mean one plate going under.',
      'Fossils are found in sedimentary rock.',
    ],
    pitfalls: <String>[
      'Blaming summer on being closer to the sun, when the northern hemisphere is actually nearer the sun during its winter.',
      'Calling any coarse grained rock igneous, which misses a banded metamorphic rock that the item described deliberately.',
      'Putting volcanoes at a sliding boundary, which sends you to the fault answer when the trench should have pointed at subduction.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'The shellfish swam across the ocean.',
        why: 'These animals lived on a shallow sea floor, which rules out a deep water crossing. Joined land is the simpler explanation.',
      ),
      CommonMistake(
        answer: 'The ocean used to be shallow enough to walk across.',
        why: 'A shallower ocean still leaves two separate coasts. Matching fossils on both sides point to one piece of land that later split.',
      ),
    ],
  ),
  Lesson(
    skillId: 'ei.ohms',
    title: 'Ohm law and power, three letters at a time',
    hook: 'One triangle gives you voltage, current and resistance, and a second gives you watts.',
    whyItMatters: 'Electronics Information is a formula section, and Ohm law items are the fastest arithmetic points on the whole test.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'The first triangle',
        'Voltage, current and resistance are locked together. Two of them give you the third, always.',
        bullets: <String>[
          'Voltage equals current times resistance, written V equals I R.',
          'Current equals voltage divided by resistance, so a fixed voltage across a larger resistance gives less current.',
          'Resistance equals voltage divided by current.',
          'The unit tells you what you divided: volts over ohms is amperes, and volts over amperes is ohms.',
        ],
      ),
      LessonSection(
        'Power is the second triangle',
        'Power is the rate of energy use, and it has three interchangeable forms. Pick the one your two known quantities fit.',
        bullets: <String>[
          'Power equals voltage times current, so watts are volts times amperes.',
          'Substituting gives power equals current squared times resistance, and also voltage squared divided by resistance.',
          'A lamp marked 120 volts and 60 watts draws half an ampere at that voltage.',
          'Heat in a resistor rises with the square of the current, so doubling current can overheat a wire four times over.',
        ],
      ),
      LessonSection(
        'Work the item backwards from the unit',
        'Before any arithmetic, write down the two quantities you were given with their units and the unit the question wants. The unit decides the operation.',
        bullets: <String>[
          'An answer wanted in amperes means you divide volts by ohms.',
          'An answer wanted in ohms with watts given means you reach for voltage squared over power.',
          'Estimate first: if the answer should be a few amperes and you get hundreds, a decimal has moved.',
          'Convert milliamperes to amperes before multiplying, so 20 milliamperes becomes 0.020.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A 12 volt battery is connected across a 4 ohm resistor. What current flows, and how much power does the resistor dissipate?',
        steps: <String>[
          'Current is voltage divided by resistance: 12 divided by 4 is 3 amperes.',
          'Power is voltage times current: 12 times 3 is 36 watts.',
          'Check with the other power form: 3 squared is 9, and 9 times 4 ohms is 36 watts, which agrees.',
        ],
        answer: '3 amperes and 36 watts.',
      ),
      WorkedExample(
        prompt: 'A lamp is marked 120 volts and 60 watts. What current does it draw, and what is its resistance?',
        steps: <String>[
          'Current is power divided by voltage: 60 divided by 120 is 0.5 amperes.',
          'Resistance is voltage divided by current: 120 divided by 0.5 is 240 ohms.',
        ],
        answer: '0.5 amperes and 240 ohms.',
      ),
      WorkedExample(
        prompt: 'A heater draws 8 amperes from a 120 volt circuit. What is its resistance, and how much power does it use?',
        steps: <String>[
          'Resistance comes from the pair you know: R = V / I.',
          'Divide: 120 / 8 = 15 ohms.',
          'Power is volts times amperes: 120 x 8 = 960 watts.',
        ],
        answer: '15 ohms and 960 watts',
      ),
    ],
    quickRules: <String>[
      'V equals I R, and the other two forms are just rearrangements.',
      'P equals V I, and you substitute for whichever quantity you were not given.',
      'Watts are always volts times amps.',
      'Doubling the current quadruples the heat in a resistor.',
    ],
    pitfalls: <String>[
      'Multiplying volts by ohms, which produces a resistance answer with a nonsense unit and a number many times too large.',
      'Treating a rating as a measurement, so a 60 watt lamp gets recorded as drawing 60 amperes from a 120 volt supply.',
      'Skipping the milliampere conversion, which turns 20 milliamperes into 20 amperes and inflates the wattage a thousandfold.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: '0.067 ohms, dividing the amperes by the volts.',
        why: 'Resistance is volts over amperes: 120 / 8 = 15 ohms. Dividing the other way gives the reciprocal of resistance.',
      ),
      CommonMistake(
        answer: '960 ohms, reporting the wattage as a resistance.',
        why: 'The number is right and the unit is wrong. 960 is watts; the resistance is 15 ohms, and the unit label tells you which is which.',
      ),
    ],
  ),
  Lesson(
    skillId: 'ei.circuits',
    title: 'Series and parallel, without the fog',
    hook: 'Series shares one current and splits the voltage, while parallel shares one voltage and splits the current.',
    whyItMatters: 'Circuit items are the most reliable block in Electronics Information, and every one of them is decided by arrangement plus one formula.',
    minutes: 9,
    sections: <LessonSection>[
      LessonSection(
        'Series: one path',
        'In a series circuit the components sit on a single path, so the same current must pass through every one of them.',
        bullets: <String>[
          'Resistances add: three 2 ohm resistors in series make 6 ohms.',
          'The current is identical everywhere in the loop.',
          'Voltage divides in proportion to resistance, so the largest resistor takes the largest share.',
          'Break the path anywhere and the entire circuit stops, which is why old light strings went dark all at once.',
        ],
      ),
      LessonSection(
        'Parallel: one voltage, many branches',
        'In a parallel circuit every branch is connected across the same two points, so every branch sees the full source voltage.',
        bullets: <String>[
          'The current divides between branches, and the smallest resistance takes the largest share.',
          'The equivalent resistance is smaller than the smallest branch, because the reciprocal sum is dominated by small resistances.',
          'Two equal resistors in parallel give half of one of them, and three equal resistors give a third.',
          'A break in one branch leaves the others working, which is why buildings are wired in parallel.',
        ],
      ),
      LessonSection(
        'Two checks that catch almost everything',
        'Before you commit an answer, run the arithmetic backwards. These two checks catch the majority of circuit errors in one line each.',
        bullets: <String>[
          'In series, the individual voltage drops must add up to the source voltage.',
          'In parallel, the branch currents must add up to the total current drawn from the source.',
          'Total power is the sum of the branch powers in either arrangement.',
          'Adding a parallel branch always lowers total resistance and raises total current.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'Three 2 ohm resistors are connected in series across a 12 volt battery. Find the current and the voltage across one resistor.',
        steps: <String>[
          'Series resistances add: 2 plus 2 plus 2 is 6 ohms.',
          'Current is voltage divided by equivalent resistance: 12 divided by 6 is 2 amperes.',
          'In series the current is the same everywhere, so each resistor drops current times resistance, which is 2 times 2, or 4 volts.',
          'Check: three drops of 4 volts add back to the 12 volt source.',
        ],
        answer: '2 amperes, with 4 volts across each resistor.',
      ),
      WorkedExample(
        prompt: 'A 6 ohm resistor and a 3 ohm resistor are connected in parallel across 12 volts. Find the current in each branch and the total current.',
        steps: <String>[
          'Each branch sees the full 12 volts, so compute branch by branch.',
          'Six ohm branch: 12 divided by 6 is 2 amperes. Three ohm branch: 12 divided by 3 is 4 amperes.',
          'Total current is 6 amperes, so the equivalent resistance is 12 divided by 6, which is 2 ohms, below the smallest branch as it must be.',
        ],
        answer: '2 amperes and 4 amperes, giving 6 amperes total.',
      ),
      WorkedExample(
        prompt: 'A 10 ohm resistor and a 20 ohm resistor are joined in series across 30 volts. What current flows, and what is the voltage across the 20 ohm resistor?',
        steps: <String>[
          'Series resistances add: 10 + 20 = 30 ohms.',
          'Current is the supply divided by the total: 30 / 30 = 1 ampere.',
          'One current flows through both, so the drop is 1 x 20 = 20 volts.',
        ],
        answer: '1 ampere, with 20 volts across the 20 ohm resistor',
      ),
    ],
    quickRules: <String>[
      'Series adds resistance, parallel divides it down below the smallest branch.',
      'Series shares current, parallel shares voltage.',
      'Two equal resistors in parallel equal half of one.',
      'Series voltage drops must add to the source, so use that as your check.',
    ],
    pitfalls: <String>[
      'Adding parallel resistances the series way, which gives 9 ohms for a 6 ohm and a 3 ohm branch and a total current far too small.',
      'Assuming current is used up as it travels through series resistors, so the last component is thought to get none; the current is the same in every part of the loop.',
      'Giving each parallel branch a share of the voltage, which halves every branch current and makes a perfectly good circuit look broken.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: '1.5 amperes, using the 20 ohm resistor as the whole circuit.',
        why: 'In series the resistances add, so the circuit is 30 ohms and the current is 1 ampere, not 1.5.',
      ),
      CommonMistake(
        answer:
            '15 volts across the 20 ohm resistor, splitting the supply evenly.',
        why: 'Series voltage divides in proportion to resistance. The 20 ohm part takes 20 of the 30 volts, leaving 10 for the other resistor.',
      ),
    ],
  ),
  Lesson(
    skillId: 'ei.components',
    title: 'Components: what each part is for',
    hook: 'You do not need to build a radio. You need to know what each part does to current and voltage.',
    whyItMatters: 'Component and symbol items are pure recall, which means they are the cheapest points in Electronics Information once the functions are straight.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'The parts that oppose or store',
        'Learn each part by what it does to the flow, and the symbol questions answer themselves.',
        bullets: <String>[
          'A resistor limits current and drops voltage, and it does not store energy.',
          'A capacitor stores charge in an electric field and blocks steady direct current while passing changes.',
          'An inductor stores energy in a magnetic field and opposes a change in current.',
          'A potentiometer is a resistor with a sliding contact, which makes it a level or volume control.',
        ],
      ),
      LessonSection(
        'The parts that allow one direction',
        'Semiconductor items are about control: letting current through one way, or letting a small signal steer a large one.',
        bullets: <String>[
          'A diode conducts one way and blocks the other, which is how alternating current is turned into pulsing direct current.',
          'An LED is a diode that emits light, and it needs a series resistor to limit its current.',
          'A transistor uses a small current to control a large one, which makes it a switch or an amplifier.',
          'A relay does the same job electromechanically, using a coil to close a separate set of contacts.',
        ],
      ),
      LessonSection(
        'Protection and symbols',
        'Symbols are shorthand, and a few details decide the items.',
        bullets: <String>[
          'A fuse melts to open the circuit, while a breaker trips and can be reset.',
          'The long line of a battery symbol is the positive terminal.',
          'Arrows pointing away from a symbol mean light is emitted, and arrows pointing in mean light is detected.',
          'A transformer changes alternating voltage by its turns ratio and does nothing useful with steady direct current.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'An LED needs about 3 volts across it and draws 20 milliamperes, and it is fed from a 9 volt supply. What series resistance holds the current at 20 milliamperes?',
        steps: <String>[
          'The resistor must drop the difference: 9 minus 3 is 6 volts.',
          'Convert the current: 20 milliamperes is 0.020 amperes.',
          'Resistance is voltage divided by current: 6 divided by 0.020 is 300 ohms.',
          'Check the dissipation: 6 volts times 0.020 amperes is 0.12 watts, so a quarter watt resistor is adequate.',
        ],
        answer: 'About 300 ohms, rated a quarter watt or more.',
      ),
      WorkedExample(
        prompt: 'A capacitor marked 25 volts is installed where it will see 50 volts. What happens?',
        steps: <String>[
          'The mark is a maximum working voltage, not a target.',
          'Fifty volts is twice the rating, so the dielectric is overstressed.',
          'The part fails, often shorted, and a shorted capacitor passes current where you expected a block.',
        ],
        answer: 'It fails, so you fit one rated at least 50 volts instead.',
      ),
      WorkedExample(
        prompt: 'A 100 ohm resistor carries 0.2 amperes. How much power does it turn into heat, and what rating should you fit?',
        steps: <String>[
          'Power in a resistor is current squared times resistance.',
          'Multiply: 0.2 x 0.2 = 0.04, then 0.04 x 100 = 4 watts.',
          'A part run at exactly its rating gets very hot, so fit the next standard size up, 5 watts or more.',
        ],
        answer: '4 watts dissipated, so fit a 5 watt or larger resistor',
      ),
    ],
    quickRules: <String>[
      'Resistor limits current, capacitor stores charge, inductor stores magnetic energy.',
      'A diode conducts one way, and an LED is a diode that lights.',
      'A transistor or a relay lets a small signal control a large one.',
      'Derate a capacitor well above the voltage it will actually see.',
    ],
    pitfalls: <String>[
      'Wiring an LED with no series resistor, which lets the current run away and destroys the diode on the first application of power.',
      'Treating a capacitor as a reservoir for steady current, when its blocking of direct current means the circuit simply stops.',
      'Fitting a transformer to step a battery supply down, which does nothing at all because a transformer needs a changing current.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: '20 watts, multiplying the resistance by the current once.',
        why: 'Resistance times current gives volts, not watts. Power is current squared times resistance: 0.04 x 100 = 4 watts.',
      ),
      CommonMistake(
        answer: 'A quarter watt resistor, on the grounds that 4 watts sounds small.',
        why: 'A resistor is rated above the power it will actually see. A quarter watt part asked to absorb 4 watts burns open.',
      ),
    ],
  ),
  Lesson(
    skillId: 'ei.safety',
    title: 'Electrical safety: test, lock, ground',
    hook: 'Every electrical safety item comes down to one idea: assume it is live until you have proved otherwise.',
    whyItMatters: 'Safety items are common in Electronics Information and in Auto and Shop, and they are almost always the easiest point in the block.',
    minutes: 7,
    sections: <LessonSection>[
      LessonSection(
        'The order of operations',
        'Safety questions reward the sequence as much as the rule. Get the order wrong and the answer is wrong even when every step is named correctly.',
        bullets: <String>[
          'De energise, lock out and tag out, then test for voltage, then work.',
          'Prove the meter on a known live source first, so you know it works before you trust a zero.',
          'Treat any circuit you did not open yourself as live, whatever the panel says.',
          'Never work on a live circuit that could have been shut off, and never work alone when it cannot.',
        ],
      ),
      LessonSection(
        'Grounding, insulation and protection',
        'These three exist to handle faults, and fault handling is what the questions are about.',
        bullets: <String>[
          'The green or bare conductor is the safety ground, and it carries fault current safely away.',
          'Insulation is rated in volts, so the same damage is far more dangerous on a high voltage tool than on a low voltage one.',
          'A fuse or breaker protects the wiring rather than the appliance, and it is sized to the wire it protects.',
          'A GFCI senses an imbalance of current to earth and opens far faster than a breaker will.',
        ],
      ),
      LessonSection(
        'Meters matched to the job',
        'Meter items are decided by where the meter connects, and a wrong connection is a blown fuse or a ruined meter.',
        bullets: <String>[
          'A voltmeter connects in parallel with the part being measured.',
          'An ammeter connects in series, which usually means breaking the circuit open.',
          'An ohmmeter measures with the circuit dead and unpowered.',
          'Start on the highest range and step down, so a wrong setting does not destroy the instrument.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'You need to measure the voltage across a resistor in a live circuit. Where does the meter connect, and what setting do you start on?',
        steps: <String>[
          'Voltage is measured across a component, so the meter connects in parallel with that resistor.',
          'Start on a range above the expected voltage, then step down for a readable number.',
          'Do not break the circuit to insert the meter, because an ammeter placed in parallel reads nonsense and can blow its fuse.',
        ],
        answer: 'In parallel, starting above the expected voltage.',
      ),
      WorkedExample(
        prompt: 'A 120 volt branch is protected by a 15 ampere breaker, and a device on that branch draws 20 amperes. What happens, and what should you check?',
        steps: <String>[
          'The device draws more than the breaker rating, so the breaker trips.',
          'The load also exceeds what a 15 ampere circuit is intended to carry, so this is not a nuisance trip.',
          'Check whether the device needs a larger dedicated circuit, and never fit a bigger breaker to stop the tripping.',
        ],
        answer: 'The breaker trips, and the load needs a circuit that can carry it.',
      ),
      WorkedExample(
        prompt: 'A metal enclosure is connected back to the panel by a green conductor. What is that conductor for, and what changes if it is left disconnected?',
        steps: <String>[
          'The green conductor is the equipment ground, a dedicated fault path that carries no working current.',
          'When a live conductor touches the case, the ground gives the current a low resistance route back to the panel.',
          'That surge is what trips the breaker. Without the ground, the case simply sits at line voltage waiting for a hand.',
        ],
        answer: 'It is the fault path that lets the breaker trip; without it the metal case can stay live.',
      ),
    ],
    quickRules: <String>[
      'Lock out, tag out, test, then touch.',
      'Voltmeter in parallel, ammeter in series, ohmmeter on a dead circuit.',
      'Green is ground, and it exists to carry fault current.',
      'Never upsize a fuse or breaker to silence a trip.',
    ],
    pitfalls: <String>[
      'Trusting a meter that was never proved on a live source, which reports a dead circuit that is in fact live.',
      'Connecting an ammeter across a component, which puts a near short across it and blows the meter fuse.',
      'Upsizing a fuse to stop nuisance trips, which removes the protection the conductor needs and turns a trip into a fire.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'It carries the working current back, so it can be left off while the circuit still runs.',
        why: 'Working current returns on the neutral. The green conductor carries nothing until a fault, which is exactly the moment it has to be there.',
      ),
      CommonMistake(
        answer:
            'It is only for lightning, so nothing inside the building changes.',
        why: 'The ground is what clears an internal fault. Disconnect it and a short to the case no longer trips anything.',
      ),
    ],
  ),
  Lesson(
    skillId: 'as.engine',
    title: 'The four stroke cycle, then the systems',
    hook: 'Suck, squeeze, bang, blow, then the systems that keep it happening a thousand times a minute.',
    whyItMatters: 'Engine items are the largest topic in Auto and Shop Information, and the cycle questions are pure recall.',
    minutes: 9,
    sections: <LessonSection>[
      LessonSection(
        'The four strokes, in order',
        'The order is fixed, and the piston direction plus valve position identifies each stroke.',
        bullets: <String>[
          'Intake: the piston moves down with the intake valve open and draws the air and fuel mixture in.',
          'Compression: the piston moves up with both valves closed and squeezes the mixture.',
          'Power: the spark ignites the mixture and the burning gas drives the piston down.',
          'Exhaust: the exhaust valve opens and the rising piston pushes the burned gas out.',
        ],
      ),
      LessonSection(
        'Two crank turns per cycle',
        'Counting power strokes is a favourite item, and it always turns on two facts.',
        bullets: <String>[
          'One complete four stroke cycle takes two revolutions of the crankshaft.',
          'So each cylinder fires once per two crankshaft revolutions.',
          'A four cylinder engine can fire every half revolution, which is 180 degrees of crank rotation.',
          'A six cylinder engine spaces its firings closer together, every 120 degrees, which is why it runs more smoothly.',
        ],
      ),
      LessonSection(
        'Cooling, oil and drive',
        'The supporting systems each do one job, and mixing them up is the common error.',
        bullets: <String>[
          'Coolant carries heat away, and the thermostat stays closed until the engine warms and then opens to the radiator.',
          'Oil lubricates, cleans and carries some heat away, and low oil pressure damages an engine faster than a low level does.',
          'The clutch or torque converter connects and disconnects the engine from the transmission.',
          'A differential lets the driven wheels turn at different speeds in a turn.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A single cylinder has a clearance volume of 50 cubic centimetres above the piston at top dead centre, and the piston sweeps 450 cubic centimetres. What is the compression ratio?',
        steps: <String>[
          'The ratio compares the total volume at the bottom of the stroke with the volume left at the top.',
          'Total volume is swept plus clearance: 450 plus 50 is 500 cubic centimetres.',
          'Divide by the clearance volume: 500 divided by 50 is 10.',
        ],
        answer: '10 to 1.',
      ),
      WorkedExample(
        prompt: 'A four cylinder four stroke engine idles at 800 revolutions per minute. How many power strokes occur per minute?',
        steps: <String>[
          'One cylinder fires once per two crank revolutions, so it fires 800 divided by 2, which is 400 times per minute.',
          'Four cylinders each fire 400 times, so 4 times 400 is 1600 power strokes per minute.',
        ],
        answer: '1600 power strokes per minute.',
      ),
      WorkedExample(
        prompt: 'A V8 engine has eight cylinders, each sweeping 400 cubic centimetres. What is its displacement in litres?',
        steps: <String>[
          'Displacement counts the swept volume of every cylinder, not the clearance space.',
          'Multiply: 8 x 400 = 3,200 cubic centimetres.',
          'Convert: 1,000 cubic centimetres is one litre, so 3,200 is 3.2 litres.',
        ],
        answer: '3.2 litres',
      ),
    ],
    quickRules: <String>[
      'Intake, compression, power, exhaust, and two crank turns finish the cycle.',
      'Compression ratio is total volume divided by clearance volume.',
      'Coolant removes heat and oil lubricates, and one never substitutes for the other.',
      'The thermostat controls coolant flow rather than temperature directly.',
    ],
    pitfalls: <String>[
      'Listing the strokes out of order and putting the power stroke before compression, which is the most common miss on a cycle question.',
      'Saying one revolution completes the cycle, which halves your firing count and lands on exactly half the correct number of power strokes.',
      'Adding the clearance volume twice when you work out a compression ratio, which gives a figure that looks close and is quietly too high.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'Adding the clearance volumes to the swept volume.',
        why: 'Displacement is swept volume only. The clearance space above the piston sets the compression ratio; it does not add litres.',
      ),
      CommonMistake(
        answer: '3,200 litres, leaving the answer in cubic centimetres.',
        why: 'A litre is 1,000 cubic centimetres, so 3,200 cubic centimetres is 3.2 litres.',
      ),
    ],
  ),
  Lesson(
    skillId: 'as.tools',
    title: 'Tools: name the job, get the tool',
    hook: 'Tool items almost never ask what a tool looks like. They ask which tool does the job in front of you.',
    whyItMatters: 'Hand and power tool items are the most numerous in Auto and Shop Information, and they reward a job first habit.',
    minutes: 7,
    sections: <LessonSection>[
      LessonSection(
        'Wrenches and drive tools',
        'Grip type decides the wrench. Match the shape of the fastener to the shape of the jaw.',
        bullets: <String>[
          'An open end or box end wrench grips a hex, and the box end grips more faces so it slips less on a tight fastener.',
          'A pipe wrench bites into round pipe with serrated jaws and is not for hex nuts, which it scars.',
          'A torque wrench measures turning effort, so it is set to a specification rather than tightened until it feels right.',
          'A socket and ratchet fits where an open wrench will not, and a breaker bar gives leverage without a ratchet mechanism to break.',
        ],
      ),
      LessonSection(
        'Cutting, shaping and threading',
        'Saws and files cut one way well and the other way badly, and threads are always inside or outside.',
        bullets: <String>[
          'A crosscut saw cuts across the grain and a rip saw cuts along it.',
          'A tap cuts internal threads in a hole and a die cuts external threads on a rod or bolt.',
          'A file cuts on the push stroke, and a hacksaw cuts on the push stroke too.',
          'A punch marks a spot so the drill does not wander, and a chisel cuts cleanly with its bevel facing the waste.',
        ],
      ),
      LessonSection(
        'Measuring and inspecting',
        'Measuring tools are separated by how fine a reading they give and what they are checking.',
        bullets: <String>[
          'A rule or tape measures length, while calipers read inside, outside and depth to a fine number.',
          'A level checks level and a square checks a right angle.',
          'A feeler gauge measures a gap, which is how valve clearance and spark plug gap are set.',
          'An impact driver is not a screwdriver, and the wrong bit rounds the head so the fastener takes the blame.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A specification calls for 90 foot pounds on a head bolt, but your torque wrench is marked in inch pounds. What do you set it to?',
        steps: <String>[
          'One foot pound is twelve inch pounds, so convert rather than guess.',
          '90 times 12 is 1080.',
        ],
        answer: '1080 inch pounds.',
      ),
      WorkedExample(
        prompt: 'You need to cut new threads inside a mounting hole for a bolt. Which tool, and what if the hole is already threaded but damaged?',
        steps: <String>[
          'Threads cut inside a hole are made with a tap, turned with a tap wrench.',
          'If the threads already exist and are only damaged, a thread chaser or a tap run carefully cleans them instead of cutting new metal.',
          'A die is the opposite job, cutting threads on the outside of a rod.',
        ],
        answer: 'A tap, used gently if the hole is already threaded.',
      ),
      WorkedExample(
        prompt: 'You must measure the outside diameter of a shaft to a thousandth of an inch. Which tool, and why is a steel rule not enough?',
        steps: <String>[
          'Name the job: a diameter measured to a thousandth of an inch, which is a precision outside measurement.',
          'Name the tool: an outside micrometer, read against its thimble.',
          'Say why the rule fails: it is divided in sixteenths, which is over sixty times coarser than a thousandth.',
        ],
        answer: 'An outside micrometer, because a rule only resolves about a sixteenth of an inch',
      ),
    ],
    quickRules: <String>[
      'A tap cuts inside, a die cuts outside.',
      'Crosscut goes across the grain and rip goes along it.',
      'Files and hacksaws cut on the push stroke.',
      'Reach for calipers when a rule is not fine enough.',
    ],
    pitfalls: <String>[
      'Using a pipe wrench on a hex nut, which rounds the flats and leaves you with the right tool on a fastener you can no longer turn.',
      'Setting a torque wrench that reads inch pounds to a foot pound figure, which under torques the bolt twelvefold and leaves nothing tight.',
      'Dragging a file or a hacksaw on the return stroke, which dulls the teeth and lets the cut wander off the line.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'A steel rule, because it is marked in inches.',
        why: 'Inches are the unit, not the resolution. A rule cannot read to a thousandth, so the measurement would be a guess.',
      ),
      CommonMistake(
        answer: 'A tape measure pressed against the end of the shaft.',
        why: 'A tape measures length or distance, and it cannot span a diameter squarely. The precision tool for a diameter is a micrometer.',
      ),
    ],
  ),
  Lesson(
    skillId: 'as.materials',
    title: 'Materials and fasteners, from the grain up',
    hook: 'Wood, steel, concrete and threads each have one habit worth knowing, and the exam tests exactly that habit.',
    whyItMatters: 'Materials and fastener items sit alongside tools in Auto and Shop Information, and most of them are settled by a single property.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Wood',
        'Wood is directional, and every wood item follows from that.',
        bullets: <String>[
          'Hardwood comes from broadleaf trees and softwood from conifers, so the labels describe the tree rather than the hardness of the board.',
          'Wood is strongest along the grain and splits easily across it.',
          'Plywood crosses its layers, so it resists warping and holds fasteners better near an edge.',
          'Nominal sizes are not actual: a two by four measures one and a half by three and a half inches.',
        ],
      ),
      LessonSection(
        'Metal and concrete',
        'Both materials are strong in one direction and weak in another, and the exam tests which is which.',
        bullets: <String>[
          'More carbon makes steel harder and more brittle, so a high carbon tool steel takes a keen edge and cracks under shock.',
          'Aluminium is light and resists corrosion through its oxide layer, but the same size member is not a substitute for steel under heavy load.',
          'Concrete is strong in compression and weak in tension, so steel bars are placed to carry the tension.',
          'Concrete gains strength as it cures and is normally judged at 28 days.',
        ],
      ),
      LessonSection(
        'Fasteners and threads',
        'Threads per inch is the number that turns a fastener item into arithmetic.',
        bullets: <String>[
          'A bolt passes through clearance holes and takes a nut, while a screw cuts or forms threads in the material itself.',
          'A bolt marked a quarter inch with 20 threads per inch advances one twentieth of an inch, or 0.05 inch, per full turn.',
          'Grade markings on a bolt head state its strength class, so a marked bolt is never swapped for an unmarked one of the same size.',
          'A flat washer spreads the load and a lock washer or thread locker resists vibration loosening.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A slab is 10 feet by 12 feet and 4 inches thick. How many cubic feet of concrete does it need, and how many cubic yards is that?',
        steps: <String>[
          'Convert the thickness to feet: 4 inches is one third of a foot.',
          'Volume is 10 times 12 times one third, which is 40 cubic feet.',
          'A cubic yard is 27 cubic feet, so 40 divided by 27 is about 1.48 cubic yards.',
        ],
        answer: '40 cubic feet, which is about 1.5 cubic yards.',
      ),
      WorkedExample(
        prompt: 'A quarter inch, twenty thread bolt is turned two and a half full turns into a nut. How far does it advance?',
        steps: <String>[
          'Twenty threads per inch means one turn moves the bolt one twentieth of an inch, which is 0.05 inch.',
          'Two and a half turns is 0.05 times 2.5, which is 0.125 inch.',
        ],
        answer: 'One eighth of an inch.',
      ),
      WorkedExample(
        prompt: 'The same plank bends far less when it is stood on edge than when it lies flat. Why?',
        steps: <String>[
          'The amount of wood is identical either way, so the answer is not more material.',
          'Bending is resisted by how far the material sits from the middle of the section, and on edge the plank is deeper.',
          'Stiffness grows with the cube of that depth, so a small increase in depth is a large gain in stiffness.',
        ],
        answer: 'On edge the plank is deeper, and stiffness rises with the cube of depth.',
      ),
    ],
    quickRules: <String>[
      'Hardwood and softwood name the tree, not the board.',
      'A two by four is one and a half by three and a half inches.',
      'Concrete carries compression and steel carries tension.',
      'Threads per inch gives the advance per turn as a fraction of an inch.',
    ],
    pitfalls: <String>[
      'Ordering lumber as if the nominal size were actual, which leaves a frame half an inch short on every stud.',
      'Swapping a grade marked bolt for an unmarked one of the same diameter, which quietly gives away most of the clamping load.',
      'Pouring a slab with no steel and then wondering why it cracks across the span, because concrete cannot carry the tension.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer:
            'Lying flat puts more wood under the load, so it must be stronger.',
        why: 'The section holds the same amount of wood in both positions. What changes is the depth, and depth is what resists bending.',
      ),
      CommonMistake(
        answer: 'On edge the plank is narrower, and narrow is stiffer.',
        why: 'Narrower is weaker, not stiffer. The gain comes from the depth, where a doubled depth means eight times the stiffness.',
      ),
    ],
  ),
  Lesson(
    skillId: 'as.welding',
    title: 'Welding, cutting and the rules',
    hook: 'Know four processes, one temperature dividing line, and the safety habits that never change.',
    whyItMatters: 'Welding items appear in both Auto and Shop and Mechanical Comprehension, and the safety items in this block are the most predictable in the section.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'The processes',
        'Name each process by what carries the arc or the heat, then match it to the job.',
        bullets: <String>[
          'Stick welding uses a consumable coated electrode whose coating supplies the shielding, so it works outdoors in wind.',
          'MIG welding feeds a wire electrode continuously and is fast on thin sheet.',
          'TIG welding uses a non consumable tungsten electrode with a separate filler rod, giving the finest control.',
          'Oxy fuel welding joins metal with a gas flame, and the same torch with a cutting head severs steel.',
        ],
      ),
      LessonSection(
        'Welding, brazing and soldering',
        'The dividing line is whether the base metal melts. Get that straight and the whole comparison answers itself.',
        bullets: <String>[
          'Welding melts the base metal, so the joint becomes one continuous piece of metal.',
          'Brazing melts a filler but not the base metal, and it happens above roughly 450 degrees Celsius.',
          'Soldering does the same thing at a lower temperature, below the brazing range.',
          'Gas cutting does not merely melt the steel: the oxygen jet burns it away along the cut.',
        ],
      ),
      LessonSection(
        'Safety that does not change',
        'These four rules cover nearly every welding safety item, and each one has a specific failure attached.',
        bullets: <String>[
          'Wear the correct shade lens for the current, and have it down before the arc starts rather than after.',
          'Keep oil and grease away from oxygen fittings and hoses, because oxygen with oil is a fire.',
          'Acetylene working pressure stays at or below 15 pounds per square inch, and the cylinder stays upright.',
          'Never weld or cut a container that held fuel until it has been purged and verified, and ventilate the space.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'You are repairing thin sheet metal, out of position, on a windy outdoor job. Which process, and why?',
        steps: <String>[
          'Wind blows shielding gas away, so a gas shielded process loses its protection outdoors.',
          'Stick welding carries its shielding in the electrode coating, so wind matters far less.',
          'Thin sheet argues for low current and a small electrode, so stick at low current, or MIG if the wind can be screened.',
        ],
        answer: 'Stick with low current for the wind and the thin sheet, and MIG only with the wind screened off.',
      ),
      WorkedExample(
        prompt: 'An acetylene regulator is being set. What is the working pressure limit, and what is the risk in exceeding it?',
        steps: <String>[
          'Acetylene becomes unstable under pressure, so the working limit is 15 pounds per square inch.',
          'Above that, decomposition can begin without any oxygen present.',
          'The failure mode is violent, and the hose, torch or regulator is what lets go.',
        ],
        answer: '15 pounds per square inch or less, with the cylinder upright.',
      ),
      WorkedExample(
        prompt: 'Why must an arc welder keep the electrode holder dry and clamp the ground lead to clean metal close to the joint?',
        steps: <String>[
          'The holder carries the welding voltage at the electrode, so a damp holder puts that voltage in the welder hand.',
          'The ground clamp completes the circuit, so the current has to get back to it through the work.',
          'Clamped close to the joint, the return path is short and no current wanders through bearings, chains or the bench.',
        ],
        answer: 'A dry holder keeps the welder insulated, and a close clean ground keeps the return path short.',
      ),
    ],
    quickRules: <String>[
      'Welding melts the base metal, brazing and soldering do not.',
      'Stick welding shrugs off wind and gas shielded processes do not.',
      'Oxygen, oil and grease never meet.',
      'Acetylene stays at or below 15 psi and upright.',
    ],
    pitfalls: <String>[
      'Calling brazing welding, which pushes you to the answer where the base metal melts and to strength claims the joint cannot support.',
      'Choosing MIG for an outdoor job in wind, where the gas blows away and the weld is porous from the first inch.',
      'Ignoring slag between passes on a stick weld, which stops the next pass bonding and leaves a joint that looks sound and is not.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'The ground clamp is only there to hold the work still.',
        why: 'The clamp is an electrical connection, not a hold down. It completes the circuit, and where it sits decides the path the current takes.',
      ),
      CommonMistake(
        answer: 'A damp holder is safe because welding gloves are leather.',
        why: 'Leather soaks through. A wet holder puts the open circuit voltage into the welder hand, which is why holders are kept dry.',
      ),
    ],
  ),
  Lesson(
    skillId: 'mc.levers',
    title: 'Levers: moments balance the bar',
    hook: 'Every lever item is one equation: force times distance on one side equals force times distance on the other.',
    whyItMatters: 'Levers and moments are the foundation of Mechanical Comprehension, and the same balance idea reappears in every other machine item.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Three classes, one test',
        'Do not memorise a list of examples. Find the three points on the bar and see which one sits in the middle.',
        bullets: <String>[
          'Locate the fulcrum, the load and the effort before anything else.',
          'Fulcrum in the middle is class one, as in a crowbar or a seesaw.',
          'Load in the middle is class two, as in a wheelbarrow, and the advantage is always greater than one.',
          'Effort in the middle is class three, as in tongs or tweezers, and the advantage is always less than one.',
        ],
      ),
      LessonSection(
        'Moments do the work',
        'A moment is force times distance from the fulcrum, so a small force far out can beat a large force close in. That single idea answers balance and advantage items alike.',
        bullets: <String>[
          'Mechanical advantage is the effort arm divided by the load arm.',
          'You gain force by giving up distance, so the load moves a fraction of the distance your hand travels.',
          'Convert to one unit before dividing, because feet over inches is not a ratio.',
          'Balance means the moments are equal, which is not the same as the load moving.',
        ],
      ),
      LessonSection(
        'Read the diagram carefully',
        'The number you are given is often the whole bar rather than the arm, and that difference is where the points go.',
        bullets: <String>[
          'Measure every arm from the fulcrum, never from the end of the bar.',
          'When the total length is given, subtract to get the arm you were not told.',
          'A long lever multiplies force and divides distance, so never claim both.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A pry bar is 5 feet long and the fulcrum is 6 inches from the load. How much effort lifts a 180 pound load when you push at the far end?',
        steps: <String>[
          'Six inches is 0.5 foot, so the load arm is 0.5 foot and the effort arm is 5 minus 0.5, which is 4.5 feet.',
          'The mechanical advantage is 4.5 divided by 0.5, which is 9.',
          'Effort is load divided by advantage: 180 divided by 9 is 20 pounds.',
        ],
        answer: '20 pounds of effort.',
      ),
      WorkedExample(
        prompt: 'A seesaw is 12 feet long with the fulcrum at its centre. A 90 pound child sits 4 feet from the fulcrum. How far from the fulcrum should a 60 pound child sit to balance it?',
        steps: <String>[
          'Moment on one side is 90 times 4, which is 360 pound feet.',
          'The other child needs 60 times distance equal to 360, so the distance is 360 divided by 60, which is 6 feet.',
          'Six feet is reachable, because the plank is 12 feet long with the pivot at the centre, so the seat is exactly at the far end.',
        ],
        answer: '6 feet from the fulcrum, at the far end of the plank.',
      ),
      WorkedExample(
        prompt: 'A wheelbarrow carries its load 1.5 feet from the wheel, and the handles are 5 feet from the wheel. How much effort lifts a 200 pound load?',
        steps: <String>[
          'The wheel is the fulcrum, so the load arm is 1.5 feet and the effort arm is 5 feet.',
          'Balance the moments: effort x 5 = 200 x 1.5 = 300.',
          'Divide: effort = 300 / 5 = 60 pounds.',
        ],
        answer: '60 pounds of effort',
      ),
    ],
    quickRules: <String>[
      'Moment equals force times distance from the fulcrum.',
      'Fulcrum middle is class one, load middle is class two, effort middle is class three.',
      'Mechanical advantage equals effort arm over load arm.',
      'Convert units before you divide.',
    ],
    pitfalls: <String>[
      'Using the whole bar as the effort arm, which gives an advantage of 10 in place of 9 and an effort of 18 pounds where the answer was 20.',
      'Dividing the arms the wrong way round, which reports an effort larger than the load itself and tells you to push harder than lifting by hand.',
      'Assuming a long lever multiplies distance along with force; it does the opposite, giving force and taking distance.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: '40 pounds, using 5 feet as the load arm.',
        why: 'The load sits 1.5 feet from the wheel. Effort x 5 = 200 x 1.5 balances at 60 pounds, not 40.',
      ),
      CommonMistake(
        answer: '133 pounds, dividing the load by the load arm alone.',
        why: 'The mechanical advantage is the ratio of the arms, 5 / 1.5, which is about 3.3, so the effort is 200 / 3.3 = 60 pounds.',
      ),
    ],
  ),
  Lesson(
    skillId: 'mc.pulleys',
    title: 'Pulleys and gears: count, then divide',
    hook: 'Pulley items are counting rope sections and gear items are a teeth ratio. Neither is hard once you stop seeing the picture as a machine.',
    whyItMatters: 'Pulleys, gears and belt items are a recurring block in Mechanical Comprehension, and they are decided by two simple counts.',
    minutes: 9,
    sections: <LessonSection>[
      LessonSection(
        'Count the supporting sections',
        'The count is the whole item. Count only the rope sections that pull upward on the movable block, and ignore every other line in the drawing.',
        bullets: <String>[
          'Mechanical advantage equals the number of sections supporting the movable block.',
          'Four supporting sections hold the load with a quarter of its weight.',
          'A single fixed pulley changes direction and nothing else, so its advantage is one.',
          'The cost of advantage is rope: four sections means hauling four feet to raise the load one foot.',
        ],
      ),
      LessonSection(
        'Gears and belts',
        'Two directions and one ratio cover this whole family of items.',
        bullets: <String>[
          'Meshed gears turn in opposite directions.',
          'The speed ratio is the ratio of teeth, so a 10 tooth gear driving a 50 tooth gear slows the output to one fifth.',
          'Two pulleys on an open belt turn the same way, and a crossed belt reverses the driven pulley.',
          'A larger driven gear gives more torque and less speed, while the power stays roughly the same.',
        ],
      ),
      LessonSection(
        'Check the answer against common sense',
        'Machines rearrange force, distance and speed. They never manufacture work, and that test catches most wrong answers on sight.',
        bullets: <String>[
          'If your effort comes out higher than the load weight, you counted sections that do not support the block.',
          'If an answer claims more torque and more speed at the same time, one of those claims is false.',
          'A system that halves the effort must double the rope you pull, so check the distance as well as the force.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A block and tackle has four rope sections pulling upward on the movable block and lifts a 200 pound load. What effort holds the load?',
        steps: <String>[
          'Count the supporting sections only, which is four.',
          'Effort is load divided by sections: 200 divided by 4 is 50 pounds.',
          'To raise the load one foot you haul four feet of rope, which is the price of that advantage.',
        ],
        answer: '50 pounds.',
      ),
      WorkedExample(
        prompt: 'A 10 tooth gear turning at 600 revolutions per minute drives a 50 tooth gear. What is the output speed, and what happens to the torque?',
        steps: <String>[
          'The teeth ratio is 50 divided by 10, which is 5.',
          'Output speed is input speed divided by the ratio: 600 divided by 5 is 120 revolutions per minute.',
          'Speed fell fivefold while torque rose by roughly the same factor, because the power is not created.',
        ],
        answer: '120 revolutions per minute, with about five times the torque.',
      ),
      WorkedExample(
        prompt: 'A single movable pulley lifts a 300 pound load. Ignoring friction, what effort holds it, and how much rope is pulled in to raise the load 4 feet?',
        steps: <String>[
          'A movable pulley hangs on two rope sections, so the effort is half the load.',
          'Halve it: 300 / 2 = 150 pounds.',
          'The trade is rope for force, so the rope moves twice as far as the load: 2 x 4 = 8 feet.',
        ],
        answer: '150 pounds of effort, with 8 feet of rope pulled',
      ),
    ],
    quickRules: <String>[
      'Count only the rope sections that support the movable block.',
      'A fixed pulley alone gives an advantage of one and changes direction only.',
      'Meshed gears reverse direction and an open belt does not.',
      'The teeth ratio sets the speed ratio, and the torque moves the opposite way.',
    ],
    pitfalls: <String>[
      'Counting every visible rope line, which doubles the section count and reports half the effort the system can really give you.',
      'Assuming a fixed pulley halves the effort, which answers with half the load weight when the honest answer is the whole weight.',
      'Saying meshed gears turn the same way, which reverses every direction item and gets a simple two gear chain exactly wrong.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: '300 pounds, because a pulley only changes the direction of the pull.',
        why: 'That is true of a fixed pulley. A movable pulley hangs on two rope sections and halves the effort to 150 pounds.',
      ),
      CommonMistake(
        answer: '150 pounds with only 4 feet of rope pulled.',
        why: 'The effort halves, so the distance doubles. 8 feet of rope has to come in to raise the load 4 feet.',
      ),
    ],
  ),
  Lesson(
    skillId: 'mc.pressure',
    title: 'Pressure is force spread over area',
    hook: 'One fraction explains hydraulics, sharp tools, snowshoes and every pressure item on the test.',
    whyItMatters: 'Fluid and pressure items are a regular block in Mechanical Comprehension, and they reduce to a single division with a sanity check.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'The fraction',
        'Pressure equals force divided by area. Everything else in this skill is that fraction applied twice.',
        bullets: <String>[
          'Pressure is measured in pounds per square inch or newtons per square metre.',
          'The same force over a smaller area gives more pressure, which is why a knife cuts and a snowshoe does not sink.',
          'Pressure in a fluid acts in every direction at a given depth, not only downward.',
          'Atmospheric pressure at sea level is about 14.7 pounds per square inch.',
        ],
      ),
      LessonSection(
        'Hydraulics: pressure travels, force multiplies',
        'A confined liquid transmits pressure unchanged in every direction, and area does the multiplying.',
        bullets: <String>[
          'In a closed system the pressure is the same everywhere, which is the principle behind a hydraulic jack.',
          'A small piston over a small area makes the pressure, and the same pressure over a large area makes a large force.',
          'The large piston travels a short distance while the small one travels far, so work is conserved.',
          'Liquid is treated as incompressible, which is why a bled brake pedal feels firm instead of spongy.',
        ],
      ),
      LessonSection(
        'Depth and buoyancy',
        'Depth adds pressure from the surface down, and buoyancy compares the weight displaced with the weight of the object.',
        bullets: <String>[
          'Pressure rises with depth because of the weight of fluid above, and it does not depend on the shape of the container.',
          'An object floats when it displaces a weight of fluid equal to its own weight.',
          'A denser fluid floats an object higher, which is why a hull rides higher in salt water than in fresh.',
          'Gauge pressure ignores the atmosphere, and absolute pressure adds it back in.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A hydraulic jack has a 2 square inch input piston and a 20 square inch output piston. A 50 pound force is applied at the input. What pressure is created and what force appears at the output?',
        steps: <String>[
          'Pressure is force over area: 50 pounds over 2 square inches is 25 pounds per square inch.',
          'The same pressure acts on 20 square inches: 25 times 20 is 500 pounds.',
          'The output force rose tenfold because the area rose tenfold, and the output travels one tenth as far.',
        ],
        answer: '25 pounds per square inch, giving 500 pounds of output force.',
      ),
      WorkedExample(
        prompt: 'A diver descends about 33 feet in sea water. Roughly how much has the pressure increased compared with the surface?',
        steps: <String>[
          'Every 33 feet of sea water adds roughly one atmosphere of pressure.',
          'One atmosphere is about 14.7 pounds per square inch, so the diver feels about twice the surface pressure in total.',
        ],
        answer: 'About one more atmosphere, or roughly 14.7 pounds per square inch extra.',
      ),
      WorkedExample(
        prompt: 'A 150 pound soldier stands on snowshoes with a total contact area of 300 square inches. What pressure does he put on the snow?',
        steps: <String>[
          'Pressure is force divided by area.',
          'Divide: 150 / 300 = 0.5 pounds per square inch.',
          'Notice the point of the snowshoe: the same weight over a bigger area is a pressure the snow can hold.',
        ],
        answer: '0.5 pounds per square inch',
      ),
    ],
    quickRules: <String>[
      'Pressure equals force divided by area.',
      'Pressure is the same everywhere in a closed hydraulic system.',
      'Small area in and big area out multiplies force and shrinks distance.',
      'Depth adds pressure, and the shape of the vessel does not.',
    ],
    pitfalls: <String>[
      'Multiplying force by area instead of dividing, which makes pressure grow as the contact area grows, the exact opposite of the truth.',
      'Forgetting that the output piston travels less far, so a jack looks as though it creates energy from nothing.',
      'Confusing gauge pressure with absolute pressure, which understates the total by about 14.7 pounds per square inch at sea level.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer:
            '150 pounds per square inch, reporting the load as the pressure.',
        why: '150 pounds is the force. Pressure spreads it over 300 square inches, which is 0.5 pounds per square inch.',
      ),
      CommonMistake(
        answer: '45,000 pounds per square inch, multiplying force by area.',
        why: 'Pressure is force divided by area. Multiplying the two turns a small pressure into an impossible number.',
      ),
    ],
  ),
  Lesson(
    skillId: 'mc.structure',
    title: 'Structure: where the load goes',
    hook: 'Loads travel along the stiffest short path. Find that path and the beam, friction and inertia items answer themselves.',
    whyItMatters: 'Structure and friction items mix with machine items throughout Mechanical Comprehension, and they reward a picture of where force lives.',
    minutes: 9,
    sections: <LessonSection>[
      LessonSection(
        'Beams and stress',
        'A bending beam does two jobs at once, one on each face.',
        bullets: <String>[
          'A simply supported beam sags with compression on top and tension on the bottom.',
          'An I beam is shaped that way because the flanges carry most of the bending load while the web holds them apart.',
          'Standing an I beam on its side throws away most of its strength.',
          'Stress is force divided by area, so a wider member carries the same load at a lower stress.',
        ],
      ),
      LessonSection(
        'Triangles and trusses',
        'Shape decides stiffness, and the triangle is the only polygon that cannot deform without a side changing length.',
        bullets: <String>[
          'A triangle holds its shape under load, which is why trusses are built from them.',
          'A rectangle needs a diagonal brace, or it racks into a parallelogram.',
          'Members of a truss are in tension or compression, and a member carrying neither is idle.',
          'A wide base and a low centre of gravity make an object hard to tip.',
        ],
      ),
      LessonSection(
        'Friction and inertia',
        'Friction is a force you calculate, and inertia is a resistance you predict.',
        bullets: <String>[
          'Friction equals the coefficient of friction times the normal force, so a heavier object takes more force to start moving.',
          'Starting friction is greater than sliding friction, which is why a stuck crate breaks free and then slides more easily.',
          'Inertia resists any change in motion, so a loaded truck needs more distance to stop than an empty one at the same speed.',
          'Lubrication separates the surfaces, which lowers the coefficient of friction.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A column carries a 2000 pound load over a 4 square inch cross section. What is the stress in the column?',
        steps: <String>[
          'Stress is force divided by area: 2000 pounds over 4 square inches is 500 pounds per square inch.',
          'Doubling the cross section would halve the stress, because the load itself does not change.',
        ],
        answer: '500 pounds per square inch.',
      ),
      WorkedExample(
        prompt: 'A 100 pound crate sits on a floor and the coefficient of friction is 0.3. How much horizontal force is needed to start it sliding, and what changes once it moves?',
        steps: <String>[
          'The normal force equals the crate weight here, which is 100 pounds.',
          'Friction is 0.3 times 100, which is 30 pounds.',
          'Once it is moving, sliding friction is lower, so less than 30 pounds keeps it moving.',
        ],
        answer: 'About 30 pounds to start it, and less to keep it moving.',
      ),
      WorkedExample(
        prompt: 'A wire rope has a breaking strength of 8,000 pounds. What load is it rated to lift with a safety factor of 4?',
        steps: <String>[
          'A safety factor protects the rope by keeping the working load below the breaking strength.',
          'Divide the breaking strength by the factor: 8,000 / 4 = 2,000 pounds.',
          'Read the direction: the factor makes the working load smaller, never larger.',
        ],
        answer: '2,000 pounds',
      ),
    ],
    quickRules: <String>[
      'Stress equals force divided by area.',
      'The top of a loaded beam compresses and the bottom stretches.',
      'Triangles are rigid and rectangles rack without a brace.',
      'Friction equals the coefficient times the normal force.',
    ],
    pitfalls: <String>[
      'Reversing tension and compression in a sagging beam, which puts the stretch on top and loses the item even though you read the sag correctly.',
      'Calculating friction from the push you apply instead of the normal force, which gives a friction figure that changes depending on how hard you are already pushing.',
      'Duplicating a rectangle instead of bracing it, which adds weight and does nothing, because the diagonal is what resists racking.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: '32,000 pounds, multiplying the strength by the factor.',
        why: 'A safety factor divides. Lifting 32,000 pounds with an 8,000 pound rope takes it past the point where it fails.',
      ),
      CommonMistake(
        answer: '8,000 pounds, because that is what the rope is rated for.',
        why: 'Breaking strength is where the rope parts. The working load sits a factor of safety below it, at 2,000 pounds.',
      ),
    ],
  ),
  Lesson(
    skillId: 'ao.rotation',
    title: 'Rotation: turn the page, not your brain',
    hook: 'You are allowed to move the paper. Turning the picture is not cheating, and it is faster than holding a shape in your head.',
    whyItMatters: 'Assembling Objects does not feed your AFQT, but a steady spatial habit there protects the line scores that technical jobs look at.',
    minutes: 7,
    sections: <LessonSection>[
      LessonSection(
        'Pick a landmark first',
        'Before rotating anything, choose one feature you can track: the longest edge, a single notch, an off centre tab, a chamfered corner. Landmarks survive rotation and they do not survive being disguised as a different piece.',
        bullets: <String>[
          'A long edge stays long through any rotation, so length is the safest landmark of all.',
          'A notch on one side stays on that side, and only its compass direction changes.',
          'An off centre feature stays off centre, which eliminates any choice that centres it.',
          'Count corners or edges first, then confirm with the landmark.',
        ],
      ),
      LessonSection(
        'Rotate, never flip',
        'A rotation keeps the piece the same handedness and a mirror image does not. The writers rely on this, because a mirrored version of the right piece looks almost correct and is always wrong.',
        bullets: <String>[
          'Turn the paper a quarter turn clockwise, which is the cheapest test available to you.',
          'A piece that only fits after an imagined flip is a mirror image, so it is not the answer.',
          'A quarter turn moves a feature at the top to one side, and two quarter turns move it to the bottom.',
          'A notch at the top left lands at the top right after a single clockwise quarter turn.',
        ],
      ),
      LessonSection(
        'Eliminate by feature, not by whole picture',
        'Comparing whole figures is slow and forgiving of errors. Comparing one feature at a time is fast and unforgiving, which is what you want.',
        bullets: <String>[
          'Look for the piece that is wrong before deciding which choice is right.',
          'Test the most distinctive feature first, because one mismatch kills an entire choice.',
          'Compare one piece at a time across all the choices, never one choice at a time.',
          'When the outline looks right and the holes look wrong, trust the holes.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A bracket is L shaped, with a long arm of 3 units and a short arm of 1 unit meeting at a right angle. The long arm points up and the short arm points right from the top. The bracket is turned 90 degrees clockwise. Where do the arms point?',
        steps: <String>[
          'Track the long arm as the landmark. A quarter turn clockwise takes a line pointing up and makes it point right.',
          'The short arm pointed right, and a quarter turn clockwise takes a line pointing right and makes it point down.',
          'The two arms still meet at a right angle, so the shape is unchanged and only the directions moved.',
        ],
        answer: 'Long arm points right and short arm points down, still at a right angle.',
      ),
      WorkedExample(
        prompt: 'A rectangular plate has one chamfered corner at the top left and a small hole near the bottom right. The plate is turned 180 degrees. A choice shows the chamfer at the bottom left with the hole at the top right. What is the verdict?',
        steps: <String>[
          'A half turn sends every feature to the diagonally opposite corner, so the chamfer belongs at the bottom right and the hole at the top left.',
          'The choice has swapped the diagonal, which is exactly what a mirror image does and what a rotation cannot do.',
          'The chamfer is the distinctive feature, so check it first and the whole choice is decided.',
        ],
        answer: 'The choice is a mirror image, so it is wrong; the correct plate has the chamfer bottom right.',
      ),
      WorkedExample(
        prompt: 'A piece is a square with a single dot in its top right corner. It is turned 90 degrees counter clockwise. Where does the dot end up?',
        steps: <String>[
          'Fix one reference point and turn it, rather than turning the whole picture in your head.',
          'A quarter turn counter clockwise carries the top right corner around to the top left.',
          'Check with a second point if the piece has one: top left would go to bottom left, and the whole square stays a square.',
        ],
        answer: 'The top left corner.',
      ),
    ],
    quickRules: <String>[
      'Physically rotate the paper, because it costs nothing.',
      'A mirror image is never the answer, however close the outline looks.',
      'Track one landmark, usually the longest edge.',
      'Compare one feature across all choices rather than one choice at a time.',
    ],
    pitfalls: <String>[
      'Accepting the choice that only fits after an imagined flip, which is the mirror image and is wrong every time it appears.',
      'Comparing whole figures at once, which lets a matching outline disguise a mirrored piece and burns two minutes on one item.',
      'Ignoring a corner that must have moved after a half turn, which leaves you confident in a choice whose chamfer sits in the wrong diagonal.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'The bottom right corner, which is where a clockwise quarter turn puts it.',
        why: 'Clockwise and counter clockwise are opposite turns. Counter clockwise from top right lands at top left.',
      ),
      CommonMistake(
        answer: 'The bottom left corner, which is half a turn away.',
        why: 'Bottom left is where a 180 degree turn sends the dot. A 90 degree counter clockwise turn stops at the top left.',
      ),
    ],
  ),
  Lesson(
    skillId: 'ao.pieces',
    title: 'Piece inventory: count before you build',
    hook: 'Most assembling objects items are decided by counting, not by imagining the build.',
    whyItMatters: 'Assembling Objects rewards a fixed counting routine, and the piece count answers items that imagination gets wrong under time pressure.',
    minutes: 7,
    sections: <LessonSection>[
      LessonSection(
        'Take the inventory first',
        'Before you look at a single answer choice, tally what you were given: how many of each size and shape, any holes or tabs, and which pieces are duplicates. You now hold a checklist and the choices are the suspects.',
        bullets: <String>[
          'Two identical pieces means the finished figure must contain two of that shape.',
          'One of a kind pieces are the fastest elimination tool you have.',
          'Record holes, tabs and cut corners, because they survive assembly and are easy to miscount.',
          'The largest piece usually sets the outline, so find it in every choice before anything else.',
        ],
      ),
      LessonSection(
        'Substitution, the usual trick',
        'The common wrong answer is not a missing piece, it is a piece that looks right and is not. Same shape with a different length is the favourite, because your eye checks the shape and skips the length.',
        bullets: <String>[
          'Check the longest piece in each choice against the original for length, not just for shape.',
          'Check that a right angle is still a right angle, since a slightly acute angle is a substitution.',
          'Check the number of identical pieces, because a choice using three of a part you were given twice is wrong.',
          'If a piece in the choice has a notch the original did not, that choice is finished.',
        ],
      ),
      LessonSection(
        'Build only what you must',
        'You do not need to assemble the whole figure. A fixed order of checks gets you to one answer without ever completing a build.',
        bullets: <String>[
          'Assemble the largest piece plus one neighbour, which usually eliminates two choices.',
          'Work in the same order every time: largest piece, then the distinctive piece, then the count.',
          'If two choices survive, the count decides, because counting is exact where imagination is not.',
          'Never spend more than a quarter of the item time on any single piece.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'The stem shows two long rectangles, one short rectangle and one right triangle. Choice A uses two long rectangles, one short rectangle and one right triangle. Choice B uses three long rectangles and one right triangle. What eliminates Choice B?',
        steps: <String>[
          'Inventory the stem: two long rectangles, one short rectangle, one right triangle.',
          'Count Choice B: three long rectangles and a triangle, so it has one long piece too many and no short piece at all.',
          'A piece you were never given cannot appear in the answer, and the missing short piece also leaves a gap in the fill.',
        ],
        answer:
            'Choice B needs a third long piece that the stem never gave you.',
      ),
      WorkedExample(
        prompt: 'The stem gives a large square panel and a narrow strip exactly as long as one side of the panel. A choice shows the strip along that side but noticeably shorter. What is the verdict?',
        steps: <String>[
          'The strip is one of a kind, so it is the distinctive piece and gets checked first.',
          'Length is the property that was substituted, which is the most common substitution on this subtest.',
          'Rotation would never shorten the strip, so the mismatch disqualifies the choice outright.',
        ],
        answer: 'It is a wrong choice, because the strip was swapped for a shorter one.',
      ),
      WorkedExample(
        prompt: 'The pieces are two identical rectangles, each twice as long as it is wide. A choice shows a square whose side equals the long side of one rectangle. Can it be built?',
        steps: <String>[
          'Take the inventory: two rectangles, each 2 by 1.',
          'Lay them with their long edges together and the outline is a square 2 by 2.',
          'Nothing was cut, flipped or left over, so the choice stands.',
        ],
        answer: 'Yes, with the two rectangles laid long edge to long edge.',
      ),
    ],
    quickRules: <String>[
      'Tally the pieces before you look at the answer choices.',
      'One of a kind pieces eliminate fastest.',
      'Same shape with the wrong length is the most common substitution.',
      'When imagination stalls, count.',
    ],
    pitfalls: <String>[
      'Chasing the outline and ignoring the interior, so a choice that fills the big shape with three copies of a piece you were given twice looks correct and is not.',
      'Accepting a lookalike piece without checking its length, which is the substitution the writers bank on and the most common lost point here.',
      'Building every figure completely in your head, which eats the section time; checking two pieces is normally enough.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer: 'No, because two rectangles can never make a square.',
        why: 'Two copies of the same rectangle meeting along their long edges close up into a square whose side is the long side.',
      ),
      CommonMistake(
        answer: 'Yes, but only if one rectangle is trimmed to fit.',
        why: 'Trimmed pieces are not the pieces you were given. Both whole rectangles fit, so no trimming is needed.',
      ),
    ],
  ),
];
