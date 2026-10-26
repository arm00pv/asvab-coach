import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:asvab_guard_coach/engines/eligibility_engine.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/engines/unlock_path.dart';
import 'package:asvab_guard_coach/screens/jobs_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The job sheet's answer to "what would it take".
///
/// Eligibility is a wall until the app shows its lowest stone, so a job the
/// candidate misses has to name the line score, the points and whether that one
/// raise is enough - and it has to do it on the narrowest phone the app supports
/// at the largest system text size Android offers. Every figure asserted here
/// comes from [UnlockPathEngine]; the sheet is checked for repeating the engine,
/// not for doing arithmetic of its own.
Future<AppState> seededState({bool withAttempt = true}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  if (!withAttempt) return state;
  // Dana: strong enough to clear many gates and short on plenty of others, so
  // one report can exercise both answers the sheet gives.
  final run = PersonaRunner.run(Personas.byId('dana'));
  await state.addAttempt(
    Attempt(
      id: 'unlock-attempt',
      kind: ExamKind.fullMock,
      startedAt: DateTime.now().subtract(const Duration(minutes: 150)),
      finishedAt: DateTime.now().subtract(const Duration(minutes: 20)),
      report: run.report,
      responses: const <QuestionResponse>[],
      questionIds: const <String>[],
      subtests: Subtest.administrationOrder,
    ),
    const <String, List<int>>{},
  );
  return state;
}

/// The jobs screen at 360 dp wide and 2x text: the narrowest phone the app
/// supports carrying the largest system font size it must survive.
Future<void> launch(
  WidgetTester tester,
  AppState state, {
  Size size = const Size(360, 800),
  double textScale = 2,
}) async {
  tester.view.physicalSize = size;
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
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: const JobsScreen(),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(tester.takeException(), isNull);

  // The list opens on "Qualified", which would hide a job the candidate
  // misses; every job is what this sheet is about.
  final everyJob = find.textContaining('Every job (');
  expect(everyJob, findsOneWidget);
  await tester.ensureVisible(everyJob);
  await tester.pumpAndSettle();
  await tester.tap(everyJob);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

/// Opens the sheet for one job: narrow the list to its code, then tap the row.
Future<void> openSheet(WidgetTester tester, Mos mos) async {
  await tester.enterText(find.byType(TextField), mos.code);
  await tester.pump();
  final row = find.text(mos.title);
  expect(row, findsOneWidget, reason: 'the search should leave one row');
  await tester.ensureVisible(row);
  await tester.pumpAndSettle();
  await tester.tap(row);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

/// Scrolls the open sheet until [target] exists, then leaves it on screen.
Future<void> reveal(WidgetTester tester, Finder target) async {
  final sheet = find.byType(DraggableScrollableSheet);
  expect(sheet, findsOneWidget);
  for (var i = 0; i < 24 && target.evaluate().isEmpty; i++) {
    await tester.drag(sheet, const Offset(0, -140));
    await tester.pump(const Duration(milliseconds: 60));
  }
}

void main() {
  testWidgets('a missed job names the raise that opens it, within 360 dp at 2x '
      'text', (tester) async {
    final state = await seededState();
    final report = state.lastReport!;

    // A real job this candidate misses, chosen by asking the engine rather
    // than by trusting a summary bucket.
    final missed = firstMissedJob(report);
    final path = UnlockPathEngine.forMos(missed, report.lineScores);
    expect(path.status, UnlockStatus.routesAvailable);
    expect(path.hasRoute, isTrue);

    await launch(tester, state);
    await openSheet(tester, missed);

    // The heading, the engine's own sentence, then every route cheapest first.
    await reveal(tester, find.text(path.message));
    expect(find.text('WHAT IT WOULD TAKE'), findsOneWidget);
    expect(find.text(path.message), findsOneWidget);

    for (final route in path.routes) {
      await reveal(tester, find.text(route.action));
      expect(find.text(route.action), findsOneWidget);
      // The badge carries the area and the points at a glance.
      expect(
        find.text('${route.score.abbr} +${route.pointsNeeded}'),
        findsOneWidget,
        reason: 'the route badge should state the area and the points',
      );
      // And the route says which of the two it is: enough on its own, or
      // exactly what it leaves short.
      final outcome = route.unlocksAlone
          ? (route.remaining.isEmpty
                ? 'That alone opens ${missed.code}.'
                : 'Opens ${missed.code} through another published alternative.')
          : 'Still short after this: '
                '${route.remaining.map((row) => row.readable).join(' and ')}.';
      expect(find.text(outcome), findsOneWidget);
    }

    expect(tester.takeException(), isNull);
  });

  testWidgets('a met job is told it is already open, not given a route', (
    tester,
  ) async {
    final state = await seededState();
    final report = state.lastReport!;
    final met = EligibilityEngine.summarise(report).qualified
        .firstWhere((m) => m.guardFielded && m.hasGate);

    await launch(tester, state);
    await openSheet(tester, met);

    // The description card now sits above the gate, so on a 360 dp phone at 2x
    // text the verdict is below the fold: scroll to it the way a candidate does
    // before asserting it is there.
    await reveal(tester, find.text('You qualify'));
    expect(find.text('You qualify'), findsOneWidget);
    expect(
      find.text('WHAT IT WOULD TAKE'),
      findsNothing,
      reason: 'nothing is short, so there is no route to name',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('with no attempt the sheet asks for one instead of reading every '
      'gate as zero', (tester) async {
    final state = await seededState(withAttempt: false);
    final job = firstGuardFieldedWithGate();

    await launch(tester, state);
    await openSheet(tester, job);

    await reveal(tester, find.textContaining('Sit a scored attempt first'));
    expect(find.textContaining('Sit a scored attempt first'), findsOneWidget);
    // A false zero would print a raise of the whole gate; none must appear.
    expect(find.textContaining('Raise '), findsNothing);
    expect(find.textContaining('Still short after this:'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

/// The first job the catalogue lists that this candidate misses and the engine
/// can name a concrete route into.
Mos firstMissedJob(ScoreReport report) {
  for (final m in MosRepository.all) {
    if (!m.guardFielded || !m.gateIsKnown || !m.hasGate) continue;
    if (UnlockPathEngine.forMos(m, report.lineScores).hasRoute) return m;
  }
  throw StateError('the seeded report misses no job with a published gate');
}

/// The first job the Guard fields whose gate the app actually holds.
Mos firstGuardFieldedWithGate() {
  for (final m in MosRepository.all) {
    if (m.guardFielded && m.gateIsKnown && m.hasGate) return m;
  }
  throw StateError('the catalogue holds no Guard-fielded job with a gate');
}
