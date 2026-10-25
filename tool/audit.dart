// Question bank audit. Runs without a Flutter binding.
//
//   dart run tool/audit.dart            full report
//   dart run tool/audit.dart --strict  non-zero exit if anything at all is
//                                      reported, warnings included
import 'dart:io';

import 'package:asvab_guard_coach/data/bank/bank_audit.dart';
import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';

void main(List<String> args) {
  final strict = args.contains('--strict');
  final questions = QuestionBank.all;
  final findings = BankAudit.run(questions);
  final errors = findings.where((f) => f.isError).toList();
  final warnings = findings.where((f) => !f.isError).toList();

  stdout.writeln('ASVAB Coach - question bank audit');
  stdout.writeln('=${'=' * 40}');
  stdout.writeln('Total items: ${questions.length}');
  stdout.writeln('');

  stdout.writeln('Items per subtest (official mock size in brackets)');
  for (final s in Subtest.administrationOrder) {
    final count = QuestionBank.countFor(s);
    final need = s.questionCount;
    final flag = count >= need ? ' ' : '!';
    stdout.writeln(
      '  $flag ${s.abbr.padRight(3)} ${count.toString().padLeft(3)} '
      '[$need]  ${s.label}',
    );
  }
  stdout.writeln('');

  final coverage = BankAudit.coverage(questions);
  stdout.writeln('Skills with the thinnest coverage');
  final sorted = coverage.entries.toList()
    ..sort((a, b) => a.value.compareTo(b.value));
  for (final entry in sorted.take(12)) {
    final skill = Skills.maybeById(entry.key);
    stdout.writeln(
      '  ${entry.value.toString().padLeft(3)}  ${entry.key.padRight(18)} '
      '${skill?.label ?? '?'}',
    );
  }
  stdout.writeln('');

  stdout.writeln('Difficulty mix per subtest (easy / medium / hard)');
  for (final s in Subtest.administrationOrder) {
    final pool = questions.where((q) => q.subtest == s).toList();
    if (pool.isEmpty) continue;
    String share(Difficulty d) {
      final n = pool.where((q) => q.difficulty == d).length;
      return '${(100 * n / pool.length).round()}%';
    }

    stdout.writeln(
      '  ${s.abbr.padRight(3)} ${share(Difficulty.easy).padLeft(4)} '
      '${share(Difficulty.medium).padLeft(5)} ${share(Difficulty.hard).padLeft(4)}',
    );
  }
  stdout.writeln('');

  if (errors.isNotEmpty) {
    stdout.writeln('ERRORS (${errors.length})');
    for (final e in errors) {
      stdout.writeln('  $e');
    }
    stdout.writeln('');
  }
  if (warnings.isNotEmpty) {
    stdout.writeln('WARNINGS (${warnings.length})');
    for (final w in warnings) {
      stdout.writeln('  $w');
    }
    stdout.writeln('');
  }
  if (errors.isEmpty && warnings.isEmpty) {
    stdout.writeln('Clean: no findings.');
  }

  final failed = errors.isNotEmpty || (strict && warnings.isNotEmpty);
  exit(failed ? 1 : 0);
}
