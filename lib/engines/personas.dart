import 'dart:math' as math;

import '../data/models/catalog.dart';
import '../data/models/exam.dart';
import '../data/models/mos.dart';
import '../data/models/question.dart';
import '../data/models/score.dart';
import 'adaptive_engine.dart';
import 'eligibility_engine.dart';
import 'persona_exam_factory.dart';
import 'scoring_engine.dart';

/// Synthetic learners used to exercise the whole pipeline end to end.
///
/// A persona is a probability of answering each subtest correctly. Feeding one
/// through the real scoring engine is how the project proves that a weak
/// candidate reads as weak, a strong candidate reads as strong, and the coaching
/// advice actually changes accordingly - without waiting for a human to sit a
/// test.
abstract final class Personas {
  static const marcus = Persona(
    id: 'marcus',
    name: 'Marcus - fresh recruit',
    description:
        'Eight years out of school, rusty on everything, motivated but '
        'unprepared. The candidate the diagnostic exists for.',
    accuracyBySubtest: <Subtest, double>{
      Subtest.gs: 0.42,
      Subtest.ar: 0.30,
      Subtest.wk: 0.44,
      Subtest.pc: 0.46,
      Subtest.mk: 0.28,
      Subtest.ei: 0.38,
      Subtest.as: 0.52,
      Subtest.mc: 0.42,
      Subtest.ao: 0.48,
    },
    timePerQuestionSeconds: 62,
    flagRate: 0.3,
  );

  static const jenna = Persona(
    id: 'jenna',
    name: 'Jenna - strong student',
    description:
        'Recently finished community college. Reads well, computes '
        'quickly, and is aiming for a technical MOS.',
    accuracyBySubtest: <Subtest, double>{
      Subtest.gs: 0.80,
      Subtest.ar: 0.78,
      Subtest.wk: 0.86,
      Subtest.pc: 0.84,
      Subtest.mk: 0.74,
      Subtest.ei: 0.62,
      Subtest.as: 0.54,
      Subtest.mc: 0.58,
      Subtest.ao: 0.76,
    },
    timePerQuestionSeconds: 40,
    flagRate: 0.05,
  );

  static const dana = Persona(
    id: 'dana',
    name: 'Dana - maths anxious',
    description:
        'Strong reader who freezes on arithmetic. A textbook case for '
        'targeting AR and MK, which are exactly the AFQT-heavy subtests.',
    accuracyBySubtest: <Subtest, double>{
      Subtest.gs: 0.62,
      Subtest.ar: 0.26,
      Subtest.wk: 0.82,
      Subtest.pc: 0.80,
      Subtest.mk: 0.30,
      Subtest.ei: 0.40,
      Subtest.as: 0.44,
      Subtest.mc: 0.38,
      Subtest.ao: 0.60,
    },
    timePerQuestionSeconds: 70,
    flagRate: 0.25,
  );

  static const ruiz = Persona(
    id: 'ruiz',
    name: 'Ruiz - career mechanic',
    description:
        'Twelve years in a garage. Dominates Auto & Shop, Mechanical '
        'and Electronics, and loses points on vocabulary.',
    accuracyBySubtest: <Subtest, double>{
      Subtest.gs: 0.50,
      Subtest.ar: 0.52,
      Subtest.wk: 0.34,
      Subtest.pc: 0.40,
      Subtest.mk: 0.46,
      Subtest.ei: 0.86,
      Subtest.as: 0.92,
      Subtest.mc: 0.88,
      Subtest.ao: 0.70,
    },
    timePerQuestionSeconds: 52,
    flagRate: 0.1,
  );

  static const ava = Persona(
    id: 'ava',
    name: 'Ava - officer candidate',
    description:
        'Four-year degree, chasing OCS. Needs GT 110, which means the '
        'verbal pair and AR.',
    accuracyBySubtest: <Subtest, double>{
      Subtest.gs: 0.82,
      Subtest.ar: 0.86,
      Subtest.wk: 0.90,
      Subtest.pc: 0.88,
      Subtest.mk: 0.84,
      Subtest.ei: 0.62,
      Subtest.as: 0.56,
      Subtest.mc: 0.64,
      Subtest.ao: 0.80,
    },
    timePerQuestionSeconds: 38,
    flagRate: 0.04,
  );

