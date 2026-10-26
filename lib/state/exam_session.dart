import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../data/models/exam.dart';
import '../data/models/exam_snapshot.dart';
import '../data/models/question.dart';
import '../data/models/score.dart';
import '../engines/scoring_engine.dart';

/// Runs one exam: which section is live, which question is on screen, how long
/// is left, and what the candidate has answered.
///
/// Kept deliberately free of widgets so it can be unit-tested by driving it
/// directly, which is exactly what the persona tests do.
///
/// The clock counts real seconds, not ticks. A phone throttles its timers when
/// the app is in the background and may stop them altogether, so a tick counter
/// would quietly hand the candidate extra minutes; [catchUp] charges the
/// interval that actually passed instead.
class ExamSession extends ChangeNotifier {
  ExamSession({
    required this.exam,
    required this.seed,
    this.onSectionComplete,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now {
    _startedAt = _now();
    _startSection(0);
  }

  /// Rebuilds a session from a persisted [snapshot].
  ///
  /// [exam] must be the exam `ExamRestore.examOf(snapshot)` returned, so the
  /// sections and option orders are exactly the ones the candidate was looking
  /// at when the app went away.
  ExamSession.resume({
    required this.exam,
    required this.seed,
    required ExamSnapshot snapshot,
    this.onSectionComplete,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now {
    _startedAt = snapshot.startedAt;
    _elapsed = math.max(0, snapshot.elapsedSeconds);
    for (final response in snapshot.responses) {
      _responses[response.questionId] = response;
    }
    if (exam.sections.isEmpty) return;
    _sectionIndex = snapshot.sectionIndex.clamp(0, exam.sections.length - 1);
    final section = exam.sections[_sectionIndex];
    final burned = (section.seconds - snapshot.remainingSeconds).clamp(
      0,
      section.seconds,
    );
    _sectionStartElapsed = _elapsed - burned;
    _questionIndex = snapshot.questionIndex.clamp(
      0,
      math.max(0, section.questions.length - 1),
    );
    _questionEnteredElapsed = _elapsed;
  }

  final Exam exam;
  final int seed;
  final void Function(int sectionIndex)? onSectionComplete;

  /// Injectable so the clock can be driven deterministically in tests.
  final DateTime Function() _now;

  late final DateTime _startedAt;

  int _sectionIndex = 0;
  int _questionIndex = 0;
  Timer? _ticker;

  /// Whole-attempt seconds actually spent.
  int _elapsed = 0;

  /// Value of [_elapsed] when the live section's clock started running.
  int _sectionStartElapsed = 0;

  /// Value of [_elapsed] when the current question came on screen.
  int _questionEnteredElapsed = 0;

  /// Wall clock at the previous tick, so a stalled or suspended ticker can be
  /// charged what it really took.
  DateTime? _lastTick;

  /// Bank-coordinate answers, keyed by question id.
  final Map<String, QuestionResponse> _responses = <String, QuestionResponse>{};

  bool _paused = false;
  bool _finished = false;

  // ---- Read-only surface -------------------------------------------------

  ExamSection get section => exam.sections[_sectionIndex];
  int get sectionIndex => _sectionIndex;
  bool get isLastSection => _sectionIndex == exam.sections.length - 1;
  int get questionIndex => _questionIndex;
  DateTime get startedAt => _startedAt;
  int get elapsedSeconds => _elapsed;
  bool get finished => _finished;
  bool get paused => _paused;
  List<ExamSection> get sections => exam.sections;

  ServedQuestion get current => section.questions[_questionIndex];
  int get sectionQuestionCount => section.questions.length;

  bool get isTimed => section.seconds < 32000;

  /// Seconds left in the live section, derived from the wall clock so that a
  /// missing tick can never add time.
  int get remainingSeconds {
    if (!isTimed) return section.seconds;
    final left = section.seconds - (_elapsed - _sectionStartElapsed);
    return left < 0 ? 0 : left;
  }

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
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    final padded = s.toString().padLeft(2, '0');
    return '$m:$padded';
  }

  bool get timeCritical => isTimed && remainingSeconds <= 60;

  // ---- Lifecycle ---------------------------------------------------------

  void start() {
    if (_finished) return;
    _paused = false;
    _lastTick = _now();
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  /// Stops the clock without losing anything. Used while a section's
  /// introduction is on screen: the real test does not charge reading time.
  void pause() {
    if (_finished) return;
    _paused = true;
    _ticker?.cancel();
    _ticker = null;
    _lastTick = null;
  }

  void resume() {
    if (_finished) return;
    start();
  }

  void _tick() {
    if (_finished || _paused) return;
    final charged = _pendingSeconds();
    if (!_advance(charged ?? 1)) notifyListeners();
  }

  /// Re-syncs the clock with the wall clock.
  ///
  /// Called when the app comes back to the foreground. If the section's time
  /// ran out while it was away, the section is completed here, exactly as the
  /// ticker would have done.
  void catchUp() {
    if (_finished || _paused) return;
    final charged = _pendingSeconds();
    if (charged == null) return;
    if (!_advance(charged)) notifyListeners();
  }

  /// Seconds really elapsed since the previous tick, or null when less than a
  /// tick's worth has passed (which is what a test's fake clock looks like).
  int? _pendingSeconds() {
    final now = _now();
    final previous = _lastTick;
    _lastTick = now;
    if (previous == null) return null;
    final milliseconds = now.difference(previous).inMilliseconds;
    if (milliseconds < 900) return null;
    // A late tick is charged what it actually took, up to a ceiling, so a long
    // sleep cannot silently skip a whole section's worth of questions.
    return (milliseconds / 1000).round().clamp(1, 12 * 3600);
  }

  /// Adds [seconds] to the clock. Returns true when the section ran out.
  bool _advance(int seconds) {
    if (seconds <= 0 || _finished) return false;
    _elapsed += seconds;
    if (!isTimed) return false;
    if (_elapsed - _sectionStartElapsed < section.seconds) return false;
    completeSection(force: true);
    return true;
  }

  void _startSection(int index) {
    _sectionIndex = index;
    _questionIndex = 0;
    _sectionStartElapsed = _elapsed;
    _questionEnteredElapsed = _elapsed;
  }

  /// Records an answer. [displayIndex] is what the candidate tapped; it is
  /// converted to bank coordinates before storage so the scoring engine and the
  /// persisted report never disagree about what was chosen.
  void answer(int? displayIndex) {
    final q = current;
    _questionEnteredElapsed = _elapsed;
    _responses[q.id] = QuestionResponse(
      questionId: q.id,
      selectedIndex: displayIndex == null ? null : q.toBankIndex(displayIndex),
      secondsSpent: _responses[q.id]?.secondsSpent ?? 0,
      flagged: isFlagged(q.id),
    );
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
    final spent = _elapsed - _questionEnteredElapsed;
    if (spent <= 0) return;
    final existing = _responses[q.id];
    _responses[q.id] = QuestionResponse(
      questionId: q.id,
      selectedIndex: existing?.selectedIndex,
      secondsSpent: (existing?.secondsSpent ?? 0) + spent,
      flagged: existing?.flagged ?? false,
    );
    _questionEnteredElapsed = _elapsed;
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
    // Mark the session finished before telling the screen, because the screen
    // decides from `finished` whether to submit the attempt or to show the next
    // section. Calling back first left the last section looking like any other,
    // so the runner tried to introduce a tenth section of a nine-section exam.
    if (isLastSection) _finished = true;
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
    _ticker = null;
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

  /// Everything needed to carry this attempt across a process restart.
  ExamSnapshot toSnapshot() => ExamSnapshot(
    examId: exam.id,
    title: exam.title,
    kind: exam.kind,
    sections: <SnapshotSection>[
      for (final s in exam.sections)
        SnapshotSection(
          subtest: s.subtest,
          minutes: s.minutes,
          label: s.label,
          questionIds: <String>[for (final q in s.questions) q.id],
          orders: <List<int>>[for (final q in s.questions) q.order],
        ),
    ],
    sectionIndex: _sectionIndex,
    questionIndex: _questionIndex,
    remainingSeconds: remainingSeconds,
    elapsedSeconds: _elapsed,
    startedAt: _startedAt,
    responses: responses,
  );

  /// Builds a finished [Attempt] from the current session.
  Attempt toAttempt(ScoreReport report) => Attempt(
    id: 'attempt-${_now().microsecondsSinceEpoch}',
    kind: exam.kind,
    startedAt: _startedAt,
    finishedAt: _now(),
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
