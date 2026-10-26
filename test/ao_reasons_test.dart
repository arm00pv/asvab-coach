import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/bank/bank_audit.dart';
import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/engines/scoring_engine.dart';
import 'package:asvab_guard_coach/screens/review_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:asvab_guard_coach/widgets/puzzle_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Assembling Objects cannot carry hand-written distractor notes: its options
/// are figures, and the reason one of them is wrong is geometric. So the reason
/// is COMPUTED from the puzzle, and these tests are the proof that the
/// computation says something true about the geometry rather than something
/// plausible about the item.
///
/// Four things are checked:
///
///  1. every wrong figure in the bank yields a reason, the three of them are
///     distinct, and the keyed figure yields none;
///  2. a reason appears exactly where the legality check refuses the figure,
///     and each code matches an independent read of the drawing;
///  3. a deliberately corrupted figure gets the code that names its
///     corruption, so the mapping is real and not coincidence;
///  4. the review screen prints the reasons against the letters the attempt
///     actually served, which is where the permutation can silently break.

/// Cells claimed by more than one piece: the witness behind an overlap reason.
int _sharedCells(List<Poly> assembly) {
  final seen = <String>{};
  var shared = 0;
  for (final piece in assembly) {
    for (final cell in piece.cells) {
      if (!seen.add('${cell.x},${cell.y}')) shared++;
    }
  }
  return shared;
}

/// Whether some placed piece is the mirror image of a stem piece, which is what
/// an inventory reason claims when it says "turned over".
bool _showsMirror(AoPuzzle puzzle, List<Poly> assembly) {
  final keys = puzzle.pieces.map((p) => p.canonicalKey).toSet();
  for (final piece in assembly) {
    if (keys.contains(piece.canonicalKey)) continue;
    for (final stem in puzzle.pieces) {
      if (stem.flipped().canonicalKey == piece.canonicalKey) return true;
    }
  }
  return false;
}

/// A connection item's joints that are open in one figure: a required pair of
/// marked points that is not orthogonally adjacent.
int _openJoints(AoPuzzle puzzle, int index) {
  final joints = puzzle.connections;
  final marks = puzzle.optionAnchors;
  if (joints == null || marks == null) return 0;
  final placed = puzzle.options[index];
  final points = marks[index];
  GridCell? markOf(String label) {
    for (var k = 0; k < placed.length && k < points.length; k++) {
      final key = placed[k].canonicalKey;
      for (var j = 0; j < puzzle.pieces.length; j++) {
        if (puzzle.pieces[j].canonicalKey == key &&
            puzzle.labels![j] == label) {
          return points[k];
        }
      }
    }
    return null;
  }

  var open = 0;
  for (final joint in joints) {
    final a = markOf(joint.a);
    final b = markOf(joint.b);
    if (a == null || b == null) {
      open++;
    } else if ((a.x - b.x).abs() + (a.y - b.y).abs() != 1) {
      open++;
    }
  }
  return open;
}

String _slot(int index) => String.fromCharCode(65 + index);

