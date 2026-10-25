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
    explanation:
        'Hostile means showing antagonism, so unfriendly is correct. Welcoming is '
        'the antonym and should be eliminated first whenever you can spot it.',
    difficulty: Difficulty.easy,
    skills: <String>['wk.synonym'],
  ),
];
