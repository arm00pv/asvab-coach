import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/core/theme/tokens.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/data/repos/mos_civilian.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/screens/jobs_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:asvab_guard_coach/widgets/mos_sourced_blocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The two sourced blocks on a job sheet: what the job is, and where it leads.
///
/// Three things are under test, and all three are about silence or attribution
/// rather than wording:
///
///  * a code the O*NET crosswalk covers shows its titles and the CC BY 4.0
///    credit, because the credit is a licence condition and not a footnote;
///  * 11B, where O*NET files combat arms work as a military occupation, says so
///    rather than being dressed up as a civilian job title;
///  * a code the crosswalk does not cover (19C and five others) shows nothing,
///    because a guessed civilian title is the one line on this sheet a candidate
///    could enlist on.
///
/// [Mos.description] is null on every entry today, so the description block is
/// asserted to stay absent over the whole roster - and, so that absence is not
/// just untested code, the block itself is pumped with a fabricated, properly
/// cited [SourcedText] and required to print its provenance line.
Future<AppState> seededState() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  final run = PersonaRunner.run(Personas.byId('dana'));
  await state.addAttempt(
    Attempt(
      id: 'civilian-attempt',
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

/// The jobs screen at 360 dp wide with 2x system text: the narrowest phone the
/// app supports carrying the largest font size Android offers, which is where a
/// block that needs a Row to hold a sentence turns into a painted overflow.
Future<void> launchJobs(WidgetTester tester, AppState state) async {
  tester.view.physicalSize = const Size(360, 800);
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
                .copyWith(textScaler: const TextScaler.linear(2)),
            child: const JobsScreen(),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(tester.takeException(), isNull);

  // The list opens on "Qualified", so a job the candidate misses would not be in
  // it; every job is what this sheet is about.
  final everyJob = find.textContaining('Every job (');
  expect(everyJob, findsOneWidget);
  await tester.ensureVisible(everyJob);
  await tester.pumpAndSettle();
  await tester.tap(everyJob);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

/// Opens the sheet for one code: narrow the list to it, then tap the row.
Future<void> openSheet(WidgetTester tester, String code) async {
  final mos = MosRepository.byCode(code);
  expect(mos, isNotNull, reason: '$code should be in the roster');
  await tester.enterText(find.byType(TextField), code);
  await tester.pump();
  final row = find.text(mos!.title);
  expect(row, findsOneWidget, reason: 'the search should leave one row');
  await tester.ensureVisible(row);
  await tester.pumpAndSettle();
  await tester.tap(row);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

/// Any paragraph that had to drop text. [RenderParagraph.didExceedMaxLines] is
/// true only when text was actually laid out and something was cut, so a label
/// with an ellipsis that happens to fit is not reported.
///
/// [of] narrows the scan to one subtree. The sheet tests need that: the job list
/// behind the modal is itself at 2x text and carries chips that ellipsise by
/// design, and reporting those would say the sheet is broken when it is not.
List<String> clippedText(WidgetTester tester, {Finder? of}) {
  final source = of == null
      ? find.byType(RichText)
      : find.descendant(of: of, matching: find.byType(RichText));
  final out = <String>[];
  for (final element in source.evaluate()) {
    final object = element.renderObject;
    if (object is RenderParagraph && object.didExceedMaxLines) {
      out.add('${object.text.toPlainText()} [maxLines=${object.maxLines}]');
    }
  }
  return out;
}

/// Pumps one block on its own, at 360 dp with 2x text.
Future<void> pumpBlock(WidgetTester tester, Widget block) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.build(Brightness.light),
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2)),
          child: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(Space.xl),
              child: block,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

/// A description that is properly cited - the shape
/// test/mos_provenance_test.dart accepts. None of this text describes any MOS:
/// the roster carries no descriptions yet, so this exists only to prove the
/// block prints what it is handed.
SourcedText citedDescription({
  MosSourceKind kind = MosSourceKind.serviceSite,
  DateTime? retrievedOn,
}) => SourcedText(
  text:
      'Drives heavy trucks over highways, unimproved roads and blackout routes '
      'as part of a convoy.',
  sourceUrl: 'https://www.goarmy.com/careers-and-jobs.html',
  retrievedOn: retrievedOn ?? DateTime(2026, 10, 26),
  sourceKind: kind,
);

Mos mosWith(SourcedText? description) => Mos(
  code: '88M',
  title: 'Motor Transport Operator',
  category: 'Transportation',
  gate: g('GT 90'),
  description: description,
);

void main() {
  group('the job sheet', () {
    testWidgets('68W shows the crosswalk title and the O*NET credit under it', (
      tester,
    ) async {
      final state = await seededState();
      final sentence = MosCivilian.inCivilianLife('68W');
      expect(sentence, isNotNull);
      expect(sentence, 'In civilian life: Paramedics');

      await launchJobs(tester, state);
      await openSheet(tester, '68W');

      // The sentence as the crosswalk reads it, including its own label.
      expect(find.textContaining('In civilian life'), findsOneWidget);
      expect(find.text(sentence!), findsOneWidget);
      expect(find.textContaining('Paramedics'), findsOneWidget);

      // The credit is a licence condition: the whole string, not a shorthand.
      expect(find.text(MosCivilian.creditLine), findsOneWidget);
      expect(find.textContaining('CC BY 4.0'), findsOneWidget);
      expect(find.textContaining('USDOL/ETA'), findsOneWidget);

      // No description has been transcribed for any entry, so its block must
      // not appear at all rather than appear empty.
      expect(find.text('WHAT THIS JOB IS'), findsNothing);

      expect(tester.takeException(), isNull);
      expect(
        clippedText(tester, of: find.byType(DraggableScrollableSheet)),
        isEmpty,
        reason:
            'the sheet cut text off at 360 dp with 2x text: '
            '${clippedText(tester, of: find.byType(DraggableScrollableSheet)).join(" / ")}',
      );
    });

    testWidgets('11B names a military occupation rather than a civilian title', (
      tester,
    ) async {
      final state = await seededState();
      final outlook = MosCivilian.byCode('11B');
      expect(outlook, isNotNull);
      expect(
        outlook!.militaryOnly,
        isTrue,
        reason:
            'O*NET files 55-3016.00 as Infantry in its military block, so 11B has '
            'no civilian occupation of its own',
      );

      await launchJobs(tester, state);
      await openSheet(tester, '11B');

      final sentence = MosCivilian.inCivilianLife('11B');
      expect(sentence, isNotNull);
      expect(sentence, contains('military occupation'));
      expect(find.text(sentence!), findsOneWidget);
      expect(find.textContaining('military occupation'), findsOneWidget);

      // The crosswalk offers Infantry and nothing else for 11B, so no civilian
      // occupation title may be dressed up as its outlook.
      expect(find.textContaining('Infantry'), findsWidgets);
      expect(find.textContaining('Paramedics'), findsNothing);

      // A military-only occupation is still O*NET content, so the credit stays.
      expect(find.text(MosCivilian.creditLine), findsOneWidget);
      expect(find.text('WHAT THIS JOB IS'), findsNothing);
      expect(tester.takeException(), isNull);
      expect(
        clippedText(tester, of: find.byType(DraggableScrollableSheet)),
        isEmpty,
      );
    });

    testWidgets('19C is silent: the crosswalk does not cover it', (
      tester,
    ) async {
      final state = await seededState();
      expect(MosCivilian.covers('19C'), isFalse);
      expect(MosCivilian.inCivilianLife('19C'), isNull);

      await launchJobs(tester, state);
      await openSheet(tester, '19C');

      // The sheet is open and showing the job - the gate card is the proof.
      expect(find.text('APTITUDE GATE'), findsOneWidget);
      // And it says nothing about civilian life: no title, no guess, and no
      // credit for data that is not shown.
      expect(find.textContaining('In civilian life'), findsNothing);
      expect(find.text(MosCivilian.creditLine), findsNothing);
      expect(find.textContaining('CC BY 4.0'), findsNothing);
      expect(find.text('WHAT THIS JOB IS'), findsNothing);
      expect(tester.takeException(), isNull);
      expect(
        clippedText(tester, of: find.byType(DraggableScrollableSheet)),
        isEmpty,
      );
    });

    testWidgets('no entry in the roster has a description to show yet', (
      tester,
    ) async {
      // The block is not missing: there is nothing sourced to put in it. This is
      // the assertion that the sheet did not fake one.
      final described = <String>[
        for (final mos in MosRepository.all)
          if (mos.description != null) mos.code,
      ];
      expect(
        described,
        isEmpty,
        reason:
            'these entries gained a description, so this test (and the sheet '
            'this test stands in for) needs revisiting: $described',
      );

      final state = await seededState();
      await launchJobs(tester, state);
      await openSheet(tester, MosRepository.all.first.code);
      expect(find.text('WHAT THIS JOB IS'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('the civilian block', () {
    testWidgets('renders nothing for every code the crosswalk omits', (
      tester,
    ) async {
      expect(MosCivilian.omittedCodes, isNotEmpty);
      for (final code in MosCivilian.omittedCodes) {
        await pumpBlock(tester, MosCivilianCard(code: code));
        expect(
          find.byType(Text),
          findsNothing,
          reason: '$code is not covered, so the block must be silent',
        );
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('wraps rather than truncating at 360 dp with 2x text', (
      tester,
    ) async {
      await pumpBlock(tester, const MosCivilianCard(code: '68W'));
      expect(find.text(MosCivilian.inCivilianLife('68W')!), findsOneWidget);
      expect(find.text(MosCivilian.creditLine), findsOneWidget);
      // The credit runs to several hundred characters; at 2x text it is many
      // lines tall, and every one of them has to be laid out, not cut.
      expect(clippedText(tester), isEmpty);
      expect(tester.takeException(), isNull);
    });
  });

  group('the description block', () {
    testWidgets('prints the sentence and where it came from', (tester) async {
      await pumpBlock(
        tester,
        MosDescriptionCard(mos: mosWith(citedDescription())),
      );

      expect(find.text('WHAT THIS JOB IS'), findsOneWidget);
      expect(find.text(citedDescription().text), findsOneWidget);
      expect(
        find.text(
          'Source: an official service site, retrieved 26 October 2026',
        ),
        findsOneWidget,
      );
      expect(clippedText(tester), isEmpty);
      expect(tester.takeException(), isNull);
    });

    testWidgets('is silent when the entry has no description', (tester) async {
      await pumpBlock(tester, MosDescriptionCard(mos: mosWith(null)));
      expect(find.byType(Text), findsNothing);
      expect(tester.takeException(), isNull);
    });

    test('each kind of source has its own label, and the line names it', () {
      const expected = <MosSourceKind, String>{
        MosSourceKind.pamphlet: 'DA Pam 611-21',
        MosSourceKind.stp: 'a Soldier Training Publication',
        MosSourceKind.cool: 'Army Credentialing Opportunities On-Line (COOL)',
        MosSourceKind.onet: 'O*NET',
        MosSourceKind.serviceSite: 'an official service site',
      };
      expect(
        expected.keys.toSet(),
        MosSourceKind.values.toSet(),
        reason: 'a source kind with no label would reach the sheet unlabelled',
      );
      for (final entry in expected.entries) {
        expect(mosSourceKindLabel(entry.key), entry.value);
        expect(
          mosProvenanceLine(citedDescription(kind: entry.key)),
          'Source: ${entry.value}, retrieved 26 October 2026',
        );
      }
    });

    test('the retrieval date is a day, written the way the data writes it', () {
      // MosCivilian.retrievedOn is "26 October 2026"; a date on the same screen
      // should not be the only one in a different shape.
      expect(
        mosRetrievedOnLabel(DateTime(2026, 10, 26)),
        MosCivilian.retrievedOn,
      );
      expect(
        mosRetrievedOnLabel(DateTime(2027, 1, 9)),
        '9 January 2027',
        reason: 'no leading zero on a day a person reads',
      );
    });
  });
}
