/// Warrant officer occupations: the roster, the requirement, and the one thing a
/// candidate could get badly wrong from them.
///
/// docs/MOS_GAP.md closed with a limitation it named honestly - "the diff covers
/// enlisted MOS, not warrant-officer MOS" - and a list of what closing it would
/// need. This file is the guard on that work. Three failures are possible and all
/// three are tested:
///
///  * a warrant occupation leaking into the enlisted roster or into a count of
///    "jobs open to enlistment today", which would inflate what a candidate can
///    take and put a job in front of them that starts years later;
///  * a requirement invented to fill the space where the pamphlet prints a feeder
///    MOS and a board rather than a line score;
///  * a sentence about the work that arrived without the citation that makes it
///    checkable.
///
/// The provenance rules are not restated here. [provenanceProblems] is imported
/// from test/mos_provenance_test.dart, so a description in this file is held to
/// exactly the rule the enlisted descriptions are held to, and a change to that
/// rule changes both.
library;

import 'mos_provenance_test.dart' show provenanceProblems;

import 'dart:io';

import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/line_score.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:asvab_guard_coach/data/repos/warrant_mos_data.dart';
import 'package:asvab_guard_coach/engines/eligibility_engine.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/screens/jobs_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The extracted text of the 04 December 2025 build of chapter 8 section B.
///
/// docs/research/_raw/ is ignored by git, so a fresh clone has no extract and the
/// source half of this file cannot run. That is reported as a skip naming the
/// command that rebuilds it, never as a silent pass; the data half runs either
/// way.
const String chapter8bPath =
    'docs/research/_raw/wo/chapter-8b-wo-specifications.txt';

const String extractHint =
    'the extracted chapter is not on disk (docs/research/_raw/ is ignored by '
    'git), so the warrant roster could not be checked against it; rebuild it '
    'with "python docs/research/extract_ch8b.py"';

/// A report that clears every published gate, so nothing is excluded by score
/// and the only thing that can move a count is the roster itself.
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

/// The month the second rescission takes effect, pinned rather than read from the
/// clock, because a boundary can only be tested by pinning it.
final DateTime october2026 = DateTime(2026, 10);