void main() {
  final aoItems = QuestionBank.bySubtest(Subtest.ao);

  group('assembling objects: computed distractor reasons', () {
    test('the subtest has items to explain', () {
      expect(aoItems, isNotEmpty);
      for (final q in aoItems) {
        expect(q.puzzle, isNotNull, reason: q.id);
      }
    });

    test('every wrong figure yields a non-empty, distinct, single-line reason '
        'and the keyed figure yields none', () {
      for (final q in aoItems) {
        final puzzle = q.puzzle!;
        final keyed = puzzle.correctIndex;
        expect(
          keyed,
          q.answerIndex,
          reason:
              '${q.id}: the keyed figure must be the one the geometry allows',
        );

        final reasons = puzzle.optionReasons;
        expect(reasons, hasLength(4), reason: q.id);

        final wrong = <String>[];
        for (var i = 0; i < reasons.length; i++) {
          final reason = reasons[i];
          if (i == keyed) {
            expect(
              reason,
              isNull,
              reason:
                  '${q.id}: figure ${i + 1} is the answer, and the answer is '
                  'explained by the Why box, not by a failure note',
            );
            continue;
          }
          expect(
            reason,
            isNotNull,
            reason: '${q.id}: figure ${i + 1} is wrong but explains nothing',
          );
          expect(
            reason!.trim(),
            isNotEmpty,
            reason: '${q.id}: figure ${i + 1} explains nothing',
          );
          expect(
            reason.contains('\n'),
            isFalse,
            reason: '${q.id}: figure ${i + 1} needs one line, not a paragraph',
          );
          expect(
            reason.trim().length,
            lessThanOrEqualTo(160),
            reason:
                '${q.id}: figure ${i + 1} runs to ${reason.length} characters',
          );
          expect(
            reason.trim(),
            reason,
            reason: '${q.id}: figure ${i + 1} carries stray whitespace',
          );
          wrong.add(reason);
        }

        expect(
          wrong.toSet().length,
          wrong.length,
          reason:
              '${q.id}: two figures share one reason, so at least one of them '
              'is being explained wrongly: $wrong',
        );
      }
    });

    test('a reason is produced exactly where the legality check refuses the '
        'figure', () {
      // The two must never disagree: a reason for a buildable figure would tell
      // a candidate their correct answer is wrong.
      for (final q in aoItems) {
        final puzzle = q.puzzle!;
        for (var i = 0; i < puzzle.options.length; i++) {
          expect(
            puzzle.flawFor(i) == null,
            puzzle.isLegal(i),
            reason:
                '${q.id}: figure ${i + 1} legal=${puzzle.isLegal(i)} but '
                'reason=${puzzle.flawFor(i)}',
          );
        }
      }
    });

    test('each code states something the drawing actually shows', () {
      for (final q in aoItems) {
        final puzzle = q.puzzle!;
        for (var i = 0; i < puzzle.options.length; i++) {
          final flaw = puzzle.flawFor(i);
          if (flaw == null) continue;
          final assembly = puzzle.options[i];
          switch (flaw.code) {
            case AoFlawCode.overlap:
              expect(
                _sharedCells(assembly),
                greaterThan(0),
                reason: '${q.id}: figure ${i + 1} claims an overlap it lacks',
              );
            case AoFlawCode.disconnected:
              expect(
                puzzle.bodyCount(assembly),
                isNot(1),
                reason: '${q.id}: figure ${i + 1} is joined after all',
              );
            case AoFlawCode.pieceMirrored:
              expect(
                puzzle.piecesMatch(assembly),
                isFalse,
                reason: '${q.id}: figure ${i + 1} does use the stem pieces',
              );
              expect(
                _showsMirror(puzzle, assembly),
                isTrue,
                reason:
                    '${q.id}: figure ${i + 1} claims a mirror image but no '
                    'piece is one',
              );
            case AoFlawCode.pieceSubstituted:
              expect(
                puzzle.piecesMatch(assembly),
                isFalse,
                reason: '${q.id}: figure ${i + 1} does use the stem pieces',
              );
            case AoFlawCode.wrongConnection:
              expect(
                _openJoints(puzzle, i),
                greaterThan(0),
                reason:
                    '${q.id}: figure ${i + 1} claims a wrong join but every '
                    'required pair of letters meets',
              );
            case AoFlawCode.pieceCount:
            case AoFlawCode.labelOffPiece:
              fail(
                '${q.id}: figure ${i + 1} is reported as ${flaw.code.code}, a '
                'family the bank should not ship',
              );
          }
        }
      }
    });

    test('a wrong-letter reason names the pair of letters the item requires', () {
      var seen = 0;
      for (final q in aoItems.where((q) => q.puzzle!.isConnectionItem)) {
        final puzzle = q.puzzle!;
        for (var i = 0; i < puzzle.options.length; i++) {
          final flaw = puzzle.flawFor(i);
          if (flaw == null || flaw.code != AoFlawCode.wrongConnection) continue;
          final named = puzzle.connections!.any(
            (joint) =>
                flaw.message.contains(joint.a) &&
                flaw.message.contains(joint.b),
          );
          expect(
            named,
            isTrue,
            reason:
                '${q.id}: figure ${i + 1} says "${flaw.message}", which names '
                'no required pair of letters',
          );
          seen++;
        }
      }
      expect(
        seen,
        greaterThan(0),
        reason: 'no wrong-letter figures were found',
      );
    });
  });

  group('assembling objects: the reasons come from the geometry', () {
    // A legal figure from the bank, deliberately corrupted one way at a time.
    // Each corruption is a real geometric change, so the code that comes back
    // has to name that change.
    final base = QuestionBank.byId('ao-001')!;
    final stemPiece = base.puzzle!.pieces[0];
    final smallPiece = base.puzzle!.pieces[1];
    final good = base.puzzle!.options[base.puzzle!.correctIndex!];

    AoFlaw? flawOf(List<Poly> corrupted) {
      final puzzle = AoPuzzle(
        pieces: base.puzzle!.pieces,
        options: <List<Poly>>[good, corrupted],
      );
      expect(
        puzzle.isLegal(0),
        isTrue,
        reason: 'the untouched figure is legal',
      );
      return puzzle.flawFor(1);
    }

    test('a mirrored piece is reported as a mirror image', () {
      final flaw = flawOf(<Poly>[stemPiece.flipped(), smallPiece.offset(6, 6)]);
      expect(flaw, isNotNull);
      expect(flaw!.code, AoFlawCode.pieceMirrored);
      expect(flaw.message, contains('mirror image'));
    });

    test('a substituted piece is reported as an outline that does not '
        'match', () {
      final flaw = flawOf(<Poly>[stemPiece, Poly.parse('10/11').offset(6, 6)]);
      expect(flaw, isNotNull);
      expect(flaw!.code, AoFlawCode.pieceSubstituted);
      expect(flaw.message, contains('outline does not match'));
    });

    test('a lost piece is reported as the wrong piece count', () {
      final flaw = flawOf(<Poly>[stemPiece]);
      expect(flaw, isNotNull);
      expect(flaw!.code, AoFlawCode.pieceCount);
      expect(flaw.message, contains('the set has 2'));
    });

    test('two pieces on one cell are reported as an overlap', () {
      final flaw = flawOf(<Poly>[stemPiece, smallPiece.offset(1, 2)]);
      expect(flaw, isNotNull);
      expect(flaw!.code, AoFlawCode.overlap);
      expect(flaw.message, contains('overlap'));
    });

    test('pieces that never meet are reported as separate bodies', () {
      final flaw = flawOf(<Poly>[stemPiece, smallPiece.offset(6, 6)]);
      expect(flaw, isNotNull);
      expect(flaw!.code, AoFlawCode.disconnected);
      expect(flaw.message, contains('2 separate bodies'));
    });

    // A connection figure built from scratch: a three-cell bar that must meet a
    // two-cell piece, with the letters A and B marking where they touch.
    final bar = Poly.parse('111');
    final domino = Poly.parse('11');
    final pieces = <Poly>[bar, domino];
    const labels = <String>['A', 'B'];
    const stemMarks = <GridCell>[GridCell(2, 0), GridCell(0, 0)];
    const joints = <AoConnection>[AoConnection('A', 'B')];

    AoFlaw? flawOfJoint(List<GridCell> marks) {
      final puzzle = AoPuzzle(
        pieces: pieces,
        options: <List<Poly>>[
          <Poly>[bar, domino.offset(3, 0)],
          <Poly>[bar, domino.offset(3, 0)],
        ],
        labels: labels,
        anchors: stemMarks,
        connections: joints,
        optionAnchors: <List<GridCell>>[
          const <GridCell>[GridCell(2, 0), GridCell(3, 0)],
          marks,
        ],
      );
      expect(puzzle.isLegal(0), isTrue, reason: 'the touching figure is legal');
      return puzzle.flawFor(1);
    }

    test('letters that end up away from each other are a wrong connection', () {
      final flaw = flawOfJoint(const <GridCell>[
        GridCell(0, 0),
        GridCell(4, 0),
      ]);
      expect(flaw, isNotNull);
      expect(flaw!.code, AoFlawCode.wrongConnection);
      expect(flaw.message, contains('A'));
      expect(flaw.message, contains('B'));
      expect(flaw.message, contains('4 cells apart'));
    });

    test('a letter off its own piece cannot be matched at all', () {
      final flaw = flawOfJoint(const <GridCell>[
        GridCell(2, 0),
        GridCell(9, 9),
      ]);
      expect(flaw, isNotNull);
      expect(flaw!.code, AoFlawCode.labelOffPiece);
    });

    test('the legal figure of a corrupted pair explains nothing', () {
      final puzzle = AoPuzzle(
        pieces: pieces,
        options: <List<Poly>>[
          <Poly>[bar, domino.offset(3, 0)],
          <Poly>[bar, domino.offset(1, 0)],
        ],
        labels: labels,
        anchors: stemMarks,
        connections: joints,
        optionAnchors: <List<GridCell>>[
          const <GridCell>[GridCell(2, 0), GridCell(3, 0)],
          const <GridCell>[GridCell(0, 0), GridCell(1, 0)],
        ],
      );
      expect(puzzle.correctIndex, 0);
      expect(puzzle.flawFor(0), isNull);
      expect(puzzle.reasonFor(0), isNull);
      expect(puzzle.optionReasons.first, isNull);
      expect(puzzle.optionReasons.last, isNotNull);
    });
  });

  group('assembling objects: the served order', () {
    const order = <int>[2, 0, 3, 1];

    test('reasons resolve through the permutation the attempt served', () {
      for (final q in aoItems) {
        final puzzle = q.puzzle!;
        final keyed = puzzle.correctIndex;
        final served = puzzle.reasonsInOrder(order);
        expect(served, hasLength(4), reason: q.id);
        for (var slot = 0; slot < order.length; slot++) {
          final bank = order[slot];
          expect(
            served[slot],
            bank == keyed ? isNull : puzzle.reasonFor(bank),
            reason:
                '${q.id}: display slot ${_slot(slot)} holds bank figure '
                '${bank + 1}',
          );
        }
        expect(
          served.where((r) => r != null).length,
          3,
          reason: '${q.id}: three of the four figures are wrong',
        );
        expect(
          served,
          isNot(puzzle.optionReasons),
          reason: '${q.id}: a non-identity order must not read like bank order',
        );
      }
    });

    test('an identity order reproduces bank order exactly', () {
      for (final q in aoItems) {
        final puzzle = q.puzzle!;
        expect(
          puzzle.reasonsInOrder(const <int>[0, 1, 2, 3]),
          puzzle.optionReasons,
          reason: q.id,
        );
      }
    });

    test('a slot the puzzle does not have is left blank, not invented', () {
      final puzzle = aoItems.first.puzzle!;
      final served = puzzle.reasonsInOrder(const <int>[0, 9]);
      expect(served, hasLength(2));
      expect(served[1], isNull);
    });
  });

  group('assembling objects: audit coverage', () {
    test('every AO item is counted as explained by computation', () {
      final coverage = BankAudit.explanationCoverage(aoItems);
      expect(coverage.items, aoItems.length);
      expect(
        coverage.computed,
        aoItems.length,
        reason:
            'computed=${coverage.computed} of ${aoItems.length} AO items; the '
            'rest claim geometry that does not explain every figure',
      );
      expect(coverage.authored, 0);
      expect(coverage.missing, 0);
      expect(coverage.covered, aoItems.length);
      expect(coverage.percent, 100);
      for (final q in aoItems) {
        expect(
          BankAudit.explanationSource(q),
          ExplanationSource.computed,
          reason: q.id,
        );
      }
    });

    test('the count is read off the puzzles, never hard coded', () {
      // Two legal figures means there is no keyed figure to suppress, so the
      // item cannot explain its wrong options however confident an audit might
      // be about the subtest. This has to read as uncovered.
      final single = Poly.parse('11');
      final broken = Question(
        id: 'ao-audit-probe',
        subtest: Subtest.ao,
        stem: 'Which of these figures will appear if they are fit together?',
        choices: const <String>['Figure A', 'Figure B'],
        answerIndex: 0,
        explanation: 'A probe item that is not part of the shipped bank.',
        difficulty: Difficulty.easy,
        skills: const <String>['ao.pieces'],
        puzzle: AoPuzzle(
          pieces: <Poly>[single],
          options: <List<Poly>>[
            <Poly>[single],
            <Poly>[single.offset(4, 0)],
          ],
        ),
      );
      expect(broken.puzzle!.correctIndex, isNull);
      expect(
        BankAudit.explanationSource(broken),
        ExplanationSource.missing,
        reason: 'a puzzle with no keyed figure cannot explain its options',
      );

      final coverage = BankAudit.explanationCoverage(<Question>[
        broken,
        ...aoItems.take(2),
      ]);
      expect(coverage.computed, 2);
      expect(coverage.missing, 1);
      expect(coverage.covered, 2);
      expect(coverage.items, 3);
      expect(coverage.line, contains('2 of 3 items'));
      expect(coverage.line, contains('computed from geometry'));
    });

    test('the bank audit has nothing to report about an AO item', () {
      final findings = BankAudit.run(aoItems, bankLevel: false);
      expect(
        findings.map((f) => f.toString()).toList(),
        isEmpty,
        reason: 'an AO item that cannot explain a figure is reported here',
      );
    });
  });

  group('assembling objects: the review screen', () {
    testWidgets('paints each computed reason against the letter that served '
        'it', (WidgetTester tester) async {
      // The permutation is where this breaks silently: reasons in bank order
      // look right on a screenshot and label the wrong figures. So the attempt
      // is served in a shuffled order and every reason is checked against its
      // letter and against the figure drawn in that slot.
      final q = QuestionBank.byId('ao-x01')!;
      final puzzle = q.puzzle!;
      const List<int> order = <int>[2, 0, 3, 1];
      final int keyedSlot = order.indexOf(q.answerIndex);
      final int pickedSlot = (keyedSlot + 1) % 4;

      tester.view.physicalSize = const Size(1280, 2200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      SharedPreferences.setMockInitialValues(<String, Object>{});
      final AppState state = AppState();
      await state.init();

      final QuestionResponse response = QuestionResponse(
        questionId: q.id,
        selectedIndex: order[pickedSlot],
        secondsSpent: 15,
      );
      final Attempt attempt = Attempt(
        id: 'ao-reason-review-check',
        kind: ExamKind.section,
        startedAt: DateTime.now().subtract(const Duration(minutes: 4)),
        finishedAt: DateTime.now(),
        report: ScoringEngine.score(
          questions: <Question>[q],
          responses: <QuestionResponse>[response],
          elapsedSeconds: 15,
        ),
        responses: <QuestionResponse>[response],
        questionIds: <String>[q.id],
        subtests: <Subtest>[Subtest.ao],
      );
      await state.addAttempt(attempt, <String, List<int>>{q.id: order});

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: state,
          child: MaterialApp(
            theme: AppTheme.build(Brightness.light),
            home: ReviewScreen(attempt: attempt),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);

      // The figures must still replay through the permutation.
      final tiles = find.byType(AssemblyOption);
      expect(tiles, findsNWidgets(4));
      for (var slot = 0; slot < 4; slot++) {
        expect(
          tester.widget<AssemblyOption>(tiles.at(slot)).poly.canonicalKey,
          puzzle.silhouette(order[slot]).canonicalKey,
          reason: 'slot ${_slot(slot)} draws the wrong figure',
        );
      }

      // ...and so must the reasons, in the same display order.
      final expected = <String>[];
      for (var slot = 0; slot < 4; slot++) {
        if (slot == keyedSlot) continue;
        final reason = puzzle.reasonFor(order[slot])!;
        expected.add(slot == pickedSlot ? '$reason (your answer)' : reason);
      }
      expect(expected, hasLength(3));

      final painted = <String>[
        for (final Text text in tester.widgetList<Text>(find.byType(Text)))
          if (text.data != null) text.data!,
      ];
      for (final line in expected) {
        expect(
          painted.where((t) => t == line).length,
          1,
          reason: 'the review should paint "$line" exactly once',
        );
      }

      // Order is the whole point: walk the painted reasons in tree order and
      // check each one sits beside its own letter.
      final inOrder = <String>[
        for (final Text text in tester.widgetList<Text>(find.byType(Text)))
          if (text.data != null && expected.contains(text.data)) text.data!,
      ];
      expect(
        inOrder,
        expected,
        reason: 'the reasons are painted out of display order',
      );

      for (var slot = 0; slot < 4; slot++) {
        if (slot == keyedSlot) continue;
        final reason = puzzle.reasonFor(order[slot])!;
        final line = slot == pickedSlot ? '$reason (your answer)' : reason;
        final row = find
            .ancestor(of: find.text(line), matching: find.byType(Row))
            .first;
        final letters = tester
            .widgetList<Text>(
              find.descendant(of: row, matching: find.byType(Text)),
            )
            .map((t) => t.data ?? '')
            .toList();
        expect(
          letters.first,
          _slot(slot),
          reason:
              'bank figure ${order[slot] + 1} is served in slot ${_slot(slot)} '
              'but its reason is labelled ${letters.first}',
        );
      }

      // The keyed figure belongs to the Why box, not to the failure list: the
      // notes block carries exactly three rows, one per wrong figure, under
      // the same heading the prose items use.
      expect(puzzle.reasonFor(q.answerIndex), isNull);
      expect(
        painted.where((t) => expected.contains(t)).length,
        3,
        reason: 'the notes block should hold one row per wrong figure',
      );
      expect(
        painted,
        contains('Why the others fail'),
        reason: 'the AO notes read under the same heading as a prose item',
      );
    });
  });
}
