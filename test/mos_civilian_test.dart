import 'dart:io';

import 'package:asvab_guard_coach/data/repos/mos_civilian.dart';
import 'package:asvab_guard_coach/data/repos/mos_civilian_data.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// What the app tells a candidate about civilian life, and where it came from.
///
/// The claim under test is narrow and checkable: these are the O*NET Military
/// Occupational Classification (MOC) crosswalk's own titles for our MOS codes,
/// the CC BY 4.0 credit travels with them, and a code the crosswalk does not
/// cover says nothing rather than something plausible.
///
/// A title is the one piece of careers copy in this app a candidate could act
/// on - "you could be a paramedic after this" is a reason to sign. So the tests
/// here are about provenance and silence, not about wording.
void main() {
  final roster = MosRepository.all;
  final rosterCodes = <String>{for (final mos in roster) mos.code};

  /// Words that mean "nobody actually sourced this".
  const placeholders = <String>[
    'TODO',
    'TBD',
    'TBA',
    'FIXME',
    'XXX',
    'PLACEHOLDER',
    'placeholder',
    'N/A',
    'n/a',
    'lorem',
    'Unknown',
    'unknown',
    '?',
  ];

  group('coverage', () {
    test('prints the coverage line', () {
      // Printed deliberately: coverage is the number this file exists to watch,
      // and a silent drop is exactly the failure it guards against.
      // ignore: avoid_print
      print(MosCivilian.coverageLine);
      expect(MosCivilian.coverageLine, contains('MOS codes mapped'));
      expect(MosCivilian.coverageLine, contains('of 156'));
    });

    test('mapped plus omitted is exactly the roster', () {
      expect(MosCivilian.carriedCount, roster.length);
      expect(
        MosCivilian.mappedCount + MosCivilian.omittedCount,
        MosCivilian.carriedCount,
        reason: 'every carried code is either mapped or named as omitted',
      );
    });

    test('the pinned counts match the crosswalk this data came from', () {
      // These numbers are the result of the join. They should only change when
      // the crosswalk is re-downloaded or the roster changes, and then
      // docs/MOS_CIVILIAN.md has to be updated in the same change.
      expect(MosCivilian.carriedCount, 156);
      expect(
        MosCivilian.mappedCount,
        150,
        reason:
            'the O*NET MOC crosswalk milx0724 covers 150 of our 156 codes; a '
            'different number means the source or the roster moved',
      );
      expect(MosCivilian.omittedCount, 6);
    });

    test('every mapped code exists in the roster', () {
      final strays = <String>[
        for (final code in mosCivilianByCode.keys)
          if (!rosterCodes.contains(code)) code,
      ];
      expect(
        strays,
        isEmpty,
        reason:
            'a civilian title for a code the app does not carry is a screen '
            'that can never show it, or a typo: $strays',
      );
    });

    test('the map is keyed by the codes the roster uses, not by aliases', () {
      for (final code in mosCivilianByCode.keys) {
        expect(
          RegExp(r'^\d{2}[A-Z]$').hasMatch(code),
          isTrue,
          reason: '"$code" is not a two-digit-plus-letter MOS code',
        );
        expect(MosRepository.byCode(code), isNotNull);
        expect(MosRepository.byCode(code)!.code, code);
      }
    });

    test('every roster code is either mapped or named as omitted', () {
      for (final code in rosterCodes) {
        final mapped = mosCivilianByCode.containsKey(code);
        final omitted = MosCivilian.omittedCodes.contains(code);
        expect(
          mapped || omitted,
          isTrue,
          reason: '$code is neither mapped nor reported as omitted',
        );
        expect(
          mapped && omitted,
          isFalse,
          reason: '$code is both mapped and reported as omitted',
        );
      }
    });

    test('the omitted codes are the six the crosswalk does not cover', () {
      // 08H, 40D and 42T postdate the crosswalk; 19C, 15X and 88P are in it
      // only as obsolete records. See docs/MOS_CIVILIAN.md section 4.
      expect(MosCivilian.omittedCodes, <String>[
        '19C',
        '08H',
        '15X',
        '40D',
        '42T',
        '88P',
      ]);
    });

    test('an omitted code is silent rather than guessed', () {
      for (final code in MosCivilian.omittedCodes) {
        expect(MosCivilian.byCode(code), isNull);
        expect(MosCivilian.noteFor(code), isNull);
        expect(MosCivilian.inCivilianLife(code), isNull);
        expect(MosCivilian.occupationsFor(code), isEmpty);
        expect(MosCivilian.covers(code), isFalse);
      }
    });
  });

  group('the entries', () {
    test('every note is a non-empty line under 200 characters', () {
      final problems = <String>[];
      for (final entry in mosCivilianByCode.entries) {
        final note = entry.value.note;
        if (note.trim().isEmpty) {
          problems.add('${entry.key}: empty note');
        } else if (note.length >= 200) {
          problems.add('${entry.key}: note is ${note.length} characters');
        } else if (note != note.trim()) {
          problems.add('${entry.key}: note has stray whitespace');
        }
      }
      expect(problems, isEmpty, reason: problems.join(', '));
    });

    test('no note, title or code contains a placeholder', () {
      final problems = <String>[];
      for (final entry in mosCivilianByCode.entries) {
        final outlook = entry.value;
        final texts = <String>[
          outlook.note,
          outlook.mocTitle,
          for (final occupation in outlook.occupations) ...<String>[
            occupation.title,
            occupation.onetSocCode,
          ],
        ];
        for (final text in texts) {
          for (final marker in placeholders) {
            if (text.contains(marker)) {
              problems.add('${entry.key}: "$text" contains "$marker"');
            }
          }
        }
      }
      expect(
        problems,
        isEmpty,
        reason:
            'unchecked text is worse than missing text: ${problems.join('; ')}',
      );
    });

    test('every entry names an occupation, with a real O*NET-SOC code', () {
      final problems = <String>[];
      for (final entry in mosCivilianByCode.entries) {
        final occupations = entry.value.occupations;
        if (occupations.isEmpty) problems.add('${entry.key}: no occupations');
        for (final occupation in occupations) {
          final shaped = RegExp(r'^\d{2}-\d{4}\.\d{2}$')
              .hasMatch(occupation.onetSocCode);
          if (!shaped) {
            problems.add(
              '${entry.key}: "${occupation.onetSocCode}" is not an O*NET-SOC '
              'code',
            );
          }
          if (occupation.title.trim().isEmpty) {
            problems.add(
              '${entry.key}: ${occupation.onetSocCode} has no title',
            );
          }
        }
        if (entry.value.mocTitle.trim().isEmpty) {
          problems.add('${entry.key}: no crosswalk title');
        }
      }
      expect(problems, isEmpty, reason: problems.join('; '));
    });

    test('the note is the crosswalk titles and nothing else', () {
      // The note is the titles, joined, plus the military-occupation caveat
      // where that is all the crosswalk offers. Nothing else may be in it: an
      // inference here would be a career claim with no source.
      final problems = <String>[];
      for (final entry in mosCivilianByCode.entries) {
        final outlook = entry.value;
        final titles = outlook.titles.join('; ');
        if (outlook.militaryOnly) {
          if (!outlook.note.startsWith(titles)) {
            problems.add('${entry.key}: note does not start with the titles');
          }
          if (!outlook.note.contains('military occupation')) {
            problems.add('${entry.key}: military-only note does not say so');
          }
          for (final occupation in outlook.occupations) {
            if (!outlook.note.contains(occupation.onetSocCode)) {
              problems.add(
                '${entry.key}: note drops ${occupation.onetSocCode}',
              );
            }
          }
        } else if (outlook.note != titles) {
          problems.add('${entry.key}: note is not the crosswalk titles');
        }
      }
      expect(problems, isEmpty, reason: problems.join('; '));
    });

    test('an entry never repeats an occupation', () {
      for (final entry in mosCivilianByCode.entries) {
        final codes = <String>[
          for (final occupation in entry.value.occupations)
            occupation.onetSocCode,
        ];
        expect(
          codes.toSet().length,
          codes.length,
          reason: '${entry.key} repeats an O*NET-SOC code: $codes',
        );
      }
    });

    test('the military-occupation entries are marked and the rest are not', () {
      final military = mosCivilianByCode.entries
          .where((entry) => entry.value.militaryOnly)
          .toList();
      expect(
        military.length,
        greaterThan(15),
        reason:
            'O*NET files combat arms work as military occupations; if this '
            'count collapses the join has probably stopped reading ONET1',
      );
      for (final entry in mosCivilianByCode.entries) {
        if (entry.value.militaryOnly) continue;
        expect(
          entry.value.note.contains('military occupation'),
          isFalse,
          reason:
              '${entry.key} says military occupation but maps civilian work',
        );
      }
      // 11B is the plain case, and the one a recruiter is most likely to press:
      // the crosswalk offers "Infantry" (55-3016.00) and nothing else.
      final infantry = MosCivilian.byCode('11B');
      expect(infantry, isNotNull);
      expect(infantry!.occupations.first.onetSocCode, '55-3016.00');
      expect(infantry.occupations.first.title, 'Infantry');
      expect(infantry.militaryOnly, isTrue);
    });
  });

  group('the attribution', () {
    test('the licence credit is the string O*NET requires', () {
      // CC BY 4.0 wants four things: the credit, a link to the licence, the
      // trademark note, and a statement of what we changed.
      for (final required in <String>[
        'O*NET',
        'U.S. Department of Labor',
        'USDOL/ETA',
        'CC BY 4.0',
        'https://creativecommons.org/licenses/by/4.0/',
        'trademark',
        'has modified all or some of this information',
        'has not approved, endorsed, or tested these modifications',
      ]) {
        expect(
          mosCivilianAttribution,
          contains(required),
          reason: 'the attribution is missing "$required"',
        );
      }
    });

    test('a screen has one string to print and it is the whole credit', () {
      expect(MosCivilian.attribution, mosCivilianAttribution);
      expect(MosCivilian.creditLine, mosCivilianAttribution);
      expect(MosCivilian.licence, contains('CC BY 4.0'));
    });

    test('the attribution is in the generated data file, verbatim', () {
      final source = File('lib/data/repos/mos_civilian_data.dart')
          .readAsStringSync();
      expect(
        source,
        contains(mosCivilianAttribution),
        reason: 'the licence asks for the credit in the data we redistribute',
      );
      expect(source, contains('GENERATED FILE - do not edit by hand'));
    });

    test('the attribution is in docs/ as well, verbatim', () {
      final String doc = File('docs/MOS_CIVILIAN.md').readAsStringSync();
      expect(doc, contains(mosCivilianAttribution));
      expect(doc, contains('CC BY 4.0'));
      expect(doc, contains('milx0724'));
    });

    test('the source and the retrieval date travel with the titles', () {
      expect(
        MosCivilian.source,
        contains('Military Occupational Classification (MOC) crosswalk'),
      );
      expect(MosCivilian.source, contains('milx0724'));
      expect(MosCivilian.source, contains('August 2024'));
      expect(MosCivilian.sourceUrl, startsWith('https://www.onetcenter.org'));
      expect(
        mosCivilianSourceSha256,
        matches(RegExp(r'^[0-9a-f]{64}$')),
        reason: 'a re-download is only checkable against a full checksum',
      );

      // A date a human can check, and one a file can sort on.
      expect(
        RegExp(r'^\d{1,2} \w+ \d{4}$').hasMatch(mosCivilianRetrievedOn),
        isTrue,
        reason: 'retrievedOn is shown to a person: "26 October 2026"',
      );
      expect(mosCivilianRetrievedOnIso, '2026-10-26');
      final iso = DateTime.parse(mosCivilianRetrievedOnIso);
      expect(
        iso.isBefore(DateTime.now().add(const Duration(days: 1))),
        isTrue,
        reason: 'the crosswalk cannot have been retrieved in the future',
      );
    });
  });

  group('lookup', () {
    test('a mapped code resolves to its note and its sentence', () {
      final outlook = MosCivilian.byCode('68W');
      expect(outlook, isNotNull);
      expect(outlook!.note, isNotEmpty);
      final sentence = MosCivilian.inCivilianLife('68W');
      expect(sentence, MosCivilian.prefix + outlook.note);
      expect(sentence!.startsWith('In civilian life: '), isTrue);
      expect(MosCivilian.covers('68W'), isTrue);
      expect(MosCivilian.occupationsFor('68W'), isNotEmpty);
    });

    test(
      'a code arrives from stored state, so lookup forgives case and space',
      () {
        final spaced = MosCivilian.byCode(' 68w ');
        expect(spaced, isNotNull);
        expect(spaced!.note, MosCivilian.byCode('68W')!.note);
      },
    );

    test('an unknown code returns null rather than a neighbour', () {
      for (final junk in <String>['', '   ', 'ZZ9', '999', '11', '11BB']) {
        expect(MosCivilian.byCode(junk), isNull, reason: 'lookup("$junk")');
        expect(MosCivilian.inCivilianLife(junk), isNull);
        expect(MosCivilian.occupationsFor(junk), isEmpty);
      }
    });

    test('every mapped code answers through the public lookup', () {
      for (final code in mosCivilianByCode.keys) {
        expect(MosCivilian.byCode(code), isNotNull, reason: code);
        expect(MosCivilian.inCivilianLife(code), isNotNull, reason: code);
      }
    });
  });
}
