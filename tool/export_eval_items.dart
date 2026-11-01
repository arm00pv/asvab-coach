import 'dart:convert';
import 'dart:io';

import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/question.dart';

/// Writes a fixed set of real bank items to JSON, for testing an outside model
/// against the app's own answers and explanations.
///
/// The point of using the bank rather than invented questions is that every
/// item here already has an authored key, an authored explanation and a line
/// per wrong option. A model's answer can be marked against that, and its
/// reasoning can be read against a human's.
void main(List<String> args) {
  final target = args.isEmpty
      ? 'build/eval_items.json'
      : args.first;

  // Two items per subtest, text only: a figure or a polyomino cannot be put in
  // a prompt, and marking a model down for not seeing a picture would be a
  // test of the harness rather than of the model.
  const order = <Subtest>[
    Subtest.wk,
    Subtest.pc,
    Subtest.mk,
    Subtest.ar,
    Subtest.gs,
    Subtest.as,
    Subtest.mc,
    Subtest.ei,
  ];

  final items = <Map<String, Object?>>[];
  for (final subtest in order) {
    final pool = QuestionBank.bySubtest(subtest)
        .where(
          (q) =>
              q.figure == null &&
              q.puzzle == null &&
              q.choiceNotes.length == q.choices.length,
        )
        .toList();
    for (final question in pool.take(2)) {
      items.add(<String, Object?>{
        'id': question.id,
        'subtest': subtest.abbr,
        'subtestLabel': subtest.label,
        'passage': question.passage,
        'stem': question.stem,
        'choices': question.choices,
        'answerIndex': question.answerIndex,
        'answerText': question.choices[question.answerIndex],
        'explanation': question.explanation,
        'choiceNotes': question.choiceNotes,
      });
    }
  }

  final file = File(target);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(<String, Object?>{
      'generatedOn': DateTime.now().toIso8601String(),
      'bankSize': QuestionBank.total,
      'items': items,
    }),
  );
  stdout.writeln('wrote ${file.path} with ${items.length} items');
}
