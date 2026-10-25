import 'dart:math' as math;

/// A grid cell coordinate. Units are arbitrary; the painter scales them.
class GridCell {
  const GridCell(this.x, this.y);
  final int x;
  final int y;

  GridCell operator +(GridCell o) => GridCell(x + o.x, y + o.y);

  @override
  bool operator ==(Object other) =>
      other is GridCell && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x,$y)';
}

/// A polyomino: a set of unit cells forming a single flat piece.
///
/// The Assembling Objects subtest is modelled with polyominoes because they
/// make the three rules the real test enforces exactly checkable in code:
///
///  1. every piece in the assembly must be one of the pieces shown;
///  2. pieces may be rotated but never mirrored, bent or broken;
///  3. pieces may not overlap, and the finished figure must be one joined body.
class Poly {
  Poly(List<GridCell> cells)
    : cells = List<GridCell>.unmodifiable(_dedupe(cells));

  /// Parses a compact bitmap. Rows are separated by '/', '1' is a filled cell:
  /// '10/10/11' is an L tetromino.
  factory Poly.parse(String art) {
    final rows = art.split('/');
    final cells = <GridCell>[];
    for (var y = 0; y < rows.length; y++) {
      final row = rows[y];
      for (var x = 0; x < row.length; x++) {
        if (row[x] == '1') cells.add(GridCell(x, y));
      }
    }
    return Poly(cells);
  }

  final List<GridCell> cells;

  static List<GridCell> _dedupe(List<GridCell> input) {
    final seen = <GridCell>{};
    final out = <GridCell>[];
    for (final c in input) {
      if (seen.add(c)) out.add(c);
    }
    out.sort((a, b) => a.y == b.y ? a.x.compareTo(b.x) : a.y.compareTo(b.y));
    return out;
  }

  int get size => cells.length;

  int get minX => cells.isEmpty ? 0 : cells.map((c) => c.x).reduce(math.min);
  int get minY => cells.isEmpty ? 0 : cells.map((c) => c.y).reduce(math.min);
  int get maxX => cells.isEmpty ? 0 : cells.map((c) => c.x).reduce(math.max);
  int get maxY => cells.isEmpty ? 0 : cells.map((c) => c.y).reduce(math.max);

  int get width => maxX - minX + 1;
  int get height => maxY - minY + 1;

  bool contains(int x, int y) => cells.any((c) => c.x == x && c.y == y);

  /// Translates so the piece's bounding box starts at the origin.
  Poly normalized() => offset(-minX, -minY);

  Poly offset(int dx, int dy) =>
      Poly(cells.map((c) => GridCell(c.x + dx, c.y + dy)).toList());

  /// 90 degrees clockwise about the origin, then re-anchored.
  Poly rotated() =>
      Poly(cells.map((c) => GridCell(-c.y, c.x)).toList()).normalized();

  /// Mirror across the vertical axis, then re-anchored. Deliberately a
  /// separate operation from [rotated]: a mirrored piece is NOT a legal move
  /// in Assembling Objects.
  Poly flipped() =>
      Poly(cells.map((c) => GridCell(-c.x, c.y)).toList()).normalized();

  /// Canonical signature that ignores translation and rotation but respects
  /// chirality.
  String get canonicalKey {
    final keys = <String>[];
    var p = normalized();
    for (var i = 0; i < 4; i++) {
      keys.add(p._rawKey());
      p = p.rotated();
    }
    keys.sort();
    return keys.first;
  }

  String _rawKey() => cells.map((c) => '${c.x},${c.y}').join(';');

  @override
  String toString() => 'Poly(${_rawKey()})';
}

/// One required joint in a labeled-connection item: the piece carrying [a] must
/// end up touching the piece carrying [b] at their marked points.
class AoConnection {
  const AoConnection(this.a, this.b);
  final String a;
  final String b;

  @override
  String toString() => '$a-$b';
}

/// A letter drawn on a specific cell of a rendered figure.
class AoLabel {
  const AoLabel(this.text, this.at);
  final String text;
  final GridCell at;
}

/// The Assembling Objects payload for a single item.
///
/// Two authentic families are modelled, roughly in the proportions the real
/// subtest uses (about 60 / 40):
///
///  * **Fit-together** ([labels] is null). Loose pieces must rotate and
///    translate into one joined figure. Only the silhouette is judged.
///  * **Labeled connection** ([labels] and [connections] are set). Each piece
///    carries a lettered attachment point in the stem, and the answer is the
///    arrangement in which the REQUIRED letters meet. Touching the wrong letter
///    is the characteristic wrong answer on this family, so it is checked
///    explicitly rather than being folded into the silhouette comparison.
///
/// Which options are legal is COMPUTED from three invariants - pieces match as
/// a rotation-invariant multiset, nothing overlaps, and the result is one joined
/// body - plus, for connection items, that every required pair of marked points
/// is orthogonally adjacent. An authoring typo therefore cannot ship an item
/// with two right answers; the test suite asserts exactly one option is legal.
class AoPuzzle {
  const AoPuzzle({
    required this.pieces,
    required this.options,
    this.labels,
    this.anchors,
    this.connections,
    this.optionAnchors,
  });

  /// The loose pieces shown in the stem.
  final List<Poly> pieces;

  /// Candidate assemblies; each is the pieces in their assembled positions.
  final List<List<Poly>> options;

  /// Letter carried by each stem piece, parallel to [pieces]. Null for a
  /// fit-together item.
  final List<String>? labels;

  /// Marked cell of each stem piece, in that piece's own coordinates.
  final List<GridCell>? anchors;

