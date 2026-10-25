import '../models/catalog.dart';
import '../models/question.dart';

/// Compact helpers for authoring spatial items.
///
/// A piece is written as a bitmap of rows separated by '/', where '1' is a
/// cell. So '10/10/11' is an L tetromino and '11' is a domino.
Poly _p(String art) => Poly.parse(art);

extension _PiecePlacement on Poly {
  Poly at(int dx, int dy) => offset(dx, dy);
}

/// Assembling Objects bank: sixteen spatial items.
///
/// Each item declares the loose pieces plus four candidate assemblies. Whether
/// a candidate is legal is COMPUTED by [AoPuzzle] from three rules - pieces
/// match, nothing overlaps, one joined body - so a typo cannot ship an item
/// with two right answers. `bank_integrity_test.dart` asserts that every item
/// has exactly one legal option.
final List<Question> assemblingObjectsBank = <Question>[
  Question(
    id: 'ao-001',
    subtest: Subtest.ao,
    stem:
        'Which of the four figures can be built from the loose pieces shown? '
        'Pieces may be turned but not flipped, bent or broken.',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation: 'Only the first assembly uses exactly the pieces shown. The second swaps the L-shaped piece for its mirror image, which you cannot get by rotating. The third slides the small piece on top of the long one, so the two overlap. The fourth substitutes a small L for the two-cell piece.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.pieces', 'ao.rotation'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('10/10/11'), _p('11')],
      options: <List<Poly>>[
        <Poly>[_p('10/10/11'), _p('11').at(1, 1)],
        <Poly>[_p('01/01/11'), _p('11').at(2, 1)],
        <Poly>[_p('10/10/11'), _p('10').at(1, 2)],
        <Poly>[_p('10/10/11'), _p('10/11').at(2, 2)],
      ],
    ),
  ),
  Question(
    id: 'ao-002',
    subtest: Subtest.ao,
    stem:
        'Which of the four figures can be built from the loose pieces shown? '
        'Pieces may be turned but not flipped, bent or broken.',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation: 'The first option seats the two-cell piece under the end of the three-cell bar and nothing overlaps. Option two lays the small piece on top of the bar, and option three leaves it disconnected. Option four replaces the two-cell piece with a three-cell corner, which would need an extra cell that the pieces do not have.',
    difficulty: Difficulty.easy,
    skills: <String>['ao.assembly', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('111'), _p('11')],
      options: <List<Poly>>[
        <Poly>[_p('111'), _p('11').at(2, 1)],
        <Poly>[_p('111'), _p('11').at(1, 0)],
        <Poly>[_p('111'), _p('11').at(4, 0)],
        <Poly>[_p('111'), _p('10/11').at(2, 1)],
      ],
    ),
  ),
  Question(
    id: 'ao-003',
    subtest: Subtest.ao,
    stem:
        'Which of the four figures can be built from the loose pieces shown? '
        'Pieces may be turned but not flipped, bent or broken.',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation: 'The zig-zag piece has a mirror twin that no rotation can produce, and option two uses that twin. Option three drops the two-cell piece straight onto occupied cells, and option four brings in a T-shaped piece that is not in the set at all. Option one is the only layout that fits together cleanly.',
    difficulty: Difficulty.hard,
    skills: <String>['ao.rotation', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('011/110'), _p('11')],
      options: <List<Poly>>[
        <Poly>[_p('011/110'), _p('11').at(2, 1)],
        <Poly>[_p('110/011'), _p('11').at(3, 1)],
        <Poly>[_p('011/110'), _p('11').at(1, 0)],
        <Poly>[_p('011/110'), _p('111/010').at(0, 2)],
      ],
    ),
  ),
  Question(
    id: 'ao-004',
    subtest: Subtest.ao,
    stem:
        'Which of the four figures can be built from the loose pieces shown? '
        'Pieces may be turned but not flipped, bent or broken.',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation: 'Two identical L pieces can interlock down the middle, which is what the first option shows. The second option mirrors one piece, the third overlaps the two pieces, and the fourth uses a corner piece with only three cells.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.assembly', 'ao.rotation'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('10/10/11'), _p('10/10/11')],
      options: <List<Poly>>[
        <Poly>[_p('10/10/11'), _p('10/10/11').at(2, 0)],
        <Poly>[_p('10/10/11'), _p('01/01/11').at(2, 0)],
        <Poly>[_p('10/10/11'), _p('10/10/11').at(1, 1)],
        <Poly>[_p('10/10/11'), _p('110/010').at(1, 1)],
      ],
    ),
  ),
  Question(
    id: 'ao-005',
    subtest: Subtest.ao,
    stem:
        'Which of the four figures can be built from the loose pieces shown? '
        'Pieces may be turned but not flipped, bent or broken.',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation: 'The T piece has a lone cell hanging below its centre, and the first option hangs the two-cell piece directly under that cell to form one body. The second option lands on occupied cells, the third uses a three-cell corner, and the fourth floats free of the rest.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.assembly', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('111/010'), _p('11')],
      options: <List<Poly>>[
        <Poly>[_p('111/010'), _p('11').at(1, 2)],
        <Poly>[_p('111/010'), _p('11').at(0, 0)],
        <Poly>[_p('111/010'), _p('10/11').at(3, 0)],
        <Poly>[_p('111/010'), _p('11').at(5, 2)],
      ],
    ),
  ),
  Question(
    id: 'ao-006',
    subtest: Subtest.ao,
    stem:
        'Which of the four figures can be built from the loose pieces shown? '
        'Pieces may be turned but not flipped, bent or broken.',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation: 'The square butts against the flat back of the L piece in the first option. Option two uses the mirrored L, which leaves a gap on the left. Option three drives the L into the square, and option four uses a zig-zag piece that is not in the set.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.pieces', 'ao.rotation'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('11/11'), _p('10/10/11')],
      options: <List<Poly>>[
        <Poly>[_p('11/11'), _p('10/10/11').at(2, 0)],
        <Poly>[_p('11/11'), _p('01/01/11').at(2, 0)],
        <Poly>[_p('11/11'), _p('10/10/11').at(1, 0)],
        <Poly>[_p('11/11'), _p('110/011').at(2, 0)],
      ],
    ),
  ),
  Question(
    id: 'ao-007',
    subtest: Subtest.ao,
    stem:
        'Which of the four figures can be built from the loose pieces shown? '
        'Pieces may be turned but not flipped, bent or broken.',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation: 'Three two-cell pieces can only make a joined figure if they line up end to end, which is the first option. Option two turns one piece upright into a cell that is already taken, option three swaps in a three-cell corner, and option four leaves all three pieces apart.',
    difficulty: Difficulty.easy,
    skills: <String>['ao.assembly', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('11'), _p('11'), _p('11')],
      options: <List<Poly>>[
        <Poly>[_p('11'), _p('11').at(2, 0), _p('11').at(4, 0)],
        <Poly>[_p('11'), _p('11').at(2, 0), _p('10').at(1, 0)],
        <Poly>[_p('11'), _p('11').at(2, 0), _p('10/11').at(4, 0)],
        <Poly>[_p('11'), _p('11').at(0, 2), _p('11').at(0, 4)],
      ],
    ),
  ),
  Question(
    id: 'ao-008',
    subtest: Subtest.ao,
    stem:
        'Which of the four figures can be built from the loose pieces shown? '
        'Pieces may be turned but not flipped, bent or broken.',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation: 'The long arm of the L ends at the row of the short foot, so the three-cell bar continues straight out from it in the first option. Option two mirrors the L, option three overlaps the bar with the foot, and option four uses a three-cell corner instead of a straight bar.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.assembly', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('10/10/11'), _p('111')],
      options: <List<Poly>>[
        <Poly>[_p('10/10/11'), _p('111').at(2, 2)],
        <Poly>[_p('01/01/11'), _p('111').at(2, 2)],
        <Poly>[_p('10/10/11'), _p('111').at(0, 2)],
        <Poly>[_p('10/10/11'), _p('10/11').at(2, 2)],
      ],
    ),
  ),
  Question(
    id: 'ao-009',
    subtest: Subtest.ao,
    stem:
        'Which of the four figures can be built from the loose pieces shown? '
        'Pieces may be turned but not flipped, bent or broken.',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation: 'The two zig-zags stack into a staircase in the first option because the upper piece ends where the lower one begins. Option two mirrors the second piece and no longer matches, option three overlaps them, and option four separates them completely.',
    difficulty: Difficulty.hard,
    skills: <String>['ao.rotation', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('011/110'), _p('011/110')],
      options: <List<Poly>>[
        <Poly>[_p('011/110'), _p('011/110').at(0, 2)],
        <Poly>[_p('011/110'), _p('110/011').at(0, 2)],
        <Poly>[_p('011/110'), _p('011/110').at(0, 1)],
        <Poly>[_p('011/110'), _p('011/110').at(4, 2)],
      ],
    ),
  ),
  Question(
    id: 'ao-010',
    subtest: Subtest.ao,
    stem:
        'Which of the four figures can be built from the loose pieces shown? '
        'Pieces may be turned but not flipped, bent or broken.',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation: 'The bar sits flush under the square in the first option, sharing a full edge. Option two pushes the bar into the square itself, option three uses a corner piece, and option four places the bar where it touches nothing.',
    difficulty: Difficulty.easy,
    skills: <String>['ao.assembly', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('11/11'), _p('111')],
      options: <List<Poly>>[
        <Poly>[_p('11/11'), _p('111').at(0, 2)],
        <Poly>[_p('11/11'), _p('111').at(1, 1)],
        <Poly>[_p('11/11'), _p('10/11').at(2, 0)],
        <Poly>[_p('11/11'), _p('111').at(4, 0)],
      ],
    ),
  ),
  Question(
    id: 'ao-011',
    subtest: Subtest.ao,
    stem:
        'Which of the four figures can be built from the loose pieces shown? '
        'Pieces may be turned but not flipped, bent or broken.',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation: 'Two T pieces join along the flat top edge without sharing any cell in the first option. Option two uses a three-cell corner, option three overlaps the pieces by one cell, and option four leaves the second T detached.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.assembly', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('111/010'), _p('111/010')],
      options: <List<Poly>>[
        <Poly>[_p('111/010'), _p('111/010').at(3, 0)],
        <Poly>[_p('111/010'), _p('110/010').at(3, 0)],
        <Poly>[_p('111/010'), _p('111/010').at(2, 0)],
        <Poly>[_p('111/010'), _p('111/010').at(6, 0)],
      ],
    ),
  ),
  Question(
    id: 'ao-012',
    subtest: Subtest.ao,
    stem:
        'Which of the four figures can be built from the loose pieces shown? '
        'Pieces may be turned but not flipped, bent or broken.',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation: 'The first option feeds the long arm into the first two-cell piece and closes the shape with the second one under the foot. Option two mirrors the L, option three stacks a piece onto cells that are already used, and option four substitutes a three-cell corner for the last two-cell piece.',
    difficulty: Difficulty.hard,
    skills: <String>['ao.pieces', 'ao.rotation', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('11'), _p('10/10/11'), _p('11')],
      options: <List<Poly>>[
        <Poly>[_p('11'), _p('10/10/11').at(2, 0), _p('11').at(3, 3)],
        <Poly>[_p('11'), _p('01/01/11').at(1, 0), _p('11').at(1, 3)],
        <Poly>[_p('11'), _p('10/10/11').at(2, 0), _p('11').at(2, 0)],
        <Poly>[_p('11'), _p('10/10/11').at(2, 0), _p('10/11').at(3, 3)],
      ],
    ),
  ),
  Question(
    id: 'ao-013',
    subtest: Subtest.ao,
    stem:
        'Which of the four figures can be built from the loose pieces shown? '
        'Pieces may be turned but not flipped, bent or broken.',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation: 'The two-cell piece under the left end of the bar makes a clean joined shape in the first option. Option two lays it across the bar so the cells collide, option three leaves a one-cell gap so the pieces never touch, and option four uses a three-cell corner.',
    difficulty: Difficulty.easy,
    skills: <String>['ao.assembly', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('1111'), _p('11')],
      options: <List<Poly>>[
        <Poly>[_p('1111'), _p('11').at(0, 1)],
        <Poly>[_p('1111'), _p('11').at(1, 0)],
        <Poly>[_p('1111'), _p('11').at(5, 0)],
        <Poly>[_p('1111'), _p('10/11').at(0, 1)],
      ],
    ),
  ),
  Question(
    id: 'ao-014',
    subtest: Subtest.ao,
    stem:
        'Which of the four figures can be built from the loose pieces shown? '
        'Pieces may be turned but not flipped, bent or broken.',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation: 'Two squares side by side share a full edge and form a clean rectangle in the first option. Option two replaces a square with a three-cell corner, option three overlaps the squares by a column, and option four opens a gap between them.',
    difficulty: Difficulty.easy,
    skills: <String>['ao.assembly', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('11/11'), _p('11/11')],
      options: <List<Poly>>[
        <Poly>[_p('11/11'), _p('11/11').at(2, 0)],
        <Poly>[_p('11/11'), _p('10/11').at(2, 0)],
        <Poly>[_p('11/11'), _p('11/11').at(1, 0)],
        <Poly>[_p('11/11'), _p('11/11').at(3, 0)],
      ],
    ),
  ),
  Question(
    id: 'ao-015',
    subtest: Subtest.ao,
    stem:
        'Which of the four figures can be built from the loose pieces shown? '
        'Pieces may be turned but not flipped, bent or broken.',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation: 'The first option is the only one that chains all three pieces: two-cell piece in the crook of the L, bar under the foot. Option two mirrors the L, option three overlaps the two-cell piece with the foot, and option four swaps the bar for a corner piece.',
    difficulty: Difficulty.hard,
    skills: <String>['ao.assembly', 'ao.pieces', 'ao.rotation'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('10/10/11'), _p('11'), _p('111')],
      options: <List<Poly>>[
        <Poly>[_p('10/10/11'), _p('11').at(1, 1), _p('111').at(1, 3)],
        <Poly>[_p('01/01/11'), _p('11').at(2, 1), _p('111').at(1, 3)],
        <Poly>[_p('10/10/11'), _p('11').at(1, 2), _p('111').at(1, 3)],
        <Poly>[_p('10/10/11'), _p('11').at(1, 1), _p('10/11').at(4, 1)],
      ],
    ),
  ),
  Question(
    id: 'ao-016',
    subtest: Subtest.ao,
    stem:
        'Which of the four figures can be built from the loose pieces shown? '
        'Pieces may be turned but not flipped, bent or broken.',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation: 'The low right edge of the zig-zag meets the square along its left column in the first option. Option two uses the mirrored zig-zag, option three overlaps the two pieces, and option four sets the square down where nothing touches it.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.rotation', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('011/110'), _p('11/11')],
      options: <List<Poly>>[
        <Poly>[_p('011/110'), _p('11/11').at(2, 1)],
        <Poly>[_p('110/011').at(1, 0), _p('11/11').at(2, 2)],
        <Poly>[_p('011/110'), _p('11/11').at(1, 1)],
        <Poly>[_p('011/110'), _p('11/11').at(4, 1)],
      ],
    ),
  ),
];
