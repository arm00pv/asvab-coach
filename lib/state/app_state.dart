import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../data/models/catalog.dart';
import '../data/models/mos.dart';
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
    notifyListeners();
    await Storage.saveAttempts(_attempts, _orders);
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
