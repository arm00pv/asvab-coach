import 'dart:convert';

import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/repos/serialization.dart';
import 'package:asvab_guard_coach/engines/exam_builder.dart';
import 'package:asvab_guard_coach/engines/scoring_engine.dart';
import 'package:asvab_guard_coach/state/exam_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('exam builder', () {
    test('a full mock matches the CAT-ASVAB structure', () {
      final exam = ExamBuilder.fullMock(seed: 42);
      // Auto & Shop is administered as two separate blocks on the computer
      // form, so a full mock has ten sections for nine subtests.
      expect(exam.sections.length, 10);
      expect(exam.questionCount, 135);
      expect(exam.minutes, 197);
      expect(exam.subtests.toSet(), Subtest.administrationOrder.toSet());
      final autoShop = exam.sectionsFor(Subtest.as);
      expect(autoShop.length, 2);
      expect(autoShop.first.displayLabel, 'Auto Information');
      expect(autoShop.last.displayLabel, 'Shop Information');
      expect(autoShop.fold<int>(0, (n, s) => n + s.questions.length), 20);
      expect(autoShop.fold<int>(0, (n, s) => n + s.minutes), 13);
    });

    test('a full mock follows the official item counts per subtest', () {
      final exam = ExamBuilder.fullMock(seed: 7);
      for (final s in Subtest.administrationOrder) {
        expect(
          exam.countFor(s),
          greaterThanOrEqualTo(s.questionCount),
          reason: s.abbr,
        );
      }
    });

    test('the diagnostic covers all nine subtests', () {
      final exam = ExamBuilder.diagnostic(seed: 3);
      expect(exam.sections.length, 9);
      for (final s in Subtest.administrationOrder) {
        expect(exam.countFor(s), 3, reason: s.abbr);
      }
    });

    test('a section practice stays inside one subtest', () {
      final exam = ExamBuilder.section(Subtest.ar, seed: 5);
      expect(exam.sections.length, 1);
      expect(exam.sections.single.subtest, Subtest.ar);
      expect(exam.sections.single.questions.length, Subtest.ar.questionCount);
    });

    test('options are shuffled away from the bank order sometimes', () {
      final exam = ExamBuilder.fullMock(seed: 11);
      final permuted = exam.allQuestions.where((q) {
        for (var i = 0; i < q.order.length; i++) {
          if (q.order[i] != i) return true;
        }
        return false;
      }).length;
      expect(
        permuted,
        greaterThan(0),
        reason: 'shuffling should reorder at least some questions',
      );
    });

    test('the display answer always maps back to the bank answer', () {
      final exam = ExamBuilder.fullMock(seed: 13);
      for (final q in exam.allQuestions) {
        expect(q.order[q.displayAnswerIndex], q.base.answerIndex);
        expect(q.displayChoices[q.displayAnswerIndex], q.base.correctChoice);
      }
    });

    test('the same seed reproduces the same exam', () {
      final a = ExamBuilder.section(Subtest.mk, seed: 99);
      final b = ExamBuilder.section(Subtest.mk, seed: 99);
      expect(
        a.allQuestions.map((q) => q.id).toList(),
        b.allQuestions.map((q) => q.id).toList(),
      );
    });
  });

  group('exam session', () {
    test('answering everything correctly maxes the report', () {
      final exam = ExamBuilder.fullMock(seed: 21);
      final responses = <QuestionResponse>[
        for (final q in exam.allQuestions)
          QuestionResponse(
            questionId: q.id,
            selectedIndex: q.base.answerIndex,
            secondsSpent: 30,
          ),
      ];
      final report = ScoringEngine.score(
        questions: exam.allQuestions.map((q) => q.base).toList(),
        responses: responses,
        elapsedSeconds: 4000,
      );
      expect(report.afqtPercentile, greaterThanOrEqualTo(95));
      expect(report.gt, greaterThanOrEqualTo(140));
      expect(report.category, anyOf('I', 'II'));
    });

    test('answering everything wrong bottoms out', () {
      final exam = ExamBuilder.fullMock(seed: 22);
      final responses = <QuestionResponse>[
        for (final q in exam.allQuestions)
          QuestionResponse(
            questionId: q.id,
            selectedIndex: (q.base.answerIndex + 1) % 4,
            secondsSpent: 20,
          ),
      ];
      final report = ScoringEngine.score(
        questions: exam.allQuestions.map((q) => q.base).toList(),
        responses: responses,
        elapsedSeconds: 3000,
      );
      expect(report.afqtPercentile, lessThan(31));
      expect(report.meetsArmyFloor, isFalse);
    });

    test('leaving everything blank scores zero, not a crash', () {
      final exam = ExamBuilder.fullMock(seed: 23);
      final report = ScoringEngine.score(
        questions: exam.allQuestions.map((q) => q.base).toList(),
        responses: const <QuestionResponse>[],
        elapsedSeconds: 10,
      );
      expect(report.totalCorrect, 0);
      expect(report.afqtPercentile, inInclusiveRange(1, 99));
    });

    test('a session advances through sections and finishes', () {
      final exam = ExamBuilder.diagnostic(seed: 31);
      final session = ExamSession(exam: exam, seed: 31);
      expect(session.sectionIndex, 0);
      var guard = 0;
      while (!session.finished && guard++ < 400) {
        session.answer(0);
        if (session.questionIndex < session.sectionQuestionCount - 1) {
          session.next();
        } else {
          session.completeSection();
        }
      }
      expect(session.finished, isTrue);
      expect(session.sectionIndex, exam.sections.length - 1);
      final report = session.finish();
      expect(report.totalAnswered, exam.questionCount);
      session.dispose();
    });

    test('answers are stored in bank coordinates, not display order', () {
      final exam = ExamBuilder.section(Subtest.wk, seed: 41);
      final session = ExamSession(exam: exam, seed: 41);
      final served = session.current;
      session.answer(served.displayAnswerIndex);
      final response = session.responses.firstWhere(
        (r) => r.questionId == served.id,
      );
      expect(response.selectedIndex, served.base.answerIndex);
      session.dispose();
    });
  });

  group('persistence round trip', () {
    test('an attempt survives JSON encoding unchanged', () {
      final exam = ExamBuilder.diagnostic(seed: 51);
      final session = ExamSession(exam: exam, seed: 51);
      for (final q in exam.allQuestions) {
        session.jumpTo(0);
        session.answer(q.displayAnswerIndex);
      }
      final report = session.finish();
      final attempt = session.toAttempt(report);
      final json = Serialization.attemptToJson(attempt, session.orders);
      final encoded = jsonEncode(json);
      final decoded = (jsonDecode(encoded) as Map).cast<String, dynamic>();
      final restored = Serialization.attemptFromJson(decoded);

      expect(restored.id, attempt.id);
      expect(restored.kind, attempt.kind);
      expect(restored.report.afqtPercentile, attempt.report.afqtPercentile);
      expect(restored.report.gt, attempt.report.gt);
      expect(restored.report.ve, attempt.report.ve);
      expect(restored.report.totalCorrect, attempt.report.totalCorrect);
      expect(restored.questionIds.length, attempt.questionIds.length);
      expect(restored.responses.length, attempt.responses.length);
      expect(
        Serialization.ordersFromJson(decoded)[exam.allQuestions.first.id],
        session.orders[exam.allQuestions.first.id],
      );
      session.dispose();
    });
  });

  group('drills and lesson quizzes', () {
    test('a drill only contains questions for the requested skills', () {
      final exam = ExamBuilder.drill(
        skillIds: <String>['ar.percent', 'mk.algebra'],
        seed: 61,
      );
      expect(exam.allQuestions, isNotEmpty);
      for (final q in exam.allQuestions) {
        expect(
          q.base.skills.any((s) => s == 'ar.percent' || s == 'mk.algebra'),
          isTrue,
          reason: q.id,
        );
      }
    });

    test('a lesson quiz is drawn from the skill it checks', () {
      final exam = ExamBuilder.lessonQuiz('mk.exponents', seed: 62);
      expect(exam.allQuestions, isNotEmpty);
      for (final q in exam.allQuestions) {
        expect(q.base.skills, contains('mk.exponents'));
      }
    });

    test('every drill skill in the taxonomy has questions', () {
      for (final skill in Skills.all) {
        expect(
          QuestionBank.all.where((q) => q.skills.contains(skill.id)).length,
          greaterThan(0),
          reason: skill.id,
        );
      }
    });
  });
}
