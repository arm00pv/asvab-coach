import 'dart:io';

import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/data/repos/mos_civilian.dart';
import 'package:asvab_guard_coach/data/repos/mos_descriptions.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:asvab_guard_coach/engines/eligibility_engine.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/screens/jobs_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The roster against the pamphlet's rescission annotations.
///
/// The defect this file exists for: DA Pam 611-21 chapter 10 section C marks
/// some MOS headings "(Rescind) YYYYMM", and the app carried none of those
/// markings. A candidate whose line scores cleared 12M was told they qualified
/// for a Firefighter enlistment the Army had retired in October 2025, complete
/// with a written description of the work. A description of a job that no longer
/// exists is worse than no description at all.
///
/// So the authority is read back, every marked heading is extracted, and the
/// roster is required to carry the same date - and to claim no rescission the
/// pamphlet does not show. The extraction prints what it found, because the
/// evidence is the point.

/// The extracted text of the 04 December 2025 build of chapter 10 section C.
///
/// docs/research/_raw/ is ignored by git, so a fresh clone has no extract and
/// the source half of this file cannot run. That is reported as a skip naming
/// the command that rebuilds the extract, never as a silent pass: the data half
/// of the file runs either way.
const String pamphletPath = 'docs/research/_raw/ch10c.txt';

const String extractHint =
    'the extracted pamphlet is not on disk (docs/research/_raw/ is ignored by '
    'git), so the roster could not be checked against it; rebuild it with '
    '"python docs/research/extract_ch10c.py"';

/// One rescind-marked MOS section heading, as the pamphlet prints it.
class PamphletRescind {
  const PamphletRescind({
    required this.code,
    required this.year,
    required this.month,
    required this.line,
    required this.heading,
  });

  /// The MOS code from the heading's own "10-XXX." numbering.
  final String code;
  final int year;
  final int month;

  /// 1-based line in the extract, so the annotation can be found again by eye.
  final int line;

  /// The heading as it was read, with wrapped lines rejoined.
  final String heading;

  /// The pamphlet's own spelling of the date: 202510.
  String get stamp => '$year${month.toString().padLeft(2, '0')}';

  String get label => '${mosMonthName(month)} $year';

  DateTime get effective => DateTime(year, month);

  @override
  String toString() => '$code  $stamp ($label)  line $line';
}

/// Every MOS section heading in [text] that carries a rescission annotation.
///
/// Read as a block, not line by line. 15W's heading wraps - "(Rescind" ends one
/// line and "202610)" opens the next - so a per-line regex reports it as
/// unmarked, which is exactly the kind of miss this guard is meant to catch. The
/// section number comes from the "10-XXX." prefix because the pamphlet never
/// wraps that, and the block stops at the next heading so one entry can never
/// borrow its neighbour's annotation.
///
/// The date itself is read loosely on purpose: 12M prints "(Rescind) 202510)"
/// with a stray bracket between the word and the digits, and this guard is not
/// going to pretend the authority is tidier than it is.
List<PamphletRescind> scanPamphlet(String text) {
  final lines = text.split(RegExp(r'\r?\n'));
  final heading = RegExp(r'^\s*10-([0-9]{2}[A-Z]{0,2})\.\s');
  final rescind = RegExp(r'[Rr]escin\w*[^0-9]{0,4}(\d{6})');
  final found = <PamphletRescind>[];
  for (var i = 0; i < lines.length; i++) {
    final section = heading.firstMatch(lines[i]);
    if (section == null) continue;
    final block = <String>[lines[i]];
    for (var j = 1; j <= 2 && i + j < lines.length; j++) {
      if (heading.hasMatch(lines[i + j])) break;
      block.add(lines[i + j]);
    }
    final joined = block.join(' ').replaceAll(RegExp(r'\s+'), ' ');
    final marked = rescind.firstMatch(joined);
    if (marked == null) continue;
    final stamp = marked.group(1)!;
    // The heading as the pamphlet prints it, cut at the end of the annotation so
    // the printout shows the marked line rather than the paragraph under it.
    var end = marked.end;
    if (end < joined.length && joined[end] == ')') end++;
    found.add(
      PamphletRescind(
        code: section.group(1)!,
        year: int.parse(stamp.substring(0, 4)),
        month: int.parse(stamp.substring(4, 6)),
        line: i + 1,
        heading: joined.substring(0, end).trim(),
      ),
    );
  }
  return found;
}

