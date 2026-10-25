import 'package:asvab_guard_coach/data/bank/auto_shop_tools.dart';
import 'package:asvab_guard_coach/data/bank/bank_audit.dart';
import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/bank/shop_tool_sketches.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/engines/exam_builder.dart';
import 'package:flutter_test/flutter_test.dart';

/// One synthetic item, so the audit rules can be exercised directly rather
/// than only through whatever the real bank happens to contain.
Question item({
  required List<String> choices,
  required int answerIndex,
  String stem = 'Which hand tool is shown in the drawing?',
  Sketch? figure,
}) => Question(
  id: 'synthetic-1',
  subtest: Subtest.as,
  stem: stem,
  choices: choices,
  answerIndex: answerIndex,
  explanation:
      'A long enough explanation that the item-quality rules do not fire on '
      'the explanation itself while a sketch rule is being tested.',
  difficulty: Difficulty.easy,
  skills: const <String>['as.tools'],
  figure: figure,
);

Set<String> codesFor(Question q) =>
    BankAudit.run(<Question>[q], bankLevel: false).map((f) => f.code).toSet();

void main() {
  group('shop tool items', () {
    test('every item is decided by its drawing', () {
      expect(autoShopToolBank, isNotEmpty);
      for (final q in autoShopToolBank) {
        expect(
          q.figure,
          isNotNull,
          reason: '${q.id} has no drawing, so it measures vocabulary',
        );
        expect(q.subtest, Subtest.as);
        expect(q.skills, contains('as.tools'));
      }
    });

    test('each drawing is wired to the tool its answer names', () {
      for (final q in autoShopToolBank) {
        final correct = q.correctChoice.trim();
        // Only the items that ask for a name; the "why" items answer with a
        // statement instead.
        if (correct.split(RegExp(r'\s+')).length > 4) continue;
        final index = shopToolSketches.indexOf(q.figure!);
        expect(
          index,
          isNonNegative,
          reason: '${q.id} uses a drawing outside the declared set',
        );
        expect(
          correct.toLowerCase(),
          contains(shopToolNames[index]),
          reason:
              '${q.id} shows the ${shopToolNames[index]} drawing but its key is '
              '"$correct"',
        );
      }
    });

    test('a naming item does not name the tool in the stem', () {
      for (final q in autoShopToolBank) {
        final correct = q.correctChoice.trim().toLowerCase();
        if (correct.split(RegExp(r'\s+')).length > 4) continue;
        expect(
          q.stem.toLowerCase(),
          isNot(contains(correct)),
          reason:
              '${q.id} prints the answer in the stem, so the drawing adds '
              'nothing',
        );
      }
    });

    test('captions describe shape without naming tools', () {
      final seen = <String>{};
      for (final sketch in shopToolSketches) {
        expect(seen.add(sketch.caption), isTrue, reason: 'duplicate caption');
        expect(sketch.prims, isNotEmpty);
      }
      // No caption may contain any tool name from the set, or it would print
      // an answer on some item.
      for (final sketch in shopToolSketches) {
        final caption = sketch.caption.toLowerCase();
        for (final name in shopToolNames) {
          expect(
            caption,
            isNot(contains(name)),
            reason: 'caption names "$name": "${sketch.caption}"',
          );
        }
      }
    });

    test('tool items belong to the Shop block, not the Auto block', () {
      final exam = ExamBuilder.fullMock(seed: 5);
      final auto = exam.sections.firstWhere(
        (s) => s.label == 'Auto Information',
      );
      final shop = exam.sections.firstWhere(
        (s) => s.label == 'Shop Information',
      );
      final toolIds = <String>{for (final q in autoShopToolBank) q.id};
      expect(
        auto.questions.where((q) => toolIds.contains(q.id)),
        isEmpty,
        reason: 'hand tools are Shop Information content',
      );
      expect(shop.questions, isNotEmpty);
    });
  });

  group('sketch audit rules', () {
    test('a caption that names the answer is an error', () {
      final q = item(
        choices: const <String>[
          'Claw hammer',
          'Ball-peen hammer',
          'Cross-peen hammer',
          'Riveting hammer',
        ],
        answerIndex: 0,
        figure: const Sketch(
          caption: 'Outline of a claw hammer with a forked claw',
          aspect: 2.6,
          prims: <SketchPrim>[
            SketchPrim.line(Pt(0.2, 0.2), Pt(0.8, 0.8)),
            SketchPrim.line(Pt(0.2, 0.8), Pt(0.8, 0.2)),
          ],
        ),
      );
      expect(codesFor(q), contains('sketch-caption-key'));
    });

    test('a caption that only describes shape is accepted', () {
      final q = item(
        choices: const <String>[
          'Claw hammer',
          'Ball-peen hammer',
          'Cross-peen hammer',
          'Riveting hammer',
        ],
        answerIndex: 0,
        figure: clawHammerSketch,
      );
      expect(codesFor(q), isNot(contains('sketch-caption-key')));
    });

    test('a stem that points at a missing picture is an error', () {
      final q = item(
        choices: const <String>['A', 'B', 'C', 'D'],
        answerIndex: 0,
        stem: 'Which hand tool is shown in the drawing?',
      );
      expect(codesFor(q), contains('stem-refers-to-missing-sketch'));
    });

    test('a mention of diagrams in general does not ask for a picture', () {
      final q = item(
        choices: const <String>['A', 'B', 'C', 'D'],
        answerIndex: 0,
        stem:
            'On a schematic diagram, a capacitor is drawn as the symbol that '
            'looks like',
      );
      expect(codesFor(q), isNot(contains('stem-refers-to-missing-sketch')));
    });

    test('a drawing instruction outside the box is an error', () {
      final q = item(
        choices: const <String>['A', 'B', 'C', 'D'],
        answerIndex: 0,
        figure: const Sketch(
          caption: 'A long enough caption for the drawing under test',
          prims: <SketchPrim>[SketchPrim.line(Pt(0.1, 0.5), Pt(1.6, 0.5))],
        ),
      );
      expect(codesFor(q), contains('sketch-out-of-bounds'));
    });

    test('every shipped drawing is inside the box and captioned', () {
      for (final q in QuestionBank.all) {
        final figure = q.figure;
        if (figure == null) continue;
        final codes = codesFor(q);
        expect(
          codes.where((c) => c.startsWith('sketch-')),
          isEmpty,
          reason: '${q.id} sketch findings',
        );
      }
    });
  });
}
