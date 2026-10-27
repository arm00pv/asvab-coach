import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/engines/scoring_engine.dart';
import 'package:asvab_guard_coach/screens/results_screen.dart';
import 'package:flutter_test/flutter_test.dart';

/// The report may only claim an AFQT percentile and a qualification when the
/// attempt can support them.
///
/// A real session on a phone answered 2 of 15 General Science items and was
/// told "QUALIFIES - You clear the Army National Guard floor". The AFQT is
/// composed from four subtests, so one subtest cannot produce it, however
/// well the two answered items went.
void main() {
  List<Question> pool(Subtest subtest, int count) => QuestionBank.all
      .where((Question q) => q.subtest == subtest)
      .take(count)
      .toList();

  test('a single subtest with most items blank cannot support a claim', () {
    final questions = pool(Subtest.gs, 15);
    final responses = <QuestionResponse>[
      for (final Question q in questions.take(2))
        QuestionResponse(
          questionId: q.id,
          selectedIndex: q.answerIndex,
          secondsSpent: 20,
        ),
      for (final Question q in questions.skip(2))
        QuestionResponse(
          questionId: q.id,
          selectedIndex: null,
          secondsSpent: 2,
        ),
    ];
    final report = ScoringEngine.score(
      questions: questions,
      responses: responses,
      elapsedSeconds: 300,
    );
    expect(
      attemptSupportsAggregate(report),
      isFalse,
      reason: 'two answered items of one subtest is not an AFQT',
    );
  });

  test('a full attempt across the AFQT subtests can support one', () {
    final questions = <Question>[
      ...pool(Subtest.ar, 8),
      ...pool(Subtest.mk, 8),
      ...pool(Subtest.wk, 8),
      ...pool(Subtest.pc, 8),
    ];
    final responses = <QuestionResponse>[
      for (final Question q in questions)
        QuestionResponse(
          questionId: q.id,
          selectedIndex: q.answerIndex,
          secondsSpent: 30,
        ),
    ];
    final report = ScoringEngine.score(
      questions: questions,
      responses: responses,
      elapsedSeconds: 900,
    );
    expect(attemptSupportsAggregate(report), isTrue);
  });

  test('the four AFQT subtests are all required', () {
    for (final Subtest missing in <Subtest>[
      Subtest.ar,
      Subtest.mk,
      Subtest.wk,
      Subtest.pc,
    ]) {
      final questions = <Question>[
        for (final Subtest s in <Subtest>[
          Subtest.ar,
          Subtest.mk,
          Subtest.wk,
          Subtest.pc,
        ])
          if (s != missing) ...pool(s, 8),
      ];
      final responses = <QuestionResponse>[
        for (final Question q in questions)
          QuestionResponse(
            questionId: q.id,
            selectedIndex: q.answerIndex,
            secondsSpent: 30,
          ),
      ];
      final report = ScoringEngine.score(
        questions: questions,
        responses: responses,
        elapsedSeconds: 900,
      );
      expect(
        attemptSupportsAggregate(report),
        isFalse,
        reason: 'a report missing ${missing.abbr} cannot produce an AFQT',
      );
    }
  });
}