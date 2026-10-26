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

/// Why one candidate assembly is not buildable.
///
/// Each code names exactly one of the geometric rules [AoPuzzle.isLegal]
/// applies, in the order [AoPuzzle.flawFor] checks them, so a figure is only
/// ever explained by something its geometry actually shows.
enum AoFlawCode {
  /// The figure does not carry the same number of pieces as the stem.
  pieceCount('piece-count'),

  /// A piece appears in mirror image, which no rotation can produce.
  pieceMirrored('piece-mirrored'),

  /// A piece is bent, shortened or otherwise not in the stem inventory.
  pieceSubstituted('piece-substituted'),

  /// Two pieces occupy the same cell.
  overlap('overlap'),

  /// The pieces fall into more than one separate body.
  disconnected('disconnected'),

  /// A marked attachment point does not sit on its own piece.
  labelOffPiece('label-off-piece'),

  /// Two marked points that must meet do not touch.
  wrongConnection('wrong-connection');

  const AoFlawCode(this.code);

  /// Stable machine name, used by the audit and the tests.
  final String code;

  @override
  String toString() => code;
}

/// One computed reason, in the shape the review screen renders: a code for the
/// tests and a single plain line for the candidate.
class AoFlaw {
  const AoFlaw(this.code, this.message);

  final AoFlawCode code;

  /// One line, in the same voice as a hand-written choice note.
  final String message;

  @override
  String toString() => '${code.code}: $message';
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

  static const List<(int, int)> _deltas = <(int, int)>[
    (1, 0),
    (-1, 0),
    (0, 1),
    (0, -1),
  ];

  /// How many cells of this assembly are claimed by more than one piece.
  ///
  /// The count is the witness the review screen quotes, so it is measured
  /// rather than guessed at.
  int _sharedCells(List<Poly> assembly) {
    final seen = <String>{};
    var shared = 0;
    for (final p in assembly) {
      for (final c in p.cells) {
        if (!seen.add(cellKey(c))) shared++;
      }
    }
    return shared;
  }

  bool _overlaps(List<Poly> assembly) => _sharedCells(assembly) > 0;

  /// How many separate bodies the union of the pieces falls into. One means the
  /// figure is joined; zero means there is nothing there at all.
  int bodyCount(List<Poly> assembly) {
    final set = <String>{
      for (final p in assembly)
        for (final c in p.cells) cellKey(c),
    };
    if (set.isEmpty) return 0;
    final visited = <String>{};
    var bodies = 0;
    for (final start in set) {
      if (!visited.add(start)) continue;
      bodies++;
      final queue = <GridCell>[_parseCell(start)];
      while (queue.isNotEmpty) {
        final cur = queue.removeLast();
        for (final (dx, dy) in _deltas) {
          final next = GridCell(cur.x + dx, cur.y + dy);
          final key = cellKey(next);
          if (set.contains(key) && visited.add(key)) queue.add(next);
        }
      }
    }
    return bodies;
  }

  static GridCell _parseCell(String key) {
    final comma = key.indexOf(',');
    return GridCell(
      int.parse(key.substring(0, comma)),
      int.parse(key.substring(comma + 1)),
    );
  }

  bool _isJoined(List<Poly> assembly) => bodyCount(assembly) == 1;

  /// The marked cell carrying [label] in one candidate assembly, or null when
  /// the figure carries no mark for it.
  GridCell? _pointFor(int optionIndex, String label) {
    final cells = optionAnchors;
    if (cells == null || optionIndex < 0 || optionIndex >= cells.length) {
      return null;
    }
    final placed = options[optionIndex];
    final points = cells[optionIndex];
    for (var i = 0; i < placed.length && i < points.length; i++) {
      if (_labelForShape(placed[i]) == label) return points[i];
    }
    return null;
  }

