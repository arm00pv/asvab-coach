import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/exam_snapshot.dart';
import '../models/mos.dart';
import '../models/review_item.dart';
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
    required this.reviews,
    this.pending,
    this.unreadableKeys = const <String>[],
    this.skippedRecords = 0,
  });

  final GoalProfile? goal;
  final List<Attempt> attempts;

  /// Option permutations, keyed by attempt id then question id.
  final Map<String, Map<String, List<int>>> orders;

  final bool darkMode;
  final bool soundOn;
  final bool onboarded;

  /// Spaced-repetition queue: questions missed or flagged, with due dates.
  final List<ReviewItem> reviews;

  /// An attempt that was interrupted mid-exam, if there is one.
  final ExamSnapshot? pending;

  /// Storage keys that could not be read, so the app can say so instead of
  /// silently presenting an empty history as if it were the whole truth.
  final List<String> unreadableKeys;

  /// How many individual records were skipped inside keys that did parse.
  final int skippedRecords;

  bool get recoveredPartially =>
      unreadableKeys.isNotEmpty || skippedRecords > 0;

  static const empty = PersistedState(
    goal: null,
    attempts: <Attempt>[],
    orders: <String, Map<String, List<int>>>{},
    darkMode: false,
    soundOn: true,
    onboarded: false,
    reviews: <ReviewItem>[],
    pending: null,
    unreadableKeys: <String>[],
    skippedRecords: 0,
  );
}

/// A decoded list plus what went wrong on the way through.
class _Recovered<T> {
  const _Recovered(this.items, this.skipped, this.failed);

  final List<T> items;
  final int skipped;
  final bool failed;
}

abstract final class Storage {
  static const _kGoal = 'asvab.goal.v1';
  static const _kAttempts = 'asvab.attempts.v1';
  static const _kOrders = 'asvab.orders.v1';
  static const _kTheme = 'asvab.dark.v1';
  static const _kSound = 'asvab.sound.v1';
  static const _kOnboarded = 'asvab.onboarded.v1';
  static const _kReviews = 'asvab.reviews.v1';
  static const _kPending = 'asvab.pending.v1';

  /// Reads everything that survives a refresh.
  ///
  /// Recovery is per key and per record, not all or nothing. A single malformed
  /// attempt must not cost the candidate their goal, their streak and their
  /// spaced-repetition queue, and it must not throw them back through
  /// onboarding: that reads as "the app forgot me" when in fact one record was
  /// bad. Whatever cannot be read is named in [PersistedState.unreadableKeys]
  /// and [PersistedState.skippedRecords] so the app can say so out loud.
  static Future<PersistedState> load() async {
    final unreadable = <String>[];
    var skipped = 0;

    SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (_) {
      return const PersistedState(
        goal: null,
        attempts: <Attempt>[],
        orders: <String, Map<String, List<int>>>{},
        darkMode: false,
        soundOn: true,
        onboarded: false,
        reviews: <ReviewItem>[],
        pending: null,
        unreadableKeys: <String>['all'],
        skippedRecords: 0,
      );
    }

    GoalProfile? goal;
    final goalRaw = prefs.getString(_kGoal);
    if (goalRaw != null) {
      try {
        goal = GoalProfile.fromJson(
          (jsonDecode(goalRaw) as Map).cast<String, dynamic>(),
        );
      } catch (_) {
        unreadable.add('goal');
      }
    }

    final attempts = <Attempt>[];
    final attemptsRaw = prefs.getString(_kAttempts);
    if (attemptsRaw != null) {
      try {
        for (final entry in (jsonDecode(attemptsRaw) as List)) {
          try {
            attempts.add(
              Serialization.attemptFromJson(
                (entry as Map).cast<String, dynamic>(),
              ),
            );
          } catch (_) {
            skipped++;
          }
        }
      } catch (_) {
        unreadable.add('attempts');
      }
    }

    final orders = <String, Map<String, List<int>>>{};
    final ordersRaw = prefs.getString(_kOrders);
    if (ordersRaw != null) {
      try {
        final decoded = (jsonDecode(ordersRaw) as Map).cast<String, dynamic>();
        for (final e in decoded.entries) {
          try {
            orders[e.key] = Serialization.ordersFromJson(<String, dynamic>{
              'orders': e.value,
            });
          } catch (_) {
            skipped++;
          }
        }
      } catch (_) {
        unreadable.add('orders');
      }
    }

    final reviews = _reviewsFrom(prefs.getString(_kReviews));
    if (reviews.failed) unreadable.add('reviews');
    skipped += reviews.skipped;

    // An interrupted attempt. A file from an older version of the app decodes
    // to null, which simply means there is nothing to resume.
    ExamSnapshot? pending;
    final pendingRaw = prefs.getString(_kPending);
    if (pendingRaw != null) {
      try {
        pending = ExamSnapshot.fromJson(
          (jsonDecode(pendingRaw) as Map).cast<String, dynamic>(),
        );
      } catch (_) {
        unreadable.add('attempt in progress');
      }
    }

    return PersistedState(
      goal: goal,
      attempts: attempts,
      orders: orders,
      darkMode: prefs.getBool(_kTheme) ?? false,
      soundOn: prefs.getBool(_kSound) ?? true,
      onboarded: prefs.getBool(_kOnboarded) ?? false,
      reviews: reviews.items,
      pending: pending,
      unreadableKeys: unreadable,
      skippedRecords: skipped,
    );
  }

  static _Recovered<ReviewItem> _reviewsFrom(String? raw) {
    if (raw == null) {
      return const _Recovered<ReviewItem>(<ReviewItem>[], 0, false);
    }
    try {
      final out = <ReviewItem>[];
      var skipped = 0;
      for (final entry in jsonDecode(raw) as List) {
        try {
          final item = ReviewItem.fromJson(
            (entry as Map).cast<String, dynamic>(),
          );
          if (item == null) {
            skipped++;
          } else {
            out.add(item);
          }
        } catch (_) {
          skipped++;
        }
      }
      return _Recovered<ReviewItem>(out, skipped, false);
    } catch (_) {
      return const _Recovered<ReviewItem>(<ReviewItem>[], 0, true);
    }
  }

  static Future<void> saveReviews(List<ReviewItem> reviews) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kReviews,
      jsonEncode(<Map<String, dynamic>>[for (final r in reviews) r.toJson()]),
    );
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

  /// Stores, or with null clears, the attempt in progress.
  static Future<void> savePending(ExamSnapshot? snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    if (snapshot == null) {
      await prefs.remove(_kPending);
      return;
    }
    await prefs.setString(_kPending, jsonEncode(snapshot.toJson()));
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
