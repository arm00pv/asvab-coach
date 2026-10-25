import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../data/models/exam.dart';
import '../data/models/question.dart';
import '../data/models/score.dart';
import '../engines/scoring_engine.dart';

/// Runs one exam: which section is live, which question is on screen, how long
/// is left, and what the candidate has answered.
///
/// Kept deliberately free of widgets so it can be unit-tested by driving it
/// directly, which is exactly what the persona tests do.
class ExamSession extends ChangeNotifier {
  ExamSession({
    required this.exam,
    required this.seed,
    this.onSectionComplete,
  }) {
    _startSection(0);
  }

  final Exam exam;
  final int seed;
  final void Function(int sectionIndex)? onSectionComplete;

  int _sectionIndex = 0;
  int _questionIndex = 0;
  Timer? _ticker;

  /// Remaining seconds for the live section.
  int _remaining = 0;

  /// Whole-attempt elapsed seconds, used for pace analysis.
  int _elapsed = 0;

  /// Bank-coordinate answers, keyed by question id.
  final Map<String, QuestionResponse> _responses = <String, QuestionResponse>{};

  /// Milliseconds spent on the current question, so per-question timing is
  /// accurate without a second timer.
  int _questionEnteredAt = 0;
  int _clock = 0;

  bool _paused = false;
  bool _finished = false;

  // ---- Read-only surface -------------------------------------------------

  ExamSection get section => exam.sections[_sectionIndex];
  int get sectionIndex => _sectionIndex;
  bool get isLastSection => _sectionIndex == exam.sections.length - 1;
  int get questionIndex => _questionIndex;
  int get remainingSeconds => _remaining;
  int get elapsedSeconds => _elapsed;
  bool get finished => _finished;
  bool get paused => _paused;
  List<ExamSection> get sections => exam.sections;

  ServedQuestion get current => section.questions[_questionIndex];
  int get sectionQuestionCount => section.questions.length;

  bool get isTimed => section.seconds < 32000;

  int? selectedFor(String questionId) => _responses[questionId]?.selectedIndex;

  bool isFlagged(String questionId) => _responses[questionId]?.flagged ?? false;

  int answeredInSection() => section.questions
      .where(
        (q) => _responses.containsKey(q.id) && _responses[q.id]!.isAnswered,
      )
      .length;

  bool get sectionAllAnswered => answeredInSection() == sectionQuestionCount;

  int get totalAnswered => _responses.values.where((r) => r.isAnswered).length;

  int get totalQuestions => exam.questionCount;

  double get sectionProgress => section.questions.isEmpty
      ? 0
      : (_questionIndex + 1) / section.questions.length;

  String get timeLabel {
    if (!isTimed) return 'Untimed';
    final m = _remaining ~/ 60;
    final s = _remaining % 60;
    final padded = s.toString().padLeft(2, '0');
    return '$m:$padded';
  }

  bool get timeCritical => isTimed && _remaining <= 60;

  // ---- Lifecycle ---------------------------------------------------------

  void start() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_finished || _paused) return;
    _clock++;
    _elapsed++;
    if (isTimed) {
      _remaining = math.max(0, _remaining - 1);
      if (_remaining == 0) {
        completeSection(force: true);
        return;
      }
    }
    notifyListeners();
  }

  void pause() {
    _paused = true;
    notifyListeners();
  }

  void resume() {
    _paused = false;
    notifyListeners();
  }

  void _startSection(int index) {
    _sectionIndex = index;
    _questionIndex = 0;
    _remaining = exam.sections[index].seconds;
    _questionEnteredAt = _clock;
  }

  /// Records an answer. [displayIndex] is what the candidate tapped; it is
  /// converted to bank coordinates before storage so the scoring engine and the
  /// persisted report never disagree about what was chosen.
  void answer(int? displayIndex) {
    final q = current;
    _questionEnteredAt = _clock;
    if (displayIndex == null) {
      _responses[q.id] = QuestionResponse(
        questionId: q.id,
        selectedIndex: null,
        secondsSpent: _responses[q.id]?.secondsSpent ?? 0,
        flagged: isFlagged(q.id),
      );
    } else {
      _responses[q.id] = QuestionResponse(
        questionId: q.id,
        selectedIndex: q.toBankIndex(displayIndex),
        secondsSpent: _responses[q.id]?.secondsSpent ?? 0,
        flagged: isFlagged(q.id),
      );
    }
    notifyListeners();
  }

  void toggleFlag() {
    final q = current;
    final existing = _responses[q.id];
    _responses[q.id] = QuestionResponse(
      questionId: q.id,
      selectedIndex: existing?.selectedIndex,
      secondsSpent: existing?.secondsSpent ?? 0,
      flagged: !(existing?.flagged ?? false),
    );
    notifyListeners();
  }

  /// Stamps the time spent, then moves. Called by next/previous/jump.
  void _commitTiming() {
    final q = current;
    final spent = _clock - _questionEnteredAt;
    if (spent <= 0) return;
    final existing = _responses[q.id];
    _responses[q.id] = QuestionResponse(
      questionId: q.id,
      selectedIndex: existing?.selectedIndex,
      secondsSpent: (existing?.secondsSpent ?? 0) + spent,
      flagged: existing?.flagged ?? false,
    );
    _questionEnteredAt = _clock;
  }

  void next() {
    if (_questionIndex < section.questions.length - 1) {
      _commitTiming();
      _questionIndex++;
      notifyListeners();
    }
  }

  void previous() {
    if (_questionIndex > 0) {
      _commitTiming();
      _questionIndex--;
      notifyListeners();
    }
  }

  void jumpTo(int index) {
    if (index >= 0 && index < section.questions.length) {
      _commitTiming();
      _questionIndex = index;
      notifyListeners();
    }
  }

  /// Ends the live section, either because the candidate asked to or because the
  /// clock ran out.
  void completeSection({bool force = false}) {
    _commitTiming();
    onSectionComplete?.call(_sectionIndex);
    if (isLastSection) {
      finish();
    } else {
      _startSection(_sectionIndex + 1);
      notifyListeners();
    }
  }

  /// Produces the final report. Safe to call more than once.
  ScoreReport finish() {
    _finished = true;
    _ticker?.cancel();
    final questions = exam.allQuestions
        .map((s) => s.base)
        .toList(growable: false);
    return ScoringEngine.score(
      questions: questions,
      responses: _responses.values.toList(),
      elapsedSeconds: _elapsed,
    );
  }

  /// The option permutation per question, persisted with the attempt so the
  /// review screen can replay exactly what the candidate saw.
  Map<String, List<int>> get orders => <String, List<int>>{
    for (final q in exam.allQuestions) q.id: q.order,
  };

  List<QuestionResponse> get responses => _responses.values.toList();

  /// Builds a finished [Attempt] from the current session.
  Attempt toAttempt(ScoreReport report) => Attempt(
    id: 'attempt-${DateTime.now().microsecondsSinceEpoch}',
    kind: exam.kind,
    startedAt: DateTime.now().subtract(Duration(seconds: _elapsed)),
    finishedAt: DateTime.now(),
    report: report,
    responses: responses,
    questionIds: exam.allQuestions.map((q) => q.id).toList(growable: false),
    subtests: exam.subtests,
  );

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