  /// Joints the assembly must contain. Null for a fit-together item.
  final List<AoConnection>? connections;

  /// Marked cell of every placed piece, per option: [option][pieceInOption].
  final List<List<GridCell>>? optionAnchors;

  bool get isConnectionItem =>
      labels != null && anchors != null && connections != null;

  /// Letters to draw on the stem pieces.
  List<AoLabel> get stemLabels {
    if (!isConnectionItem) return const <AoLabel>[];
    return <AoLabel>[
      for (var i = 0; i < pieces.length; i++) AoLabel(labels![i], anchors![i]),
    ];
  }

  /// Letters to draw on a candidate assembly.
  List<AoLabel> optionLabels(int optionIndex) {
    if (!isConnectionItem || optionAnchors == null) return const <AoLabel>[];
    if (optionIndex < 0 || optionIndex >= options.length) {
      return const <AoLabel>[];
    }
    final placed = options[optionIndex];
    final cells = optionAnchors![optionIndex];
    // Letters belong to pieces, not to positions, so recover which stem letter
    // each placed piece carries by matching shape.
    final out = <AoLabel>[];
    for (var i = 0; i < placed.length && i < cells.length; i++) {
      final label = _labelForShape(placed[i]);
      if (label != null) out.add(AoLabel(label, cells[i]));
    }
    return out;
  }

  String? _labelForShape(Poly placed) {
    final key = placed.canonicalKey;
    for (var i = 0; i < pieces.length; i++) {
      if (pieces[i].canonicalKey == key) return labels![i];
    }
    return null;
  }

  /// Pieces present in the assembly match the stem pieces as a multiset,
  /// rotation allowed, mirroring not.
  bool piecesMatch(List<Poly> assembly) {
    if (assembly.length != pieces.length) return false;
    final want = pieces.map((p) => p.canonicalKey).toList()..sort();
    final got = assembly.map((p) => p.canonicalKey).toList()..sort();
    for (var i = 0; i < want.length; i++) {
      if (want[i] != got[i]) return false;
    }
    return true;
  }

  static String cellKey(GridCell c) => '${c.x},${c.y}';

  bool _overlaps(List<Poly> assembly) {
    final seen = <String>{};
    for (final p in assembly) {
      for (final c in p.cells) {
        if (!seen.add(cellKey(c))) return true;
      }
    }
    return false;
  }

  bool _isJoined(List<Poly> assembly) {
    final all = <GridCell>[for (final p in assembly) ...p.cells];
    if (all.isEmpty) return false;
    final set = all.map(cellKey).toSet();
    final start = all.first;
    final queue = <GridCell>[start];
    final visited = <String>{cellKey(start)};
    const deltas = <(int, int)>[(1, 0), (-1, 0), (0, 1), (0, -1)];
    while (queue.isNotEmpty) {
      final cur = queue.removeLast();
      for (final (dx, dy) in deltas) {
        final key = '${cur.x + dx},${cur.y + dy}';
        if (set.contains(key) && visited.add(key)) {
          queue.add(GridCell(cur.x + dx, cur.y + dy));
        }
      }
    }
    return visited.length == set.length;
  }

  /// Every required joint is present: the two marked points are orthogonal
  /// neighbours.
  bool _connectionsSatisfied(int optionIndex) {
    final needed = connections;
    final cells = optionAnchors;
    if (needed == null || cells == null) return true;
    final placed = options[optionIndex];
    final points = cells[optionIndex];
    GridCell? pointFor(String label) {
      for (var i = 0; i < placed.length && i < points.length; i++) {
        if (_labelForShape(placed[i]) == label) return points[i];
      }
      return null;
    }

    for (final joint in needed) {
      final a = pointFor(joint.a);
      final b = pointFor(joint.b);
      if (a == null || b == null) return false;
      if ((a.x - b.x).abs() + (a.y - b.y).abs() != 1) return false;
    }
    return true;
  }

  /// Every marked point must actually sit on its own piece.
  bool _anchorsValid(int optionIndex) {
    if (!isConnectionItem) return true;
    final cells = optionAnchors;
    if (cells == null || optionIndex >= cells.length) return false;
    final placed = options[optionIndex];
    final points = cells[optionIndex];
    if (points.length != placed.length) return false;
    for (var i = 0; i < placed.length; i++) {
      if (!placed[i].cells.any((c) => c == points[i])) return false;
    }
    return true;
  }

  /// A candidate is legal only if the pieces match, nothing overlaps, the result
  /// is one joined body, and every required joint is present.
  bool isLegal(int optionIndex) {
    if (optionIndex < 0 || optionIndex >= options.length) return false;
    final assembly = options[optionIndex];
    return piecesMatch(assembly) &&
        !_overlaps(assembly) &&
        _isJoined(assembly) &&
        _anchorsValid(optionIndex) &&
        _connectionsSatisfied(optionIndex);
  }

  List<bool> get legality =>
      List<bool>.generate(options.length, isLegal, growable: false);

  /// How many options are legal. Must be exactly 1 for a well-formed item.
  int get legaltyCount => legality.where((x) => x).length;

  /// The single legal option, or null when the item is malformed.
  int? get correctIndex {
    final legal = legality;
    final hits = <int>[
      for (var i = 0; i < legal.length; i++)
        if (legal[i]) i,
    ];
    return hits.length == 1 ? hits.first : null;
  }

  /// Union silhouette of a candidate, used by the painter.
  Poly silhouette(int optionIndex) {
    final cells = <GridCell>[for (final p in options[optionIndex]) ...p.cells];
    return Poly(cells);
  }
}
