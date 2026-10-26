import 'dart:convert';

import 'package:asvab_guard_coach/app.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/data/models/review_item.dart';
import 'package:asvab_guard_coach/data/repos/storage.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage recovery.
///
/// The saved state lives in browser local storage, which can be truncated by a
/// quota error, evicted by the browser, or left behind by an older build. The
/// rule these tests hold is that no single unreadable record may cost the
/// candidate anything else, and that a recovery is never silent.
Future<SharedPreferences> prefsWith({
  required Map<String, Object> values,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final prefs = await SharedPreferences.getInstance();
  for (final entry in values.entries) {
    await prefs.setString(entry.key, entry.value as String);
  }
  return prefs;
}

void main() {
  const goalKey = 'asvab.goal.v1';
  const attemptsKey = 'asvab.attempts.v1';
  const reviewsKey = 'asvab.reviews.v1';
  const onboardedKey = 'asvab.onboarded.v1';
  const themeKey = 'asvab.dark.v1';

  group('storage recovery', () {
    test(
      'a corrupt attempt list does not cost the goal or the theme',
      () async {
        final prefs = await prefsWith(
          values: <String, Object>{
            goalKey: jsonEncode(<String, dynamic>{
              'displayName': 'Kept Soldier',
              'targetAfqt': 60,
              'targetGt': 110,
              'targetMosCodes': <String>['68W'],
              'targetDate': null,
              'officerTrack': false,
              'dailyMinutes': 30,
            }),
            attemptsKey: '{ this is not json',
          },
        );
        await prefs.setBool(onboardedKey, true);
        await prefs.setBool(themeKey, true);

        final loaded = await Storage.load();
        expect(loaded.goal?.displayName, 'Kept Soldier');
        expect(loaded.onboarded, isTrue);
        expect(loaded.darkMode, isTrue);
        expect(loaded.attempts, isEmpty);
        expect(loaded.unreadableKeys, contains('attempts'));
        expect(loaded.recoveredPartially, isTrue);
      },
    );

    test('one bad attempt is skipped and the rest survive', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final seeded = AppState();
      await seeded.init();
      await seeded.setGoal(
        const GoalProfile(
          displayName: 'Partial Soldier',
          targetAfqt: 55,
          targetGt: 105,
          targetMosCodes: <String>[],
          targetDate: null,
          officerTrack: false,
          dailyMinutes: 20,
        ),
      );
      // Write one genuine attempt through the real save path, then put a
      // broken record in front of it. The genuine one must survive.
      final result = PersonaRunner.run(Personas.byId('ava'));
      await seeded.addAttempt(
        Attempt(
          id: 'whole-attempt',
          kind: ExamKind.fullMock,
          startedAt: DateTime(2026, 3, 1, 9),
          finishedAt: DateTime(2026, 3, 1, 12),
          report: result.report,
          responses: const <QuestionResponse>[],
          questionIds: const <String>[],
          subtests: Subtest.administrationOrder,
        ),
        const <String, List<int>>{},
      );

      final prefs = await SharedPreferences.getInstance();
      final existing = jsonDecode(prefs.getString(attemptsKey)!) as List;
      await prefs.setString(
        attemptsKey,
        jsonEncode(<dynamic>[
          <String, dynamic>{'id': 'broken'},
          ...existing,
        ]),
      );

      final loaded = await Storage.load();
      expect(loaded.attempts, hasLength(1));
      expect(loaded.attempts.single.id, 'whole-attempt');
      expect(loaded.skippedRecords, 1);
      expect(loaded.goal?.displayName, 'Partial Soldier');
    });

    test('one malformed review is skipped, the rest survive', () async {
      // Valid JSON holding a record the model cannot build: this is the
      // per-record path, which must not cost the whole queue.
      final good = ReviewItem(
        questionId: 'as-001',
        dueAt: DateTime(2026, 1, 2),
      ).toJson();
      final prefs = await prefsWith(
        values: <String, Object>{
          reviewsKey: jsonEncode(<Map<String, dynamic>>[
            <String, dynamic>{'q': 5},
            good,
          ]),
        },
      );
      await prefs.setBool(onboardedKey, true);

      final loaded = await Storage.load();
      expect(loaded.unreadableKeys, isEmpty);
      expect(loaded.reviews.single.questionId, 'as-001');
      expect(loaded.skippedRecords, 1);
      expect(loaded.recoveredPartially, isTrue);
      expect(loaded.onboarded, isTrue);
    });

    test('an unparseable review queue keeps everything else', () async {
      final prefs = await prefsWith(
        values: <String, Object>{reviewsKey: '[{"questionId": '},
      );
      await prefs.setBool(onboardedKey, true);
      await prefs.setBool(themeKey, false);

      final loaded = await Storage.load();
      expect(loaded.reviews, isEmpty);
      expect(loaded.unreadableKeys, contains('reviews'));
      expect(loaded.onboarded, isTrue);
      expect(loaded.darkMode, isFalse);
    });

    test('a healthy store reports no recovery', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final state = AppState();
      await state.init();
      await state.setGoal(
        const GoalProfile(
          displayName: 'Clean Soldier',
          targetAfqt: 50,
          targetGt: 100,
          targetMosCodes: <String>[],
          targetDate: null,
          officerTrack: false,
          dailyMinutes: 15,
        ),
      );
      await Storage.saveReviews(<ReviewItem>[]);

      final loaded = await Storage.load();
      expect(loaded.recoveredPartially, isFalse);
      expect(loaded.unreadableKeys, isEmpty);
      expect(loaded.skippedRecords, 0);
      expect(loaded.goal?.displayName, 'Clean Soldier');
    });
  });

  group('recovery reaches the candidate', () {
    testWidgets('a corrupt store still boots, and says so', (tester) async {
      tester.view.physicalSize = const Size(900, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final prefs = await prefsWith(
        values: <String, Object>{
          goalKey: jsonEncode(<String, dynamic>{
            'displayName': 'Recovered Soldier',
            'targetAfqt': 60,
            'targetGt': 110,
            'targetMosCodes': <String>[],
            'targetDate': null,
            'officerTrack': false,
            'dailyMinutes': 30,
          }),
          attemptsKey: 'not json at all',
        },
      );
      await prefs.setBool(onboardedKey, true);

      final state = AppState();
      await state.init();
      expect(state.loading, isFalse);
      expect(state.onboarded, isTrue);
      expect(state.storageRecovered, isTrue);

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: state,
          child: const AsvabCoachApp(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Straight to the dashboard, not the boot spinner and not onboarding.
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Some saved data could not be read'), findsOneWidget);
      expect(
        find.textContaining('your attempt history'),
        findsOneWidget,
        reason: 'the notice has to name what was lost',
      );

      // Acknowledging it is a single tap and it stays dismissed.
      await tester.tap(find.text('Got it'));
      await tester.pump();
      expect(find.text('Some saved data could not be read'), findsNothing);
      expect(state.storageRecovered, isFalse);
    });

    testWidgets('a clean store shows no notice', (tester) async {
      tester.view.physicalSize = const Size(900, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      SharedPreferences.setMockInitialValues(<String, Object>{});
      final state = AppState();
      await state.init();
      await state.setGoal(
        const GoalProfile(
          displayName: 'Clean Soldier',
          targetAfqt: 50,
          targetGt: 100,
          targetMosCodes: <String>[],
          targetDate: null,
          officerTrack: false,
          dailyMinutes: 15,
        ),
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: state,
          child: const AsvabCoachApp(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Some saved data could not be read'), findsNothing);
    });
  });
}
