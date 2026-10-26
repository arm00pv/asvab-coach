import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/line_score.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:asvab_guard_coach/engines/eligibility_engine.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/screens/jobs_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// What the headline count is counting.
///
/// The defect this file exists for: the engine counted every entry with a
/// published gate, so "N of 156 jobs open" included 12M Firefighter months after
/// the Army rescinded it in October 2025. The rows and the detail sheet already
/// said "Retired October 2025 - not available for enlistment"; the number above
/// them said the candidate qualified for it. The fix belongs where the summary
/// is computed, not in each screen, so this file pins the clock at three dates
/// and holds the engine and every screen that reads it to the same answer.
///
/// The boundary is the rescission month itself. DA Pam 611-21 prints
/// "(Rescind) 202510" on 12M's section heading and "202610" on 15E's and 15W's,
/// and a section rescinded as of October is not an enlistment target in October.

/// A report that clears every published gate, so nothing is excluded by score:
/// the only thing that can move a count here is the date.
ScoreReport clearsEverything() => ScoreReport(
  subtestScores: const <Subtest, SubtestScore>{},
  skillMastery: const <String, SkillMastery>{},
  ve: 50,
  afqtComposite: 250,
  afqtPercentile: 99,
  lineScores: <LineScore, int>{for (final ls in LineScore.values) ls: 999},
  elapsedSeconds: 0,
  totalAnswered: 0,
  totalCorrect: 0,
);

EligibilitySummary summaryFor(ScoreReport report, DateTime now) =>
    EligibilityEngine.summarise(report, now: now);

EligibilitySummary at(DateTime now) => summaryFor(clearsEverything(), now);

/// The roster on a date the test can pin, not the day the suite runs. The
/// machine that runs this file may well be sitting in October 2026 - the date
/// the second rescission takes effect - so nothing here may read the real clock.
final DateTime october2025 = DateTime(2025, 10);
final DateTime october2026 = DateTime(2026, 10);
final DateTime year2027 = DateTime(2027, 6, 15);

/// A scored candidate for the widget half, which needs a real [AppState].
Future<AppState> scoredState() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  final run = PersonaRunner.run(Personas.byId('jenna'));
  await state.addAttempt(
    Attempt(
      id: 'eligibility-count-attempt',
      kind: ExamKind.fullMock,
      startedAt: DateTime(2026, 9, 26, 9),
      finishedAt: DateTime(2026, 9, 26, 11),
      report: run.report,
      responses: const <QuestionResponse>[],
      questionIds: const <String>[],
      subtests: Subtest.administrationOrder,
    ),
    const <String, List<int>>{},
  );
  return state;
}

