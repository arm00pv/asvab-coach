import 'package:asvab_guard_coach/data/bank/assembling_objects_connection.dart';
import 'package:asvab_guard_coach/data/bank/bank_audit.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/polyomino.dart';
import 'package:flutter_test/flutter_test.dart';

/// Human readable account of one candidate: which of the five rules it breaks.
/// The bank is only as trustworthy as the computed legality, so when an item is
/// wrong this string says why, option by option.
String _explain(AoPuzzle puzzle, int index) {
  final placed = puzzle.options[index];
  final marks = puzzle.optionAnchors![index];
  final matches = puzzle.piecesMatch(placed);

  final occupied = <String>{};
  var overlap = false;
  for (final piece in placed) {
    for (final cell in piece.cells) {
      if (!occupied.add('${cell.x},${cell.y}')) overlap = true;
    }
  }

  final all = <GridCell>[for (final piece in placed) ...piece.cells];
  var joined = all.isNotEmpty;
  if (all.isNotEmpty) {
    final visited = <String>{'${all.first.x},${all.first.y}'};
    final queue = <GridCell>[all.first];
    const deltas = <(int, int)>[(1, 0), (-1, 0), (0, 1), (0, -1)];
    while (queue.isNotEmpty) {
      final cur = queue.removeLast();
      for (final (dx, dy) in deltas) {
        final key = '${cur.x + dx},${cur.y + dy}';
        if (occupied.contains(key) && visited.add(key)) {
          queue.add(GridCell(cur.x + dx, cur.y + dy));
        }
      }
    }
    joined = visited.length == occupied.length;
  }

  final marksOnPieces =
      marks.length == placed.length &&
      List<int>.generate(
        placed.length,
        (k) => k,
      ).every((k) => placed[k].cells.contains(marks[k]));

  String? labelOf(Poly piece) {
    for (var k = 0; k < puzzle.pieces.length; k++) {
      if (puzzle.pieces[k].canonicalKey == piece.canonicalKey) {
        return puzzle.labels![k];
      }
    }
    return null;
  }

  GridCell? markOf(String label) {
    for (var k = 0; k < placed.length && k < marks.length; k++) {
      if (labelOf(placed[k]) == label) return marks[k];
    }
    return null;
  }

  final joints = <String>[];
  for (final joint in puzzle.connections ?? const <AoConnection>[]) {
    final a = markOf(joint.a);
    final b = markOf(joint.b);
    if (a == null || b == null) {
      joints.add('${joint.a}-${joint.b}: unmarked');
    } else {
      final gap = (a.x - b.x).abs() + (a.y - b.y).abs();
      joints.add('${joint.a}-${joint.b} = $gap');
    }
  }

  final jointText = joints.join(' / ');
  return 'opt ${index + 1}: pieces=$matches overlap=$overlap '
      'joined=$joined marks=$marksOnPieces $jointText '
      '=> legal=${puzzle.isLegal(index)}';
}

String _report(AoPuzzle puzzle) => <String>[
  for (var i = 0; i < puzzle.options.length; i++) _explain(puzzle, i),
].join(' | ');

