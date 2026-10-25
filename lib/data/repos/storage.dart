import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/mos.dart';
import '../models/score.dart';
import 'serialization.dart';

/// Everything that survives a page refresh, stored in browser local storage.
class PersistedState {
  const PersistedState({
    required this.goal,
    required this.attempts,
    required this.orders,
    required this.darkMode,
    required this.soundOn,
    required this.onboarded,
  });

  final GoalProfile? goal;
  final List<Attempt> attempts;

  /// Option permutations, keyed by attempt id then question id.
  final Map<String, Map<String, List<int>>> orders;

  final bool darkMode;
  final bool soundOn;
  final bool onboarded;

  static const empty = PersistedState(
    goal: null,
    attempts: <Attempt>[],
    orders: <String, Map<String, List<int>>>{},
    darkMode: false,
    soundOn: true,
    onboarded: false,
  );
}

abstract final class Storage {
  static const _kGoal = 'asvab.goal.v1';
  static const _kAttempts = 'asvab.attempts.v1';
  static const _kOrders = 'asvab.orders.v1';
  static const _kTheme = 'asvab.dark.v1';
  static const _kSound = 'asvab.sound.v1';
  static const _kOnboarded = 'asvab.onboarded.v1';

  static Future<PersistedState> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final goalRaw = prefs.getString(_kGoal);
      final attemptsRaw = prefs.getString(_kAttempts);
      final ordersRaw = prefs.getString(_kOrders);

      GoalProfile? goal;
      if (goalRaw != null) {
        goal = GoalProfile.fromJson(
          (jsonDecode(goalRaw) as Map).cast<String, dynamic>(),
        );
      }

      final attempts = <Attempt>[];
      if (attemptsRaw != null) {
        for (final entry in (jsonDecode(attemptsRaw) as List)) {
          attempts.add(
            Serialization.attemptFromJson(
              (entry as Map).cast<String, dynamic>(),
            ),
          );
        }
      }

      final orders = <String, Map<String, List<int>>>{};
      if (ordersRaw != null) {
        final decoded = (jsonDecode(ordersRaw) as Map).cast<String, dynamic>();
        for (final e in decoded.entries) {
          orders[e.key] = Serialization.ordersFromJson(<String, dynamic>{
            'orders': e.value,
          });
        }
      }

      return PersistedState(
        goal: goal,
        attempts: attempts,
        orders: orders,
        darkMode: prefs.getBool(_kTheme) ?? false,
        soundOn: prefs.getBool(_kSound) ?? true,
        onboarded: prefs.getBool(_kOnboarded) ?? false,
      );
    } catch (_) {
      // Corrupt or unavailable storage must never brick the app.
      return PersistedState.empty;
    }
  }

  static Future<void> saveGoal(GoalProfile goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kGoal, jsonEncode(goal.toJson()));
    await prefs.setBool(_kOnboarded, true);
  }

  static Future<void> saveAttempts(
    List<Attempt> attempts,
    Map<String, Map<String, List<int>>> orders,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kAttempts,
      jsonEncode(<Map<String, dynamic>>[
        for (final a in attempts)
          Serialization.attemptToJson(a, orders[a.id] ?? const {}),
      ]),
    );
    await prefs.setString(
      _kOrders,
      jsonEncode(<String, dynamic>{
        for (final e in orders.entries) e.key: e.value,
      }),
    );
  }

  static Future<void> saveTheme(bool dark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kTheme, dark);
  }

  static Future<void> saveSound(bool on) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSound, on);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
