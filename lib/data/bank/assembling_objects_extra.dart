import '../models/catalog.dart';
import '../models/question.dart';

/// Compact helpers for authoring spatial items.
///
/// A piece is written as a bitmap of rows separated by a slash, where '1' is a
/// filled cell. So '10/10/11' is an L tetromino and '11' is a domino.
Poly _p(String art) => Poly.parse(art);

extension _PiecePlacement on Poly {
  Poly at(int dx, int dy) => offset(dx, dy);
}

/// Assembling Objects: the second authoring pass, twenty items.
///
/// Twelve of them are fit-together items and eight are labeled-connection
/// items, the same sixty / forty split the real subtest uses. Nothing here is
/// copied from a published item: the piece inventories, the candidate
/// assemblies and the wording are all written for this bank.
///
/// Whether a figure is legal is COMPUTED, never declared. [AoPuzzle] checks
/// that the pieces match as a rotation-invariant multiset, that no two pieces
/// overlap, and that the result is one joined body, plus - for the connection
/// family - that every required pair of marked cells is orthogonally adjacent
/// and that every mark sits on its own piece. Each item carries exactly one
/// legal figure, which test/bank_ao_extra_test.dart asserts along with the
/// eight-by-eight box the real item is drawn in.
///
/// The answer is not always the first figure. Real items spread the key across
/// the four positions, so the option lists below do the same.
///
/// Placement convention for the connection family: a piece placed with
/// [at] has its marked cell at (stem anchor + dx, stem anchor + dy), and
/// [AoPuzzle.optionAnchors] lists one absolute cell per piece, in that option's
/// own piece order.
final List<Question> assemblingObjectsExtraBank = <Question>[
  // --- fit together -------------------------------------------------------
  Question(
    id: 'ao-x01',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 1,
    explanation:
        'The four-cell bar and the two-cell piece have to meet along an edge '
        'without sharing a cell. One figure lays the small piece along the end '
        'of the bar, so the pieces collide and what is left is the bar alone. '
        'Another sets it down two rows with an empty row between them, leaving '
        'two separate islands. A third swaps the small piece for an L of three '
        'cells, which '
        'this set does not contain. The remaining figure turns the small piece '
        'down from the right-hand end of the bar, so the two share a full edge '
        'and form one body.',
    difficulty: Difficulty.easy,
    skills: <String>['ao.assembly', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('1111'), _p('11')],
      options: <List<Poly>>[
        <Poly>[_p('1111'), _p('11').at(2, 0)],
        <Poly>[_p('1111'), _p('11').at(3, 1)],
        <Poly>[_p('1111'), _p('11').at(0, 2)],
        <Poly>[_p('1111'), _p('10/11').at(3, 1)],
      ],
    ),
  ),
  Question(
    id: 'ao-x02',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation:
        'The T piece has a single cell hanging below the centre of its bar, and '
        'only a figure that hangs the two-cell piece under that cell keeps both '
        'pieces whole and joined. One figure lays the two-cell piece over that '
        'hanging cell and the one beside it, so the pieces share cells. One '
        'leaves the small piece floating well clear of the T. The last replaces '
        'the two-cell piece '
        'with an L of three cells, which this set does not contain.',
    difficulty: Difficulty.easy,
    skills: <String>['ao.pieces', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('111/010'), _p('11')],
      options: <List<Poly>>[
        <Poly>[_p('111/010'), _p('11').at(0, 2)],
        <Poly>[_p('111/010'), _p('11').at(1, 1)],
        <Poly>[_p('111/010'), _p('11').at(4, 0)],
        <Poly>[_p('111/010'), _p('10/11').at(0, 2)],
      ],
    ),
  ),
  Question(
    id: 'ao-x03',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 2,
    explanation:
        'The three-cell bar has to sit against the long arm of the L without '
        'landing on the L itself. One figure lays the bar along the foot, so '
        'the two pieces overlap. Another drops the bar two rows below the foot '
        'with nothing between them, so the figure falls apart into two islands. '
        'A third shortens the bar to two cells. The figure that works turns the '
        'bar horizontal in the crook of the L, a row above the foot, where it '
        'shares an edge with the arm and uses no cell twice.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.assembly', 'ao.rotation'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('10/10/11'), _p('111')],
      options: <List<Poly>>[
        <Poly>[_p('10/10/11'), _p('111').at(1, 2)],
        <Poly>[_p('10/10/11'), _p('111').at(2, 3)],
        <Poly>[_p('10/10/11'), _p('111').at(1, 1)],
        <Poly>[_p('10/10/11'), _p('11').at(1, 1)],
      ],
    ),
  ),
  Question(
    id: 'ao-x04',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 1,
    explanation:
        'The zig-zag piece and the three-cell L must be used exactly as shown, '
        'joined and without a shared cell. One figure lays the L inside the '
        'zig-zag, so the pieces collide. Another sets the L clear of the '
        'zig-zag with a gap between them. A third uses the mirror image of the '
        'zig-zag, which looks close but cannot be produced by turning the piece '
        'over. The remaining figure drops the L from the right-hand end of the '
        'zig-zag, so every cell is used once and the result is one body.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.rotation', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('011/110'), _p('10/11')],
      options: <List<Poly>>[
        <Poly>[_p('011/110'), _p('10/11').at(1, 1)],
        <Poly>[_p('011/110'), _p('10/11').at(2, 1)],
        <Poly>[_p('110/011'), _p('10/11').at(2, 2)],
        <Poly>[_p('011/110'), _p('10/11').at(4, 0)],
      ],
    ),
  ),
  Question(
    id: 'ao-x05',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 2,
    explanation:
        'The U-shaped piece opens along its top row with one cell missing '
        'between the arms, and the two-cell piece has to hang off it somewhere '
        'that leaves a single joined figure. One figure sets the small piece so '
        'far to the right that nothing touches. Another lays it across the '
        'floor of the U, where its cells collide with the right arm. A third '
        'substitutes an L of three cells for the two-cell piece. The figure '
        'that works continues the U to the right, sharing a full edge with the '
        'right arm.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.pieces', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('101/111'), _p('11')],
      options: <List<Poly>>[
        <Poly>[_p('101/111'), _p('11').at(4, 0)],
        <Poly>[_p('101/111'), _p('11').at(1, 1)],
        <Poly>[_p('101/111'), _p('11').at(3, 0)],
        <Poly>[_p('101/111'), _p('10/11').at(3, 0)],
      ],
    ),
  ),
  Question(
    id: 'ao-x06',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 1,
    explanation:
        'The P-shaped piece carries a single cell at the bottom of its stem, '
        'and the joined figure has to be built outward from that cell. One '
        'figure drops the two-cell piece onto the block of the P, so the cells '
        'collide. Another sets it down two columns clear of the piece, leaving '
        'two islands. A third replaces it with an L of three cells. The figure '
        'that works hangs the two-cell piece straight under the lone bottom '
        'cell, so the outline stays connected and no cell is used twice.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.assembly', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('11/11/10'), _p('11')],
      options: <List<Poly>>[
        <Poly>[_p('11/11/10'), _p('10/11').at(0, 3)],
        <Poly>[_p('11/11/10'), _p('11').at(0, 3)],
        <Poly>[_p('11/11/10'), _p('11').at(0, 1)],
        <Poly>[_p('11/11/10'), _p('11').at(3, 0)],
      ],
    ),
  ),
  Question(
    id: 'ao-x07',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation:
        'The W-shaped piece ends at a single cell in its lowest row, so the '
        'two-cell piece can be attached at that cell or lost entirely. One '
        'figure parks the small piece off to the right with a one-cell gap, so '
        'the result is two bodies rather than one. Another lies it across the '
        'bottom two cells of the W, which collide. A third makes the small '
        'piece three cells long. The figure that works continues the W downward '
        'from its lowest cell, so the pieces share an edge.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.rotation', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('100/110/011'), _p('11')],
      options: <List<Poly>>[
        <Poly>[_p('100/110/011'), _p('11').at(2, 3)],
        <Poly>[_p('100/110/011'), _p('11').at(3, 0)],
        <Poly>[_p('100/110/011'), _p('10/11').at(2, 3)],
        <Poly>[_p('100/110/011'), _p('11').at(1, 2)],
      ],
    ),
  ),
  Question(
    id: 'ao-x08',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 1,
    explanation:
        'The five-cell cross has four arms, and the L can hang on only one of '
        'them without touching the cross twice. One figure drives the long arm '
        'of the L up through the cross, so the pieces overlap. Another hangs '
        'the mirrored L, which no rotation of the given piece can produce. A '
        'third sets the L far enough away that nothing touches it. The figure '
        'that works hangs the L from the arm pointing down, so its long side '
        'runs down beside the cross and the foot turns away at the bottom.',
    difficulty: Difficulty.hard,
    skills: <String>['ao.rotation', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('010/111/010'), _p('10/10/11')],
      options: <List<Poly>>[
        <Poly>[_p('010/111/010'), _p('10/10/11').at(1, 2)],
        <Poly>[_p('010/111/010'), _p('10/10/11').at(2, 2)],
        <Poly>[_p('010/111/010'), _p('01/01/11').at(2, 1)],
        <Poly>[_p('010/111/010'), _p('10/10/11').at(4, 2)],
      ],
    ),
  ),
  Question(
    id: 'ao-x09',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 3,
    explanation:
        'Three pieces have to come together into one body with no cell used '
        'twice. One figure lays the two-cell piece over the foot of the L, so '
        'the pieces collide. Another parks it two cells clear of everything, '
        'leaving a loose island. A third lengthens the two-cell piece into an L '
        'of three cells. The figure that works keeps the bar in the crook of '
        'the L and hangs the two-cell piece under the foot, so all three pieces '
        'touch and no cell is repeated.',
    difficulty: Difficulty.hard,
    skills: <String>['ao.assembly', 'ao.pieces', 'ao.rotation'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('10/10/11'), _p('111'), _p('11')],
      options: <List<Poly>>[
        <Poly>[_p('10/10/11'), _p('111').at(1, 0), _p('10/11').at(1, 3)],
        <Poly>[_p('10/10/11'), _p('111').at(1, 0), _p('11').at(0, 2)],
        <Poly>[_p('10/10/11'), _p('111').at(1, 0), _p('11').at(5, 0)],
        <Poly>[_p('10/10/11'), _p('111').at(1, 0), _p('11').at(1, 3)],
      ],
    ),
  ),
  Question(
    id: 'ao-x10',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 3,
    explanation:
        'The square and the three-cell bar make one figure only if the bar is '
        'attached along an edge of the square. One figure stands the bar in the '
        'square, so cells collide. Another sets it down two columns clear, '
        'leaving two islands. A third cuts the bar to two cells. The figure '
        'that works stands the bar upright against the right edge of the '
        'square, so the pieces meet along a full edge and no cell is counted '
        'twice.',
    difficulty: Difficulty.easy,
    skills: <String>['ao.assembly', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('11/11'), _p('111')],
      options: <List<Poly>>[
        <Poly>[_p('11/11'), _p('1/1/1').at(1, 0)],
        <Poly>[_p('11/11'), _p('1/1/1').at(4, 0)],
        <Poly>[_p('11/11'), _p('1/1').at(2, 0)],
        <Poly>[_p('11/11'), _p('1/1/1').at(2, 0)],
      ],
    ),
  ),
  Question(
    id: 'ao-x11',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation:
        'The four-cell bar has to stand beside the T without covering any of '
        'the T own cells. One figure slides the bar onto the right-hand cell of '
        'the crossbar, so the pieces overlap. Another sets the bar down two '
        'cells clear of the T with nothing between them. A third cuts the bar '
        'to three cells. The figure that works stands the bar upright against '
        'the right end of the crossbar, so the pieces meet along an edge and '
        'form one figure.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.rotation', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('1111'), _p('111/010')],
      options: <List<Poly>>[
        <Poly>[_p('111/010'), _p('1/1/1/1').at(3, 0)],
        <Poly>[_p('111/010'), _p('1/1/1/1').at(2, 0)],
        <Poly>[_p('111/010'), _p('111').at(3, 0)],
        <Poly>[_p('111/010'), _p('1/1/1/1').at(5, 0)],
      ],
    ),
  ),
  Question(
    id: 'ao-x12',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if they are fit together?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 2,
    explanation:
        'The U-shaped piece and the L must be joined without a shared cell, and '
        'the L has only one edge on the U that it can use. One figure drives '
        'the L down through the arms of the U, so the cells collide. Another '
        'uses the mirror image of the L, which cannot be produced by turning '
        'it. A third leaves the L stranded with a gap beside the U. The figure '
        'that works lays the long side of the L against the right arm, with the '
        'foot turning away at the bottom.',
    difficulty: Difficulty.hard,
    skills: <String>['ao.rotation', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('101/111'), _p('10/10/11')],
      options: <List<Poly>>[
        <Poly>[_p('101/111'), _p('10/10/11').at(2, 0)],
        <Poly>[_p('101/111'), _p('01/01/11').at(2, 0)],
        <Poly>[_p('101/111'), _p('10/10/11').at(3, 0)],
        <Poly>[_p('101/111'), _p('10/10/11').at(5, 0)],
      ],
    ),
  ),

  // --- labeled connection ------------------------------------------------
  Question(
    id: 'ao-x13',
    subtest: Subtest.ao,
    stem:
        'Which of these figures will appear if the letters for each object are '
        'matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 2,
    explanation:
        'Turning a piece does not move its letter, so the joint has to be built '
        'where the letters are. In the figure that works the marked cell of the '
        'two-cell piece sits directly under A, so A and B share an edge. One '
        'figure slides the small piece so the pieces still touch but B ends up '
        'two cells away from A. Another lays it on the solid body of the marked '
        'piece, so the two overlap. The last replaces the two-cell piece with a '
        'square, which carries no B at all.',
    difficulty: Difficulty.easy,
    skills: <String>['ao.connection', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('11/11/10'), _p('11')],
      labels: <String>['A', 'B'],
      anchors: <GridCell>[const GridCell(0, 0), const GridCell(1, 0)],
      connections: const <AoConnection>[AoConnection('A', 'B')],
      options: <List<Poly>>[
        <Poly>[_p('11/11/10').at(2, 1), _p('11').at(2, 0)],
        <Poly>[_p('11/11/10').at(2, 1), _p('11').at(2, 1)],
        <Poly>[_p('11/11/10').at(2, 1), _p('11').at(1, 0)],
        <Poly>[_p('11/11/10').at(2, 1), _p('11/11').at(0, 0)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[const GridCell(2, 1), const GridCell(3, 0)],
        <GridCell>[const GridCell(2, 1), const GridCell(3, 1)],
        <GridCell>[const GridCell(2, 1), const GridCell(2, 0)],
        <GridCell>[const GridCell(2, 1), const GridCell(0, 0)],
      ],
    ),
  ),
  Question(
    id: 'ao-x14',
    subtest: Subtest.ao,
    stem:
        'Which of these figures will appear if the letters for each object are '
        'matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 3,
    explanation:
        'The letter A sits on the cell that hangs below the T, so it is that '
        'cell and not the crossbar that has to meet B. The figure that works '
        'starts the bar directly beneath A, so the two marked cells touch. One '
        'figure stands the bar against the right-hand end of the crossbar, '
        'where the pieces touch but B is two cells from A. Another runs the bar '
        'along the crossbar itself, so the cells collide. The last replaces the '
        'bar with a two-cell piece, which carries no B.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.connection', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('111/010'), _p('111')],
      labels: <String>['A', 'B'],
      anchors: <GridCell>[const GridCell(1, 1), const GridCell(0, 0)],
      connections: const <AoConnection>[AoConnection('A', 'B')],
      options: <List<Poly>>[
        <Poly>[_p('111/010'), _p('11').at(1, 2)],
        <Poly>[_p('111/010'), _p('1/1/1').at(3, 0)],
        <Poly>[_p('111/010'), _p('111').at(0, 1)],
        <Poly>[_p('111/010'), _p('111').at(1, 2)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[const GridCell(1, 1), const GridCell(1, 2)],
        <GridCell>[const GridCell(1, 1), const GridCell(3, 0)],
        <GridCell>[const GridCell(1, 1), const GridCell(0, 1)],
        <GridCell>[const GridCell(1, 1), const GridCell(1, 2)],
      ],
    ),
  ),
  Question(
    id: 'ao-x15',
    subtest: Subtest.ao,
    stem:
        'Which of these figures will appear if the letters for each object are '
        'matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 2,
    explanation:
        'A rides on the foot of the L, so the bar has to be brought to that '
        'foot and not to the tall arm. The figure that works starts the bar '
        'straight down from the foot, so A and B share an edge. One figure lays '
        'the bar across the foot itself, so the cells collide. Another cuts it '
        'to two cells, which leaves nothing carrying B. The last hangs the bar '
        'below the tall arm, where the pieces still touch but A and B end up '
        'two cells apart.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.connection', 'ao.rotation'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('10/10/11'), _p('111')],
      labels: <String>['A', 'B'],
      anchors: <GridCell>[const GridCell(1, 2), const GridCell(0, 0)],
      connections: const <AoConnection>[AoConnection('A', 'B')],
      options: <List<Poly>>[
        <Poly>[_p('10/10/11'), _p('1/1/1').at(0, 2)],
        <Poly>[_p('10/10/11'), _p('1/1').at(1, 3)],
        <Poly>[_p('10/10/11'), _p('1/1/1').at(1, 3)],
        <Poly>[_p('10/10/11'), _p('1/1/1').at(0, 3)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[const GridCell(1, 2), const GridCell(0, 2)],
        <GridCell>[const GridCell(1, 2), const GridCell(1, 3)],
        <GridCell>[const GridCell(1, 2), const GridCell(1, 3)],
        <GridCell>[const GridCell(1, 2), const GridCell(0, 3)],
      ],
    ),
  ),
  Question(
    id: 'ao-x16',
    subtest: Subtest.ao,
    stem:
        'Which of these figures will appear if the letters for each object are '
        'matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 3,
    explanation:
        'A marks the lower right cell of the square and B marks the top of the '
        'L stem, so those two cells have to meet. In the figure that works the '
        'top of the stem sits right beside A. One figure shoves the L into the '
        'square, so cells collide. Another drops the square a row, so the '
        'pieces still touch but A and B are two cells apart. The last '
        'substitutes a two-cell piece for the L, which carries no B.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.connection', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('11/11'), _p('10/11')],
      labels: <String>['A', 'B'],
      anchors: <GridCell>[const GridCell(1, 1), const GridCell(0, 0)],
      connections: const <AoConnection>[AoConnection('A', 'B')],
      options: <List<Poly>>[
        <Poly>[_p('11/11').at(0, 1), _p('10/11').at(2, 1)],
        <Poly>[_p('11/11').at(0, 0), _p('10/11').at(1, 0)],
        <Poly>[_p('11/11').at(0, 0), _p('11').at(2, 1)],
        <Poly>[_p('11/11').at(0, 0), _p('10/11').at(2, 1)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[const GridCell(1, 2), const GridCell(2, 1)],
        <GridCell>[const GridCell(1, 1), const GridCell(1, 0)],
        <GridCell>[const GridCell(1, 1), const GridCell(2, 1)],
        <GridCell>[const GridCell(1, 1), const GridCell(2, 1)],
      ],
    ),
  ),
  Question(
    id: 'ao-x17',
    subtest: Subtest.ao,
    stem:
        'Which of these figures will appear if the letters for each object are '
        'matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 2,
    explanation:
        'A is marked on the upper left cell of the zig-zag and B on the left '
        'end of the bar, so the bar has to be brought to that point and not to '
        'the far end of the zig-zag. The figure that works starts the bar just '
        'above A, so the two marked cells share an edge. One figure lays the '
        'whole bar across the zig-zag, so the pieces collide. Another pushes it '
        'one cell further along, where the pieces touch but A and B are two '
        'cells apart. The last shortens the bar to three cells.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.connection', 'ao.rotation'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('011/110'), _p('1111')],
      labels: <String>['A', 'B'],
      anchors: <GridCell>[const GridCell(1, 0), const GridCell(0, 0)],
      connections: const <AoConnection>[AoConnection('A', 'B')],
      options: <List<Poly>>[
        <Poly>[_p('011/110').at(0, 1), _p('1111').at(0, 1)],
        <Poly>[_p('011/110').at(0, 1), _p('1111').at(2, 0)],
        <Poly>[_p('011/110').at(0, 1), _p('1111').at(1, 0)],
        <Poly>[_p('011/110').at(0, 1), _p('111').at(1, 0)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[const GridCell(1, 1), const GridCell(0, 1)],
        <GridCell>[const GridCell(1, 1), const GridCell(2, 0)],
        <GridCell>[const GridCell(1, 1), const GridCell(1, 0)],
        <GridCell>[const GridCell(1, 1), const GridCell(1, 0)],
      ],
    ),
  ),
  Question(
    id: 'ao-x18',
    subtest: Subtest.ao,
    stem:
        'Which of these figures will appear if the letters for each object are '
        'matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 1,
    explanation:
        'Two joints are required here, so the figure has to bring both the bar '
        'and the two-cell piece to the marked corner of the square. The figure '
        'that works puts B on the right of A and C directly under A, so both '
        'pairs meet. One figure drives the bar through the square, so cells '
        'collide. Another stands the bar upright with A and B two cells apart. '
        'The last replaces the two-cell piece with an L, which carries no C.',
    difficulty: Difficulty.hard,
    skills: <String>['ao.connection', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('11/11'), _p('111'), _p('11')],
      labels: <String>['A', 'B', 'C'],
      anchors: <GridCell>[
        const GridCell(1, 1),
        const GridCell(0, 0),
        const GridCell(1, 0),
      ],
      connections: const <AoConnection>[
        AoConnection('A', 'B'),
        AoConnection('A', 'C'),
      ],
      options: <List<Poly>>[
        <Poly>[_p('11/11'), _p('111').at(2, 1), _p('10/11').at(0, 2)],
        <Poly>[_p('11/11'), _p('111').at(2, 1), _p('11').at(0, 2)],
        <Poly>[_p('11/11'), _p('111').at(0, 1), _p('11').at(0, 2)],
        <Poly>[_p('11/11'), _p('1/1/1').at(2, 0), _p('11').at(0, 2)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[
          const GridCell(1, 1),
          const GridCell(2, 1),
          const GridCell(0, 2),
        ],
        <GridCell>[
          const GridCell(1, 1),
          const GridCell(2, 1),
          const GridCell(1, 2),
        ],
        <GridCell>[
          const GridCell(1, 1),
          const GridCell(0, 1),
          const GridCell(1, 2),
        ],
        <GridCell>[
          const GridCell(1, 1),
          const GridCell(2, 0),
          const GridCell(1, 2),
        ],
      ],
    ),
  ),
  Question(
    id: 'ao-x19',
    subtest: Subtest.ao,
    stem:
        'Which of these figures will appear if the letters for each object are '
        'matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 3,
    explanation:
        'A marks the centre of the T crossbar, so the bar has to stop beside '
        'that cell rather than run across it. The figure that works starts the '
        'bar one cell to the right of A, so the marked cells touch. One figure '
        'runs the bar along the crossbar, so the pieces collide. Another stops '
        'it one cell further out, where the pieces touch but A and B are two '
        'cells apart. The last shortens the bar to three cells.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.connection', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('111/010'), _p('1111')],
      labels: <String>['A', 'B'],
      anchors: <GridCell>[const GridCell(1, 0), const GridCell(0, 0)],
      connections: const <AoConnection>[AoConnection('A', 'B')],
      options: <List<Poly>>[
        <Poly>[_p('111/010').at(0, 1), _p('1111').at(2, 0)],
        <Poly>[_p('111/010').at(0, 1), _p('1111').at(0, 1)],
        <Poly>[_p('111/010').at(0, 1), _p('111').at(1, 0)],
        <Poly>[_p('111/010').at(0, 1), _p('1111').at(1, 0)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[const GridCell(1, 1), const GridCell(2, 0)],
        <GridCell>[const GridCell(1, 1), const GridCell(0, 1)],
        <GridCell>[const GridCell(1, 1), const GridCell(1, 0)],
        <GridCell>[const GridCell(1, 1), const GridCell(1, 0)],
      ],
    ),
  ),
  Question(
    id: 'ao-x20',
    subtest: Subtest.ao,
    stem:
        'Which of these figures will appear if the letters for each object are '
        'matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 1,
    explanation:
        'A is marked on the top left cell of the U, which has a notch between '
        'its arms. The figure that works puts the marked cell of the two-cell '
        'piece directly above A, so the letters meet. One slides the small '
        'piece one cell further right, where the pieces touch but A and B end '
        'up two cells apart. Another drops it a row onto the arm of the U, so '
        'the cells collide. The last swaps it for a square, which carries no B.',
    difficulty: Difficulty.hard,
    skills: <String>['ao.connection', 'ao.rotation'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('101/111'), _p('11')],
      labels: <String>['A', 'B'],
      anchors: <GridCell>[const GridCell(0, 0), const GridCell(0, 0)],
      connections: const <AoConnection>[AoConnection('A', 'B')],
      options: <List<Poly>>[
        <Poly>[_p('101/111').at(2, 2), _p('11').at(3, 1)],
        <Poly>[_p('101/111').at(2, 2), _p('11').at(2, 1)],
        <Poly>[_p('101/111').at(2, 2), _p('11/11').at(0, 1)],
        <Poly>[_p('101/111').at(2, 2), _p('11').at(2, 3)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[const GridCell(2, 2), const GridCell(3, 1)],
        <GridCell>[const GridCell(2, 2), const GridCell(2, 1)],
        <GridCell>[const GridCell(2, 2), const GridCell(0, 1)],
        <GridCell>[const GridCell(2, 2), const GridCell(2, 3)],
      ],
    ),
  ),
];