/// A scored candidate, for the widget half.
Future<AppState> scoredState() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  final run = PersonaRunner.run(Personas.byId('jenna'));
  await state.addAttempt(
    Attempt(
      id: 'warrant-section-attempt',
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

/// The jobs screen at the narrowest phone the app supports, at 2x text, on the
/// officer-and-warrant tab, scrolled to the warrant section.
Future<void> openWarrantSection(WidgetTester tester) async {
  final state = await scoredState();
  tester.view.physicalSize = const Size(360, 1400);
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
            child: JobsScreen(now: october2026),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));

  final officerChip = find.textContaining('Officer & warrant');
  expect(officerChip, findsOneWidget);
  await tester.ensureVisible(officerChip);
  await tester.pumpAndSettle();
  await tester.tap(officerChip);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

void main() {
  final warrant = MosRepository.warrant;
  final roster = MosRepository.all;

  group('the enlisted roster is untouched', () {
    test('it is still 156 entries, all of them enlisted', () {
      expect(MosRepository.enlistedCount, 156);
      expect(roster, hasLength(156));
      final notEnlisted = roster
          .where((m) => !m.isEnlisted)
          .map((m) => m.code)
          .toList();
      expect(
        notEnlisted,
        isEmpty,
        reason:
            'a warrant occupation in the enlisted roster would be counted as a '
            'job open to enlistment: ${notEnlisted.join(', ')}',
      );
    });

    test('no warrant code is reachable through the enlisted lookups', () {
      final warrantCodes = <String>{for (final m in warrant) m.code};
      for (final code in warrantCodes) {
        expect(
          MosRepository.byCode(code),
          isNull,
          reason: '$code is a warrant occupation, not an enlisted MOS',
        );
        expect(MosRepository.search(code), isEmpty, reason: code);
      }
      // ...and the other way round, so the two lists cannot silently merge.
      for (final mos in roster) {
        expect(MosRepository.warrantByCode(mos.code), isNull, reason: mos.code);
      }
    });

    test('the warrant list is reachable, non-empty and its own list', () {
      expect(MosRepository.warrant, isNotEmpty);
      expect(MosRepository.warrantCount, MosRepository.warrant.length);
      expect(MosRepository.warrantByCode('153A'), isNotNull);
      expect(MosRepository.warrantByCode(' 153a '), isNotNull);
    });
  });

  group('warrant entries reach no enlisted count', () {
    test('the summary counts 153 open jobs and no warrant occupation', () {
      final summary = EligibilityEngine.summarise(
        clearsEverything(),
        now: october2026,
      );
      expect(summary.total, 153);
      expect(summary.catalogueSize, 156);
      final warrantCodes = <String>{for (final m in warrant) m.code};
      final leaked = <String>[
        for (final m in summary.all)
          if (warrantCodes.contains(m.code)) m.code,
        for (final m in [...summary.unverified, ...summary.retired])
          if (warrantCodes.contains(m.code)) m.code,
      ];
      expect(
        leaked,
        isEmpty,
        reason:
            'an eligibility bucket is a statement about a job the candidate can '
            'be enlisted into: ${leaked.join(', ')}',
      );
    });

    test('the enlistable and retired lists are enlisted-only', () {
      for (final m in MosRepository.enlistableAsOf(october2026)) {
        expect(m.isEnlisted, isTrue, reason: m.code);
      }
      for (final m in MosRepository.retiredAsOf(october2026)) {
        expect(m.isEnlisted, isTrue, reason: m.code);
      }
    });
  });

  group('the warrant roster', () {
    test(
      'carries the whole of chapter 8 section B it was transcribed from',
      () {
        // The count is asserted deliberately: adding an occupation is a data change
        // that should update this number, and dropping one should fail here.
        expect(warrant, hasLength(71));
        expect(warrant, hasLength(MosRepository.warrantCount));
      },
    );

    test('has no duplicate codes and every code is a warrant code', () {
      final seen = <String, int>{};
      for (final m in warrant) {
        seen[m.code] = (seen[m.code] ?? 0) + 1;
      }
      final duplicates = <String>[
        for (final e in seen.entries)
          if (e.value > 1) '${e.key} x${e.value}',
      ];
      expect(duplicates, isEmpty, reason: duplicates.join(', '));
      for (final m in warrant) {
        expect(m.id, m.code);
        expect(
          RegExp(r'^\d{3}[A-Z]$').hasMatch(m.code),
          isTrue,
          reason:
              '${m.code} is not a warrant officer code: three digits and a '
              'letter, which is what separates 153A from the enlisted 15-series',
        );
        expect(m.title.trim(), isNotEmpty, reason: m.code);
      }
    });

    test('every entry is an appointment, not an enlistment', () {
      for (final m in warrant) {
        expect(m.appointment, MosAppointment.warrantOfficer, reason: m.code);
        expect(m.isWarrantOfficer, isTrue, reason: m.code);
        expect(m.isEnlisted, isFalse, reason: m.code);
        // The one fact a candidate planning a first job would get wrong.
        expect(
          m.requiresPriorService,
          isTrue,
          reason: '${m.code} is appointed from the ranks',
        );
      }
      // ...and no enlisted entry claims it.
      for (final m in roster) {
        expect(m.requiresPriorService, isFalse, reason: m.code);
      }
    });

    test('every entry either carries a gate or says why not', () {
      final bad = <String>[];
      for (final m in warrant) {
        switch (m.gateStatus) {
          case MosGateStatus.published:
            if (!m.hasGate) bad.add('${m.code}: published but no gate');
          case MosGateStatus.noRequirement:
            if (m.hasGate) {
              bad.add('${m.code}: no requirement but carries one');
            }
            if (m.prerequisites.isEmpty) {
              bad.add(
                '${m.code}: no gate and no prerequisites, so the entry says '
                'nothing at all about what the Army requires',
              );
            }
          case MosGateStatus.unverified:
            bad.add('${m.code}: unverified is not allowed on this roster');
        }
        for (final requirement in m.prerequisites) {
          if (requirement.trim().length < 10) {
            bad.add('${m.code}: prerequisite "$requirement" says nothing');
          }
        }
      }
      expect(bad, isEmpty, reason: bad.join('; '));
    });

    test('exactly two warrant occupations publish a line-score gate', () {
      final withGate =
          warrant.where((m) => m.hasGate).map((m) => m.code).toList()..sort();
      expect(
        withGate,
        <String>['280A', '490B'],
        reason:
            'chapter 8 section B prints an ASVAB score in exactly two sections; '
            'anything else arriving with a gate needs a citation in the section '
            'first',
      );
      for (final m in warrant.where((m) => m.hasGate)) {
        expect(m.gate.label, 'GT 110', reason: m.code);
        expect(m.note, contains('no waivers'), reason: m.code);
        for (final alt in m.gate.alternatives) {
          expect(alt, isNotEmpty, reason: m.code);
          for (final req in alt) {
            expect(req.min, inInclusiveRange(1, 220), reason: m.code);
          }
        }
      }
      for (final m in warrant.where((m) => !m.hasGate)) {
        expect(m.gate.isEmpty, isTrue, reason: m.code);
        expect(m.gateStatus, MosGateStatus.noRequirement, reason: m.code);
      }
    });

    test('the requirement each entry prints is the authority\'s own list', () {
      // Spot checks on the facts a candidate would act on: the feeder MOS, the
      // non-accession status, and the physical the aviation sections print.
      final byCode = <String, Mos>{for (final m in warrant) m.code: m};
      expect(byCode['153A']!.title, contains('Rotary Wing Aviator'));
      expect(byCode['153A']!.prerequisites.first, contains('Non-accession'));
      expect(byCode['153A']!.prerequisites.join(' '), contains('Class I'));
      expect(byCode['120A']!.prerequisites.first, contains('12H'));
      expect(byCode['311A']!.prerequisites.join(' '), contains('AR 195-3'));
      expect(byCode['351Y']!.description, isNull);
      expect(byCode['351Y']!.note, contains('AR 614-115'));
    });

    test(
      'the codes the roster deliberately leaves out are named with a reason',
      () {
        expect(mosWarrantExcluded.keys.toSet(), <String>{
          '011A',
          '011M',
          '255Z',
          '915E',
          '948E',
        });
        for (final entry in mosWarrantExcluded.entries) {
          expect(
            MosRepository.warrantByCode(entry.key),
            isNull,
            reason:
                '${entry.key} is recorded as excluded and must not be carried',
          );
          expect(entry.value.trim().length, greaterThan(40), reason: entry.key);
        }
      },
    );
  });

  group('the descriptions', () {
    test(
      'every description the roster carries passes the provenance rules',
      () {
        final problems = <String>[];
        for (final m in warrant) {
          problems.addAll(
            provenanceProblems('${m.code} description', m.description),
          );
        }
        expect(
          problems,
          isEmpty,
          reason:
              'a description without a dated https citation is a guess shown as a '
              'fact:\n  ${problems.join('\n  ')}',
        );
      },
    );

    test('the described and the undescribed are both counted', () {
      final described = warrant.where((m) => m.description != null).toList();
      final undescribed = warrant
          .where((m) => m.description == null)
          .map((m) => m.code)
          .toList();
      expect(described, hasLength(70));
      expect(
        undescribed,
        <String>['351Y'],
        reason:
            '351Y is the only section whose duties are not in the chapter - it '
            'says "see AR 614-115" - so its description stays null rather than '
            'being invented',
      );
      for (final m in described) {
        final text = m.description!.text;
        expect(
          text.length,
          inInclusiveRange(40, 320),
          reason: '${m.code} is ${text.length} characters',
        );
        expect(
          m.description!.sourceKind,
          MosSourceKind.pamphlet,
          reason: m.code,
        );
        expect(
          m.description!.sourceUrl,
          contains('chapter-8b-wo-specifications.pdf'),
          reason: m.code,
        );
        expect(
          m.description!.retrievedOn,
          DateTime(2026, 10, 26),
          reason: '${m.code} carries the day the section was read',
        );
      }
    });

    test('no description repeats another verbatim', () {
      // Nine sections print one shared duties paragraph. Paraphrasing it once and
      // pasting it is how seven aviation entries would stop describing seven
      // different aircraft.
      final texts = <String, String>{};
      final duplicates = <String>[];
      for (final m in warrant) {
        final text = m.description?.text;
        if (text == null) continue;
        final earlier = texts[text];
        if (earlier != null) duplicates.add('$earlier and ${m.code}');
        texts[text] = m.code;
      }
      expect(duplicates, isEmpty, reason: duplicates.join('; '));
    });
  });

  group('against the chapter file', () {
    final file = File(chapter8bPath);
    final String? skip = file.existsSync() ? null : extractHint;
    final sectionsByCode = <String, String>{};
    if (skip == null) {
      final lines = file.readAsLinesSync();
      String? headingCode;
      var inHeading = false;
      for (final line in lines) {
        final heading = RegExp(r'^\s*8-(\d{3,4})[A-Z]?\.').firstMatch(line);
        if (heading != null) {
          headingCode = heading.group(1);
          inHeading = true;
        } else if (inHeading && RegExp(r'^\s*[a-h][ .]').hasMatch(line)) {
          inHeading = false;
        }
        if (inHeading) {
          for (final code in RegExp(
            r'\b(\d{3}[A-Z])\b',
          ).allMatches(line).map((m) => m.group(1)!)) {
            sectionsByCode.putIfAbsent(code, () => headingCode ?? '?');
          }
        }
      }
    }

    test('every occupation the chapter specifies is carried or recorded', () {
      final carried = <String>{for (final m in warrant) m.code};
      final accounted = <String>{...carried, ...mosWarrantExcluded.keys};
      final missing = <String>[
        for (final code in sectionsByCode.keys)
          if (!accounted.contains(code)) code,
      ]..sort();
      final extra = <String>[
        for (final code in accounted)
          if (!sectionsByCode.containsKey(code)) code,
      ]..sort();
      stdout.writeln(
        'Warrant roster: ${carried.length} carried, '
        '${mosWarrantExcluded.length} recorded as excluded, '
        '${sectionsByCode.length} codes in chapter 8 section B.',
      );
      expect(
        missing,
        isEmpty,
        reason:
            'these codes are specified in the chapter and are neither carried '
            'nor recorded as excluded: ${missing.join(', ')}',
      );
      expect(
        extra,
        isEmpty,
        reason:
            'these codes are carried or excluded but the chapter does not '
            'specify them: ${extra.join(', ')}',
      );
    }, skip: skip);

    test('the two gated occupations are the two the chapter gives a GT to', () {
      final sectionsWithGt = <String>[];
      for (final entry in sectionsByCode.entries) {
        final section = chapterSectionText(
          file.readAsStringSync(),
          entry.value,
        );
        if (section.contains('ASVAB GT Score of 110')) {
          sectionsWithGt.add(entry.key);
        }
      }
      sectionsWithGt.sort();
      expect(
        sectionsWithGt,
        <String>['280A', '490B'],
        reason:
            'the chapter prints an ASVAB GT score of 110 in exactly these '
            'sections, no waivers; the app carries a gate for both and for '
            'nothing else',
      );
    }, skip: skip);
  });

  group('the jobs screen renders one at 360 dp and 2x text', () {
    testWidgets('the warrant section appears under the officer tab', (
      tester,
    ) async {
      await openWarrantSection(tester);

      final heading = find.text('Warrant officer occupations');
      expect(heading, findsOneWidget);
      await tester.ensureVisible(heading);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // The card: a code, a title, and the requirement the pamphlet publishes.
      final code = find.text('120A');
      expect(code, findsOneWidget);
      await tester.ensureVisible(code);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Construction Engineering Technician'), findsOneWidget);
      expect(
        find.textContaining('feeder MOSs 12H, 12K, 12N'),
        findsOneWidget,
        reason: 'the card prints the feeder MOSs the section publishes',
      );
    });

    testWidgets('it never reads as a job the candidate can be offered', (
      tester,
    ) async {
      await openWarrantSection(tester);

      final callout = find.textContaining(
        'You cannot enlist into a warrant officer occupation',
      );
      expect(callout, findsOneWidget);
      // The scored candidate clears every gate in the catalogue, so any "Qualified"
      // on this tab would be a verdict about a warrant occupation.
      expect(find.text('Qualified'), findsNothing);
      expect(find.textContaining('pts short'), findsNothing);
      expect(find.text('You qualify'), findsNothing);
      await tester.ensureVisible(callout);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}

/// The text of one section of the chapter file, from its heading to the next.
///
/// Used only by the source half of this file: the question it answers is "does
/// this section print an ASVAB score", which is a question about the pamphlet and
/// not about the app.
String chapterSectionText(String full, String sectionNumber) {
  final start = RegExp(
    '^\\s*8-$sectionNumber[0-9A-Z]*\\.',
    multiLine: true,
  ).firstMatch(full);
  if (start == null) return '';
  final next = RegExp(
    r'^\s*8-\d{3,4}[A-Z]?\.',
    multiLine: true,
  ).firstMatch(full.substring(start.end));
  final end = next == null ? full.length : start.end + next.start;
  return full.substring(start.start, end);
}
