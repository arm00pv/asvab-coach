import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../data/bank/question_bank.dart';
import '../data/models/catalog.dart';
import '../data/models/mos.dart';
import '../data/models/question.dart';
import '../data/models/review_item.dart';
import '../data/models/score.dart';
import '../data/repos/storage.dart';

/// Application-wide state: who the learner is, what they have done, and how the
/// app looks. Screens read from here; only this class writes to storage.
class AppState extends ChangeNotifier {
  AppState();

  GoalProfile? _goal;
  List<Attempt> _attempts = <Attempt>[];
  Map<String, Map<String, List<int>>> _orders =
      <String, Map<String, List<int>>>{};
  List<ReviewItem> _reviews = <ReviewItem>[];
  bool _darkMode = false;
  bool _soundOn = true;
  bool _onboarded = false;
  bool _loading = true;

  GoalProfile? get goal => _goal;
  List<Attempt> get attempts => List<Attempt>.unmodifiable(_attempts);
  bool get darkMode => _darkMode;
  bool get soundOn => _soundOn;
  bool get onboarded => _onboarded;
  bool get loading => _loading;
  bool get hasGoal => _goal != null;

  /// The spaced-repetition queue, soonest due first.
  List<ReviewItem> get reviews => List<ReviewItem>.unmodifiable(_reviews);

  /// Queue entries whose scheduled moment has arrived.
  List<ReviewItem> dueReviews([DateTime? now]) {
    final at = now ?? DateTime.now();
    final due = _reviews.where((r) => r.isDue(at)).toList()
      ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
    return due;
  }

  int get dueReviewCount => dueReviews().length;

  /// The questions to serve in the next review session.
  List<Question> get dueReviewQuestions {
    final out = <Question>[];
    for (final item in dueReviews()) {
      final q = QuestionBank.byId(item.questionId);
      if (q != null) out.add(q);
    }
    return out;
  }

  /// Questions still in the queue, including those not yet due.
  int get reviewQueueSize => _reviews.length;

  /// Most recent finished attempt, if any.
  Attempt? get lastAttempt => _attempts.isEmpty ? null : _attempts.last;

  ScoreReport? get lastReport => lastAttempt?.report;

  /// History newest first, for the progress screen.
  List<Attempt> get history => _attempts.reversed.toList(growable: false);

  int get diagnosticCount =>
      _attempts.where((a) => a.kind == ExamKind.diagnostic).length;

  int get mockCount =>
      _attempts.where((a) => a.kind == ExamKind.fullMock).length;

  Map<String, List<int>> ordersFor(String attemptId) =>
      _orders[attemptId] ?? const <String, List<int>>{};

  /// Best AFQT across all attempts.
  int get bestAfqt {
    var best = 0;
    for (final a in _attempts) {
      best = math.max(best, a.report.afqtPercentile);
    }
    return best;
  }

  int get bestGt {
    var best = 0;
    for (final a in _attempts) {
      best = math.max(best, a.report.gt);
    }
    return best;
  }

  /// Consecutive calendar days with at least one attempt, counting back from the
  /// most recent attempt.
  int get streakDays {
    if (_attempts.isEmpty) return 0;
    final days =
        _attempts
            .map(
              (a) => DateTime(
                a.finishedAt.year,
                a.finishedAt.month,
                a.finishedAt.day,
              ),
            )
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));
    var streak = 1;
    for (var i = 1; i < days.length; i++) {
      final diff = days[i - 1].difference(days[i]).inDays;
      if (diff == 1) {
        streak++;
      } else if (diff > 1) {
        break;
      }
    }
    return streak;
  }

  /// Distinct skills practised at least once.
  int get skillsTouched =>
      <String>{for (final a in _attempts) ...a.report.skillMastery.keys}.length;

  Future<void> init() async {
    final persisted = await Storage.load();
    _goal = persisted.goal;
    _attempts = List<Attempt>.of(persisted.attempts);
    _orders = persisted.orders;
    _darkMode = persisted.darkMode;
    _soundOn = persisted.soundOn;
    _onboarded = persisted.onboarded;
    _reviews = List<ReviewItem>.of(persisted.reviews);
    _loading = false;
    notifyListeners();
  }

  Future<void> setGoal(GoalProfile goal) async {
    _goal = goal;
    _onboarded = true;
    notifyListeners();
    await Storage.saveGoal(goal);
  }

  Future<void> addAttempt(
    Attempt attempt,
    Map<String, List<int>> orderByQuestion,
  ) async {
    _attempts = <Attempt>[..._attempts, attempt];
    _orders = <String, Map<String, List<int>>>{
      ..._orders,
      attempt.id: orderByQuestion,
    };
    _applyToReviewQueue(attempt);
    notifyListeners();
    await Storage.saveAttempts(_attempts, _orders);
    await Storage.saveReviews(_reviews);
  }

  /// Feeds a finished attempt into the spaced-repetition queue.
  ///
  /// A normal attempt only ever adds or resets: anything missed or flagged comes
  /// back tomorrow. A review session is what advances the interval, so a
  /// question only graduates after four successful retrievals on the days it was
  /// scheduled for.
  void _applyToReviewQueue(Attempt attempt) {
    final now = DateTime.now();
    final queue = <String, ReviewItem>{
      for (final r in _reviews) r.questionId: r,
    };
    final isReview = attempt.kind == ExamKind.review;

    for (final response in attempt.responses) {
      final question = QuestionBank.byId(response.questionId);
      if (question == null) continue;
      final answered = response.selectedIndex != null;
      final correct =
          answered && response.selectedIndex == question.answerIndex;
      final existing = queue[response.questionId];

      if (isReview) {
        if (existing == null) continue;
        if (correct) {
          final next = existing.answeredCorrectly(now);
          if (next.graduated) {
            queue.remove(response.questionId);
          } else {
            queue[response.questionId] = next;
          }
        } else {
          queue[response.questionId] = existing.answeredWrong(now);
        }
        continue;
      }

      if (!correct || response.flagged) {
        queue[response.questionId] = ReviewItem(
          questionId: response.questionId,
          dueAt: now.add(Duration(days: ReviewItem.intervals.first)),
          timesMissed: (existing?.timesMissed ?? 0) + 1,
          lastSeenAt: now,
        );
      }
    }

    _reviews = queue.values.toList()
      ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
  }

  /// Kept for tests and for the reset path.
  Future<void> clearReviewQueue() async {
    _reviews = <ReviewItem>[];
    notifyListeners();
    await Storage.saveReviews(_reviews);
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    notifyListeners();
    await Storage.saveTheme(value);
  }

  Future<void> setSound(bool value) async {
    _soundOn = value;
    notifyListeners();
    await Storage.saveSound(value);
  }

  Future<void> reset() async {
    _goal = null;
    _attempts = <Attempt>[];
    _orders = <String, Map<String, List<int>>>{};
    _onboarded = false;
    notifyListeners();
    await Storage.clearAll();
    await Storage.saveTheme(_darkMode);
  }

  /// Subtest-level trend across the last [n] attempts that exercised it.
  List<int> trendFor(Subtest subtest, {int n = 8}) {
    final values = <int>[];
    for (final a in _attempts) {
      final s = a.report.subtestScores[subtest];
      if (s != null && s.total > 0) values.add(s.standardScore);
    }
    if (values.length <= n) return values;
    return values.sublist(values.length - n);
  }

  List<int> get afqtTrend {
    final values = <int>[];
    for (final a in _attempts) {
      if (a.kind == ExamKind.diagnostic || a.kind == ExamKind.fullMock) {
        values.add(a.report.afqtPercentile);
      }
    }
    return values;
  }
}