/// How many "10-XXX." section headings the extract holds, marked or not. The
/// scan above is only trustworthy if the headings were found at all.
int countHeadings(String text) {
  final heading = RegExp(r'^\s*10-[0-9]{2}[A-Z]{0,2}\.\s');
  return text.split(RegExp(r'\r?\n')).where(heading.hasMatch).length;
}

/// A candidate with scores high enough that 12M's gate is cleared - the case
/// where the old screen said "Qualified" over a retired job.
Future<AppState> scoredState() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  final run = PersonaRunner.run(Personas.byId('jenna'));
  await state.addAttempt(
    Attempt(
      id: 'rescind-attempt',
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

/// The jobs screen at 360 dp wide and 2x text - the narrowest phone the app
/// supports carrying the largest system font Android offers - with the clock
/// pinned to September 2026: 12M's rescission is behind that date and 15E's is
/// ahead of it, so one row reads "Retired", another "Retiring", and neither is
/// an accident of what day the suite happens to run on.
Future<void> launchJobs(
  WidgetTester tester,
  AppState state, {
  DateTime? now,
  Size size = const Size(360, 640),
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
            child: JobsScreen(now: now ?? DateTime(2026, 9, 26)),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(tester.takeException(), isNull);

  // The list opens on "Qualified"; every job is what these rows are about.
  final everyJob = find.textContaining('Every job (');
  expect(everyJob, findsOneWidget);
  await tester.ensureVisible(everyJob);
  await tester.pumpAndSettle();
  await tester.tap(everyJob);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

/// Paragraphs that actually dropped text while laying out.
List<String> clippedText(WidgetTester tester) {
  final out = <String>[];
  for (final element in find.byType(RichText).evaluate()) {
    final object = element.renderObject;
    if (object is RenderParagraph && object.didExceedMaxLines) {
      out.add(object.text.toPlainText());
    }
  }
  return out;
}

/// Registers the real Roboto face so the layout assertions measure the phone's
/// font rather than Ahem, where every glyph is a square as wide as it is tall.
Future<void> loadRealFonts() async {
  final marker = Platform.resolvedExecutable.indexOf('bin');
  if (marker < 0) return;
  final sep = Platform.pathSeparator;
  final root = Platform.resolvedExecutable.substring(0, marker);
  final dir = '${root}bin${sep}cache${sep}artifacts${sep}material_fonts$sep';
  for (final name in <String>[
    'Roboto-Regular.ttf',
    'Roboto-Medium.ttf',
    'Roboto-Bold.ttf',
    'MaterialIcons-Regular.otf',
  ]) {
    final file = File(dir + name);
    if (!file.existsSync()) continue;
    final family = name.endsWith('.otf') ? 'MaterialIcons' : 'Roboto';
    final loader = FontLoader(family)
      ..addFont(
        Future<ByteData>.value(ByteData.sublistView(file.readAsBytesSync())),
      );
    await loader.load();
  }
}

void main() {
  final pamphlet = File(pamphletPath);
  final String? skipSource = pamphlet.existsSync() ? null : extractHint;
  final String sourceText = pamphlet.existsSync()
      ? pamphlet.readAsStringSync()
      : '';
  final marked = skipSource == null
      ? scanPamphlet(sourceText)
      : const <PamphletRescind>[];

  group('the pamphlet', () {
    test('has its section headings where the scan looks for them', () {
      expect(
        countHeadings(sourceText),
        greaterThanOrEqualTo(150),
        reason:
            'the extract should hold well over a hundred "10-XXX." section '
            'headings; fewer than this means the file is truncated or the scan '
            'reads the wrong shape of text',
      );
    }, skip: skipSource);

    test('prints every rescind-marked heading it finds', () {
      // Printed deliberately: this list IS the evidence, and the evidence is
      // exactly what was missing when the roster drifted out of step.
      // ignore: avoid_print
      print('rescind-marked MOS sections in $pamphletPath:');
      for (final r in marked) {
        // ignore: avoid_print
        print('  $r');
        // ignore: avoid_print
        print('      "${r.heading}"');
      }
      expect(marked, isNotEmpty, reason: extractHint);
      for (final r in marked) {
        expect(
          RegExp(r'^[0-9]{2}[A-Z]{0,2}$').hasMatch(r.code),
          isTrue,
          reason: '${r.code} does not look like an MOS code: ${r.heading}',
        );
        expect(r.month, inInclusiveRange(1, 12), reason: r.heading);
        expect(r.year, inInclusiveRange(2000, 2100), reason: r.heading);
      }
    }, skip: skipSource);
  });

  group('the roster and the pamphlet agree', () {
    test('every rescind-marked MOS carries the pamphlet date', () {
      final missing = <String>[];
      final wrong = <String>[];
      for (final r in marked) {
        final mos = MosRepository.byCode(r.code);
        if (mos == null) {
          missing.add(
            '${r.code} (the pamphlet rescinds it; the roster has no entry '
            'at all)',
          );
          continue;
        }
        final on = mos.rescindOn;
        if (on == null) {
          missing.add('${r.code} (marked $r; the data carries no rescindOn)');
        } else if (on.year != r.year || on.month != r.month) {
          final carried = '${on.year}${on.month.toString().padLeft(2, '0')}';
          wrong.add(
            '${r.code}: the pamphlet says ${r.stamp}, the data says '
            '$carried',
          );
        }
      }
      expect(
        missing,
        isEmpty,
        reason:
            'the pamphlet marks these MOS rescinded and the roster still '
            'offers them as live enlistment targets: ${missing.join("; ")}',
      );
      expect(wrong, isEmpty, reason: wrong.join('; '));
    }, skip: skipSource);

    test('the roster claims no rescission the pamphlet does not show', () {
      final shown = <String>{for (final r in marked) r.code};
      final invented = <String>[
        for (final mos in MosRepository.rescindMarked)
          if (!shown.contains(mos.code))
            '${mos.code} carries rescindOn ${mos.rescindOn}',
      ];
      expect(
        invented,
        isEmpty,
        reason:
            'a rescindOn with no annotation behind it retires a job on this '
            'own authority: ${invented.join("; ")}',
      );
    }, skip: skipSource);

    test('the marked codes are exactly the three the pamphlet marks', () {
      final codes = MosRepository.rescindMarked.map((m) => m.code).toList()
        ..sort();
      expect(codes, <String>['12M', '15E', '15W']);
    });

    test('the dates are the ones printed, and are months not days', () {
      final dates = <String, String>{
        for (final mos in MosRepository.rescindMarked)
          mos.code:
              '${mos.rescindOn!.year}'
              '${mos.rescindOn!.month.toString().padLeft(2, '0')}',
      };
      expect(dates, <String, String>{
        '12M': '202510',
        '15E': '202610',
        '15W': '202610',
      });
      for (final mos in MosRepository.rescindMarked) {
        expect(
          mos.rescindOn!.day,
          1,
          reason:
              'the pamphlet dates a rescission in YYYYMM; a day in there is a '
              'day somebody made up',
        );
      }
    });

    test('a rescinded MOS is kept, with its gate and its history', () {
      // Deleting history is not the fix: a candidate still meets the code, and
      // the roster is not allowed to pretend 12M never existed.
      expect(MosRepository.enlistedCount, 156);
      for (final code in <String>['12M', '15E', '15W']) {
        final mos = MosRepository.byCode(code);
        expect(mos, isNotNull, reason: '$code must stay in the roster');
        expect(mos!.hasGate, isTrue, reason: '$code keeps its published gate');
        // The description and the civilian crosswalk stay too: they are what
        // the candidate should still be able to read, now under a retirement
        // banner rather than as a job on offer.
        expect(
          MosDescriptions.forMos(mos),
          isNotNull,
          reason: '$code keeps the description it already had',
        );
        expect(
          MosCivilian.covers(code),
          isTrue,
          reason: '$code keeps its civilian crosswalk',
        );
      }
    });
  });

  group('the copy keeps retired and retiring apart', () {
    // The day the roster was verified against this build of the pamphlet.
    final now = DateTime(2026, 10, 26);

    test('a rescission month in the past reads as retired', () {
      final mos = MosRepository.byCode('12M')!;
      expect(mos.retiredAt(now), isTrue);
      expect(mos.retiringAt(now), isFalse);
      expect(
        mos.rescindHeadline(now),
        'Retired October 2025 - not available for enlistment',
      );
      expect(mos.rescindDetail(now), contains('202510'));
      expect(mos.rescindDetail(now), contains('not available for enlistment'));
    });

    test('a rescission month still ahead reads as retiring', () {
      final mos = MosRepository.byCode('15E')!;
      final before = DateTime(2026, 9, 26);
      expect(mos.retiredAt(before), isFalse);
      expect(mos.retiringAt(before), isTrue);
      expect(
        mos.rescindHeadline(before),
        'Retiring October 2026 - confirm with a recruiter before planning '
        'around it',
      );
      expect(mos.rescindDetail(before), contains('202610'));
      expect(mos.rescindDetail(before), contains('confirm'));
    });

    test('the rescission month itself is the first closed month', () {
      final mos = MosRepository.byCode('15W')!;
      // A section printed "(Rescind 202610)" is withdrawn as of 202610, so the
      // last day of September is the last day it stands and the first of
      // October is already too late. Everything that counts jobs reads this one
      // comparison, so the boundary cannot drift between screen and engine.
      expect(mos.retiredAt(DateTime(2026, 9, 30)), isFalse);
      expect(mos.retiringAt(DateTime(2026, 9, 30)), isTrue);
      expect(mos.retiredAt(DateTime(2026, 10)), isTrue);
      expect(mos.retiringAt(DateTime(2026, 10)), isFalse);
      expect(
        mos.retiredAt(DateTime(2025, 10)),
        isFalse,
        reason: '15W is 202610',
      );
      final retired12M = MosRepository.byCode('12M')!;
      expect(retired12M.retiredAt(DateTime(2025, 9, 30)), isFalse);
      expect(retired12M.retiredAt(DateTime(2025, 10)), isTrue);
    });

    test('the same MOS reads retired from its rescission month onwards', () {
      final mos = MosRepository.byCode('15W')!;
      expect(
        mos.rescindHeadline(DateTime(2026, 9, 30)),
        'Retiring October 2026 - confirm with a recruiter before planning '
        'around it',
      );
      for (final day in <DateTime>[
        DateTime(2026, 10),
        DateTime(2026, 11, 1),
        DateTime(2027, 3, 15),
      ]) {
        expect(
          mos.rescindHeadline(day),
          'Retired October 2026 - not available for enlistment',
          reason: '$day',
        );
        expect(mos.retiredAt(day), isTrue, reason: '$day');
      }
    });

    test('an unmarked MOS says nothing about rescission', () {
      for (final mos in MosRepository.all) {
        if (mos.rescindMarked) continue;
        expect(mos.retiredAt(now), isFalse, reason: mos.code);
        expect(mos.retiringAt(now), isFalse, reason: mos.code);
        expect(mos.rescindHeadline(now), isNull, reason: mos.code);
        expect(mos.rescindDetail(now), isNull, reason: mos.code);
        expect(mos.rescindMonthLabel, '', reason: mos.code);
      }
    });

    test('the repository can name both lists for a given day', () {
      // September 2026: one retirement behind the clock, two ahead of it.
      final before = DateTime(2026, 9, 26);
      expect(
        MosRepository.retiredAsOf(before).map((m) => m.code).toList(),
        <String>['12M'],
      );
      expect(
        MosRepository.retiringAsOf(before).map((m) => m.code).toList(),
        <String>['15E', '15W'],
      );
      // The same day split into what can be enlisted into and what cannot.
      expect(MosRepository.enlistableAsOf(before).length, 155);
      expect(MosRepository.enlistableCountAsOf(before), 155);
      // October 2026 onward: all three are retired and nothing is retiring.
      expect(
        MosRepository.retiredAsOf(now).map((m) => m.code).toList(),
        <String>['12M', '15E', '15W'],
      );
      expect(MosRepository.retiringAsOf(now), isEmpty);
      expect(MosRepository.enlistableCountAsOf(now), 153);
      expect(MosRepository.enlistableCountAsOf(DateTime(2027, 5, 1)), 153);
      // The roster itself never shrinks: the entries are kept and marked.
      expect(MosRepository.all.length, 156);
      expect(MosRepository.enlistedCount, 156);
      expect(
        MosRepository.enlistableAsOf(now).length +
            MosRepository.retiredAsOf(now).length,
        MosRepository.all.length,
        reason:
            'the two lists must partition the roster, not overlap or lose '
            'an entry',
      );
    });
  });

  group('the jobs screen never offers a rescinded MOS', () {
    setUpAll(loadRealFonts);

    testWidgets('a retired job is marked on its row at 360 dp and 2x text', (
      tester,
    ) async {
      final state = await scoredState();
      final mos = MosRepository.byCode('12M')!;
      // This candidate clears the gate, which is the whole reason the marking
      // matters: before this change the row read "Qualified".
      expect(
        EligibilityEngine.evaluate(mos.gate, state.lastReport!).qualified,
        isTrue,
        reason: 'the persona should clear the 12M gate for this test to bite',
      );

      await launchJobs(tester, state);
      await tester.enterText(find.byType(TextField), '12M');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(
        find.text('Retired October 2025 - not available for enlistment'),
        findsOneWidget,
        reason: 'the row has to say what happened to the job, in words',
      );
      expect(find.text('Retired'), findsOneWidget);
      expect(
        find.text('Qualified'),
        findsNothing,
        reason: 'a retired job must never read as a job the candidate can take',
      );
      expect(find.textContaining('pts short'), findsNothing);
      expect(tester.takeException(), isNull);
      expect(
        clippedText(tester),
        isEmpty,
        reason: 'labels were cut off: ${clippedText(tester).join(" / ")}',
      );

      // ...and the sheet repeats it before it says anything else about the job.
      final row = find.text(mos.title);
      expect(row, findsOneWidget);
      await tester.ensureVisible(row);
      await tester.pumpAndSettle();
      await tester.tap(row);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      expect(find.text('Retired October 2025'), findsOneWidget);
      expect(find.textContaining('not available for enlistment'), findsWidgets);
      expect(
        find.text('You qualify'),
        findsNothing,
        reason: 'no line score opens a job the Army has retired',
      );
      expect(find.textContaining('WHAT IT WOULD TAKE'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a job on its way out is warned about, not retired', (
      tester,
    ) async {
      final state = await scoredState();
      await launchJobs(tester, state);
      await tester.enterText(find.byType(TextField), '15E');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(
        find.text(
          'Retiring October 2026 - confirm with a recruiter before planning '
          'around it',
        ),
        findsOneWidget,
      );
      expect(find.text('Retiring'), findsOneWidget);
      expect(find.text('Retired'), findsNothing);
      expect(tester.takeException(), isNull);
      expect(clippedText(tester), isEmpty);

      final row = find.text(MosRepository.byCode('15E')!.title);
      await tester.ensureVisible(row);
      await tester.pumpAndSettle();
      await tester.tap(row);
      await tester.pumpAndSettle();
      expect(find.text('Retiring October 2026'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
