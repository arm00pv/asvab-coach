import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/line_score.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/engines/recruiter_sheet.dart';
import 'package:asvab_guard_coach/screens/recruiter_sheet_screen.dart';
import 'package:asvab_guard_coach/screens/results_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The catalogue's compact gate grammar, re-implemented here so this test does
/// not depend on the roster: '|' separates OR alternatives, '&' ANDs inside one,
/// and every requirement is 'ABBR MIN'.
AptitudeGate gateOf(String spec) {
  if (spec.trim().isEmpty) {
    return const AptitudeGate(<List<LineScoreRequirement>>[]);
  }
  return AptitudeGate(<List<LineScoreRequirement>>[
    for (final alternative in spec.split('|'))
      <LineScoreRequirement>[
        for (final part in alternative.split('&')) _requirement(part.trim()),
      ],
  ]);
}

LineScoreRequirement _requirement(String part) {
  final bits = part.split(' ');
  expect(bits.length, 2, reason: 'gate row "$part" is not "ABBR MIN"');
  return LineScoreRequirement(_lineScore(bits[0]), int.parse(bits[1]));
}

LineScore _lineScore(String abbr) =>
    LineScore.values.firstWhere((score) => score.abbr == abbr.toUpperCase());

Map<LineScore, int> sheetOf(Map<String, int> byAbbr) => <LineScore, int>{
  for (final entry in byAbbr.entries) _lineScore(entry.key): entry.value,
};

Mos mosOf({
  required String code,
  required String title,
  required String gate,
  String category = 'Combat Arms',
  MosGateStatus gateStatus = MosGateStatus.published,
  String? componentLimit,
  String? extraTest,
  bool securityClearance = false,
  int? asvabMinimum,
}) => Mos(
  code: code,
  title: title,
  category: category,
  gate: gateOf(gate),
  gateStatus: gateStatus,
  componentLimit: componentLimit,
  extraTest: extraTest,
  securityClearance: securityClearance,
  asvabMinimum: asvabMinimum,
);

ScoreReport reportOf({
  Map<String, int> lines = const <String, int>{},
  int afqtComposite = 202,
  int afqtPercentile = 63,
  int ve = 50,
}) => ScoreReport(
  subtestScores: const <Subtest, SubtestScore>{},
  skillMastery: const <String, SkillMastery>{},
  ve: ve,
  afqtComposite: afqtComposite,
  afqtPercentile: afqtPercentile,
  lineScores: sheetOf(lines),
  elapsedSeconds: 3600,
  totalAnswered: 135,
  totalCorrect: 90,
);

const Map<String, int> workedLines = <String, int>{
  'GT': 105,
  'ST': 109,
  'CL': 110,
  'CO': 100,
  'EL': 103,
  'FA': 112,
  'GM': 100,
  'MM': 100,
  'OF': 100,
  'SC': 100,
  'VE': 50,
};

/// The story the formatter's own test tells - jobs met, jobs close, a job
/// nobody can judge and a job the Guard cannot access - plus one title long
/// enough to force the widest line the sheet is allowed to produce.
final List<Mos> jobs = <Mos>[
  mosOf(code: '11B', title: 'Infantryman', gate: 'CO 90'),
  mosOf(code: '11C', title: 'Indirect Fire Infantryman', gate: 'CO 95'),
  mosOf(code: '68W', title: 'Combat Medic Specialist', gate: 'ST 101|GT 100'),
  mosOf(
    code: '25U',
    title: 'Signal Support Systems Specialist',
    gate: 'EL 100',
  ),
  mosOf(code: '12N', title: 'Horizontal Construction Engineer', gate: 'GT 110'),
  mosOf(code: '92A', title: 'Automated Logistical Specialist', gate: 'CL 118'),
  mosOf(
    code: '68P',
    title: 'Radiology Specialist with a Deliberately Long Title Here',
    gate: 'ST 95',
  ),
  mosOf(code: '13B', title: 'Cannon Crewmember', gate: 'FA 130'),
  mosOf(
    code: '89B',
    title: 'Ammunition Specialist',
    gate: '',
    gateStatus: MosGateStatus.unverified,
  ),
  mosOf(
    code: '68K',
    title: 'Medical Laboratory Specialist',
    gate: 'ST 100',
    componentLimit: MosComponent.activeComponentOnly,
  ),
];

final ScoreReport report = reportOf(lines: workedLines);
final DateTime may4 = DateTime.utc(2026, 5, 4);
const String candidate = 'Alex Rivera';

/// The page the screen must render, computed from the formatter itself so the
/// test cannot drift from the artefact it is checking.
List<RecruiterSheetSection> sections() => RecruiterSheet.sections(
  report: report,
  jobs: jobs,
  generatedOn: may4,
  candidateName: candidate,
);

