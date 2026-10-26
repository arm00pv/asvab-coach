import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/bank/assembling_objects_extra.dart';
import 'package:asvab_guard_coach/data/bank/bank_audit.dart';
import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/exam.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/engines/scoring_engine.dart';
import 'package:asvab_guard_coach/screens/exam_screen.dart';
import 'package:asvab_guard_coach/screens/review_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:asvab_guard_coach/widgets/puzzle_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// What one candidate figure gets right and wrong, so a failure names the
/// invariant the item broke rather than only reporting a count.
class _Facts {
  _Facts(this.index, this.puzzle);

  final int index;
  final AoPuzzle puzzle;

  List<Poly> get placed => puzzle.options[index];

  bool get piecesMatch => puzzle.piecesMatch(placed);

  bool get overlaps {
    final seen = <String>{};
    for (final piece in placed) {
      for (final cell in piece.cells) {
        if (!seen.add('${cell.x},${cell.y}')) return true;
      }
    }
    return false;
  }

  /// Required joints still open: a joint is open when its two marked cells are
  /// not orthogonally adjacent. Always zero for a fit-together item, which
  /// carries no letters.
  int get openJoints {
    final joints = puzzle.connections;
    final marks = puzzle.optionAnchors;
    if (joints == null || marks == null) return 0;
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

  @override
  String toString() =>
      'figure ${index + 1}: pieces=$piecesMatch overlap=$overlaps '
      'openJoints=$openJoints legal=${puzzle.isLegal(index)}';
}

String _report(AoPuzzle puzzle) => <String>[
  for (var i = 0; i < puzzle.options.length; i++) _Facts(i, puzzle).toString(),
].join(' | ');

/// Stem pieces plus the outline of the one legal figure. Two items sharing this
/// signature are the same puzzle drawn twice.
String _signature(Question q) {
  final puzzle = q.puzzle!;
  final keys = puzzle.pieces.map((p) => p.canonicalKey).toList()..sort();
  return '${keys.join(' + ')} => ${puzzle.silhouette(q.answerIndex).canonicalKey}';
}

void _expectInsideBox(List<Poly> assembly, String reason) {
  final cells = <GridCell>[for (final piece in assembly) ...piece.cells];
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
  expect(width, lessThanOrEqualTo(8), reason: reason);
  expect(height, lessThanOrEqualTo(8), reason: reason);
}

void main() {
  final extra = assemblingObjectsExtraBank;
  final extraIds = extra.map((q) => q.id).toSet();
  final fitTogether = extra.where((q) => !q.puzzle!.isConnectionItem).toList();
  final connection = extra.where((q) => q.puzzle!.isConnectionItem).toList();

  group('assembling objects extra bank', () {
    test('ships twenty items in the ao-x series', () {
      expect(extra, hasLength(20));
      for (var i = 0; i < extra.length; i++) {
        expect(
          extra[i].id,
          'ao-x${(i + 1).toString().padLeft(2, '0')}',
          reason: 'ids must run ao-x01 .. ao-x20',
        );
      }
      expect(extraIds, hasLength(extra.length));
      expect(extra.every((q) => q.subtest == Subtest.ao), isTrue);
    });

    test('keeps the sixty / forty split the real subtest uses', () {
      expect(fitTogether, hasLength(12));
      expect(connection, hasLength(8));
    });

    test('every item carries four candidate figures', () {
      for (final q in extra) {
        final puzzle = q.puzzle;
        expect(puzzle, isNotNull, reason: q.id);
        expect(puzzle!.options, hasLength(4), reason: q.id);
        expect(q.choices, hasLength(4), reason: q.id);
        expect(puzzle.pieces, isNotEmpty, reason: q.id);
      }
    });

    test('exactly one figure satisfies every rule, and it is the key', () {
      for (final q in extra) {
        final puzzle = q.puzzle!;
        expect(puzzle.legaltyCount, 1, reason: '${q.id}: ${_report(puzzle)}');
        expect(puzzle.correctIndex, q.answerIndex, reason: q.id);
      }
    });

    test('every item carries the three distractor families', () {
      for (final q in extra) {
        final puzzle = q.puzzle!;
        var collisions = 0;
        var separated = 0;
        var inventory = 0;
        var wrongLetters = 0;
        for (var i = 0; i < puzzle.options.length; i++) {
          if (puzzle.isLegal(i)) continue;
          final facts = _Facts(i, puzzle);
          if (!facts.piecesMatch) {
            inventory++;
          } else if (facts.overlaps) {
            collisions++;
          } else if (facts.openJoints > 0) {
            wrongLetters++;
          } else {
            separated++;
          }
        }
        expect(
          collisions,
          greaterThanOrEqualTo(1),
          reason: '${q.id}: needs a figure whose pieces collide',
        );
        expect(
          inventory,
          greaterThanOrEqualTo(1),
          reason: '${q.id}: needs a substituted or mirrored piece',
        );
        if (puzzle.isConnectionItem) {
          expect(
            wrongLetters,
            greaterThanOrEqualTo(1),
            reason:
                '${q.id}: needs a figure that joins the pieces at the wrong '
                'letters; ${_report(puzzle)}',
          );
        } else {
          expect(
            separated,
            greaterThanOrEqualTo(1),
            reason: '${q.id}: needs a figure that falls into two islands',
          );
        }
      }
    });

    test('counting the pieces is never enough on its own', () {
      for (final q in extra) {
        final puzzle = q.puzzle!;
        final matching = <int>[
          for (var i = 0; i < puzzle.options.length; i++)
            if (puzzle.piecesMatch(puzzle.options[i])) i,
        ];
        expect(matching.length, greaterThanOrEqualTo(2), reason: q.id);
        expect(matching.length, lessThan(puzzle.options.length), reason: q.id);
      }
    });

    test('a fit-together item shows four different figures', () {
      // Two tiles drawing the same outline would leave the item unanswerable,
      // so every fit-together option has to be a distinct silhouette.
      for (final q in fitTogether) {
        final puzzle = q.puzzle!;
        final keys = <String>{
          for (var i = 0; i < puzzle.options.length; i++)
            puzzle.silhouette(i).canonicalKey,
        };
        expect(keys, hasLength(4), reason: '${q.id} draws one figure twice');
      }
    });

    test('a connection item has distinct pieces and a letter on each', () {
      for (final q in connection) {
        final puzzle = q.puzzle!;
        final keys = puzzle.pieces.map((p) => p.canonicalKey).toList();
        expect(keys.toSet(), hasLength(keys.length), reason: q.id);
        expect(puzzle.labels, hasLength(puzzle.pieces.length), reason: q.id);
        expect(puzzle.anchors, hasLength(puzzle.pieces.length), reason: q.id);
        expect(puzzle.connections, isNotEmpty, reason: q.id);
        expect(puzzle.optionAnchors, hasLength(4), reason: q.id);
        for (var i = 0; i < puzzle.anchors!.length; i++) {
          expect(
            puzzle.pieces[i].cells.contains(puzzle.anchors![i]),
            isTrue,
            reason: '${q.id}: every letter sits on its own piece',
          );
        }
        for (final anchors in puzzle.optionAnchors!) {
          expect(anchors, hasLength(puzzle.pieces.length), reason: q.id);
        }
      }
    });

    test('every required joint is named in the explanation', () {
      // The stem is deliberately generic, so the review text is the only place
      // the pair of letters is written out in words.
      for (final q in connection) {
        for (final joint in q.puzzle!.connections!) {
          for (final letter in <String>[joint.a, joint.b]) {
            expect(
              RegExp('\\b$letter\\b').hasMatch(q.explanation),
              isTrue,
              reason: '${q.id}: the explanation never mentions $letter',
            );
          }
        }
      }
    });

    test('every figure stays inside an eight by eight box', () {
      for (final q in extra) {
        final puzzle = q.puzzle!;
        _expectInsideBox(puzzle.pieces, '${q.id} loose pieces');
        for (var i = 0; i < puzzle.options.length; i++) {
          _expectInsideBox(puzzle.options[i], '${q.id} figure ${i + 1}');
        }
      }
    });

    test('spreads the answer across the four positions', () {
      final positions = <int>[0, 0, 0, 0];
      for (final q in extra) {
        positions[q.answerIndex]++;
      }
      for (var i = 0; i < positions.length; i++) {
        expect(
          positions[i],
          greaterThanOrEqualTo(3),
          reason: 'position ${i + 1} is under used: ${positions.join('/')}',
        );
      }
    });

    test('spreads difficulty the way the real pool does', () {
      int count(Difficulty d) => extra.where((q) => q.difficulty == d).length;
      expect(count(Difficulty.easy), greaterThanOrEqualTo(4));
      expect(count(Difficulty.medium), greaterThanOrEqualTo(10));
      expect(count(Difficulty.hard), greaterThanOrEqualTo(4));
      expect(
        count(Difficulty.easy) +
            count(Difficulty.medium) +
            count(Difficulty.hard),
        extra.length,
      );
    });

    test('tags only Assembling Objects skills that exist', () {
      for (final q in extra) {
        expect(q.skills, isNotEmpty, reason: q.id);
        expect(q.skills.length, lessThanOrEqualTo(3), reason: q.id);
        for (final id in q.skills) {
          final skill = Skills.maybeById(id);
          expect(skill, isNotNull, reason: '${q.id}: $id');
          expect(skill!.subtest, Subtest.ao, reason: q.id);
        }
      }
    });

    test('never repeats a puzzle the bank already ships', () {
      final shipped = <String, String>{
        for (final q in QuestionBank.bySubtest(Subtest.ao))
          if (!extraIds.contains(q.id)) _signature(q): q.id,
      };
      for (final q in extra) {
        final clash = shipped[_signature(q)];
        expect(clash, isNull, reason: '${q.id} repeats $clash');
      }
    });

    test('is registered with the aggregator', () {
      final ids = QuestionBank.all.map((q) => q.id).toSet();
      for (final q in extra) {
        expect(ids, contains(q.id), reason: '${q.id} is not in the bank');
      }
      expect(QuestionBank.countFor(Subtest.ao), greaterThanOrEqualTo(57));
    });

    test('every item audits clean at item level', () {
      final findings = BankAudit.run(extra, bankLevel: false);
      expect(
        findings.map((f) => f.toString()).toList(),
        isEmpty,
        reason: 'every finding here is an item defect',
      );
    });

    test('options are plain ASCII', () {
      for (final q in extra) {
        for (final text in <String>[q.stem, q.explanation, ...q.choices]) {
          expect(
            RegExp(r'[^\x20-\x7E]').hasMatch(text),
            isFalse,
            reason: '${q.id} contains a non-ASCII character',
          );
        }
      }
    });
  });

  group('the runner draws the figure it grades', () {
    testWidgets('the figure in the graded slot is the legal assembly', (
      tester,
    ) async {
      // Options are reshuffled per attempt, so the tile in display slot i shows
      // the figure held at bank option order[i]. Painting silhouette(i) instead
      // would show one figure and grade another, which is exactly what the
      // runner did before both renderers were pointed through the permutation.
      final q = QuestionBank.byId('ao-x01')!;
      final puzzle = q.puzzle!;
      final order = <int>[2, 0, 3, 1];
      final served = ServedQuestion(base: q, order: order);
      final expectedSlot = order.indexOf(q.answerIndex);
      final legalKey = puzzle.silhouette(q.answerIndex).canonicalKey;

      tester.view.physicalSize = const Size(1280, 1500);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      SharedPreferences.setMockInitialValues(<String, Object>{});
      final state = AppState();
      await state.init();

      final exam = Exam(
        id: 'ao-order-check',
        kind: ExamKind.section,
        title: Subtest.ao.label,
        sections: <ExamSection>[
          ExamSection(
            subtest: Subtest.ao,
            questions: <ServedQuestion>[served],
            minutes: 6,
          ),
        ],
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: state,
          child: MaterialApp(
            theme: AppTheme.build(Brightness.light),
            home: ExamScreen(exam: exam),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Begin section'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);

      final tiles = find.byType(AssemblyOption);
      expect(tiles, findsNWidgets(4));
      final drawn = <String>[];
      for (var i = 0; i < 4; i++) {
        final view = tester.widget<PolyView>(
          find.descendant(of: tiles.at(i), matching: find.byType(PolyView)),
        );
        drawn.add(view.poly.canonicalKey);
      }
      expect(
        drawn[expectedSlot],
        legalKey,
        reason: 'drawn: ${drawn.join(' | ')}',
      );
      for (var i = 0; i < 4; i++) {
        expect(
          drawn[i],
          puzzle.silhouette(order[i]).canonicalKey,
          reason: 'slot ${i + 1} shows the wrong figure: ${drawn.join(' | ')}',
        );
      }
    });

    testWidgets('a replayed attempt badges the figure it calls correct', (
      tester,
    ) async {
      // The review screen is where a candidate learns why an answer was wrong,
      // so the green badge has to sit on the same figure the runner drew. Both
      // screens resolve the figures through the attempt's own permutation.
      final q = QuestionBank.byId('ao-x02')!;
      final puzzle = q.puzzle!;
      final order = <int>[1, 3, 0, 2];
      final wrong = (q.answerIndex + 1) % q.choices.length;

      tester.view.physicalSize = const Size(1280, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      SharedPreferences.setMockInitialValues(<String, Object>{});
      final state = AppState();
      await state.init();

      final attempt = Attempt(
        id: 'ao-review-check',
        kind: ExamKind.section,
        startedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        finishedAt: DateTime.now(),
        report: ScoringEngine.score(
          questions: <Question>[q],
          responses: <QuestionResponse>[
            QuestionResponse(
              questionId: q.id,
              selectedIndex: wrong,
              secondsSpent: 12,
            ),
          ],
          elapsedSeconds: 12,
        ),
        responses: <QuestionResponse>[
          QuestionResponse(
            questionId: q.id,
            selectedIndex: wrong,
            secondsSpent: 12,
          ),
        ],
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

      final tiles = find.byType(AssemblyOption);
      expect(tiles, findsNWidgets(4));
      final legalKey = puzzle.silhouette(q.answerIndex).canonicalKey;
      for (var i = 0; i < 4; i++) {
        final tile = tester.widget<AssemblyOption>(tiles.at(i));
        expect(
          tile.poly.canonicalKey,
          puzzle.silhouette(order[i]).canonicalKey,
          reason: 'slot ${i + 1} replays the wrong figure',
        );
        expect(
          tile.state == OptionState.correct,
          tile.poly.canonicalKey == legalKey,
          reason: 'slot ${i + 1} badges the wrong figure',
        );
      }
    });
  });
}