void main() {
  group('assembling objects: labeled connection bank', () {
    test('every item is a well formed connection puzzle', () {
      for (final q in assemblingObjectsConnectionBank) {
        final puzzle = q.puzzle;
        expect(puzzle, isNotNull, reason: q.id);
        expect(puzzle!.isConnectionItem, isTrue, reason: q.id);
        expect(
          puzzle.labels,
          isNotNull,
          reason: '${q.id}: connection items carry one letter per piece',
        );
        expect(puzzle.labels!.length, puzzle.pieces.length, reason: q.id);
        final keys = puzzle.pieces.map((p) => p.canonicalKey).toList();
        expect(
          keys.toSet().length,
          keys.length,
          reason:
              '${q.id}: pieces must be visually distinct so a letter '
              'identifies exactly one piece',
        );
        expect(puzzle.options.length, 4, reason: q.id);
        expect(puzzle.optionAnchors!.length, 4, reason: q.id);
        for (final anchors in puzzle.optionAnchors!) {
          expect(
            anchors.length,
            puzzle.pieces.length,
            reason: '${q.id}: one marked cell per piece in every figure',
          );
        }
      }
    });

    test('exactly one figure satisfies every rule', () {
      for (final q in assemblingObjectsConnectionBank) {
        final puzzle = q.puzzle!;
        expect(puzzle.legaltyCount, 1, reason: '${q.id}: ${_report(puzzle)}');
        expect(puzzle.correctIndex, q.answerIndex, reason: q.id);
      }
    });

    test('every item carries one of each distractor family', () {
      for (final q in assemblingObjectsConnectionBank) {
        final puzzle = q.puzzle!;
        var wrongConnection = 0;
        var collision = 0;
        var inventory = 0;
        for (var i = 0; i < puzzle.options.length; i++) {
          if (puzzle.isLegal(i)) continue;
          final detail = _explain(puzzle, i);
          if (detail.contains('pieces=false')) {
            inventory++;
          } else if (detail.contains('overlap=true')) {
            collision++;
          } else {
            wrongConnection++;
          }
        }
        expect(
          wrongConnection,
          greaterThanOrEqualTo(1),
          reason:
              '${q.id}: needs a figure that joins the pieces at the wrong '
              'letters; ${_report(puzzle)}',
        );
        expect(
          collision,
          greaterThanOrEqualTo(1),
          reason: '${q.id}: needs a figure whose pieces collide',
        );
        expect(
          inventory,
          greaterThanOrEqualTo(1),
          reason:
              '${q.id}: needs a figure with a substituted or mirrored piece',
        );
      }
    });

    // The programme's own stem for this family is generic: the letters to be
    // matched are drawn on the pieces, not named in the text. So the item must
    // declare its joints in the puzzle and render the letters on every piece.
    test('the stem follows the official wording and the figure carries the '
        'letters', () {
      const official =
          'Which of these figures will appear if the letters for each object '
          'are matched?';
      for (final q in assemblingObjectsConnectionBank) {
        expect(q.stem, official, reason: q.id);
        final joints = q.puzzle!.connections!;
        expect(joints, isNotEmpty, reason: q.id);
        final drawn = q.puzzle!.stemLabels.map((l) => l.text).toSet();
        for (final joint in joints) {
          expect(drawn, contains(joint.a), reason: q.id);
          expect(drawn, contains(joint.b), reason: q.id);
        }
        for (var i = 0; i < q.puzzle!.options.length; i++) {
          expect(q.puzzle!.optionLabels(i), isNotEmpty, reason: q.id);
        }
      }
    });

    test('ships sixteen items with unique ids in the ao-c series', () {
      final items = assemblingObjectsConnectionBank;
      expect(items.length, 16);
      for (var i = 0; i < items.length; i++) {
        expect(items[i].id, 'ao-c${(i + 1).toString().padLeft(2, '0')}');
      }
      expect(items.map((q) => q.id).toSet().length, items.length);
    });

    test('tags only Assembling Objects skills that exist', () {
      for (final q in assemblingObjectsConnectionBank) {
        expect(q.skills, isNotEmpty, reason: q.id);
        expect(q.skills.length, lessThanOrEqualTo(3), reason: q.id);
        for (final id in q.skills) {
          expect(Skills.maybeById(id), isNotNull, reason: '$q.id: $id');
          expect(q.skills, contains('ao.connection'), reason: q.id);
        }
      }
    });

    test('spreads the answer across positions and difficulty bands', () {
      final items = assemblingObjectsConnectionBank;
      final positions = <int>[0, 0, 0, 0];
      for (final q in items) {
        positions[q.answerIndex]++;
      }
      for (var i = 0; i < positions.length; i++) {
        expect(
          positions[i],
          greaterThanOrEqualTo(3),
          reason: 'position ${i + 1}',
        );
      }
      final easy = items.where((q) => q.difficulty == Difficulty.easy).length;
      final medium = items
          .where((q) => q.difficulty == Difficulty.medium)
          .length;
      final hard = items.where((q) => q.difficulty == Difficulty.hard).length;
      expect(easy, greaterThanOrEqualTo(3));
      expect(medium, greaterThanOrEqualTo(6));
      expect(hard, greaterThanOrEqualTo(3));
      expect(easy + medium + hard, items.length);
    });

    test('counting the pieces is never enough on its own', () {
      // The candidate must still have to look at where the letters land, so
      // more than one figure has to survive the inventory check.
      for (final q in assemblingObjectsConnectionBank) {
        final puzzle = q.puzzle!;
        final matching = <int>[
          for (var i = 0; i < puzzle.options.length; i++)
            if (puzzle.piecesMatch(puzzle.options[i])) i,
        ];
        expect(matching.length, greaterThanOrEqualTo(2), reason: q.id);
        expect(matching.length, lessThan(puzzle.options.length), reason: q.id);
      }
    });

    test('every figure that uses the stem pieces draws a letter for each', () {
      // The renderer drops a mark it cannot attribute, so a figure built from
      // the stem inventory must show one letter per piece; only the decoy that
      // substitutes a piece is allowed to show a piece with no letter.
      for (final q in assemblingObjectsConnectionBank) {
        final puzzle = q.puzzle!;
        expect(puzzle.stemLabels.length, puzzle.pieces.length, reason: q.id);
        for (var i = 0; i < puzzle.options.length; i++) {
          final drawn = puzzle.optionLabels(i).length;
          if (puzzle.piecesMatch(puzzle.options[i])) {
            expect(
              drawn,
              puzzle.pieces.length,
              reason: '$q.id option ${i + 1}',
            );
          } else {
            expect(
              drawn,
              greaterThanOrEqualTo(1),
              reason: '$q.id option ${i + 1}',
            );
          }
        }
      }
    });

    test('the explanation says which letters have to meet', () {
      // The official stem is deliberately generic, so the review text is the
      // only place the required pair is written out in words.
      for (final q in assemblingObjectsConnectionBank) {
        for (final joint in q.puzzle!.connections!) {
          expect(
            RegExp('\\b${joint.a}\\b').hasMatch(q.explanation),
            isTrue,
            reason: '${q.id}: the explanation never mentions ${joint.a}',
          );
          expect(
            RegExp('\\b${joint.b}\\b').hasMatch(q.explanation),
            isTrue,
            reason: '${q.id}: the explanation never mentions ${joint.b}',
          );
        }
      }
    });

    test('every figure stays inside an eight by eight box', () {
      // The real item is drawn in a small box; an assembly that sprawls is a
      // presentation bug the candidate can see.
      for (final q in assemblingObjectsConnectionBank) {
        final puzzle = q.puzzle!;
        final assemblies = <List<Poly>>[puzzle.pieces, ...puzzle.options];
        for (final assembly in assemblies) {
          final cells = <GridCell>[
            for (final piece in assembly) ...piece.cells,
          ];
          final xs = cells.map((c) => c.x);
          final ys = cells.map((c) => c.y);
          final width =
              xs.reduce((a, b) => a > b ? a : b) -
              xs.reduce((a, b) => a < b ? a : b) +
              1;
          final height =
              ys.reduce((a, b) => a > b ? a : b) -
              ys.reduce((a, b) => a < b ? a : b) +
              1;
          expect(width, lessThanOrEqualTo(8), reason: q.id);
          expect(height, lessThanOrEqualTo(8), reason: q.id);
        }
      }
    });

    test('has no audit errors', () {
      final errors = BankAudit.run(
        assemblingObjectsConnectionBank,
        bankLevel: false,
      ).where((f) => f.isError).toList();
      expect(errors, isEmpty, reason: errors.map((f) => '$f').join('\n'));
    });
  });
}