/// Every line those sections carry, headings first.
List<String> expectedLines() {
  final lines = <String>[];
  for (final section in sections()) {
    final heading = section.heading;
    if (heading != null && heading.isNotEmpty) lines.add(heading);
    lines.addAll(section.lines);
  }
  return lines;
}

RecruiterSheetScreen workedScreen({List<Mos>? withJobs}) =>
    RecruiterSheetScreen(
      report: report,
      jobs: withJobs ?? jobs,
      generatedOn: may4,
      candidateName: candidate,
    );

RecruiterSheetScreen noAttemptScreen() => RecruiterSheetScreen(
  report: null,
  jobs: jobs,
  generatedOn: may4,
  candidateName: candidate,
);

Future<void> pumpSheet(
  WidgetTester tester,
  Widget screen, {
  Size size = const Size(390, 844),
  double textScale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.build(Brightness.light),
      home: textScale == 1
          ? screen
          : Builder(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(textScale)),
                child: screen,
              ),
            ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

void main() {
  group('the sheet on screen', () {
    testWidgets('every line of the sheet is rendered, the disclaimer and the '
        'job rows included', (tester) async {
      await pumpSheet(tester, workedScreen());
      expect(tester.takeException(), isNull);

      final expected = expectedLines();
      expect(expected, isNotEmpty);
      // Blank entries are the formatter's own paragraph breaks; they are drawn
      // as empty rows, so only the lines that carry words are asserted.
      for (final line in expected.where((line) => line.isNotEmpty)) {
        expect(
          find.text(line),
          findsAtLeastNWidgets(1),
          reason: 'the sheet line "$line" is not on the page',
        );
      }

      // Named outright: these are the things the page exists to say.
      expect(
        find.text('ESTIMATE ONLY - NOT AN OFFICIAL ASVAB RECORD.'),
        findsOneWidget,
      );
      expect(
        find.text(RecruiterSheet.wrap(RecruiterSheet.estimateDisclaimer).first),
        findsOneWidget,
      );
      expect(find.text('Prepared 2026-05-04'), findsOneWidget);
      expect(find.text('11B  Infantryman'), findsOneWidget);
      expect(find.text('68W  Combat Medic Specialist'), findsOneWidget);
      expect(
        find.text(
          'JOBS YOU MEET (${RecruiterSheet.build(report: report, jobs: jobs, generatedOn: may4).metCount})',
        ),
        findsOneWidget,
      );
    });

    testWidgets('each line is its own monospace Text, so the layout cannot '
        're-wrap a column the formatter placed', (tester) async {
      await pumpSheet(tester, workedScreen());
      final row = tester.widget<Text>(find.text('11B  Infantryman'));
      expect(row.data, '11B  Infantryman');
      expect(row.softWrap, isFalse);
      expect(row.style?.fontFamily, 'monospace');
      expect(row.style?.fontFamilyFallback, contains('monospace'));
      // The neighbouring row is a separate widget, not text inside this one.
      expect(
        tester.widget<Text>(find.text('11C  Indirect Fire Infantryman')).data,
        '11C  Indirect Fire Infantryman',
      );
    });

    testWidgets('a long line neither overflows nor is clipped at 360x800 with '
        '2x system text', (tester) async {
      await pumpSheet(
        tester,
        workedScreen(),
        size: const Size(360, 800),
        textScale: 2,
      );
      expect(tester.takeException(), isNull);

      // The widest body line the formatter produced - found from the formatter,
      // not assumed - is on the page whole.
      final bodyLines = <String>[
        for (final section in sections()) ...section.lines,
      ];
      final longest = bodyLines.reduce((a, b) => b.length >= a.length ? b : a);
      expect(longest.length, greaterThan(30));
      expect(find.text(longest), findsOneWidget);

      final paragraph = tester.renderObject<RenderParagraph>(
        find.text(longest),
      );
      expect(paragraph.didExceedMaxLines, isFalse);

      // The line either fits the page as laid out, or the block offers a
      // horizontal scroll that reaches it. What may not happen is a line wider
      // than the page with no way to read its right-hand column.
      final horizontalScroll = find.byWidgetPredicate(
        (w) =>
            w is SingleChildScrollView && w.scrollDirection == Axis.horizontal,
      );
      if (horizontalScroll.evaluate().isEmpty) {
        expect(paragraph.size.width, lessThanOrEqualTo(360));
      } else {
        expect(
          find.descendant(of: horizontalScroll, matching: find.text(longest)),
          findsOneWidget,
        );
      }
    });

    testWidgets('the sheet lays out on a small phone and on a tablet', (
      tester,
    ) async {
      for (final size in <Size>[const Size(360, 640), const Size(800, 1280)]) {
        await pumpSheet(tester, workedScreen(), size: size);
        expect(tester.takeException(), isNull);
        expect(find.text('11B  Infantryman'), findsOneWidget);
      }
    });
  });

  group('copying the sheet', () {
    testWidgets('the copy action puts the whole sheet on the clipboard and '
        'confirms it', (tester) async {
      final copied = <String>[];
      final messenger = tester.binding.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(SystemChannels.platform, (
        MethodCall call,
      ) async {
        if (call.method == 'Clipboard.setData') {
          final arguments = call.arguments as Map<Object?, Object?>;
          copied.add(arguments['text']! as String);
        }
        return null;
      });
      addTearDown(
        () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
      );

      await pumpSheet(tester, workedScreen());

      await tester.ensureVisible(find.text('Copy sheet'));
      await tester.pump();
      await tester.tap(find.text('Copy sheet'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(copied, hasLength(1));
      // Exactly the page that is on screen, in one paste.
      expect(
        copied.single,
        RecruiterSheet.render(
          report: report,
          jobs: jobs,
          generatedOn: may4,
          candidateName: candidate,
        ),
      );
      expect(copied.single, startsWith('ASVAB GUARD COACH'));
      expect(copied.single, contains('ESTIMATE ONLY'));
      expect(
        find.text('Sheet copied. Paste it wherever you need it.'),
        findsOneWidget,
      );

      // Let the confirmation retire, so no timer outlives the test.
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    });

    testWidgets('the app bar carries the same copy action', (tester) async {
      await pumpSheet(tester, workedScreen());
      expect(find.byTooltip('Copy sheet text'), findsOneWidget);
    });
  });

  group('nothing to show', () {
    testWidgets('with no attempt at all the page says so instead of drawing an '
        'empty sheet', (tester) async {
      await pumpSheet(tester, noAttemptScreen());
      expect(tester.takeException(), isNull);

      expect(find.text('No sheet to hand over yet'), findsOneWidget);
      expect(
        find.textContaining('Take the diagnostic or a practice test'),
        findsOneWidget,
      );
      // No invented numbers, and no copy action that would copy nothing.
      expect(find.textContaining('JOBS YOU MEET'), findsNothing);
      expect(find.text('AFQT'), findsNothing);
      expect(find.text('Copy sheet'), findsNothing);
      expect(find.byTooltip('Copy sheet text'), findsNothing);
    });

    testWidgets('with no jobs loaded the page says that rather than claiming '
        'the candidate meets nothing', (tester) async {
      await pumpSheet(tester, workedScreen(withJobs: const <Mos>[]));
      expect(tester.takeException(), isNull);

      expect(find.text('The job list is empty'), findsOneWidget);
      expect(find.textContaining('catalogue is not loaded'), findsOneWidget);
      // A sheet here would print "JOBS YOU MEET (0)" - a claim about the roster
      // dressed up as a result - so none of it is drawn.
      expect(find.textContaining('JOBS YOU MEET'), findsNothing);
      expect(find.textContaining('ESTIMATE ONLY'), findsNothing);
      expect(find.text('Copy sheet'), findsNothing);
      expect(find.byTooltip('Copy sheet text'), findsNothing);
    });
  });

  group('the way in', () {
    testWidgets('the report carries a recruiter sheet control that opens it', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final state = AppState();
      await state.init();
      final result = PersonaRunner.run(Personas.byId('jenna'));
      await state.addAttempt(
        Attempt(
          id: 'sheet-entry',
          kind: ExamKind.fullMock,
          startedAt: DateTime.now().subtract(const Duration(minutes: 150)),
          finishedAt: DateTime.now().subtract(const Duration(minutes: 20)),
          report: result.report,
          responses: const <QuestionResponse>[],
          questionIds: const <String>[],
          subtests: Subtest.administrationOrder,
        ),
        const <String, List<int>>{},
      );

      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: state,
          child: MaterialApp(
            theme: AppTheme.build(Brightness.light),
            home: ResultsScreen(attempt: state.attempts.last),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);

      final entry = find.text('Recruiter sheet');
      expect(entry, findsOneWidget);
      await tester.ensureVisible(entry);
      await tester.pump();
      await tester.tap(entry);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(RecruiterSheetScreen), findsOneWidget);
      // Opened against the real catalogue, so it is a sheet and not an empty
      // page: the disclaimer the formatter prints is on screen.
      expect(
        find.text('ESTIMATE ONLY - NOT AN OFFICIAL ASVAB RECORD.'),
        findsOneWidget,
      );
    });
  });
}