  static const sam = Persona(
    id: 'sam',
    name: 'Sam - pure guesser',
    description:
        'Answers every item at chance. The floor case: the engine must '
        'never report this candidate as qualified for a technical MOS.',
    accuracyBySubtest: <Subtest, double>{
      Subtest.gs: 0.25,
      Subtest.ar: 0.25,
      Subtest.wk: 0.25,
      Subtest.pc: 0.25,
      Subtest.mk: 0.25,
      Subtest.ei: 0.25,
      Subtest.as: 0.25,
      Subtest.mc: 0.25,
      Subtest.ao: 0.25,
    },
    timePerQuestionSeconds: 8,
    flagRate: 0.0,
  );

  static const taylor = Persona(
    id: 'taylor',
    name: 'Taylor - speed runner',
    description:
        'Accurate but rushed - fourteen seconds a question. Tests that '
        'the pace analysis reads correctly.',
    accuracyBySubtest: <Subtest, double>{
      Subtest.gs: 0.68,
      Subtest.ar: 0.62,
      Subtest.wk: 0.72,
      Subtest.pc: 0.70,
      Subtest.mk: 0.64,
      Subtest.ei: 0.58,
      Subtest.as: 0.60,
      Subtest.mc: 0.58,
      Subtest.ao: 0.66,
    },
    timePerQuestionSeconds: 14,
    flagRate: 0.0,
  );

  static const all = <Persona>[marcus, jenna, dana, ruiz, ava, sam, taylor];

  static Persona byId(String id) =>
      all.firstWhere((p) => p.id == id, orElse: () => marcus);
}

/// A scored persona outcome, plus the derived coaching the app would show.
class PersonaResult {
  const PersonaResult({
    required this.persona,
    required this.report,
    required this.summary,
    required this.topPriority,
    required this.nextAction,
    required this.elapsedSeconds,
  });

  final Persona persona;
  final ScoreReport report;
  final EligibilitySummary summary;
  final SkillPriority? topPriority;
  final NextAction nextAction;
  final int elapsedSeconds;
}

/// Runs a persona through a full mock, using the real builder, the real scoring
/// engine and the real coaching engine. Nothing is stubbed.
abstract final class PersonaRunner {
  static PersonaResult run(Persona persona, {int seed = 20260101}) {
    final exam = _buildExam(seed);
    final responses = respond(exam, persona, seed: seed);
    final report = ScoringEngine.score(
      questions: exam.allQuestions.map((q) => q.base).toList(growable: false),
      responses: responses,
      elapsedSeconds: responses.fold(0, (a, r) => a + r.secondsSpent),
    );
    final summary = EligibilityEngine.summarise(report);
    final priorities = AdaptiveEngine.priorities(report);
    return PersonaResult(
      persona: persona,
      report: report,
      summary: summary,
      topPriority: priorities.isEmpty ? null : priorities.first,
      nextAction: AdaptiveEngine.nextAction(
        lastReport: report,
        history: const <Attempt>[],
        goal: GoalProfile.defaults,
        diagnosticCount: 1,
      ),
      elapsedSeconds: responses.fold(0, (a, r) => a + r.secondsSpent),
    );
  }

  /// Builds the exam without importing the builder's UI dependencies.
  static Exam _buildExam(int seed) => PersonaExamFactory.fullMock(seed: seed);

  /// Deterministic per-question answering for a persona.
  static List<QuestionResponse> respond(
    Exam exam,
    Persona persona, {
    int seed = 20260101,
  }) {
    final responses = <QuestionResponse>[];
    for (final served in exam.allQuestions) {
      final q = served.base;
      final rng = math.Random(
        q.id.hashCode ^ persona.id.hashCode ^ (seed * 2654435761),
      );
      final accuracy = persona.accuracyFor(q.subtest);
      final correct = rng.nextDouble() < accuracy;
      final int selected;
      if (correct) {
        selected = q.answerIndex;
      } else {
        final wrong = <int>[
          for (var i = 0; i < q.choices.length; i++)
            if (i != q.answerIndex) i,
        ];
        selected = wrong[rng.nextInt(wrong.length)];
      }
      final jitter = 0.7 + rng.nextDouble() * 0.6;
      responses.add(
        QuestionResponse(
          questionId: q.id,
          selectedIndex: selected,
          secondsSpent: (persona.timePerQuestionSeconds * jitter).round(),
          flagged: rng.nextDouble() < persona.flagRate,
        ),
      );
    }
    return responses;
  }
}
