import 'package:asvab_guard_coach/data/models/career_field.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/repos/mos_data.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// The roster itself: what it carries, what it refuses to guess, and when it
/// was last checked.
///
/// The failure this file exists for is the expensive one. A candidate told they
/// do not qualify for a job they do qualify for loses a career; a candidate told
/// they qualify for a job the Guard does not field loses a year. Both are data
/// bugs, so both are tested here rather than trusted to review.
void main() {
  final roster = MosRepository.all;

  /// The 97 codes the catalogue carried before the 2026-10-26 diff. Their ids
  /// are what saved eligibility and the officer pathways are keyed on, so they
  /// must survive any future roster work.
  const legacyCodes = <String>[
    '11B',
    '11C',
    '12B',
    '12D',
    '12G',
    '12K',
    '12M',
    '12N',
    '12P',
    '12R',
    '12T',
    '12W',
    '12Y',
    '13B',
    '13F',
    '13J',
    '13M',
    '13R',
    '19C',
    '19D',
    '19K',
    '18B',
    '18C',
    '18D',
    '88H',
    '88K',
    '88L',
    '88M',
    '88N',
    '89B',
    '89D',
    '92A',
    '92F',
    '92G',
    '92L',
    '92M',
    '92R',
    '92S',
    '92W',
    '92Y',
    '74D',
    '36B',
    '42A',
    '51C',
    '91B',
    '91E',
    '91S',
    '94E',
    '68A',
    '68C',
    '68E',
    '68G',
    '68J',
    '68K',
    '68P',
    '68S',
    '68T',
    '68V',
    '68W',
    '68X',
    '17C',
    '17E',
    '25B',
    '25D',
    '25E',
    '25H',
    '25U',
    '35F',
    '35G',
    '35L',
    '35M',
    '35N',
    '35P',
    '35S',
    '35T',
    '15B',
    '15E',
    '15F',
    '15N',
    '15P',
    '15Q',
    '15R',
    '15T',
    '15U',
    '15W',
    '27D',
    '31B',
    '31D',
    '31E',
    '37F',
    '38B',
    '42R',
    '42S',
    '46S',
    '46V',
    '56M',
    '79R',
  ];

  group('the roster', () {
    test('has no duplicate codes', () {
      final seen = <String, int>{};
      for (final m in roster) {
        seen[m.code] = (seen[m.code] ?? 0) + 1;
      }
      final duplicates = <String>[
        for (final e in seen.entries)
          if (e.value > 1) '${e.key} x${e.value}',
      ];
      expect(duplicates, isEmpty, reason: 'duplicate MOS codes: $duplicates');
    });

    test('ids are the codes, and every code is a plausible MOS code', () {
      for (final m in roster) {
        expect(m.id, m.code);
        expect(
          RegExp(r'^\d{2}[A-Z]$').hasMatch(m.code),
          isTrue,
          reason: '${m.code} is not a two-digit-plus-letter MOS code',
        );
      }
    });

    test('carries every code it carried before the 2026 diff', () {
      final present = <String>{for (final m in roster) m.code};
      final missing = <String>[
        for (final code in legacyCodes)
          if (!present.contains(code)) code,
      ];
      expect(
        missing,
        isEmpty,
        reason:
            'these ids are keyed on by saved eligibility and the officer '
            'pathways, so they may not be dropped: $missing',
      );
    });

    test('carries the whole of the pamphlet roster it was diffed against', () {
      // The count is asserted deliberately: adding a MOS is a data change that
      // should update this number, and dropping one should fail here.
      expect(MosRepository.enlistedCount, 156);
      expect(MosRepository.enlistedCount, roster.length);
      expect(MosRepository.officerPathways.length, 9);
    });
  });

  group('gates', () {
    test('every entry either publishes a gate or says it has none', () {
      final bad = <String>[];
      for (final m in roster) {
        switch (m.gateStatus) {
          case MosGateStatus.published:
            if (!m.hasGate) bad.add('${m.code}: published but no gate');
          case MosGateStatus.noRequirement:
            if (m.hasGate) bad.add('${m.code}: no requirement but carries one');
          case MosGateStatus.unverified:
            if (m.hasGate) {
              bad.add('${m.code}: unverified but carries a gate anyway');
            }
        }
      }
      expect(bad, isEmpty, reason: bad.join('; '));
    });

    test('a published gate is structurally sound', () {
      for (final m in roster.where((m) => m.hasGate)) {
        expect(m.gate.alternatives, isNotEmpty, reason: m.code);
        for (final alt in m.gate.alternatives) {
          expect(
            alt,
            isNotEmpty,
            reason: '${m.code} has an empty alternative, which reads as a pass',
          );
          for (final req in alt) {
            // Nothing in the authority asks for a score outside the Army scale.
            expect(
              req.min,
              inInclusiveRange(1, 220),
              reason: '${m.code} ${req.score.abbr} ${req.min} is off the scale',
            );
          }
        }
      }
    });

    test('no gate repeats the same aptitude area inside one alternative', () {
      for (final m in roster.where((m) => m.hasGate)) {
        for (final alt in m.gate.alternatives) {
          final areas = alt.map((r) => r.score).toList();
          expect(
            areas.toSet().length,
            areas.length,
            reason: '${m.code} names an aptitude area twice in one alternative',
          );
        }
      }
    });

    test('the entries with no aptitude requirement are exactly these', () {
      final codes = MosRepository.noAptitudeRequirement.map((m) => m.code);
      expect(codes, containsAll(<String>['42R', '42S', '18F']));
      expect(
        MosRepository.noAptitudeRequirement.length,
        3,
        reason:
            'the pamphlet states a N/A aptitude requirement for 18F and none '
            'at all for the two musician MOS; anything else arriving here needs '
            'a citation first',
      );
    });

    test('nothing is silently unverified', () {
      expect(
        MosRepository.gatesUnverified,
        isEmpty,
        reason:
            'the 2026-10-26 diff verified every gate against the pamphlet; an '
            'unverified gate would be shown to a candidate as a warning rather '
            'than a number, so it should never arrive unnoticed',
      );
    });

    test('the alternatives the pamphlet prints are all carried', () {
      // Each of these is a job the app used to call unreachable for anyone who
      // met the pamphlet's second, combination path.
      const combinations = <String, List<String>>{
        '91B': <String>['MM 92', 'MM 87 + GT 85'],
        '91E': <String>['GM 88 + GT 95', 'GM 98'],
        '91S': <String>['MM 87 + GT 85', 'MM 92'],
        '89B': <String>['ST 91', 'ST 86 + GT 85'],
        '94E': <String>['EL 102', 'EL 97 + ST 90'],
        '12D': <String>['GM 98 + GT 107', 'GM 98 + ST 106'],
      };
      for (final entry in combinations.entries) {
        final mos = MosRepository.byCode(entry.key);
        expect(mos, isNotNull, reason: entry.key);
        for (final alternative in entry.value) {
          final labels = mos!.gate.alternatives
              .map((alt) => alt.map((r) => r.label).join(' + '))
              .toList();
          expect(
            labels,
            contains(alternative),
            reason:
                '${entry.key} should carry the pamphlet alternative '
                '"$alternative", carries $labels',
          );
        }
      }
    });

    test('no entry pretends an extra test is a yes/no flag', () {
      for (final m in roster.where((m) => m.extraTest != null)) {
        expect(
          m.extraTest!.length,
          greaterThan(2),
          reason: '${m.code} carries an extra test of "${m.extraTest}"',
        );
        expect(<String>['Y', 'N', 'y', 'n'], isNot(contains(m.extraTest)));
      }
    });
  });

  group('fields and categories', () {
    test('every entry resolves to a career field', () {
      final unresolved = <String>[
        for (final m in roster)
          if (CareerField.of(m) == null) '${m.code} ${m.title}',
      ];
      expect(unresolved, isEmpty, reason: unresolved.join(', '));
    });

    test('every career field prefix is one the reference table names', () {
      final declared = <String>{for (final f in CareerField.all) f.prefix};
      final unknown = <String>[
        for (final m in roster)
          if (!declared.contains(m.code.substring(0, 2))) m.code,
      ];
      expect(unknown, isEmpty, reason: unknown.join(', '));
    });

    test('every category is one the filter chips offer', () {
      final offered = <String>{...MosCategory.ordered};
      final stray = <String>[
        for (final m in roster)
          if (!offered.contains(m.category)) '${m.code} ${m.category}',
      ];
      expect(stray, isEmpty, reason: stray.join(', '));
      // ...and every category offered actually has a job behind it.
      final used = <String>{for (final m in roster) m.category};
      for (final category in MosCategory.ordered) {
        expect(
          used,
          contains(category),
          reason: '$category would show as an empty filter',
        );
      }
    });

    test('the filter chips count what the data holds', () {
      // The chips read "Enlisted (n)", "Every job (n)" and
      // "Officer & warrant (n)". Each number has to be the list it opens.
      expect(MosRepository.enlistedCount, roster.length);
      expect(
        roster.length,
        MosRepository.search('').length,
        reason: 'an empty search must return exactly the enlisted roster',
      );
      final routeCount = MosRepository.officerPathways.length;
      expect(
        routeCount,
        MosRepository.officerPathways.map((p) => p.id).toSet().length,
        reason: 'duplicate pathway ids would inflate the officer chip',
      );
    });
  });

  group('the National Guard question', () {
    test('a job restricted to another component is marked, not hidden', () {
      final notGuard = MosRepository.notGuardFielded.map((m) => m.code).toList()
        ..sort();
      expect(
        notGuard,
        <String>['38B', '38R', '38W', '42T', '79R', '79S', '79V', '88P', '88U'],
        reason:
            'these are the codes the pamphlet restricts to the Active '
            'Component or the USAR. Telling a Guard candidate they qualify for '
            'one is the same harm as hiding a job they do qualify for',
      );
    });

    test('every component restriction is one the model recognises', () {
      for (final m in roster.where((m) => m.componentLimit != null)) {
        expect(
          MosComponent.all,
          contains(m.componentLimit),
          reason: '${m.code} carries "${m.componentLimit}"',
        );
      }
    });

    test('the Guard-only and Guard-fielded codes stay fielded', () {
      for (final code in <String>['12G', '79T']) {
        final mos = MosRepository.byCode(code);
        expect(mos, isNotNull, reason: code);
        expect(mos!.guardFielded, isTrue, reason: '$code is a Guard job');
      }
    });
  });

  group('the verified-as-of date', () {
    test('states a year that can be checked', () {
      expect(mosRosterVerifiedAsOf, isNotEmpty);
      final match = RegExp(r'(\d{1,2}) (\w+) (\d{4})')
          .firstMatch(mosRosterVerifiedAsOf);
      expect(
        match,
        isNotNull,
        reason:
            'the date is shown to a candidate, so it is written for a human: '
            '"26 October 2026"',
      );
      final year = int.parse(match!.group(3)!);
      expect(year, greaterThanOrEqualTo(2026));
      expect(
        DateTime(year, 1, 1).isBefore(DateTime.now()),
        isTrue,
        reason: 'a roster cannot have been verified in the future',
      );
    });

    test('names the document it was checked against', () {
      expect(mosRosterAuthority, contains('611-21'));
      expect(mosRosterAuthority, contains('chapter 10'));
      expect(mosRosterCaveat.toLowerCase(), contains('recruiter'));
    });

    test('is reachable through the repository the screens use', () {
      expect(MosRepository.rosterVerifiedAsOf, mosRosterVerifiedAsOf);
      expect(MosRepository.rosterAuthority, mosRosterAuthority);
      expect(MosRepository.rosterCaveat, mosRosterCaveat);
    });
  });
}
