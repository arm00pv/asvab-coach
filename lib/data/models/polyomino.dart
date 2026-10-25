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

/// The Assembling Objects payload for a single item.
///
/// [pieces] are the loose pieces shown in the stem. Every entry of [options]
/// is a candidate assembly, expressed as the pieces in their assembled
/// positions. Which options are legal is computed, never hand-declared, so an
/// authoring mistake cannot produce a question with two right answers without
/// the test suite catching it.
class AoPuzzle {
  const AoPuzzle({required this.pieces, required this.options});

  final List<Poly> pieces;
  final List<List<Poly>> options;

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

  static String _cellKey(GridCell c) => '${c.x},${c.y}';

  bool _overlaps(List<Poly> assembly) {
    final seen = <String>{};
    for (final p in assembly) {
      for (final c in p.cells) {
        if (!seen.add(_cellKey(c))) return true;
      }
    }
    return false;
  }

  bool _isJoined(List<Poly> assembly) {
    final all = <GridCell>[for (final p in assembly) ...p.cells];
    if (all.isEmpty) return false;
    final set = all.map(_cellKey).toSet();
    final start = all.first;
    final queue = <GridCell>[start];
    final visited = <String>{_cellKey(start)};
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

  /// A candidate is legal only if the pieces match, nothing overlaps, and the
  /// result is one joined body.
  bool isLegal(int optionIndex) {
    if (optionIndex < 0 || optionIndex >= options.length) return false;
    final assembly = options[optionIndex];
    return piecesMatch(assembly) && !_overlaps(assembly) && _isJoined(assembly);
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