/// The jobs screen at the narrowest phone the app supports, at 2x text, with
/// the clock pinned and the list switched to every job - the mode in which a
/// retired entry has to remain visible.
Future<void> launchJobs(
  WidgetTester tester,
  AppState state,
  DateTime now,
) async {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ChangeNotifierProvider<AppState>.value(
      value: state,
      child: MaterialApp(
        theme: AppTheme.build(Brightness.light),
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(2)),
            child: JobsScreen(now: now),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(tester.takeException(), isNull);
  final everyJob = find.textContaining('Every job (');
  expect(everyJob, findsOneWidget);
  await tester.ensureVisible(everyJob);
  await tester.pumpAndSettle();
  await tester.tap(everyJob);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

void main() {
  group('the denominator is the catalogue that can be enlisted into', () {
    test('156 entries are transcribed; only the open ones are counted', () {
      expect(MosRepository.all.length, 156);
      expect(MosRepository.enlistedCount, 156, reason: 'the roster is 156');
      expect(MosRepository.rescindMarked.map((m) => m.code).toList(), <String>[
        '12M',
        '15E',
        '15W',
      ]);
    });

    test('October 2025: 12M has gone, 15E and 15W are still open', () {
      final summary = at(october2025);
      expect(summary.total, 155);
      expect(summary.retired.map((m) => m.code).toList(), <String>['12M']);
      expect(summary.catalogueSize, 156);
      expect(summary.retiredNote, contains('12M'));
      expect(summary.retiredNote, isNot(contains('15E')));
    });

    test('October 2026: 15E and 15W go with it, leaving 153', () {
      final summary = at(october2026);
      expect(summary.total, 153);
      expect(summary.retired.map((m) => m.code).toList(), <String>[
        '12M',
        '15E',
        '15W',
      ]);
      expect(summary.catalogueSize, 156);
      expect(summary.retiredNote, contains('3 retired entries not counted'));
      expect(summary.retiredNote, contains('12M, 15E, 15W'));
    });

    test('2027: nothing further retires, so the count holds at 153', () {
      final summary = at(year2027);
      expect(summary.total, 153);
      expect(summary.retiredCount, 3);
      expect(summary.total, at(october2026).total);
    });

    test('the count only moves at a rescission month, and nowhere else', () {
      // Every month from two years before the first rescission to two years
      // after the last one. A boundary that is off by a month, or a filter that
      // drops an entry whenever it feels like it, shows up here as an extra
      // transition rather than as a single surprise in one assertion.
      final months = <String, int>{};
      for (var year = 2024; year <= 2028; year++) {
        for (var month = 1; month <= 12; month++) {
          final stamp = '$year-${month.toString().padLeft(2, '0')}';
          months[stamp] = at(DateTime(year, month)).total;
        }
      }
      final steps = <String>[];
      int? previous;
      for (final entry in months.entries) {
        if (previous != null && entry.value != previous) steps.add(entry.key);
        previous = entry.value;
      }
      expect(
        steps,
        <String>['2025-10', '2026-10'],
        reason:
            'the only months that change the count are the two rescission '
            'months: 12M in October 2025, 15E and 15W in October 2026',
      );
      expect(months['2024-01'], 156);
      expect(months['2025-09'], 156);
      expect(months['2025-10'], 155);
      expect(months['2026-09'], 155);
      expect(months['2026-10'], 153);
      expect(months['2028-12'], 153);
    });

    test('the boundary is a month, not the day after the month ends', () {
      // The last day of September and the first of October are on opposite
      // sides of it; nothing in between is a coin toss.
      expect(at(DateTime(2026, 9, 30)).total, 155);
      expect(at(DateTime(2026, 10, 1)).total, 153);
      expect(at(DateTime(2025, 9, 30)).total, 156);
      expect(at(DateTime(2025, 10, 1)).total, 155);
    });

    test('the met set only ever loses the entries that retire', () {
      // Not just "the number went down": across each boundary the met list is
      // the previous one minus exactly the codes that retired, and between
      // boundaries it is identical. A filter that dropped a live job, or one
      // that let a retired one linger, breaks the set equality rather than
      // landing on a plausible-looking total.
      final reports = <ScoreReport>[
        clearsEverything(),
        PersonaRunner.run(Personas.byId('marcus')).report,
      ];
      final transitions = <({DateTime from, DateTime to, List<String> drops})>[
        (
          from: DateTime(2025, 9, 30),
          to: DateTime(2025, 10),
          drops: <String>['12M'],
        ),
        (
          from: DateTime(2026, 9, 30),
          to: DateTime(2026, 10),
          drops: <String>['15E', '15W'],
        ),
        (
          from: DateTime(2026, 10),
          to: DateTime(2027, 6, 15),
          drops: const <String>[],
        ),
        (
          from: DateTime(2026, 3, 1),
          to: DateTime(2026, 3, 31),
          drops: const <String>[],
        ),
      ];
      for (final report in reports) {
        for (final t in transitions) {
          final before = summaryFor(report, t.from);
          final after = summaryFor(report, t.to);
          final dropped = t.drops.isEmpty ? 'nothing' : t.drops.join(', ');
          expect(
            after.qualified.map((m) => m.code).toSet(),
            before.qualified
                .map((m) => m.code)
                .toSet()
                .difference(t.drops.toSet()),
            reason: '${t.from} -> ${t.to} must only drop $dropped',
          );
          expect(after.total, before.total - t.drops.length);
        }
      }
    });

    test('the summary and the repository never disagree', () {
      for (final now in <DateTime>[
        DateTime(2025, 9, 30),
        october2025,
        DateTime(2026, 9, 30),
        october2026,
        year2027,
      ]) {
        final summary = at(now);
        expect(summary.total, MosRepository.enlistableCountAsOf(now));
        expect(summary.retiredCount, MosRepository.retiredAsOf(now).length);
        expect(summary.catalogueSize, MosRepository.all.length);
        expect(
          summary.total + summary.retiredCount,
          summary.catalogueSize,
          reason: 'counted and retired must partition the roster on $now',
        );
      }
    });
  });

  group('a retired MOS is never a job the candidate meets', () {
    test('all three retired gates are cleared by this report', () {
      // The premise, asserted rather than assumed: a perfect report satisfies
      // every one of these gates, so only the date can keep them out.
      for (final code in <String>['12M', '15E', '15W']) {
        final mos = MosRepository.byCode(code)!;
        expect(mos.hasGate, isTrue, reason: code);
        expect(
          EligibilityEngine.evaluate(mos.gate, clearsEverything()).qualified,
          isTrue,
          reason: '$code is a job this report would otherwise qualify for',
        );
      }
    });

    test('none of them reaches a bucket, in any month', () {
      final retiredCodes = <String>['12M', '15E', '15W'];
      for (final now in <DateTime>[october2025, october2026, year2027]) {
        final summary = at(now);
        for (final code in retiredCodes) {
          final mos = MosRepository.byCode(code)!;
          if (!mos.retiredAt(now)) continue;
          expect(summary.isQualified(mos), isFalse, reason: '$code on $now');
          expect(summary.qualified.contains(mos), isFalse);
          expect(summary.nearMiss.contains(mos), isFalse);
          expect(summary.outOfReach.contains(mos), isFalse);
          expect(summary.unverified.contains(mos), isFalse);
          expect(summary.all.contains(mos), isFalse);
          // Kept, marked, and named - just not counted.
          expect(summary.isRetired(mos), isTrue, reason: '$code on $now');
        }
      }
    });

    test('15E and 15W are counted in September 2026 and not in October', () {
      final before = at(DateTime(2026, 9, 30));
      final after = at(october2026);
      for (final code in <String>['15E', '15W']) {
        final mos = MosRepository.byCode(code)!;
        expect(before.isQualified(mos), isTrue, reason: code);
        expect(after.isQualified(mos), isFalse, reason: code);
      }
      expect(
        before.qualified.length - after.qualified.length,
        2,
        reason: 'exactly the two MOS that retire that month leave the met list',
      );
    });

    test('12M leaves the met list in October 2025 and never comes back', () {
      final mos = MosRepository.byCode('12M')!;
      expect(at(DateTime(2025, 9, 30)).isQualified(mos), isTrue);
      for (final now in <DateTime>[october2025, october2026, year2027]) {
        expect(at(now).isQualified(mos), isFalse, reason: '$now');
      }
    });

    test('the percentage is out of the open catalogue, not the roster', () {
      final summary = at(october2026);
      final expected = ((summary.qualified.length / 153) * 100).round();
      expect(summary.percentQualified, expected);
      expect(summary.total, isNot(MosRepository.all.length));
    });
  });

  group('the screens read the one summary', () {
    testWidgets('the jobs list still shows a retired entry, marked', (
      tester,
    ) async {
      final state = await scoredState();
      await launchJobs(tester, state, year2027);

      // The count excludes it...
      expect(
        find.textContaining('of 153 jobs open to enlistment today'),
        findsOneWidget,
        reason: 'the headline denominator must be the open catalogue',
      );
      expect(
        find.textContaining('retired entries not counted: 12M, 15E, 15W'),
        findsOneWidget,
        reason: 'a denominator that shrinks has to say why',
      );

      // ...and the row is still there, saying what happened to the job.
      await tester.enterText(find.byType(TextField), '15W');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);
      expect(
        find.text('Retired October 2026 - not available for enlistment'),
        findsOneWidget,
        reason:
            'hiding the entry would be the wrong fix: it is marked, kept '
            'and explained',
      );
      expect(find.text('Retired'), findsOneWidget);
      expect(
        find.text('Qualified'),
        findsNothing,
        reason: 'a retired job must never read as one the candidate can take',
      );
      expect(find.textContaining('pts short'), findsNothing);
      expect(
        find.textContaining('of 153 jobs open to enlistment today'),
        findsOneWidget,
        reason: 'filtering the list must not change what the count says',
      );
    });

    testWidgets('the same entry is counted before its month arrives', (
      tester,
    ) async {
      final state = await scoredState();
      await launchJobs(tester, state, DateTime(2026, 9, 26));
      expect(
        find.textContaining('of 155 jobs open to enlistment today'),
        findsOneWidget,
        reason: 'in September 2026 only 12M is retired',
      );
      expect(
        find.textContaining('1 retired entry not counted: 12M'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextField), '15W');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);
      expect(
        find.textContaining('Retiring October 2026'),
        findsOneWidget,
        reason: 'an entry still open is warned about, not retired',
      );
    });
  });
}
