import 'dart:convert';

import 'package:asvab_guard_coach/app.dart';
import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/screens/exam_screen.dart';
import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/exam.dart';
import 'package:asvab_guard_coach/data/models/exam_snapshot.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/engines/exam_builder.dart';
import 'package:asvab_guard_coach/engines/exam_restore.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:asvab_guard_coach/state/exam_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Interruptions.
///
/// A full mock is three hours on a phone that can be closed, drained, or have
/// its app reclaimed at any moment. These tests hold two promises: an
/// interrupted attempt comes back exactly as it was left, and the clock never
/// quietly gains time when the app is in the background.
class ManualClock {
  DateTime value = DateTime(2026, 3, 1, 9);

  DateTime call() => value;

  void advance(Duration by) => value = value.add(by);
}

Exam examWith({
  required int minutes,
  int count = 4,
  Subtest subtest = Subtest.ar,
}) {
  final pool = QuestionBank.bySubtest(subtest).take(count).toList();
  return Exam(
    id: 'clock-test',
    kind: ExamKind.section,
    sections: <ExamSection>[
      ExamSection(
        subtest: subtest,
        questions: <ServedQuestion>[
          for (final q in pool) ServedQuestion.identity(q),
        ],
        minutes: minutes,
      ),
    ],
    title: 'Clock test',
  );
}

const pendingKey = 'asvab.pending.v1';

/// A snapshot that is mid-way through a diagnostic, written the way the app
/// writes one.
ExamSnapshot interruptedAttempt() {
  final exam = ExamBuilder.diagnostic(seed: 12);
  // No start(): the helper only needs the answers, and a live ticker inside a
  // widget test outlives the widget tree.
  final session = ExamSession(exam: exam, seed: 12);
  session.answer(0);
  session.next();
  session.answer(1);
  return session.toSnapshot();
}

