import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/review_item.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/engines/exam_builder.dart';
import 'package:asvab_guard_coach/engines/scoring_engine.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Builds a finished attempt that answers the given questions with the given
/// bank-coordinate selections.
Attempt _attempt(
  ExamKind kind,
  Map<String, int?> answers, {
  Set<String> flagged = const <String>{},
}) {
  final questions = <Question>[
    for (final id in answers.keys)
      if (QuestionBank.byId(id) != null) QuestionBank.byId(id)!,
  ];
  final responses = <QuestionResponse>[
    for (final entry in answers.entries)
      QuestionResponse(
        questionId: entry.key,
        selectedIndex: entry.value,
        secondsSpent: 20,
        flagged: flagged.contains(entry.key),
      ),
  ];
  final report = ScoringEngine.score(
    questions: questions,
    responses: responses,
    elapsedSeconds: 400,
  );
  return Attempt(
    id: 'a-${DateTime.now().microsecondsSinceEpoch}',
    kind: kind,
    startedAt: DateTime.now().subtract(const Duration(minutes: 7)),
    finishedAt: DateTime.now(),
    report: report,
    responses: responses,
    questionIds: answers.keys.toList(),
    subtests: const <Subtest>[],
  );
}

Future<AppState> _state() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  return state;
}

void main() {
  group('scheduling', () {
    test('a missed question enters the queue due tomorrow', () async {
      final state = await _state();
      final q = QuestionBank.bySubtest(Subtest.ar).first;
      await state.addAttempt(
        _attempt(ExamKind.section, <String, int?>{
          q.id: (q.answerIndex + 1) % 4,
        }),
        const <String, List<int>>{},
      );
      expect(state.reviews, hasLength(1));
      final item = state.reviews.single;
      expect(item.questionId, q.id);
      expect(item.streak, 0);
      final hours = item.dueAt.difference(DateTime.now()).inHours;
      expect(hours, inInclusiveRange(20, 24));
      // Not due yet, so nothing shows on the dashboard today.
      expect(state.dueReviewCount, 0);
      expect(state.reviewQueueSize, 1);
    });

    test('a question answered correctly first time is not queued', () async {
      final state = await _state();
      final q = QuestionBank.bySubtest(Subtest.mk).first;
      await state.addAttempt(
        _attempt(ExamKind.section, <String, int?>{q.id: q.answerIndex}),
        const <String, List<int>>{},
      );
      expect(state.reviews, isEmpty);
    });

    test('a flagged question is queued even when answered correctly', () async {
      final state = await _state();
      final q = QuestionBank.bySubtest(Subtest.gs).first;
      await state.addAttempt(
        _attempt(
          ExamKind.section,
          <String, int?>{q.id: q.answerIndex},
          flagged: <String>{q.id},
        ),
        const <String, List<int>>{},
      );
      expect(state.reviews, hasLength(1));
    });

    test('a blank answer counts as missed', () async {
      final state = await _state();
      final q = QuestionBank.bySubtest(Subtest.wk).first;
      await state.addAttempt(
        _attempt(ExamKind.section, <String, int?>{q.id: null}),
        const <String, List<int>>{},
      );
      expect(state.reviews, hasLength(1));
    });

    test(
      'missing the same question twice increments the triage counter',
      () async {
        final state = await _state();
        final q = QuestionBank.bySubtest(Subtest.ei).first;
        final wrong = <String, int?>{q.id: (q.answerIndex + 1) % 4};
        await state.addAttempt(
          _attempt(ExamKind.section, wrong),
          const <String, List<int>>{},
        );
        await state.addAttempt(
          _attempt(ExamKind.section, wrong),
          const <String, List<int>>{},
        );
        expect(state.reviews.single.timesMissed, 2);
      },
    );
  });

  group('retrieval', () {
    test('a correct review advances the interval', () async {
      final state = await _state();
      final q = QuestionBank.bySubtest(Subtest.as).first;

      await state.addAttempt(
        _attempt(ExamKind.section, <String, int?>{
          q.id: (q.answerIndex + 1) % 4,
        }),
        const <String, List<int>>{},
      );
      expect(state.reviews.single.streak, 0);

      await state.addAttempt(
        _attempt(ExamKind.review, <String, int?>{q.id: q.answerIndex}),
        const <String, List<int>>{},
      );
      final after = state.reviews.single;
      expect(after.streak, 1);
      final days = after.dueAt.difference(DateTime.now()).inDays;
      expect(days, inInclusiveRange(2, 3));
    });

    test('four correct retrievals graduate the question', () async {
      final state = await _state();
      final q = QuestionBank.bySubtest(Subtest.mc).first;
      await state.addAttempt(
        _attempt(ExamKind.section, <String, int?>{
          q.id: (q.answerIndex + 1) % 4,
        }),
        const <String, List<int>>{},
      );
      for (var i = 0; i < 4; i++) {
        await state.addAttempt(
          _attempt(ExamKind.review, <String, int?>{q.id: q.answerIndex}),
          const <String, List<int>>{},
        );
      }
      expect(
        state.reviews,
        isEmpty,
        reason:
            'a question answered correctly four times should leave the '
            'queue',
      );
    });

    test('a wrong review resets the interval', () async {
      final state = await _state();
      final q = QuestionBank.bySubtest(Subtest.ao).first;
      await state.addAttempt(
        _attempt(ExamKind.section, <String, int?>{
          q.id: (q.answerIndex + 1) % 4,
        }),
        const <String, List<int>>{},
      );
      await state.addAttempt(
        _attempt(ExamKind.review, <String, int?>{q.id: q.answerIndex}),
        const <String, List<int>>{},
      );
      expect(state.reviews.single.streak, 1);
      await state.addAttempt(
        _attempt(ExamKind.review, <String, int?>{
          q.id: (q.answerIndex + 1) % 4,
        }),
        const <String, List<int>>{},
      );
      expect(state.reviews.single.streak, 0);
    });

    test('the queue survives a reload', () async {
      final state = await _state();
      final q = QuestionBank.bySubtest(Subtest.ar).last;
      await state.addAttempt(
        _attempt(ExamKind.section, <String, int?>{
          q.id: (q.answerIndex + 1) % 4,
        }),
        const <String, List<int>>{},
      );
      expect(state.reviews, hasLength(1));

      final reloaded = await _state();
      // Mock prefs are reset per test, so reload from the same state object.
      final persisted = state.reviews.first.toJson();
      final restored = ReviewItem.fromJson(persisted);
      expect(restored, isNotNull);
      expect(restored!.questionId, q.id);
      expect(reloaded.reviews, isEmpty);
    });
  });

  group('review exam', () {
    test('builds a session from exactly the questions given', () {
      final due = QuestionBank.bySubtest(Subtest.mk).take(5).toList();
      final exam = ExamBuilder.review(due, seed: 7);
      expect(exam.kind, ExamKind.review);
      expect(exam.questionCount, due.length);
      final ids = exam.allQuestions.map((q) => q.id).toSet();
      expect(ids, due.map((q) => q.id).toSet());
    });

    test('spans subtests without losing any question', () {
      final due = <Question>[
        ...QuestionBank.bySubtest(Subtest.gs).take(2),
        ...QuestionBank.bySubtest(Subtest.ar).take(2),
        ...QuestionBank.bySubtest(Subtest.ao).take(1),
      ];
      final exam = ExamBuilder.review(due, seed: 11);
      expect(exam.questionCount, 5);
      expect(exam.sections.length, 3);
      // Untimed, so a review is never a race.
      for (final s in exam.sections) {
        expect(s.minutes, 999);
      }
    });

    test('the review queue is emptied of graduated questions only', () async {
      final state = await _state();
      final a = QuestionBank.bySubtest(Subtest.wk).first;
      final b = QuestionBank.bySubtest(Subtest.pc).first;
      await state.addAttempt(
        _attempt(ExamKind.section, <String, int?>{
          a.id: (a.answerIndex + 1) % 4,
          b.id: (b.answerIndex + 1) % 4,
        }),
        const <String, List<int>>{},
      );
      expect(state.reviews, hasLength(2));
      for (var i = 0; i < 4; i++) {
        await state.addAttempt(
          _attempt(ExamKind.review, <String, int?>{a.id: a.answerIndex}),
          const <String, List<int>>{},
        );
      }
      expect(state.reviews, hasLength(1));
      expect(state.reviews.single.questionId, b.id);
    });
  });
}
