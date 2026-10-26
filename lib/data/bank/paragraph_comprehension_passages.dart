import '../models/catalog.dart';
import '../models/question.dart';

/// Paragraph Comprehension: five passages, three questions each.
///
/// Every passage here was written for this app. Nothing is quoted from an
/// official ASVAB form or from a commercial study guide, and no item claims to
/// be a released exam question.
///
/// The subtest always presents a passage with a question about it, so each item
/// carries its own copy of the text and the three questions on one passage ask
/// three different things - main idea, detail, inference, purpose, vocabulary
/// or sequence - instead of testing the same reading twice.
///
/// Test-taker evidence shapes the distractors: the attractive option is the
/// polished, sweeping generalisation and the key is the modest detail the
/// passage actually supports. Every item here is authored to that rule, and
/// bank_audit.dart fails an item whose correct option is visibly the longest.
final List<Question> readingPassageBank = <Question>[
  // --- passage one: oil analysis ------------------------------------------
  Question(
    id: 'pc-p01',
    subtest: Subtest.pc,
    passage:
        'An oil sample drawn from an engine tells only half a story. The '
        'laboratory reports the metals it finds, but a single reading cannot '
        'say whether iron is rising or falling; only a series of samples shows '
        'the trend. A maintenance section that samples every hundred hours '
        'learns how fast an engine normally wears, and then a small jump is '
        'visible against that baseline. The same section usually keeps the '
        'dates of its samples on the work order rather than in a separate log, '
        'because a trend line is worthless if it cannot be matched to the hours '
        'on the engine.',
    stem: 'Which statement best expresses the main point of the passage?',
    choices: <String>[
      'every engine in a section is sampled on the same schedule so that the results can be compared with one another',
      'a sample is worth reading only against earlier samples from the same engine',
      'the laboratory identifies every metal that is present in the sample',
      'the readings are kept apart from the hours recorded on the work order',
    ],
    answerIndex: 1,
    explanation:
        'The passage makes one point and supports it twice: a single reading '
        'cannot show a trend, so the samples are compared with the engine own '
        'baseline and matched to its hours. The option about sampling every '
        'engine on one schedule sounds well organised, but the passage says '
        'the opposite - the comparison is against the same engine, not across '
        'a fleet. What the laboratory reports and where the dates are kept are '
        'details that serve the point rather than the point itself.',
    difficulty: Difficulty.medium,
    skills: <String>['pc.mainidea'],
  ),
  Question(
    id: 'pc-p02',
    subtest: Subtest.pc,
    passage:
        'An oil sample drawn from an engine tells only half a story. The '
        'laboratory reports the metals it finds, but a single reading cannot '
        'say whether iron is rising or falling; only a series of samples shows '
        'the trend. A maintenance section that samples every hundred hours '
        'learns how fast an engine normally wears, and then a small jump is '
        'visible against that baseline. The same section usually keeps the '
        'dates of its samples on the work order rather than in a separate log, '
        'because a trend line is worthless if it cannot be matched to the hours '
        'on the engine.',
    stem:
        'According to the passage, where does a section usually record the '
        'dates of its samples?',
    choices: <String>[
      'on the work order for the job',
      'in a separate log book kept for the purpose',
      'on the report the laboratory returns',
      'on a tag wired to the dipstick',
    ],
    answerIndex: 0,
    explanation:
        'The passage says the dates are kept on the work order rather than in a '
        'separate log, and gives the reason: the readings have to be tied to '
        'the hours on the engine. A separate log is exactly what the text rules '
        'out. The laboratory report and a tag on the dipstick are plausible '
        'places to write a date, but the passage never mentions either.',
    difficulty: Difficulty.easy,
    skills: <String>['pc.detail'],
  ),
  Question(
    id: 'pc-p03',
    subtest: Subtest.pc,
    passage:
        'An oil sample drawn from an engine tells only half a story. The '
        'laboratory reports the metals it finds, but a single reading cannot '
        'say whether iron is rising or falling; only a series of samples shows '
        'the trend. A maintenance section that samples every hundred hours '
        'learns how fast an engine normally wears, and then a small jump is '
        'visible against that baseline. The same section usually keeps the '
        'dates of its samples on the work order rather than in a separate log, '
        'because a trend line is worthless if it cannot be matched to the hours '
        'on the engine.',
    stem: 'The passage implies that a single sample is of limited use because',
    choices: <String>[
      'laboratories cannot measure iron accurately enough to be trusted',
      'it does not show which way a reading is moving',
      'samples drawn on different dates cannot be compared with one another',
      'a section rarely has the equipment needed to draw one',
    ],
    answerIndex: 1,
    explanation:
        'The second sentence gives the reason: one reading cannot say whether a '
        'metal is rising or falling, so only a series shows the trend. The '
        'option claiming samples cannot be compared is the reverse of the '
        'passage, which builds its whole case on comparing them. Nothing is '
        'said about laboratory accuracy or about who owns the sampling '
        'equipment.',
    difficulty: Difficulty.medium,
    skills: <String>['pc.inference'],
  ),

  // --- passage two: depot layout ------------------------------------------
  Question(
    id: 'pc-p04',
    subtest: Subtest.pc,
    passage:
        'The fastest way to load a truck is rarely the fastest way to load the '
        'next one. A warehouse that stores its heaviest and least frequently '
        'requested items at the back forces pickers to walk the length of the '
        'building for a pallet, and the walk repeats on every order that needs '
        'one. Most depots therefore rank stock by how often it is touched '
        'rather than by how much space it takes, and put the items that leave '
        'most often nearest the door. The saving is measured in steps, and '
        'steps are measured in the minutes a truck sits at the dock.',
    stem:
        'According to the passage, items that leave a depot most often are '
        'stored',
    choices: <String>[
      'at the back, where the heaviest pallets go',
      'in whichever bay has the most free floor space',
      'wherever the oldest stock is already sitting',
      'nearest the door the trucks load from',
    ],
    answerIndex: 3,
    explanation:
        'The passage states it plainly: the items that leave most often go '
        'nearest the door. The heaviest and least requested stock is what sits '
        'at the back, so that option reverses the passage. Free floor space and '
        'the age of the stock are sensible depot considerations that the '
        'paragraph never raises.',
    difficulty: Difficulty.easy,
    skills: <String>['pc.detail'],
  ),
  Question(
    id: 'pc-p05',
    subtest: Subtest.pc,
    passage:
        'The fastest way to load a truck is rarely the fastest way to load the '
        'next one. A warehouse that stores its heaviest and least frequently '
        'requested items at the back forces pickers to walk the length of the '
        'building for a pallet, and the walk repeats on every order that needs '
        'one. Most depots therefore rank stock by how often it is touched '
        'rather than by how much space it takes, and put the items that leave '
        'most often nearest the door. The saving is measured in steps, and '
        'steps are measured in the minutes a truck sits at the dock.',
    stem: 'Which statement best states the main idea of the passage?',
    choices: <String>[
      'pallet trucks should be replaced with powered equipment wherever the budget allows it',
      'stock should be ranked by how often it is picked, not by how much room it needs',
      'warehouse layout should be designed so that trucks never wait at the dock, which keeps both labour and equipment costs down over a full season',
      'heavy pallets are the main cause of slow loading at a busy depot',
    ],
    answerIndex: 1,
    explanation:
        'The paragraph is built around one decision - rank stock by how often '
        'it is touched rather than by how much space it takes - and then '
        'measures the benefit in steps. The long option about a layout where '
        'trucks never wait sounds like the considered summary, but the passage '
        'promises shorter walks, not a dock with no queue, and it says nothing '
        'about labour or equipment costs. Heavy pallets are one symptom in one '
        'example, and no equipment purchase is proposed.',
    difficulty: Difficulty.medium,
    skills: <String>['pc.mainidea'],
  ),
  Question(
    id: 'pc-p06',
    subtest: Subtest.pc,
    passage:
        'The fastest way to load a truck is rarely the fastest way to load the '
        'next one. A warehouse that stores its heaviest and least frequently '
        'requested items at the back forces pickers to walk the length of the '
        'building for a pallet, and the walk repeats on every order that needs '
        'one. Most depots therefore rank stock by how often it is touched '
        'rather than by how much space it takes, and put the items that leave '
        'most often nearest the door. The saving is measured in steps, and '
        'steps are measured in the minutes a truck sits at the dock.',
    stem: 'The statement that the saving is measured in steps suggests that',
    choices: <String>[
      'shorter walks at the depot shorten the time a truck waits',
      'pickers should be paid according to the distance they walk',
      'steps and loading times are unrelated measures of depot work',
      'a depot that saves steps must spend more on pallet trucks',
    ],
    answerIndex: 0,
    explanation:
        'The last sentence ties steps to the minutes a truck spends at the '
        'dock, which is the reason a shorter walk is worth anything at all. '
        'Saying the two measures are unrelated contradicts that link. Nothing '
        'is said about how pickers are paid or about money spent on equipment, '
        'so those options sound practical but are not in the text.',
    difficulty: Difficulty.medium,
    skills: <String>['pc.inference'],
  ),

  // --- passage three: compass declination ---------------------------------
  Question(
    id: 'pc-p07',
    subtest: Subtest.pc,
    passage:
        'A compass needle points at magnetic north, which is not the same place '
        'as the north printed on a map. The angle between the two is called '
        'declination, and in most of the United States it is a few degrees in '
        'one direction or the other. A few degrees is enough to miss a '
        'checkpoint by hundreds of meters after a long leg, so the correction '
        'is applied before the march rather than during it. Soldiers are taught '
        'to convert the bearing once, write it down, and follow the written '
        'number; recomputing it at each halt is how a patrol acquires a second '
        'error on top of the first.',
    stem: 'In the passage, the word declination refers to',
    choices: <String>[
      'the height of a checkpoint above the level of the sea',
      'the distance a patrol covers between one halt and the next',
      'the angle between magnetic north and the north on the map',
      'the slow wander of a compass needle as a patrol moves between checkpoints',
    ],
    answerIndex: 2,
    explanation:
        'The passage defines the word in its second sentence: the angle between '
        'magnetic north and the north printed on the map. The long option about '
        'a needle wandering is the sort of technical-sounding explanation that '
        'is easy to accept, but the text attributes no wander to the needle; '
        'the difference is between two norths. Elevation and distance are '
        'map-reading quantities the passage never connects to the word.',
    difficulty: Difficulty.medium,
    skills: <String>['pc.vocabulary'],
  ),
  Question(
    id: 'pc-p08',
    subtest: Subtest.pc,
    passage:
        'A compass needle points at magnetic north, which is not the same place '
        'as the north printed on a map. The angle between the two is called '
        'declination, and in most of the United States it is a few degrees in '
        'one direction or the other. A few degrees is enough to miss a '
        'checkpoint by hundreds of meters after a long leg, so the correction '
        'is applied before the march rather than during it. Soldiers are taught '
        'to convert the bearing once, write it down, and follow the written '
        'number; recomputing it at each halt is how a patrol acquires a second '
        'error on top of the first.',
    stem:
        'According to the passage, when is the correction applied to the '
        'bearing?',
    choices: <String>[
      'at each halt along the route',
      'after the first checkpoint has been reached',
      'whenever the compass needs to be checked',
      'once, before the march begins',
    ],
    answerIndex: 3,
    explanation:
        'The passage says the correction is applied before the march rather '
        'than during it, and the last sentence repeats the order of work: '
        'convert once, write it down, follow the written number. Converting at '
        'each halt is named as the mistake that adds a second error, and the '
        'passage gives no rule about waiting for a checkpoint or about '
        'checking the compass.',
    difficulty: Difficulty.easy,
    skills: <String>['pc.sequence'],
  ),
  Question(
    id: 'pc-p09',
    subtest: Subtest.pc,
    passage:
        'A compass needle points at magnetic north, which is not the same place '
        'as the north printed on a map. The angle between the two is called '
        'declination, and in most of the United States it is a few degrees in '
        'one direction or the other. A few degrees is enough to miss a '
        'checkpoint by hundreds of meters after a long leg, so the correction '
        'is applied before the march rather than during it. Soldiers are taught '
        'to convert the bearing once, write it down, and follow the written '
        'number; recomputing it at each halt is how a patrol acquires a second '
        'error on top of the first.',
    stem:
        'The passage suggests that converting the bearing again at every halt '
        'would',
    choices: <String>[
      'make no difference to the patrol once the first leg is complete',
      'leave the patrol with a second error stacked on the first',
      'guarantee that the patrol arrives at the wrong checkpoint',
      'simplify the arithmetic for soldiers who are already tired',
    ],
    answerIndex: 1,
    explanation:
        'The final sentence says recomputing at each halt is how a patrol '
        'acquires a second error on top of the first, so the implied result is '
        'cumulative error rather than a correction. Guaranteeing a wrong '
        'checkpoint overstates it: the passage describes an added error, not a '
        'certain miss. It also never suggests that repeated arithmetic is '
        'easier for a tired soldier, and it does clearly claim a difference.',
    difficulty: Difficulty.hard,
    skills: <String>['pc.inference'],
  ),

  // --- passage four: the unread binder ------------------------------------
  Question(
    id: 'pc-p10',
    subtest: Subtest.pc,
    passage:
        'Every unit has a binder of standing operating procedures that nobody '
        'opens until something goes wrong, and then everyone discovers it is '
        'three revisions out of date. The problem is not that procedures are '
        'written down. It is that a document which is never used in the '
        'ordinary week is never corrected in the ordinary week either, so the '
        'errors accumulate quietly and are found at the worst possible moment. '
        'A page that is consulted daily is corrected every time it misleads '
        'someone. A page that is consulted once a year has a year of '
        'uncorrected mistakes standing behind it, and by then the person '
        'reading it has no way to tell which parts worked the last time.',
    stem: 'What is the main point the author is making?',
    choices: <String>[
      'a procedure that is never used is never corrected, so its errors pile up quietly',
      'standing operating procedures should be kept in a binder that is replaced in full every year',
      'units should rewrite their procedures whenever a new commander takes over the section',
      'written procedures are less dependable than the habits of experienced soldiers',
    ],
    answerIndex: 0,
    explanation:
        'The passage turns on one observation: a page nobody uses is a page '
        'nobody corrects, so its mistakes are found late. The option about '
        'replacing the binder annually is the polished administrative fix, but '
        'the author never proposes a review cycle, a commander handover or any '
        'other remedy. The claim that habits beat written procedures is the '
        'opposite of the author position, which opens by saying the problem is '
        'not that procedures are written down.',
    difficulty: Difficulty.medium,
    skills: <String>['pc.mainidea'],
  ),
  Question(
    id: 'pc-p11',
    subtest: Subtest.pc,
    passage:
        'Every unit has a binder of standing operating procedures that nobody '
        'opens until something goes wrong, and then everyone discovers it is '
        'three revisions out of date. The problem is not that procedures are '
        'written down. It is that a document which is never used in the '
        'ordinary week is never corrected in the ordinary week either, so the '
        'errors accumulate quietly and are found at the worst possible moment. '
        'A page that is consulted daily is corrected every time it misleads '
        'someone. A page that is consulted once a year has a year of '
        'uncorrected mistakes standing behind it, and by then the person '
        'reading it has no way to tell which parts worked the last time.',
    stem: 'The tone of the passage is best described as',
    choices: <String>[
      'cheerful and optimistic about how procedures improve',
      'formal and strictly technical',
      'wry and a little resigned',
      'hostile toward the soldiers who write procedures',
    ],
    answerIndex: 2,
    explanation:
        'The opening image - a binder nobody opens until something goes wrong - '
        'and the dry phrase about the worst possible moment show a wry, '
        'resigned observer, and the author includes the unit rather than '
        'attacking anyone. The passage explains a habit, so it is not merely '
        'technical, and there is no optimism about procedures improving. '
        'Nobody is blamed, which rules out hostility.',
    difficulty: Difficulty.medium,
    skills: <String>['pc.purpose'],
  ),
  Question(
    id: 'pc-p12',
    subtest: Subtest.pc,
    passage:
        'Every unit has a binder of standing operating procedures that nobody '
        'opens until something goes wrong, and then everyone discovers it is '
        'three revisions out of date. The problem is not that procedures are '
        'written down. It is that a document which is never used in the '
        'ordinary week is never corrected in the ordinary week either, so the '
        'errors accumulate quietly and are found at the worst possible moment. '
        'A page that is consulted daily is corrected every time it misleads '
        'someone. A page that is consulted once a year has a year of '
        'uncorrected mistakes standing behind it, and by then the person '
        'reading it has no way to tell which parts worked the last time.',
    stem:
        'According to the passage, a page that is consulted daily is corrected',
    choices: <String>[
      'once a year, when the whole binder is reviewed',
      'only after an inspection has found the error',
      'whenever a new edition of the manual is printed',
      'each time it misleads the person using it',
    ],
    answerIndex: 3,
    explanation:
        'The passage states that a page consulted daily is corrected every time '
        'it misleads someone, and contrasts that with a page consulted once a '
        'year. Annual review, inspection findings and new editions are all '
        'plausible ways for a manual to change, but each of them contradicts '
        'the pattern the author describes, which depends on the page being used '
        'often enough to catch its own errors.',
    difficulty: Difficulty.medium,
    skills: <String>['pc.detail'],
  ),

  // --- passage five: preparing steel for paint -----------------------------
  Question(
    id: 'pc-p13',
    subtest: Subtest.pc,
    passage:
        'Paint fails from the steel outward. A hull painted over mill scale '
        'will lose the paint in sheets, because the scale flakes and takes the '
        'coating with it, so the surface is prepared before any paint is '
        'opened. Preparation runs in a fixed order: remove the scale and the '
        'old coating, wash off the salt, let the steel dry, and only then apply '
        'the first coat. Skipping the wash is the most common shortcut and the '
        'most expensive one, since salt left under a sound-looking coat keeps '
        'drawing moisture and starts the rust that the paint was meant to stop. '
        'Each coat then goes on before the last one has cured hard, so the '
        'layers can bond.',
    stem:
        'According to the passage, what is done immediately after the salt is '
        'washed off?',
    choices: <String>[
      'the first coat of paint is applied',
      'the steel is allowed to dry',
      'the mill scale is removed from the plate',
      'the old coating is inspected for cracks',
    ],
    answerIndex: 1,
    explanation:
        'The passage gives the order of work explicitly: remove the scale and '
        'the old coating, wash off the salt, let the steel dry, and only then '
        'apply the first coat. Painting therefore comes two steps after the '
        'wash rather than one, which is what makes that option tempting. '
        'Removing mill scale happens first in the sequence, and inspecting the '
        'old coating for cracks appears nowhere in the passage.',
    difficulty: Difficulty.medium,
    skills: <String>['pc.sequence'],
  ),
  Question(
    id: 'pc-p14',
    subtest: Subtest.pc,
    passage:
        'Paint fails from the steel outward. A hull painted over mill scale '
        'will lose the paint in sheets, because the scale flakes and takes the '
        'coating with it, so the surface is prepared before any paint is '
        'opened. Preparation runs in a fixed order: remove the scale and the '
        'old coating, wash off the salt, let the steel dry, and only then apply '
        'the first coat. Skipping the wash is the most common shortcut and the '
        'most expensive one, since salt left under a sound-looking coat keeps '
        'drawing moisture and starts the rust that the paint was meant to stop. '
        'Each coat then goes on before the last one has cured hard, so the '
        'layers can bond.',
    stem: 'The central point of the passage is that',
    choices: <String>[
      'salt is the single most destructive substance a steel hull ever meets',
      'paint should be applied in thin coats and allowed to cure hard between them',
      'the order of preparing the surface decides whether the paint holds',
      'mill scale does no harm once a coat of paint has covered it',
    ],
    answerIndex: 2,
    explanation:
        'The passage opens by saying paint fails from the steel outward and '
        'then spends its length on the order of preparation, which is the point '
        'the salt example is there to prove. Calling salt the most destructive '
        'substance goes beyond the text, which names it as the most common '
        'shortcut. The passage wants each coat laid on before the last has '
        'cured hard, the reverse of the curing option, and it says mill scale '
        'flakes the coating off rather than being harmless.',
    difficulty: Difficulty.hard,
    skills: <String>['pc.mainidea'],
  ),
  Question(
    id: 'pc-p15',
    subtest: Subtest.pc,
    passage:
        'Paint fails from the steel outward. A hull painted over mill scale '
        'will lose the paint in sheets, because the scale flakes and takes the '
        'coating with it, so the surface is prepared before any paint is '
        'opened. Preparation runs in a fixed order: remove the scale and the '
        'old coating, wash off the salt, let the steel dry, and only then apply '
        'the first coat. Skipping the wash is the most common shortcut and the '
        'most expensive one, since salt left under a sound-looking coat keeps '
        'drawing moisture and starts the rust that the paint was meant to stop. '
        'Each coat then goes on before the last one has cured hard, so the '
        'layers can bond.',
    stem:
        'The passage implies that a coat applied over salt left on the steel '
        'will',
    choices: <String>[
      'look sound while rust spreads underneath it',
      'flake off in sheets within a season of launching',
      'cure harder than a coat applied to clean steel',
      'make the next coat of paint unnecessary',
    ],
    answerIndex: 0,
    explanation:
        'The passage describes salt under a sound-looking coat drawing moisture '
        'and starting rust, so the implied result is a coat that appears sound '
        'while the steel beneath it corrodes. Flaking in sheets is what mill '
        'scale does, which is a different failure in this passage. Nothing is '
        'said about the coat curing harder, and one coat does not remove the '
        'need for the next.',
    difficulty: Difficulty.hard,
    skills: <String>['pc.inference'],
  ),
];