void main() {
  group('the snapshot', () {
    test('survives a trip through JSON', () {
      final clock = ManualClock();
      final exam = ExamBuilder.diagnostic(seed: 4242);
      final session = ExamSession(exam: exam, seed: 4242, now: clock.call)
        ..start();
      clock.advance(const Duration(seconds: 90));
      session.catchUp();
      session.answer(1);
      session.next();
      session.answer(3);
      session.toggleFlag();

      final original = session.toSnapshot();
      final decoded = ExamSnapshot.fromJson(
        jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>,
      );

      expect(decoded, isNotNull);
      final copy = decoded!;
      expect(copy.examId, original.examId);
      expect(copy.kind, original.kind);
      expect(copy.sections, hasLength(original.sections.length));
      expect(copy.elapsedSeconds, original.elapsedSeconds);
      expect(copy.remainingSeconds, original.remainingSeconds);
      expect(copy.questionIndex, original.questionIndex);
      expect(copy.answered, 2);
      expect(copy.responses.any((r) => r.flagged), isTrue);
      final firstSection = original.sections.first;
      expect(copy.sections.first.questionIds, firstSection.questionIds);
      expect(copy.sections.first.orders, firstSection.orders);
    });

    test('written by another version is ignored, not misread', () {
      final session = ExamSession(
        exam: ExamBuilder.diagnostic(seed: 9),
        seed: 9,
      );
      final json = session.toSnapshot().toJson()..['v'] = 99;
      expect(ExamSnapshot.fromJson(json), isNull);
    });

    test('rebuilds the same questions in the same order', () {
      final exam = ExamBuilder.diagnostic(seed: 77);
      final snapshot = ExamSession(exam: exam, seed: 77).toSnapshot();
      final rebuilt = ExamRestore.examOf(snapshot);

      expect(rebuilt, isNotNull);
      expect(rebuilt!.sections, hasLength(exam.sections.length));
      for (var s = 0; s < exam.sections.length; s++) {
        expect(
          rebuilt.sections[s].questions.map((q) => q.id).toList(),
          exam.sections[s].questions.map((q) => q.id).toList(),
        );
        expect(
          rebuilt.sections[s].questions.map((q) => q.order).toList(),
          exam.sections[s].questions.map((q) => q.order).toList(),
        );
      }
    });

    test('is refused when a question it names is gone from the bank', () {
      final session = ExamSession(
        exam: ExamBuilder.diagnostic(seed: 5),
        seed: 5,
      );
      final json = session.toSnapshot().toJson();
      final sections = json['sections'] as List;
      final first = (sections.first as Map).cast<String, dynamic>();
      final ids = (first['q'] as List).toList();
      ids[0] = 'no-such-question';
      first['q'] = ids;
      sections[0] = first;

      final snapshot = ExamSnapshot.fromJson(json);
      expect(snapshot, isNotNull);
      expect(ExamRestore.examOf(snapshot!), isNull);
    });

    test('is refused when an option order is not a permutation', () {
      final session = ExamSession(
        exam: ExamBuilder.diagnostic(seed: 6),
        seed: 6,
      );
      final json = session.toSnapshot().toJson();
      final sections = json['sections'] as List;
      final first = (sections.first as Map).cast<String, dynamic>();
      final orders = (first['o'] as List).toList();
      final scrambled = (orders.first as List).toList();
      scrambled[0] = scrambled[1];
      orders[0] = scrambled;
      first['o'] = orders;
      sections[0] = first;

      final snapshot = ExamSnapshot.fromJson(json);
      expect(snapshot, isNotNull);
      expect(ExamRestore.examOf(snapshot!), isNull);
    });
  });

  group('resuming', () {
    test('lands on the same question with the same answers and clock', () {
      final clock = ManualClock();
      final exam = ExamBuilder.section(Subtest.ar, seed: 31);
      final session = ExamSession(exam: exam, seed: 31, now: clock.call)
        ..start();
      clock.advance(const Duration(seconds: 45));
      session.catchUp();
      session.answer(2);
      session.next();
      clock.advance(const Duration(seconds: 30));
      session.catchUp();

      final snapshot = session.toSnapshot();
      final rebuilt = ExamRestore.examOf(snapshot);
      expect(rebuilt, isNotNull);

      final restoredClock = ManualClock();
      final resumed = ExamSession.resume(
        exam: rebuilt!,
        seed: 31,
        snapshot: snapshot,
        now: restoredClock.call,
      );

      expect(resumed.questionIndex, 1);
      expect(resumed.sectionIndex, 0);
      expect(resumed.elapsedSeconds, 75);
      expect(resumed.remainingSeconds, snapshot.remainingSeconds);
      // Stored in bank coordinates, so the shuffled display index 2 is not
      // necessarily bank index 2: compare against what the live session kept.
      final firstId = exam.sections[0].questions[0].id;
      expect(resumed.selectedFor(firstId), session.selectedFor(firstId));
      expect(resumed.selectedFor(firstId), isNotNull);
      expect(resumed.totalAnswered, 1);
      // The served option order is the one the candidate was looking at.
      expect(resumed.current.order, session.current.order);
    });

    test('carries the clock on from where it stopped', () {
      final clock = ManualClock();
      final session = ExamSession(
        exam: examWith(minutes: 10, count: 4),
        seed: 1,
        now: clock.call,
      )..start();
      clock.advance(const Duration(seconds: 60));
      session.catchUp();

      final snapshot = session.toSnapshot();
      final resumedClock = ManualClock();
      final resumed = ExamSession.resume(
        exam: ExamRestore.examOf(snapshot)!,
        seed: 1,
        snapshot: snapshot,
        now: resumedClock.call,
      )..start();

      expect(resumed.remainingSeconds, session.remainingSeconds);
      resumedClock.advance(const Duration(seconds: 30));
      resumed.catchUp();
      expect(resumed.remainingSeconds, session.remainingSeconds - 30);
    });
  });

  group('the clock', () {
    test('charges the real interval when the ticker was suspended', () {
      final clock = ManualClock();
      final session = ExamSession(
        exam: examWith(minutes: 10, count: 4),
        seed: 1,
        now: clock.call,
      )..start();
      expect(session.remainingSeconds, 600);

      // Ten minutes in the background: the platform stops delivering ticks.
      clock.advance(const Duration(minutes: 10));
      session.catchUp();

      expect(session.elapsedSeconds, 600);
      expect(session.remainingSeconds, 0);
    });

    test('an untimed section never runs out', () {
      final clock = ManualClock();
      final session = ExamSession(
        exam: examWith(minutes: 999, count: 3),
        seed: 1,
        now: clock.call,
      )..start();
      clock.advance(const Duration(hours: 2));
      session.catchUp();
      expect(session.finished, isFalse);
      expect(session.remainingSeconds, 999 * 60);
    });

    test('reading a section introduction costs no time', () {
      final clock = ManualClock();
      final session = ExamSession(
        exam: examWith(minutes: 10, count: 4),
        seed: 1,
        now: clock.call,
      )..start();
      session.pause();

      clock.advance(const Duration(minutes: 3));
      session.catchUp();
      expect(session.remainingSeconds, 600);

      session.resume();
      clock.advance(const Duration(seconds: 20));
      session.catchUp();
      expect(session.remainingSeconds, 580);
    });

    test('ends the section when the wall clock says the time is gone', () {
      final clock = ManualClock();
      final completed = <int>[];
      final session = ExamSession(
        exam: examWith(minutes: 1, count: 4),
        seed: 1,
        now: clock.call,
        onSectionComplete: completed.add,
      )..start();
      clock.advance(const Duration(seconds: 61));
      session.catchUp();

      expect(completed, <int>[0]);
      expect(session.finished, isTrue);
    });
  });

  group('an interrupted attempt on the dashboard', () {
    test('is offered back on the next launch', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final snapshot = interruptedAttempt();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(pendingKey, jsonEncode(snapshot.toJson()));
      await prefs.setBool('asvab.onboarded.v1', true);

      final state = AppState();
      await state.init();

      expect(state.hasPendingAttempt, isTrue);
      expect(state.pendingAttempt!.answered, 2);
      expect(state.pendingExam, isNotNull);
    });

    test('is dropped when the bank can no longer serve it', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final json = interruptedAttempt().toJson();
      final sections = json['sections'] as List;
      final first = (sections.first as Map).cast<String, dynamic>();
      final ids = (first['q'] as List).toList();
      ids[0] = 'retired-item';
      first['q'] = ids;
      sections[0] = first;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(pendingKey, jsonEncode(json));

      final state = AppState();
      await state.init();

      expect(state.hasPendingAttempt, isFalse);
      // A resume that would fail on tap is reported like any other record that
      // could not be restored, not offered and not silently ignored.
      expect(state.skippedRecords, 1);
    });

    test('is cleared when the attempt is finally submitted', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      await (await SharedPreferences.getInstance()).setString(
        pendingKey,
        jsonEncode(interruptedAttempt().toJson()),
      );
      final state = AppState();
      await state.init();
      expect(state.hasPendingAttempt, isTrue);

      final exam = state.pendingExam!;
      final session = ExamSession(exam: exam, seed: 1, now: ManualClock().call);
      final report = session.finish();
      await state.addAttempt(session.toAttempt(report), session.orders);

      expect(state.hasPendingAttempt, isFalse);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(pendingKey), isNull);
    });

    test('a fresh launch shows no resume card', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final state = AppState();
      await state.init();
      expect(state.hasPendingAttempt, isFalse);
    });
  });

  group('the resume card in the app', () {
    Future<AppState> launch(WidgetTester tester) async {
      tester.view.physicalSize = const Size(430, 950);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        pendingKey,
        jsonEncode(interruptedAttempt().toJson()),
      );
      await prefs.setBool('asvab.onboarded.v1', true);
      final state = AppState();
      await state.init();
      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: state,
          child: const AsvabCoachApp(),
        ),
      );
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 120));
      }
      return state;
    }

    testWidgets('offers the attempt back and reopens it where it stopped', (
      tester,
    ) async {
      final state = await launch(tester);
      expect(find.text('Attempt in progress'), findsOneWidget);
      expect(find.textContaining('was interrupted'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Resume'));
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 120));
      }

      // Straight back onto the question, not the section introduction.
      expect(find.byType(ExamScreen), findsOneWidget);
      expect(find.text('Begin section'), findsNothing);
      expect(state.hasPendingAttempt, isTrue);
      expect(tester.takeException(), isNull);
    });

    testWidgets('discarding it asks first and then clears it', (tester) async {
      final state = await launch(tester);

      await tester.tap(find.widgetWithText(TextButton, 'Discard'));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Discard this attempt?'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Discard'));
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 120));
      }

      expect(find.text('Attempt in progress'), findsNothing);
      expect(state.hasPendingAttempt, isFalse);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(pendingKey), isNull);
    });
  });

  group('the runner saves as it goes', () {
    testWidgets('a phone that pauses the app keeps the answers so far', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(430, 950);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      addTearDown(
        () => tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        ),
      );
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final state = AppState();
      await state.init();

      final exam = ExamBuilder.section(Subtest.ar, seed: 3);
      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: state,
          child: MaterialApp(
            theme: AppTheme.build(Brightness.light),
            home: ExamScreen(exam: exam),
          ),
        ),
      );
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 120));
      }
      await tester.tap(find.text('Begin section'));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
      await tester.pump(const Duration(milliseconds: 200));

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 120));
      }

      expect(state.hasPendingAttempt, isTrue);
      expect(state.pendingAttempt!.answered, 1);
      expect(state.pendingAttempt!.sections.first.subtest, Subtest.ar);
      expect(tester.takeException(), isNull);
    });
  });
}
