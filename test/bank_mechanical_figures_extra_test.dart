import 'package:asvab_guard_coach/data/bank/bank_audit.dart';
import 'package:asvab_guard_coach/data/bank/mechanical.dart';
import 'package:asvab_guard_coach/data/bank/mechanical_extra.dart';
import 'package:asvab_guard_coach/data/bank/mechanical_figures.dart';
import 'package:asvab_guard_coach/data/bank/mechanical_figures_extra.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every point carried by one drawing instruction, whichever slot holds it.
List<Pt> _points(SketchPrim prim) => <Pt>[
  if (prim.a != null) prim.a!,
  if (prim.b != null) prim.b!,
  if (prim.c != null) prim.c!,
];

String _stemKey(Question q) => q.stem.trim().toLowerCase();

String _choiceKey(Question q) =>
    (q.choices.map((c) => c.trim().toLowerCase()).toList()..sort()).join('|');

void main() {
  final items = mechanicalFigureExtraBank;

  test('no audit errors at item level', () {
    final findings = BankAudit.run(items, bankLevel: false);
    final errors = findings.where((f) => f.isError).toList();
    expect(errors, isEmpty, reason: errors.map((f) => '$f').join('\n'));
    // Nothing in this set should even earn an authoring note.
    expect(findings, isEmpty, reason: findings.map((f) => '$f').join('\n'));
  });

  test('ships ten items with ids mc-f07 to mc-f16, all MC and all drawn', () {
    expect(items.length, 10);
    for (var i = 0; i < items.length; i++) {
      final q = items[i];
      final expected = 'mc-f${(i + 7).toString().padLeft(2, '0')}';
      expect(q.id, expected);
      expect(q.subtest, Subtest.mc, reason: q.id);
      expect(
        q.figure,
        isNotNull,
        reason: '${q.id}: every item carries a figure',
      );
      expect(q.choices.length, 4, reason: q.id);
      expect(q.skills, isNotEmpty, reason: q.id);
      for (final sid in q.skills) {
        expect(sid.startsWith('mc.'), isTrue, reason: '${q.id} -> $sid');
      }
    }
    expect(items.map((q) => q.id).toSet().length, items.length);
  });

  test('repeats no stem and no option set from the other MC pools', () {
    final others = <Question>[
      ...mechanicalBank,
      ...mechanicalExtraBank,
      ...mechanicalFigureBank,
    ];
    final stems = <String, String>{for (final q in others) _stemKey(q): q.id};
    final choiceSets = <String, String>{
      for (final q in others) _choiceKey(q): q.id,
    };
    for (final q in items) {
      final priorStem = stems[_stemKey(q)];
      expect(
        priorStem,
        isNull,
        reason: '${q.id} repeats the stem of $priorStem',
      );
      final priorSet = choiceSets[_choiceKey(q)];
      expect(
        priorSet,
        isNull,
        reason: '${q.id} repeats the options of $priorSet',
      );
      stems[_stemKey(q)] = q.id;
      choiceSets[_choiceKey(q)] = q.id;
    }
  });

  test('every figure is a real drawing with a label', () {
    for (final q in items) {
      final figure = q.figure!;
      expect(
        figure.prims.length,
        greaterThanOrEqualTo(5),
        reason: '${q.id}: only ${figure.prims.length} primitives',
      );
      final labels = figure.prims.where((p) => p.kind == SketchPrimKind.text);
      expect(
        labels,
        isNotEmpty,
        reason: '${q.id}: the figure carries no label',
      );
      expect(
        figure.caption.trim().length,
        greaterThanOrEqualTo(30),
        reason: q.id,
      );
    }
  });

  test('every coordinate sits inside the 0 to 1 canvas', () {
    for (final q in items) {
      for (final prim in q.figure!.prims) {
        for (final p in _points(prim)) {
          expect(
            p.x,
            inInclusiveRange(0.0, 1.0),
            reason: '${q.id}: x = ${p.x} escapes the canvas',
          );
          expect(
            p.y,
            inInclusiveRange(0.0, 1.0),
            reason: '${q.id}: y = ${p.y} escapes the canvas',
          );
        }
        expect(
          prim.r,
          inInclusiveRange(0.0, 1.0),
          reason: '${q.id}: radius ${prim.r} escapes the canvas',
        );
      }
    }
  });

  test('covers the six MC skills the brief asks for', () {
    final bySkill = <String, int>{};
    for (final q in items) {
      for (final sid in q.skills) {
        bySkill[sid] = (bySkill[sid] ?? 0) + 1;
      }
    }
    expect(bySkill['mc.structure'], 2);
    expect(bySkill['mc.motion'], 2);
    expect(bySkill['mc.pressure'], 2);
    expect(bySkill['mc.levers'], 1);
    expect(bySkill['mc.pulleys'], 2);
    expect(bySkill['mc.materials'], 1);
    expect(
      bySkill.values.reduce((a, b) => a + b),
      items.length,
      reason: 'each item carries exactly one skill',
    );
  });

  test('mixes two easy, six medium and two hard items', () {
    expect(items.where((q) => q.difficulty == Difficulty.easy).length, 2);
    expect(items.where((q) => q.difficulty == Difficulty.medium).length, 6);
    expect(items.where((q) => q.difficulty == Difficulty.hard).length, 2);
  });

  test('spreads the correct option across the four positions', () {
    final positions = <int>[0, 0, 0, 0];
    for (final q in items) {
      positions[q.answerIndex]++;
    }
    for (var i = 0; i < positions.length; i++) {
      expect(
        positions[i],
        greaterThanOrEqualTo(2),
        reason: 'position ${i + 1}',
      );
    }
  });

  test('keeps every item plain ASCII', () {
    final ascii = RegExp(r'^[\x20-\x7E]*$');
    for (final q in items) {
      final text = <String>[
        q.stem,
        q.explanation,
        q.figure!.caption,
        ...q.choices,
        for (final p in q.figure!.prims) p.text,
      ];
      for (final t in text) {
        expect(ascii.hasMatch(t), isTrue, reason: '${q.id}: "$t"');
      }
    }
  });
}
