import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/line_score.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:asvab_guard_coach/engines/line_score_drill.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/engines/unlock_path.dart';
import 'package:asvab_guard_coach/screens/exam_screen.dart';
import 'package:asvab_guard_coach/screens/jobs_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The last piece of the unlock path: one tap from a route to the practice that
/// would do it.
///
/// The sheet can already say "raise GT by 2, which still leaves CO short". What
/// it could not do was start the work, so the candidate was left to work out
/// what GT is made of. These tests hold the sheet to three promises:
///
///  * every route offers a set built from the subtests that compose that line
///    score - and the composition is checked here by re-deriving it from
///    [LineScore]'s own weights, never by asking the engine that built the set;
///  * the label states the size of the set that is actually started, so the
///    number the candidate reads is the number they sit;
///  * with no attempt on record there is no action at all, because there are no
///    line scores to aim at and guessing a target is worse than offering none.
///
/// It runs on the narrowest phone the app supports at the largest system text
/// size Android offers, because the action sits inside the sheet that already
/// has to survive there.
Future<AppState> seededState({bool withAttempt = true}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  if (!withAttempt) return state;
  // Dana clears plenty of gates and misses plenty of others, so one report
  // exercises both answers the sheet gives.
  final run = PersonaRunner.run(Personas.byId('dana'));
  await state.addAttempt(
    Attempt(
      id: 'drill-attempt',
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

/// The subtests that compose [score], re-derived here from the scoring model.
///
/// Deliberately a second implementation: if the sheet and the engine agreed
/// because both called the same helper, this test could not tell a correct
/// composition from a shared mistake. The rules are the ones
/// [LineScore.compute] applies - the weighted rows, VE via WK and PC wherever a
/// verbal weight exists, and GT's own literal VE + AR sum.
Set<Subtest> feedingOf(LineScore score) {
  if (score.isVe) return Subtest.veSubtests.toSet();
  return <Subtest>{
    ...score.weights.keys,
    if (score.isLiteralSum) ...<Subtest>[Subtest.ar, ...Subtest.veSubtests],
    if (score.veWeight != 0) ...Subtest.veSubtests,
  };
}

/// The jobs screen at 360 dp wide and 2x text.
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

  // The list opens on "Qualified", which would hide a job the candidate misses.
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
  for (var i = 0; i < 40 && target.evaluate().isEmpty; i++) {
    await tester.drag(sheet, const Offset(0, -140));
    await tester.pump(const Duration(milliseconds: 60));
  }
  expect(
    target,
    findsWidgets,
    reason: 'the action never appeared in the sheet',
  );
  await tester.ensureVisible(target.first);
  await tester.pump(const Duration(milliseconds: 100));
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

void main() {
  test('the composition is read off the scoring model, not a table', () {
    // GT is the literal VE + AR sum, and VE is WK + PC.
    expect(LineScoreDrillEngine.feedingSubtests(LineScore.gt), <Subtest>[
      Subtest.ar,
      Subtest.wk,
      Subtest.pc,
    ]);
    // CO weights every reported standard score plus VE, which is WK and PC.
    expect(LineScoreDrillEngine.feedingSubtests(LineScore.co), <Subtest>[
      Subtest.gs,
      Subtest.ar,
      Subtest.wk,
      Subtest.pc,
      Subtest.mk,
      Subtest.ei,
      Subtest.as,
      Subtest.mc,
    ]);
    // No line score is computed from Assembling Objects, so none drills it.
    for (final score in LineScore.values) {
      expect(
        LineScoreDrillEngine.feedingSubtests(score),
        isNot(contains(Subtest.ao)),
        reason: '${score.abbr} is not computed from AO',
      );
      expect(LineScoreDrillEngine.feedingSubtests(score), isNotEmpty);
    }
  });

  test(
    'a set is sized like the app short sets and aimed at one line score',
    () {
      final report = PersonaRunner.run(Personas.byId('dana')).report;
      for (final score in <LineScore>[LineScore.gt, LineScore.co]) {
        final drill = LineScoreDrillEngine.forScore(
          score: score,
          report: report,
          seed: 11,
        );
        expect(drill, isNotNull, reason: '${score.abbr} should have a drill');
        final set = drill!;
        expect(
          set.questionCount,
          LineScoreDrillEngine.defaultCount,
          reason: 'a short set is the size of the weak-spot drill',
        );
        expect(set.label, contains('${score.abbr} practice'));
        expect(set.label, contains('${set.questionCount} questions'));
        final feeding = feedingOf(score);
        for (final question in set.exam.allQuestions) {
          expect(
            feeding,
            contains(question.subtest),
            reason: '${question.id} does not feed ${score.abbr}',
          );
        }
        for (final subtest in set.exam.subtests) {
          expect(feeding, contains(subtest));
        }
      }
    },
  );

  test('every route into a missed job can start its own set', () {
    final report = PersonaRunner.run(Personas.byId('dana')).report;
    final missed = firstMissedJob(report);
    final path = UnlockPathEngine.forMos(missed, report.lineScores);
    expect(path.routes, isNotEmpty);
    for (final route in path.routes) {
      final drill = LineScoreDrillEngine.forScore(
        score: route.score,
        report: report,
        seed: 5,
      );
      expect(
        drill,
        isNotNull,
        reason: '${route.action} is offered with no practice behind it',
      );
      expect(drill!.questionCount, greaterThan(0));
      expect(drill.label, contains(route.score.abbr));
    }
  });

  testWidgets('a missed job starts the practice aimed at the short line score, '
      'within 360 dp at 2x text', (tester) async {
    final state = await seededState();
    final report = state.lastReport!;

    final missed = firstMissedJob(report);
    final path = UnlockPathEngine.forMos(missed, report.lineScores);
    final route = path.routes.first;
    final feeding = feedingOf(route.score);

    await launch(tester, state);
    await openSheet(tester, missed);

    // The route itself, then its action.
    await reveal(tester, find.text(route.action));
    expect(find.text(route.action), findsOneWidget);
    final action = find.textContaining('${route.score.abbr} practice - ');
    await reveal(tester, action);
    expect(tester.takeException(), isNull);

    // The label claims a size and names the line score it aims at.
    final label = tester.widget<Text>(action.first).data!;
    final claimed = RegExp(
      r'^(GS|AR|WK|PC|MK|EI|AS|MC|GT|VE|SC|CO|EL|FA|GM|MM|OF|ST|CL) practice'
      r' - (\d+) questions? that move your .+ score$',
    ).firstMatch(label);
    expect(claimed, isNotNull, reason: 'the action reads "$label"');
    expect(claimed!.group(1), route.score.abbr);
    final count = int.parse(claimed.group(2)!);

    // The label must survive the largest system text size on a 360 dp phone.
    final paragraph = tester.renderObject<RenderParagraph>(
      find.text(label).first,
    );
    expect(
      paragraph.didExceedMaxLines,
      isFalse,
      reason: 'the drill action was cut off at 360 dp with 2x text',
    );

    // Why these questions: the composition, named.
    expect(
      find.textContaining('Drawn from '),
      findsWidgets,
      reason: 'the row should say which subtests the set is drawn from',
    );

    await tester.tap(find.text(label).first);
    // The runner is pushed with a fade; step it forward rather than settling,
    // because the section clock would keep the tree changing.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 240));
    await tester.pump(const Duration(milliseconds: 240));

    final started = tester.widget<ExamScreen>(find.byType(ExamScreen));
    final exam = started.exam;
    expect(exam.questionCount, count, reason: 'the label claims $count');
    expect(exam.allQuestions, isNotEmpty);
    expect(
      exam.title,
      label,
      reason: 'the set carries the label it was sold as',
    );
    for (final served in exam.allQuestions) {
      expect(
        feeding,
        contains(served.subtest),
        reason:
            '${served.id} (${served.subtest.abbr}) does not feed '
            '${route.score.abbr}, so this set would not move it',
      );
    }
    // At least one question from the subtests that compose the line score, and
    // no section served under a name the candidate was not promised.
    for (final section in exam.sections) {
      expect(feeding, contains(section.subtest));
      expect(section.questions, isNotEmpty);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('with no attempt on record the drill is absent rather than '
      'guessing a target', (tester) async {
    final state = await seededState(withAttempt: false);
    final job = firstGuardFieldedWithGate();

    await launch(tester, state);
    await openSheet(tester, job);

    await reveal(tester, find.textContaining('Sit a scored attempt first'));
    // No line scores on record, so there is nothing to aim a practice set at.
    expect(
      find.textContaining('practice - '),
      findsNothing,
      reason: 'a drill was offered without a report to aim it',
    );
    expect(find.textContaining('Drawn from '), findsNothing);
    expect(find.byType(FilledButton), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