  /// Every required joint is present: the two marked points are orthogonal
  /// neighbours.
  bool _connectionsSatisfied(int optionIndex) {
    final needed = connections;
    if (needed == null || optionAnchors == null) return true;
    for (final joint in needed) {
      final a = _pointFor(optionIndex, joint.a);
      final b = _pointFor(optionIndex, joint.b);
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

  /// The first rule [isLegal] rejects one candidate on, as a single plain line,
  /// or null when the figure is buildable.
  ///
  /// Every reason is read off the same geometry the legality check reads - the
  /// piece multiset, the occupancy grid, the connectivity walk and the marked
  /// points - so a review never states a claim the puzzle cannot support, and
  /// the correct figure gets no reason at all (it is explained by the "Why"
  /// box instead).
  AoFlaw? flawFor(int optionIndex) {
    if (optionIndex < 0 || optionIndex >= options.length) {
      return const AoFlaw(
        AoFlawCode.pieceCount,
        'There is no such figure among the candidates.',
      );
    }
    final assembly = options[optionIndex];
    if (!piecesMatch(assembly)) return _inventoryFlaw(assembly);
    final shared = _sharedCells(assembly);
    if (shared > 0) {
      return AoFlaw(
        AoFlawCode.overlap,
        'Two pieces share ${shared == 1 ? 'a cell' : '$shared cells'}, so '
        'they overlap instead of fitting together.',
      );
    }
    final bodies = bodyCount(assembly);
    if (bodies != 1) {
      return AoFlaw(
        AoFlawCode.disconnected,
        bodies == 0
            ? 'The figure is empty, so it cannot be the assembled pieces.'
            : 'The pieces fall into $bodies separate bodies; the finished '
                  'figure has to be one joined outline.',
      );
    }
    if (!_anchorsValid(optionIndex)) return _anchorFlaw(optionIndex);
    if (!_connectionsSatisfied(optionIndex)) return _jointFlaw(optionIndex);
    return null;
  }

  /// One line per candidate, in bank order: null for the figure that works and
  /// a computed reason for every figure that does not.
  List<String?> get optionReasons =>
      List<String?>.generate(options.length, reasonFor, growable: false);

  /// [optionReasons] for one candidate.
  String? reasonFor(int optionIndex) => flawFor(optionIndex)?.message;

  /// The reasons a review should paint, in the order the attempt served the
  /// options: `order[displaySlot]` is the bank option shown in that slot, so
  /// the figures on screen and the reasons beside them always describe the
  /// same candidate. The keyed figure gets null because the "Why" box owns it.
  ///
  /// A slot holding an index this puzzle does not have is left blank rather
  /// than invented.
  List<String?> reasonsInOrder(List<int> order) {
    final keyed = correctIndex;
    return List<String?>.generate(order.length, (slot) {
      final bank = order[slot];
      if (bank < 0 || bank >= options.length) return null;
      if (bank == keyed) return null;
      return reasonFor(bank);
    }, growable: false);
  }

  /// The outline does not match the stem inventory: a piece is mirrored, bent,
  /// shortened or present one time too many.
  AoFlaw _inventoryFlaw(List<Poly> assembly) {
    if (assembly.length != pieces.length) {
      return AoFlaw(
        AoFlawCode.pieceCount,
        'The figure is built from ${assembly.length} pieces; the set has '
        '${pieces.length}.',
      );
    }
    final want = <String, int>{};
    for (final p in pieces) {
      want.update(p.canonicalKey, (n) => n + 1, ifAbsent: () => 1);
    }
    final got = <String, int>{};
    for (final p in assembly) {
      got.update(p.canonicalKey, (n) => n + 1, ifAbsent: () => 1);
    }
    final surplus = <String>[
      for (final e in got.entries)
        if (e.value > (want[e.key] ?? 0)) e.key,
    ];
    final shortfall = <String>[
      for (final e in want.entries)
        if ((got[e.key] ?? 0) < e.value) e.key,
    ];
    if (surplus.isEmpty || shortfall.isEmpty) {
      // Equal piece counts with no surplus and no shortfall means the multiset
      // matched, so this cannot happen; keep a truthful fallback anyway.
      return AoFlaw(
        AoFlawCode.pieceSubstituted,
        'The pieces in this figure are not the pieces shown in the set.',
      );
    }
    int sizeOf(List<Poly> source, String key) =>
        source.firstWhere((p) => p.canonicalKey == key).size;
    final extraKey = surplus.first;
    for (final missingKey in shortfall) {
      final stemPiece = pieces.firstWhere((p) => p.canonicalKey == missingKey);
      if (stemPiece.flipped().canonicalKey == extraKey) {
        return AoFlaw(
          AoFlawCode.pieceMirrored,
          'The ${stemPiece.size}-cell piece is turned over: the figure shows '
          'its mirror image, and no rotation of that piece produces it.',
        );
      }
    }
    final missingKey = shortfall.first;
    final missingSize = sizeOf(pieces, missingKey);
    final usedSize = sizeOf(assembly, extraKey);
    if (missingSize == usedSize) {
      return AoFlaw(
        AoFlawCode.pieceSubstituted,
        'A $usedSize-cell piece is bent into a shape the set does not '
        'carry, so the outline does not match the pieces shown.',
      );
    }
    if (want.containsKey(extraKey)) {
      return AoFlaw(
        AoFlawCode.pieceSubstituted,
        'The figure uses ${got[extraKey]} copies of the $usedSize-cell '
        'piece; the set supplies ${want[extraKey]}.',
      );
    }
    return AoFlaw(
      AoFlawCode.pieceSubstituted,
      'The figure uses a $usedSize-cell piece where the set supplies a '
      '$missingSize-cell one, so the outline does not match the pieces '
      'shown.',
    );
  }

  /// A marked point that is not on its own piece.
  AoFlaw _anchorFlaw(int optionIndex) {
    if (!isConnectionItem) {
      return const AoFlaw(
        AoFlawCode.labelOffPiece,
        'The figure does not carry the letters the item is matched on.',
      );
    }
    final cells = optionAnchors;
    if (cells == null ||
        optionIndex >= cells.length ||
        cells[optionIndex].length != options[optionIndex].length) {
      return const AoFlaw(
        AoFlawCode.labelOffPiece,
        'The figure does not mark one attachment point per piece, so its '
        'letters cannot be read.',
      );
    }
    return const AoFlaw(
      AoFlawCode.labelOffPiece,
      'A marked point sits off its own piece, so the figure does not show the '
      'letter where it has to be matched.',
    );
  }

  /// A required pair of marked points that does not meet.
  AoFlaw _jointFlaw(int optionIndex) {
    final needed = connections ?? const <AoConnection>[];
    for (final joint in needed) {
      final a = _pointFor(optionIndex, joint.a);
      final b = _pointFor(optionIndex, joint.b);
      if (a == null || b == null) {
        return AoFlaw(
          AoFlawCode.wrongConnection,
          'The figure cannot show where ${joint.a} meets ${joint.b}, so the '
          'required join is not made.',
        );
      }
      final gap = (a.x - b.x).abs() + (a.y - b.y).abs();
      if (gap != 1) {
        return AoFlaw(
          AoFlawCode.wrongConnection,
          'The points marked ${joint.a} and ${joint.b} are $gap cells '
          'apart; the answer has to bring them together.',
        );
      }
    }
    return const AoFlaw(
      AoFlawCode.wrongConnection,
      'The letters this item requires do not meet in this figure.',
    );
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
