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

/// Assembling Objects: the labeled-connection family.
///
/// The real Assembling Objects subtest gives roughly forty percent of its items
/// to this family. Each loose piece carries a lettered attachment point, and
/// the task is to find the figure in which the REQUIRED letters meet. Merely
/// touching is not enough: the marked points themselves must end up face to
/// face, which is why an arrangement that joins two pieces at the wrong letters
/// is the characteristic wrong answer here and is the tempting distractor in
/// every item.
///
/// Legality is COMPUTED by [AoPuzzle] from five rules - the pieces match as a
/// rotation-invariant multiset, nothing overlaps, the result is one joined
/// body, every required pair of marked points is orthogonally adjacent, and
/// every mark sits on its own piece. Each item therefore carries exactly one
/// legal figure, and test/bank_ao_connection_test.dart proves it.
///
/// Placement convention: a piece placed with .at(dx, dy) has its marked cell at
/// (stem anchor x + dx, stem anchor y + dy). Marks are listed per option, one
/// per piece, in that option own piece order.
final List<Question> assemblingObjectsConnectionBank = <Question>[
  Question(
    id: 'ao-c01',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if the letters for each object are matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation:
        'The letters have to face each other, not merely come close. The first '
        'figure seats the two-cell piece directly under the foot of the L, so '
        'points A and B share an edge. The second slides it onto the foot '
        'itself, so the pieces overlap. The third sets it down one cell away '
        'and leaves A and B two cells apart. The fourth swaps the two-cell '
        'piece for a three-cell corner that is not in the set at all.',
    difficulty: Difficulty.easy,
    skills: <String>['ao.connection', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('10/10/11'), _p('11')],
      labels: <String>['A', 'B'],
      anchors: <GridCell>[const GridCell(0, 2), const GridCell(0, 0)],
      connections: const <AoConnection>[AoConnection('A', 'B')],
      options: <List<Poly>>[
        <Poly>[_p('10/10/11'), _p('11').at(0, 3)],
        <Poly>[_p('10/10/11'), _p('11').at(1, 2)],
        <Poly>[_p('10/10/11'), _p('11').at(1, 3)],
        <Poly>[_p('10/10/11'), _p('10/11').at(0, 3)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[const GridCell(0, 2), const GridCell(0, 3)],
        <GridCell>[const GridCell(0, 2), const GridCell(1, 2)],
        <GridCell>[const GridCell(0, 2), const GridCell(1, 3)],
        <GridCell>[const GridCell(0, 2), const GridCell(0, 3)],
      ],
    ),
  ),
  Question(
    id: 'ao-c02',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if the letters for each object are matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 1,
    explanation:
        'A joined figure is not enough, because the marked points themselves '
        'must touch. Only the second figure puts the marked end of the bar '
        'directly on top of the marked cell of the square, so A and B share an '
        'edge. The first lays the square across that end so the pieces '
        'overlap, the third drops it beside the foot with the letters four '
        'cells apart, and the fourth brings in a T-shaped piece that is not in '
        'the set.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.connection', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('111/100'), _p('11/11')],
      labels: <String>['A', 'B'],
      anchors: <GridCell>[const GridCell(2, 0), const GridCell(0, 0)],
      connections: const <AoConnection>[AoConnection('A', 'B')],
      options: <List<Poly>>[
        <Poly>[_p('111/100').at(0, 1), _p('11/11').at(2, 0)],
        <Poly>[_p('111/100').at(0, 1), _p('11/11').at(2, 2)],
        <Poly>[_p('111/100').at(0, 1), _p('11/11').at(0, 3)],
        <Poly>[_p('111/100').at(0, 1), _p('111/010').at(2, 2)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[const GridCell(2, 1), const GridCell(2, 0)],
        <GridCell>[const GridCell(2, 1), const GridCell(2, 2)],
        <GridCell>[const GridCell(2, 1), const GridCell(0, 3)],
        <GridCell>[const GridCell(2, 1), const GridCell(2, 2)],
      ],
    ),
  ),
  Question(
    id: 'ao-c03',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if the letters for each object are matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 2,
    explanation:
        'Notice which end of the bar carries the letter. In the third figure '
        'the bar lies directly on top of the marked cell of the L, so A and B '
        'touch and nothing overlaps. The first slides the bar one cell to the '
        'left, leaving the letters two cells apart, the second drops the bar '
        'across the L so the pieces share a cell, and the fourth replaces the '
        'three-cell bar with a four-cell one.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.connection', 'ao.rotation'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('10/10/11'), _p('111')],
      labels: <String>['A', 'B'],
      anchors: <GridCell>[const GridCell(0, 0), const GridCell(0, 0)],
      connections: const <AoConnection>[AoConnection('A', 'B')],
      options: <List<Poly>>[
        <Poly>[_p('10/10/11').at(1, 1), _p('111').at(0, 0)],
        <Poly>[_p('10/10/11').at(1, 1), _p('111').at(0, 1)],
        <Poly>[_p('10/10/11').at(1, 1), _p('111').at(1, 0)],
        <Poly>[_p('10/10/11').at(1, 1), _p('1111').at(1, 0)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[const GridCell(1, 1), const GridCell(0, 0)],
        <GridCell>[const GridCell(1, 1), const GridCell(0, 1)],
        <GridCell>[const GridCell(1, 1), const GridCell(1, 0)],
        <GridCell>[const GridCell(1, 1), const GridCell(1, 0)],
      ],
    ),
  ),
  Question(
    id: 'ao-c04',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if the letters for each object are matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 3,
    explanation:
        'Turning a piece does not move its letter, so the joint has to be '
        'built at the marked cells. The fourth figure hooks the marked foot of '
        'the L onto the marked tip of the zig-zag, and A meets B. The first '
        'parks the L against the far end of the zig-zag with A and B four '
        'cells apart, the second drives the L through cells of the zig-zag, '
        'and the third cuts the L down to a three-cell corner.',
    difficulty: Difficulty.hard,
    skills: <String>['ao.rotation', 'ao.connection'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('011/110'), _p('10/10/11')],
      labels: <String>['A', 'B'],
      anchors: <GridCell>[const GridCell(0, 1), const GridCell(1, 2)],
      connections: const <AoConnection>[AoConnection('A', 'B')],
      options: <List<Poly>>[
        <Poly>[_p('011/110').at(1, 1), _p('10/10/11').at(4, 0)],
        <Poly>[_p('011/110').at(1, 1), _p('10/10/11').at(1, 0)],
        <Poly>[_p('011/110').at(1, 1), _p('10/11').at(0, 2)],
        <Poly>[_p('011/110').at(1, 1), _p('10/10/11').at(0, 1)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[const GridCell(1, 2), const GridCell(5, 2)],
        <GridCell>[const GridCell(1, 2), const GridCell(2, 2)],
        <GridCell>[const GridCell(1, 2), const GridCell(1, 3)],
        <GridCell>[const GridCell(1, 2), const GridCell(1, 3)],
      ],
    ),
  ),
  Question(
    id: 'ao-c05',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if the letters for each object are matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 1,
    explanation:
        'The corner can go down four different ways near the marked end of the '
        'bar, and only one of them lands B beside A. That is the second '
        'figure, where the elbow of the corner sits just above the marked end '
        'of the bar. The first leaves it at the other end, three cells from A, '
        'the third pushes the elbow onto the bar itself, and the fourth cuts '
        'the corner down to a two-cell piece.',
    difficulty: Difficulty.easy,
    skills: <String>['ao.connection', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('1111'), _p('10/11')],
      labels: <String>['A', 'B'],
      anchors: <GridCell>[const GridCell(3, 0), const GridCell(0, 1)],
      connections: const <AoConnection>[AoConnection('A', 'B')],
      options: <List<Poly>>[
        <Poly>[_p('1111').at(0, 2), _p('10/11').at(1, 0)],
        <Poly>[_p('1111').at(0, 2), _p('10/11').at(3, 0)],
        <Poly>[_p('1111').at(0, 2), _p('10/11').at(3, 2)],
        <Poly>[_p('1111').at(0, 2), _p('11').at(3, 1)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[const GridCell(3, 2), const GridCell(1, 1)],
        <GridCell>[const GridCell(3, 2), const GridCell(3, 1)],
        <GridCell>[const GridCell(3, 2), const GridCell(3, 3)],
        <GridCell>[const GridCell(3, 2), const GridCell(3, 1)],
      ],
    ),
  ),
  Question(
    id: 'ao-c06',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if the letters for each object are matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 2,
    explanation:
        'Both pieces must be used whole, joined, and with the letters side by '
        'side. The third figure hangs the two-cell piece under the marked end '
        'of the bar, so A and B touch. The first puts it under the middle of '
        'the bar, three cells from the letter, the second lays it on cells the '
        'bar already uses, and the fourth stretches the bar from three cells '
        'to four.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.connection', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('111'), _p('11')],
      labels: <String>['A', 'B'],
      anchors: <GridCell>[const GridCell(0, 0), const GridCell(1, 0)],
      connections: const <AoConnection>[AoConnection('A', 'B')],
      options: <List<Poly>>[
        <Poly>[_p('111').at(1, 2), _p('11').at(2, 3)],
        <Poly>[_p('111').at(1, 2), _p('11').at(1, 2)],
        <Poly>[_p('111').at(1, 2), _p('11').at(0, 3)],
        <Poly>[_p('1111').at(1, 2), _p('11').at(0, 3)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[const GridCell(1, 2), const GridCell(3, 3)],
        <GridCell>[const GridCell(1, 2), const GridCell(2, 2)],
        <GridCell>[const GridCell(1, 2), const GridCell(1, 3)],
        <GridCell>[const GridCell(1, 2), const GridCell(1, 3)],
      ],
    ),
  ),
  Question(
    id: 'ao-c07',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if the letters for each object are matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 3,
    explanation:
        'A square can be set down four ways around a marked cell, and only one '
        'of them keeps every cell of the L clear. In the fourth figure the '
        'square sits directly beside the marked foot of the L and A meets B. '
        'The first drops it under the same column, leaving A and B two cells '
        'apart, the second buries it in cells the L already uses, and the '
        'third substitutes a T-shaped piece.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.connection', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('10/10/11'), _p('11/11')],
      labels: <String>['A', 'B'],
      anchors: <GridCell>[const GridCell(1, 2), const GridCell(0, 0)],
      connections: const <AoConnection>[AoConnection('A', 'B')],
      options: <List<Poly>>[
        <Poly>[_p('10/10/11').at(0, 0), _p('11/11').at(0, 3)],
        <Poly>[_p('10/10/11').at(0, 0), _p('11/11').at(0, 2)],
        <Poly>[_p('10/10/11').at(0, 0), _p('111/010').at(2, 2)],
        <Poly>[_p('10/10/11').at(0, 0), _p('11/11').at(2, 2)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[const GridCell(1, 2), const GridCell(0, 3)],
        <GridCell>[const GridCell(1, 2), const GridCell(0, 2)],
        <GridCell>[const GridCell(1, 2), const GridCell(2, 2)],
        <GridCell>[const GridCell(1, 2), const GridCell(2, 2)],
      ],
    ),
  ),
  Question(
    id: 'ao-c08',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if the letters for each object are matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation:
        'The stem piece is drawn upright, so it has to be turned before it '
        'will fit a horizontal row. In the first figure the turned piece has '
        'its marked cell directly above the marked cell of the bar, and A '
        'meets B. The second runs the bar through the turned piece, the third '
        'bolts the bar to the far right end with A and B three cells apart, '
        'and the fourth uses a four-cell bar.',
    difficulty: Difficulty.hard,
    skills: <String>['ao.rotation', 'ao.connection'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('10/10/11'), _p('111')],
      labels: <String>['A', 'B'],
      anchors: <GridCell>[const GridCell(1, 2), const GridCell(2, 0)],
      connections: const <AoConnection>[AoConnection('A', 'B')],
      options: <List<Poly>>[
        <Poly>[_p('111/100').at(2, 0), _p('111').at(0, 2)],
        <Poly>[_p('111/100').at(2, 0), _p('111').at(1, 1)],
        <Poly>[_p('111/100').at(2, 0), _p('111').at(3, 1)],
        <Poly>[_p('111/100').at(2, 0), _p('1111').at(0, 2)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[const GridCell(2, 1), const GridCell(2, 2)],
        <GridCell>[const GridCell(2, 1), const GridCell(3, 1)],
        <GridCell>[const GridCell(2, 1), const GridCell(5, 1)],
        <GridCell>[const GridCell(2, 1), const GridCell(2, 2)],
      ],
    ),
  ),
  Question(
    id: 'ao-c09',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if the letters for each object are matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 1,
    explanation:
        'Both joints have to be right at the same time, so a figure that joins '
        'all three pieces can still be wrong. Only the second figure has A '
        'meeting B beside the marked foot of the L and C meeting B under the '
        'mark on the domino. The first hangs the chain from the long arm of '
        'the L, leaving A and B two cells apart, the third lays the domino '
        'across cells the L already uses, and the fourth replaces the corner '
        'with a second domino.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.connection', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('10/10/11'), _p('11'), _p('10/11')],
      labels: <String>['A', 'B', 'C'],
      anchors: <GridCell>[
        const GridCell(1, 2),
        const GridCell(0, 0),
        const GridCell(0, 0),
      ],
      connections: const <AoConnection>[
        AoConnection('A', 'B'),
        AoConnection('B', 'C'),
      ],
      options: <List<Poly>>[
        <Poly>[
          _p('10/10/11').at(0, 0),
          _p('11').at(0, 3),
          _p('10/11').at(0, 4),
        ],
        <Poly>[
          _p('10/10/11').at(0, 0),
          _p('11').at(2, 2),
          _p('10/11').at(2, 3),
        ],
        <Poly>[
          _p('10/10/11').at(0, 0),
          _p('11').at(0, 2),
          _p('10/11').at(0, 3),
        ],
        <Poly>[_p('10/10/11').at(0, 0), _p('11').at(2, 2), _p('11').at(2, 3)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[
          const GridCell(1, 2),
          const GridCell(0, 3),
          const GridCell(0, 4),
        ],
        <GridCell>[
          const GridCell(1, 2),
          const GridCell(2, 2),
          const GridCell(2, 3),
        ],
        <GridCell>[
          const GridCell(1, 2),
          const GridCell(0, 2),
          const GridCell(0, 3),
        ],
        <GridCell>[
          const GridCell(1, 2),
          const GridCell(2, 2),
          const GridCell(2, 3),
        ],
      ],
    ),
  ),
  Question(
    id: 'ao-c10',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if the letters for each object are matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 2,
    explanation:
        'Three pieces in one joined body is not the same thing as three '
        'letters meeting. The third figure is the only one with C directly '
        'under A and B directly beside A. The first leaves the domino one cell '
        'too low, so A and C never meet, the second stacks B into cells of the '
        'square, and the fourth swaps B for a T-shaped piece.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.connection', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('11/11'), _p('10/10/11'), _p('11')],
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
        <Poly>[
          _p('11/11').at(0, 1),
          _p('10/10/11').at(2, 2),
          _p('11').at(0, 4),
        ],
        <Poly>[
          _p('11/11').at(0, 1),
          _p('10/10/11').at(0, 2),
          _p('11').at(0, 3),
        ],
        <Poly>[
          _p('11/11').at(0, 1),
          _p('10/10/11').at(2, 2),
          _p('11').at(0, 3),
        ],
        <Poly>[_p('11/11').at(0, 1), _p('111/010').at(2, 2), _p('11').at(0, 3)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[
          const GridCell(1, 2),
          const GridCell(2, 2),
          const GridCell(1, 4),
        ],
        <GridCell>[
          const GridCell(1, 2),
          const GridCell(0, 2),
          const GridCell(1, 3),
        ],
        <GridCell>[
          const GridCell(1, 2),
          const GridCell(2, 2),
          const GridCell(1, 3),
        ],
        <GridCell>[
          const GridCell(1, 2),
          const GridCell(2, 2),
          const GridCell(1, 3),
        ],
      ],
    ),
  ),
  Question(
    id: 'ao-c11',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if the letters for each object are matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 3,
    explanation:
        'The fourth figure turns C so that its marked elbow hangs just above '
        'B, one cell from A. A row of three pieces looks tidy whichever joint '
        'fails: the first parks C at the far right end, three cells from B, '
        'the second drives the domino into cells of the bar, and the third '
        'replaces C with a second domino.',
    difficulty: Difficulty.easy,
    skills: <String>['ao.connection', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('111'), _p('11'), _p('10/11')],
      labels: <String>['A', 'B', 'C'],
      anchors: <GridCell>[
        const GridCell(2, 0),
        const GridCell(0, 0),
        const GridCell(1, 1),
      ],
      connections: const <AoConnection>[
        AoConnection('A', 'B'),
        AoConnection('B', 'C'),
      ],
      options: <List<Poly>>[
        <Poly>[_p('111').at(0, 2), _p('11').at(3, 2), _p('10/11').at(4, 0)],
        <Poly>[_p('111').at(0, 2), _p('11').at(1, 2), _p('10/11').at(0, 0)],
        <Poly>[_p('111').at(0, 2), _p('11').at(3, 2), _p('11').at(2, 1)],
        <Poly>[_p('111').at(0, 2), _p('11').at(3, 2), _p('10/11').at(2, 0)],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[
          const GridCell(2, 2),
          const GridCell(3, 2),
          const GridCell(5, 1),
        ],
        <GridCell>[
          const GridCell(2, 2),
          const GridCell(1, 2),
          const GridCell(1, 1),
        ],
        <GridCell>[
          const GridCell(2, 2),
          const GridCell(3, 2),
          const GridCell(3, 1),
        ],
        <GridCell>[
          const GridCell(2, 2),
          const GridCell(3, 2),
          const GridCell(3, 1),
        ],
      ],
    ),
  ),
  Question(
    id: 'ao-c12',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if the letters for each object are matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation:
        'The long bar of the T has to stay clear while the letter on its stem '
        'cell picks up the other two pieces. In the first figure B sits '
        'immediately right of A and C immediately right of B. The second drops '
        'C under the left end of the T, three cells from B, the third lays C '
        'across the bar of the T, and the fourth brings in a three-cell '
        'corner.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.connection', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('111/010'), _p('10/10/11'), _p('11')],
      labels: <String>['A', 'B', 'C'],
      anchors: <GridCell>[
        const GridCell(1, 1),
        const GridCell(0, 0),
        const GridCell(0, 0),
      ],
      connections: const <AoConnection>[
        AoConnection('A', 'B'),
        AoConnection('B', 'C'),
      ],
      options: <List<Poly>>[
        <Poly>[
          _p('111/010').at(0, 0),
          _p('10/10/11').at(2, 1),
          _p('11').at(3, 1),
        ],
        <Poly>[
          _p('111/010').at(0, 0),
          _p('10/10/11').at(2, 1),
          _p('11').at(0, 2),
        ],
        <Poly>[
          _p('111/010').at(0, 0),
          _p('10/10/11').at(2, 1),
          _p('11').at(2, 0),
        ],
        <Poly>[
          _p('111/010').at(0, 0),
          _p('10/10/11').at(2, 1),
          _p('10/11').at(3, 1),
        ],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[
          const GridCell(1, 1),
          const GridCell(2, 1),
          const GridCell(3, 1),
        ],
        <GridCell>[
          const GridCell(1, 1),
          const GridCell(2, 1),
          const GridCell(0, 2),
        ],
        <GridCell>[
          const GridCell(1, 1),
          const GridCell(2, 1),
          const GridCell(2, 0),
        ],
        <GridCell>[
          const GridCell(1, 1),
          const GridCell(2, 1),
          const GridCell(3, 1),
        ],
      ],
    ),
  ),
  Question(
    id: 'ao-c13',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if the letters for each object are matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 1,
    explanation:
        'Two joints in a chain mean one bad joint spoils the whole figure. The '
        'second figure is the only one with the bar in the middle: A meets B at '
        'the join under the zig-zag, and C meets B at the left end of the bar. '
        'The first slides the L to the right end of the bar, far from B, the '
        'third drives the L through the zig-zag and the bar, and the fourth '
        'turns the four-cell bar into a T.',
    difficulty: Difficulty.hard,
    skills: <String>['ao.rotation', 'ao.connection', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('011/110'), _p('1111'), _p('10/10/11')],
      labels: <String>['A', 'B', 'C'],
      anchors: <GridCell>[
        const GridCell(0, 1),
        const GridCell(0, 0),
        const GridCell(1, 2),
      ],
      connections: const <AoConnection>[
        AoConnection('A', 'B'),
        AoConnection('B', 'C'),
      ],
      options: <List<Poly>>[
        <Poly>[
          _p('011/110').at(1, 0),
          _p('1111').at(1, 2),
          _p('10/10/11').at(4, 3),
        ],
        <Poly>[
          _p('011/110').at(1, 0),
          _p('1111').at(1, 2),
          _p('10/10/11').at(0, 1),
        ],
        <Poly>[
          _p('011/110').at(1, 0),
          _p('1111').at(1, 2),
          _p('10/10/11').at(1, 0),
        ],
        <Poly>[
          _p('011/110').at(1, 0),
          _p('111/010').at(1, 2),
          _p('10/10/11').at(0, 1),
        ],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[
          const GridCell(1, 1),
          const GridCell(1, 2),
          const GridCell(5, 5),
        ],
        <GridCell>[
          const GridCell(1, 1),
          const GridCell(1, 2),
          const GridCell(1, 3),
        ],
        <GridCell>[
          const GridCell(1, 1),
          const GridCell(1, 2),
          const GridCell(2, 2),
        ],
        <GridCell>[
          const GridCell(1, 1),
          const GridCell(1, 2),
          const GridCell(1, 3),
        ],
      ],
    ),
  ),
  Question(
    id: 'ao-c14',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if the letters for each object are matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 2,
    explanation:
        'Once a corner of the square is marked, the square has only two free '
        'sides, and the bar has to be threaded between them. In the third '
        'figure A abuts the marked end of C and B sits directly under the mark '
        'on C. The first lets B hang under A, three cells from C, the second '
        'pushes B up into A and C, and the fourth stretches C to four cells.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.connection', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('11/11'), _p('011/110'), _p('111')],
      labels: <String>['A', 'B', 'C'],
      anchors: <GridCell>[
        const GridCell(1, 0),
        const GridCell(1, 0),
        const GridCell(0, 0),
      ],
      connections: const <AoConnection>[
        AoConnection('A', 'C'),
        AoConnection('B', 'C'),
      ],
      options: <List<Poly>>[
        <Poly>[
          _p('11/11').at(1, 3),
          _p('011/110').at(1, 5),
          _p('111').at(3, 3),
        ],
        <Poly>[
          _p('11/11').at(1, 3),
          _p('011/110').at(2, 2),
          _p('111').at(3, 3),
        ],
        <Poly>[
          _p('11/11').at(1, 3),
          _p('011/110').at(2, 4),
          _p('111').at(3, 3),
        ],
        <Poly>[
          _p('11/11').at(1, 3),
          _p('011/110').at(2, 4),
          _p('1111').at(3, 3),
        ],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[
          const GridCell(2, 3),
          const GridCell(2, 5),
          const GridCell(3, 3),
        ],
        <GridCell>[
          const GridCell(2, 3),
          const GridCell(3, 2),
          const GridCell(3, 3),
        ],
        <GridCell>[
          const GridCell(2, 3),
          const GridCell(3, 4),
          const GridCell(3, 3),
        ],
        <GridCell>[
          const GridCell(2, 3),
          const GridCell(3, 4),
          const GridCell(3, 3),
        ],
      ],
    ),
  ),
  Question(
    id: 'ao-c15',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if the letters for each object are matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 3,
    explanation:
        'The tall L sets the height of the figure, so the two small pieces '
        'have very little room. The fourth figure sets B beside A and tucks C '
        'above it, closing both joints. The first slides C up against the arm '
        'of A where B cannot reach it, the second puts C on cells of B, and '
        'the third substitutes a T-shaped piece for B.',
    difficulty: Difficulty.hard,
    skills: <String>['ao.connection', 'ao.pieces'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('10/10/10/11'), _p('11/11'), _p('11')],
      labels: <String>['A', 'B', 'C'],
      anchors: <GridCell>[
        const GridCell(1, 3),
        const GridCell(0, 0),
        const GridCell(1, 0),
      ],
      connections: const <AoConnection>[
        AoConnection('A', 'B'),
        AoConnection('B', 'C'),
      ],
      options: <List<Poly>>[
        <Poly>[
          _p('10/10/10/11').at(0, 0),
          _p('11/11').at(2, 3),
          _p('11').at(1, 0),
        ],
        <Poly>[
          _p('10/10/10/11').at(0, 0),
          _p('11/11').at(2, 3),
          _p('11').at(2, 3),
        ],
        <Poly>[
          _p('10/10/10/11').at(0, 0),
          _p('111/010').at(2, 3),
          _p('11').at(1, 2),
        ],
        <Poly>[
          _p('10/10/10/11').at(0, 0),
          _p('11/11').at(2, 3),
          _p('11').at(1, 2),
        ],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[
          const GridCell(1, 3),
          const GridCell(2, 3),
          const GridCell(2, 0),
        ],
        <GridCell>[
          const GridCell(1, 3),
          const GridCell(2, 3),
          const GridCell(3, 3),
        ],
        <GridCell>[
          const GridCell(1, 3),
          const GridCell(2, 3),
          const GridCell(2, 2),
        ],
        <GridCell>[
          const GridCell(1, 3),
          const GridCell(2, 3),
          const GridCell(2, 2),
        ],
      ],
    ),
  ),
  Question(
    id: 'ao-c16',
    subtest: Subtest.ao,
    stem: 'Which of these figures will appear if the letters for each object are matched?',
    choices: <String>['Figure A', 'Figure B', 'Figure C', 'Figure D'],
    answerIndex: 0,
    explanation:
        'With the bar lying across the middle, the other two pieces can only '
        'attach around its marked end cell. In the first figure A sits '
        'directly under B and C directly above B. The second slides A three '
        'cells to the right, the third pushes A up into B, and the fourth '
        'replaces C with a four-cell T.',
    difficulty: Difficulty.medium,
    skills: <String>['ao.connection', 'ao.assembly'],
    puzzle: AoPuzzle(
      pieces: <Poly>[_p('10/11'), _p('1111'), _p('11/11')],
      labels: <String>['A', 'B', 'C'],
      anchors: <GridCell>[
        const GridCell(0, 0),
        const GridCell(0, 0),
        const GridCell(1, 1),
      ],
      connections: const <AoConnection>[
        AoConnection('A', 'B'),
        AoConnection('B', 'C'),
      ],
      options: <List<Poly>>[
        <Poly>[_p('10/11').at(1, 3), _p('1111').at(1, 2), _p('11/11').at(0, 0)],
        <Poly>[_p('10/11').at(3, 3), _p('1111').at(1, 2), _p('11/11').at(0, 0)],
        <Poly>[_p('10/11').at(2, 2), _p('1111').at(1, 2), _p('11/11').at(0, 0)],
        <Poly>[
          _p('10/11').at(1, 3),
          _p('1111').at(1, 2),
          _p('111/010').at(0, 0),
        ],
      ],
      optionAnchors: <List<GridCell>>[
        <GridCell>[
          const GridCell(1, 3),
          const GridCell(1, 2),
          const GridCell(1, 1),
        ],
        <GridCell>[
          const GridCell(3, 3),
          const GridCell(1, 2),
          const GridCell(1, 1),
        ],
        <GridCell>[
          const GridCell(2, 2),
          const GridCell(1, 2),
          const GridCell(1, 1),
        ],
        <GridCell>[
          const GridCell(1, 3),
          const GridCell(1, 2),
          const GridCell(1, 1),
        ],
      ],
    ),
  ),
];
