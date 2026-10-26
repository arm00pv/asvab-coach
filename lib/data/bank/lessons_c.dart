import '../models/lesson.dart';

/// The final reinforcement lesson: assembling the whole figure.
const List<Lesson> lessonsC = <Lesson>[
  Lesson(
    skillId: 'ao.assembly',
    title: 'Building the figure without overlap or gaps',
    hook:
        'Assembling Objects is not a visualisation test. It is a checklist '
        'test wearing a picture.',
    whyItMatters:
        'Assembling Objects feeds several line scores, and it is the '
        'most trainable subtest on the battery. Almost nobody raises their '
        'vocabulary by fifteen points in a week, but almost anybody can stop '
        'losing points to two repeatable mistakes.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Run the same three checks, in the same order, every time',
        'You are given loose pieces and four finished figures. Exactly one can '
            'be built. Rather than trying to see the answer, eliminate options '
            'with three checks that never change order.',
        bullets: <String>[
          'Check one, inventory: are all the pieces present, and has any piece '
              'been swapped for a different shape?',
          'Check two, overlap: two pieces cannot occupy the same area.',
          'Check three, connection: the finished figure must be one solid body, '
              'not two islands that happen to touch.',
        ],
      ),
      LessonSection(
        'Pieces can turn but never flip',
        'This is the rule the subtest leans on hardest. A shape and its mirror '
            'image are different pieces. You may rotate a piece as far as you '
            'like, but turning it over is not allowed.',
        bullets: <String>[
          'An L and its mirrored J are different pieces, even though they look '
              'like the same shape seen from the other side.',
          'Zig-zag shapes also come in mirror pairs. Compare handedness once you '
              'know to look for it.',
          'When two options look identical apart from handedness, that is the '
              'entire item. Choose the handedness you were given.',
        ],
      ),
      LessonSection(
        'Work backwards from the most distinctive feature',
        'Do not start with the biggest piece. Start with the piece that has the '
            'oddest profile: the one with a notch, a long arm, or a single cell '
            'sticking out. Pin that feature, then test the options against it.',
        bullets: <String>[
          'The notch and the arm are constraints. An option with the feature '
              'pointing the wrong way is out immediately.',
          'Count cells when two options look close. Total cells are fixed, so a '
              'figure with an extra cell cannot be built.',
          'Past about 45 seconds, take the best remaining option and move on. '
              'There is no penalty for guessing here.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt:
            'The pieces are an L-shaped four-cell piece and a two-cell bar. '
            'Option A fills the notch with the bar. Option B uses a mirrored L '
            'with the bar outside it. Option C lays the bar across cells the L '
            'already occupies. Option D shows the arrangement of A but with a '
            'three-cell corner instead of the L. Which one can be built?',
        steps: <String>[
          'Option B uses a mirrored L, so it fails the no-flip rule.',
          'Option C overlaps the pieces, so it fails the no-overlap rule.',
          'Option D has a three-cell piece where a four-cell piece was given, so '
              'the inventory is wrong.',
          'Option A uses the right pieces, overlaps nothing, and forms one body.',
        ],
        answer: 'Option A',
      ),
      WorkedExample(
        prompt:
            'Two candidate figures share an identical outline except that '
            'the zig-zag runs left-to-right in one and right-to-left in the '
            'other. The given pieces include that zig-zag in one handedness. '
            'Which figure is buildable?',
        steps: <String>[
          'Recognise this as a handedness item rather than a shape item.',
          'The outline is the same either way, so comparing outlines cannot '
              'decide it.',
          'Only the figure containing the zig-zag in the given handedness can be '
              'assembled without flipping a piece.',
        ],
        answer: 'The figure whose zig-zag matches the handedness given.',
      ),
      WorkedExample(
        prompt: 'A figure to be built has to contain six cells. The pieces given are a four-cell L and a two-cell bar. One choice fills a seven-cell outline perfectly. What rules that choice out?',
        steps: <String>[
          'Count the inventory before comparing shapes: 4 + 2 = 6 cells in total.',
          'The cell count cannot change during assembly, so the finished figure has exactly six cells.',
          'An outline of seven cells needs a seventh cell from somewhere, so that choice can never be built.',
        ],
        answer: 'The cell count is fixed at six, so the seven-cell choice is impossible.',
      ),
    ],
    quickRules: <String>[
      'Inventory, overlap, connection, always in that order.',
      'Total cell count is fixed, so count when two options look identical.',
      'Rotating is legal, flipping is not. Handedness is the trap.',
      'Start from the oddest feature, not the biggest piece.',
    ],
    pitfalls: <String>[
      'Choosing the mirrored piece because it looks like a rotation at a glance.',
      'Missing an overlap hidden under the largest piece.',
      'Picking a figure that is really two islands touching at a single corner.',
    ],
    commonMistakes: <CommonMistake>[
      CommonMistake(
        answer:
            'Counting the outline once and assuming the pieces will fill it.',
        why: 'The pieces set the total, 4 + 2 = 6 cells. An outline that needs seven cannot be built however convincing it looks.',
      ),
      CommonMistake(
        answer: 'Assuming a cell can be trimmed off the L to make the fit.',
        why: 'Trimming is not assembling. Pieces are used whole, so a shorter piece is a piece you were not given.',
      ),
    ],
  ),
];
