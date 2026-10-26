import '../models/catalog.dart';
import '../models/question.dart';

/// Word Knowledge bank. Mirrors the real subtest: a word either standing alone
/// or underlined in a sentence, with four distractors chosen from the same
/// register so the answer cannot be spotted by length or tone.
const List<Question> wordKnowledgeBank = <Question>[
  Question(
    id: 'wk-001',
    subtest: Subtest.wk,
    stem:
        'The supply sergeant kept an ABUNDANT stock of batteries in the conex.',
    choices: <String>['plentiful', 'damaged', 'borrowed', 'outdated'],
    answerIndex: 0,
    choiceNotes: <String>[
      'Abundant means present in large quantity, and plentiful is the word that names exactly that.',
      'Damaged reads quantity as condition; surplus stock is often worn, but the word says only that there is a lot.',
      'Borrowed confuses the stock on the shelves with the paperwork behind it, and nothing here is on loan.',
      'Outdated fits old surplus stock, a tempting assumption, but abundance measures how much rather than how old.',
    ],
    explanation:
        'Abundant means present in large quantity, so plentiful is the closest '
        'meaning. Outdated and damaged are tempting because surplus stock is often old, but '
        'neither word means "a lot of".',
    difficulty: Difficulty.easy,
    skills: <String>['wk.context', 'wk.academic'],
  ),
  Question(
    id: 'wk-002',
    subtest: Subtest.wk,
    stem: 'OBSTINATE',
    choices: <String>['flexible', 'stubborn', 'cautious', 'curious'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Flexible is the direct antonym, so it goes the moment you know obstinate means refusing to bend.',
      'Obstinate describes holding a position and refusing to move, which is exactly what stubborn names.',
      'Cautious concerns care about risk, and obstinacy concerns will, so the two traits are unrelated.',
      'Curious describes wanting to know things, and obstinate describes refusing to change a mind.',
    ],
    explanation:
        'Obstinate means refusing to change a position or course of action, which is '
        'stubborn. Flexible is the direct opposite, and cautious and curious describe '
        'different traits entirely.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.synonym'],
  ),
  Question(
    id: 'wk-003',
    subtest: Subtest.wk,
    stem: 'The commander was CANDID about the unit shortfalls during the briefing.',
    choices: <String>['dishonest', 'hesitant', 'frank', 'confused'],
    answerIndex: 2,
    choiceNotes: <String>[
      'Dishonest is the opposite; candid speech may sting, but it is the absence of concealment.',
      'Hesitant comes close because a candid speaker may pause, yet the word names directness rather than delay.',
      'Candid means saying exactly what you think, and frank is the plain English word for that.',
      'Confused describes an unclear mind, and this commander knew the shortfalls well enough to name them.',
    ],
    explanation:
        'Candid means honest and direct, so frank fits. Dishonest is the opposite, '
        'and someone who is candid is not being hesitant - they are saying exactly what they '
        'think.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.context', 'wk.academic'],
  ),
  Question(
    id: 'wk-004',
    subtest: Subtest.wk,
    stem: 'CURTAIL',
    choices: <String>['extend', 'postpone', 'cancel', 'shorten'],
    answerIndex: 3,
    choiceNotes: <String>[
      'Extend reverses the word: curtailing cuts a thing short instead of lengthening it.',
      'Postpone moves something later in time without shortening it, which is delay rather than curtailment.',
      'Cancel is too strong, since curtailing trims a programme that still goes ahead.',
      'To curtail is to cut short, and this option names that reduction without claiming the thing is gone.',
    ],
    explanation:
        'To curtail something is to cut it short, so shorten is the match. Cancel is '
        'too strong, since curtailing does not remove the thing, and extend is its opposite.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.synonym'],
  ),
  Question(
    id: 'wk-005',
    subtest: Subtest.wk,
    stem: 'The word INAUDIBLE most nearly means',
    choices: <String>[
      'not able to be heard',
      'not able to be seen',
      'difficult to repeat',
      'spoken in anger',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'The prefix in- means not and the root audire means hear, so this option matches both parts.',
      'That is in- plus videre, the root of invisible, so the option swaps sight for hearing.',
      'Nothing in the word concerns repetition, since audibility is about whether sound reaches the ear at all.',
      'Tone of voice is not in the word, and a remark can be inaudible whether whispered kindly or shouted.',
    ],
    explanation:
        'The prefix in- means not and the root audire means to hear, so inaudible '
        'means not able to be heard. The same root gives you audience and audio, which is the '
        'clue that identifies the answer without memorising the word.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.roots'],
  ),
  Question(
    id: 'wk-006',
    subtest: Subtest.wk,
    stem: 'METICULOUS',
    choices: <String>['careless', 'very careful', 'very slow', 'overconfident'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Careless is the antonym, so it is the first option to cut when meticulous means showing great care.',
      'Meticulous means showing great attention to detail, and this option states that quality plainly.',
      'Slow is a possible side effect, and careful work can be quick, because the word names attention, not pace.',
      'Overconfidence is a separate fault, and meticulous workers usually distrust their own memory.',
    ],
    explanation:
        'Meticulous means showing great attention to detail, so very careful is '
        'correct. Very slow is a possible side effect of being meticulous, not its meaning - '
        'a trap when a distractor describes a consequence instead of a definition.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.synonym', 'wk.academic'],
  ),
  Question(
    id: 'wk-007',
    subtest: Subtest.wk,
    stem: 'TENACIOUS',
    choices: <String>['weak', 'persistent', 'generous', 'quiet'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Weak is the antonym of tenacity, which describes holding firm rather than giving way.',
      'Tenacious means holding firmly to an effort, so this option names that refusal to let go.',
      'Generosity is unrelated, and the ten- root means to hold, as it also does in tenant and retain.',
      'Quietness says nothing about resolve, and a tenacious person can be loud or silent.',
    ],
    explanation:
        'Tenacious describes holding firmly to a position or effort, so persistent '
        'is the match. The root ten- meaning to hold also appears in tenant and retain.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.synonym', 'wk.roots'],
  ),
  Question(
    id: 'wk-008',
    subtest: Subtest.wk,
    stem: 'ARDUOUS',
    choices: <String>['brief', 'dangerous', 'difficult', 'unnecessary'],
    answerIndex: 2,
    choiceNotes: <String>[
      'Brief describes duration, and arduous work can take minutes or months.',
      'Dangerous adds a threat the word does not carry, since arduous means demanding effort, perilous or not.',
      'Arduous means requiring great effort, and this option is the plainest match for that demand.',
      'Unnecessary confuses hard work with wasted work, and arduous tasks are often essential.',
    ],
    explanation:
        'Arduous means requiring great effort, so difficult is correct. Danger and '
        'duration are separate ideas; an arduous climb is demanding whether or not it is '
        'perilous.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.synonym', 'wk.academic'],
  ),
  Question(
    id: 'wk-009',
    subtest: Subtest.wk,
    stem: 'The instructions were AMBIGUOUS, so the squad completed the task twice.',
    choices: <String>['unclear', 'incorrect', 'lengthy', 'insulting'],
    answerIndex: 0,
    choiceNotes: <String>[
      'Ambiguous means open to more than one reading, and this option names that quality directly.',
      'Incorrect mistakes vagueness for error, and the instructions can be accurate and still confusing.',
      'Lengthy describes size, and the squad repeated the task because the meaning was uncertain.',
      'Insulting describes tone, and the second half of the sentence reports a repeat, not hurt feelings.',
    ],
    explanation:
        'Ambiguous means open to more than one interpretation, so unclear is the '
        'answer. The word says nothing about being wrong or long, which is why the second '
        'half of the sentence matters: the squad did the work twice because they could not '
        'tell what was asked.',
    difficulty: Difficulty.easy,
    skills: <String>['wk.context'],
  ),
  Question(
    id: 'wk-010',
    subtest: Subtest.wk,
    stem: 'FUTILE',
    choices: <String>['energetic', 'useless', 'expensive', 'final'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Energetic describes effort spent, and futile describes effort that produces nothing however energetic.',
      'Futile means producing no useful result, and this option says exactly that.',
      'Expensive is about cost, and a cheap attempt can be every bit as futile.',
      'Final is a trap, because futile work often ends an effort, but the word names lack of effect, not of successor.',
    ],
    explanation:
        'Futile means producing no useful result, so useless is correct. Final is a '
        'trap because something futile often IS the end of an effort, but the word describes '
        'lack of effect, not lack of a successor.',
    difficulty: Difficulty.easy,
    skills: <String>['wk.synonym'],
  ),
  Question(
    id: 'wk-011',
    subtest: Subtest.wk,
    stem: 'IMPARTIAL',
    choices: <String>['unfair', 'unbiased', 'unprepared', 'unwilling'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Unfair is the opposite, since im- means not and partial means biased, which builds unbiased.',
      'The prefix im- (not) plus partial (biased) builds exactly this option.',
      'Unprepared attaches the same im- to a different root, so it describes readiness instead of bias.',
      'Unwilling describes reluctance to act, and an impartial judge can be very willing to hear a case.',
    ],
    explanation:
        'The prefix im- (not) plus partial (biased) gives unbiased. Note that this '
        'item rewards knowing the prefix rather than knowing the whole word, which is exactly '
        'why the roots strategy pays off.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.roots', 'wk.academic'],
  ),
  Question(
    id: 'wk-012',
    subtest: Subtest.wk,
    stem: 'To SOLICIT a donation means to',
    choices: <String>['refuse', 'repay', 'request', 'record'],
    answerIndex: 2,
    choiceNotes: <String>[
      'Refuse is the antonym, and spotting an antonym is the fastest way to cut an option on a word item.',
      'Repay answers a debt already owed, while soliciting asks for something not yet given.',
      'To solicit is to ask for, and this option is the neutral verb for that asking.',
      'Recording is documenting a request that someone else made, not making one.',
    ],
    explanation:
        'Solicit means to ask for, so request is correct. Refuse is its opposite, '
        'which is the fastest way to eliminate a distractor on word items: check for '
        'antonyms before synonyms.',
    difficulty: Difficulty.easy,
    skills: <String>['wk.synonym'],
  ),
  Question(
    id: 'wk-013',
    subtest: Subtest.wk,
    stem: 'The new procedure should MITIGATE the risk of heat injury.',
    choices: <String>['increase', 'reduce', 'explain', 'predict'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Increase is the opposite, and mitigating makes a risk smaller rather than larger.',
      'To mitigate is to make less severe, and this option names that lowering of a risk.',
      'Explaining a risk leaves it intact, and the sentence says the procedure acts on the risk itself.',
      'Predicting a risk does nothing to it, so the procedure could not be credited with the change.',
    ],
    explanation:
        'To mitigate is to make less severe, so reduce is correct. Increase is the '
        'opposite, and explaining or predicting a risk does nothing to it - the sentence says '
        'the procedure acts on the risk itself.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.context', 'wk.academic'],
  ),
  Question(
    id: 'wk-014',
    subtest: Subtest.wk,
    stem: 'PRUDENT',
    choices: <String>['reckless', 'cautious', 'wealthy', 'friendly'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Reckless is the exact opposite, taking risk where prudent judgement avoids it.',
      'Prudent means showing good judgement about risk, and this option is the closest of the four.',
      'Wealthy is a coincidence of sound rather than meaning, and prudence can belong to someone with nothing.',
      'Friendliness describes manner, and prudence describes judgement about what to risk.',
    ],
    explanation:
        'Prudent means showing good judgement about risk, so cautious is closest. '
        'Reckless is its exact opposite, and wealthy is only a coincidence of the similar '
        'sound in some languages.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.synonym', 'wk.academic'],
  ),
  Question(
    id: 'wk-015',
    subtest: Subtest.wk,
    stem: 'DILIGENT',
    choices: <String>['lazy', 'industrious', 'cheerful', 'educated'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Lazy is the antonym, and diligent means working with steady effort.',
      'Diligent means working with steady effort, which is what this option names.',
      'Cheerful describes mood, and a diligent worker can be grim from start to finish.',
      'Education is never implied, since diligence is about sustained effort rather than credentials.',
    ],
    explanation:
        'Diligent means working with steady effort, so industrious fits. Lazy is the '
        'opposite, and education is not implied by diligence.',
    difficulty: Difficulty.easy,
    skills: <String>['wk.synonym'],
  ),
  Question(
    id: 'wk-016',
    subtest: Subtest.wk,
    stem: 'The briefing was REDUNDANT: the same three points were repeated for an hour.',
    choices: <String>[
      'unnecessarily repetitive',
      'poorly organised',
      'highly classified',
      'too short',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'Redundant means exceeding what is needed, and the hour of repeats supplies that excess.',
      'Poorly organised is a different flaw, and disorganisation can scramble a briefing without repeating it.',
      'Classification decides who may hear a briefing, not how often the points are made.',
      'Too short is the opposite, since an hour of repeats is length the audience did not need.',
    ],
    explanation:
        'Redundant means exceeding what is needed, and the sentence spells out the '
        'repetition as the evidence. Poorly organised is a different flaw that could produce '
        'repetition, but redundancy names the repetition itself.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.context', 'wk.academic'],
  ),
  Question(
    id: 'wk-017',
    subtest: Subtest.wk,
    stem: 'SCRUTINIZE',
    choices: <String>[
      'glance at',
      'examine closely',
      'criticise loudly',
      'copy exactly',
    ],
    answerIndex: 1,
    choiceNotes: <String>[
      'A glance is the opposite of scrutiny, which is detailed inspection.',
      'To scrutinize is to inspect in detail, and this option states that inspection.',
      'Criticism is a separate act, and scrutiny may reveal nothing worth criticising.',
      'Copying may follow an inspection, and scrutinizing does not require making a copy.',
    ],
    explanation:
        'To scrutinize is to inspect in detail, so examine closely is correct. A '
        'glance is the opposite, and criticism or copying are separate actions that scrutiny '
        'may or may not lead to.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.synonym'],
  ),
  Question(
    id: 'wk-018',
    subtest: Subtest.wk,
    stem: 'The word COERCE most nearly means to',
    choices: <String>['persuade gently', 'force', 'assist', 'warn'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Persuasion leaves the choice intact, and coercion is precisely what removes it.',
      'Coercion means compelling someone by threat or pressure, which is what this option names.',
      'Assisting helps the other person act, whereas coercion overrides their will.',
      'A warning supplies information and leaves the decision, so it is not coercion.',
    ],
    explanation:
        'Coercion is compelling someone by threat or pressure, so force is correct. '
        'Persuading gently is the near-trap: persuasion leaves the choice intact, while '
        'coercion removes it.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.synonym', 'wk.academic'],
  ),
  Question(
    id: 'wk-019',
    subtest: Subtest.wk,
    stem: 'To ADVOCATE for a change is to',
    choices: <String>['oppose it', 'support it', 'delay it', 'study it'],
    answerIndex: 1,
    choiceNotes: <String>[
      'To advocate is to argue for something, so opposing it is the reverse of the word.',
      'An advocate argues publicly for a cause, so to advocate is to support it.',
      'Delay is a tactic either side might use, and it is not what the word means.',
      'Studying a change is preparation, and advocacy is the public argument that follows it.',
    ],
    explanation:
        'An advocate argues publicly for a cause, so to advocate is to support. In '
        'legal usage an advocate is the person doing the arguing, not the one objecting.',
    difficulty: Difficulty.easy,
    skills: <String>['wk.synonym'],
  ),
  Question(
    id: 'wk-020',
    subtest: Subtest.wk,
    stem: 'RELUCTANT',
    choices: <String>['eager', 'unwilling', 'unable', 'dishonest'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Eager is the antonym, since reluctance is hesitation rather than appetite.',
      'Reluctant means hesitant or disinclined, and this option names that absence of want.',
      'Unable describes capacity and reluctant describes desire, so a willing but untrained person is unable.',
      'Dishonesty concerns truthfulness, and reluctance concerns not wanting to act.',
    ],
    explanation:
        'Reluctant means hesitant or disinclined, so unwilling is correct. Unable is '
        'a common confusion: reluctant is about not WANTING to act, unable is about not being '
        'ABLE to.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.synonym', 'wk.academic'],
  ),
  Question(
    id: 'wk-021',
    subtest: Subtest.wk,
    stem: 'The word BENEVOLENT is built from roots that mean',
    choices: <String>['bad will', 'good will', 'strong will', 'new will'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Bad will is the mal- prefix, as in malevolent, so this option swaps the prefix and reverses the meaning.',
      'Bene- means good and vol- means will, so the two roots build good will.',
      'Strong will would need a root for strength, and the bene- here says good.',
      'New will would need a root such as nov-, which benevolent does not contain.',
    ],
    explanation:
        'Bene- means good and vol- means will or wish, so benevolent means well '
        'wishing. The contrasting prefix mal- appears in malevolent and malice, which is why '
        'learning prefixes in opposing pairs doubles what you can decode.',
    difficulty: Difficulty.medium,
    skills: <String>['wk.roots'],
  ),
  Question(
    id: 'wk-022',
    subtest: Subtest.wk,
    stem: 'HOSTILE',
    choices: <String>['welcoming', 'unfriendly', 'uncertain', 'noisy'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Welcoming is the antonym and should go first whenever you can spot one.',
      'Hostile means showing antagonism, and this option names that antagonism.',
      'Uncertain describes doubt, and hostility is a settled opposition.',
      'Noise is a matter of volume, and a silent stare can be thoroughly hostile.',
    ],
    explanation:
        'Hostile means showing antagonism, so unfriendly is correct. Welcoming is '
        'the antonym and should be eliminated first whenever you can spot it.',
    difficulty: Difficulty.easy,
    skills: <String>['wk.synonym'],
  ),
];
