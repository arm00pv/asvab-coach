/// The union of the four description slices, and the lookup a screen uses.
///
/// The slices were written in parallel, so the things that can go wrong are the
/// things that go wrong when four maps are added up: a code written twice (one
/// sentence silently lost), a code that is not on the roster (a description
/// nobody can be shown), a slice that quietly shrank so the total is no longer
/// the sum, and two codes that ended up with the same words because an entry was
/// pasted across the divide.
///
/// Each of those is asserted here against the four slice maps directly, not only
/// against the union the library serves, so the proof does not depend on the
/// union having been built correctly. The library checks the same three
/// invariants at build time and throws; this file is the evidence that the
/// committed data satisfies them.
///
/// Coverage is not asserted as a number the data has to reach arbitrarily: it is
/// asserted that all 156 roster codes are described, and a code that is not is
/// named in the failure message rather than folded into a count. The coverage
/// line is printed so the number is in the CI log instead of being inferred from
/// silence.
library;

import 'dart:io';

import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/repos/mos_description_slice_1.dart';
import 'package:asvab_guard_coach/data/repos/mos_description_slice_2.dart';
import 'package:asvab_guard_coach/data/repos/mos_description_slice_3.dart';
import 'package:asvab_guard_coach/data/repos/mos_description_slice_4.dart';
import 'package:asvab_guard_coach/data/repos/mos_descriptions.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// How many codes the roster carries. Pinned rather than read, so a roster that
/// grew or lost a code shows up here as a mismatch instead of shrinking the
/// denominator this file is about.
const int rosterSize = 156;

void main() {
  final slices = <String, Map<String, SourcedText>>{
    'slice 1': mosDescriptionSlice1,
    'slice 2': mosDescriptionSlice2,
    'slice 3': mosDescriptionSlice3,
    'slice 4': mosDescriptionSlice4,
  };
  final Map<String, SourcedText> merged = MosDescriptions.all;
  final Set<String> rosterCodes = <String>{
    for (final Mos m in MosRepository.all) m.code,
  };

  group('the union is what it claims', () {
    test('no code is written in two slices', () {
      final owners = <String, String>{};
      final problems = <String>[];
      for (final MapEntry<String, Map<String, SourcedText>> slice
          in slices.entries) {
        for (final String code in slice.value.keys) {
          final String? earlier = owners[code];
          if (earlier != null) {
            problems.add('$code is in $earlier and again in ${slice.key}');
          } else {
            owners[code] = slice.key;
          }
        }
      }
      expect(
        problems,
        isEmpty,
        reason:
            'the slices are not disjoint, so one of the two sentences per code '
            'is being thrown away: ${problems.join('; ')}',
      );
      // And the union agrees: a code in two slices would have collapsed here.
      expect(merged.keys, hasLength(owners.length));
    });

    test('the union is exactly the four slices added up', () {
      final int summed = slices.values.fold(
        0,
        (int n, Map<String, SourcedText> s) => n + s.length,
      );
      expect(merged, hasLength(summed), reason: 'union size = sum of slices');
      expect(MosDescriptions.count, summed);
      expect(
        merged.keys.toSet(),
        hasLength(summed),
        reason: 'a repeated key means one slice overwrote another',
      );
      expect(merged, hasLength(rosterSize));
    });

    test('every described code is a real roster code', () {
      final List<String> strays = merged.keys
          .where((String code) => !rosterCodes.contains(code))
          .toList();
      expect(
        strays,
        isEmpty,
        reason:
            'a description keyed to a code the catalogue does not carry can '
            'never be shown to anyone: ${strays.join(', ')}',
      );
    });

    test('every value the union serves is the slot its slice holds', () {
      // Not just the keys: the union must hand over the same object, so a
      // description cannot be rewritten on the way through.
      for (final MapEntry<String, Map<String, SourcedText>> slice
          in slices.entries) {
        for (final MapEntry<String, SourcedText> entry in slice.value.entries) {
          expect(
            merged[entry.key],
            same(entry.value),
            reason:
                '${entry.key} from ${slice.key} is not what the union serves',
          );
        }
      }
    });

    test('a screen cannot write to the merged map', () {
      expect(
        () => merged['11B'] = mosDescriptionSlice1['11B']!,
        throwsUnsupportedError,
        reason:
            'a description is a sourced value: it is replaced by a data pass, '
            'never assigned by the screen that displays it',
      );
    });
  });

  group('coverage of the roster', () {
    test('the roster still holds the 156 codes the slices were cut from', () {
      expect(rosterCodes, hasLength(rosterSize));
      expect(MosRepository.enlistedCount, rosterSize);
      expect(MosRepository.all, hasLength(rosterSize));
    });

    test(
      'all 156 roster codes are described, and none is reported missing',
      () {
        final List<String> missing = <String>[
          for (final Mos mos in MosRepository.all)
            if (!merged.containsKey(mos.code)) mos.code,
        ];
        expect(
          missing,
          isEmpty,
          reason:
              'these codes would render no description on the job sheet: '
              '${missing.join(', ')}',
        );
        expect(MosDescriptions.omittedCodes, isEmpty);
        expect(MosDescriptions.describedCodes, hasLength(rosterSize));
        expect(MosDescriptions.describedCount, rosterSize);
        expect(MosDescriptions.omittedCount, 0);
        expect(
          MosDescriptions.describedCount + MosDescriptions.omittedCount,
          MosDescriptions.carriedCount,
        );
      },
    );

    test('the coverage line reports 156 of 156', () {
      final String line = MosDescriptions.coverageLine;
      // Printed as well as asserted: the number belongs in the CI log, where it
      // can be watched rather than looked up.
      stdout.writeln(line);
      expect(line, contains('156 of 156'));
      expect(line, contains('100.0%'));
      expect(line, contains('0 omitted'));
      expect(line, contains('none'));
      expect(line, contains('DA Pam 611-21'));
    });
  });

  group('the lookup a screen uses', () {
    test('every described code resolves to its own entry', () {
      for (final String code in merged.keys) {
        expect(MosDescriptions.forCode(code), same(merged[code]), reason: code);
        expect(
          MosDescriptions.forCode(code.toLowerCase()),
          same(merged[code]),
          reason: '$code in lower case should read the same as in upper case',
        );
        expect(MosDescriptions.covers(code), isTrue, reason: code);
        expect(MosDescriptions.textFor(code), merged[code]!.text, reason: code);
      }
    });

    test('case and surrounding whitespace are forgiven', () {
      final SourcedText? exact = MosDescriptions.forCode('68W');
      expect(exact, isNotNull);
      const List<String> variants = <String>[
        '68w',
        ' 68W',
        '68W ',
        '  68w  ',
        '\t68W\n',
      ];
      for (final String variant in variants) {
        expect(
          MosDescriptions.forCode(variant),
          same(exact),
          reason: '"$variant" names the same job as "68W"',
        );
      }
    });

    test('an unknown code is null, not a guess', () {
      const List<String> unknown = <String>[
        '00Z',
        'ZZZ',
        '',
        '   ',
        '11B-S',
        'nope',
      ];
      for (final String code in unknown) {
        expect(
          MosDescriptions.forCode(code),
          isNull,
          reason: '"$code" is not a code the catalogue describes',
        );
        expect(MosDescriptions.covers(code), isFalse);
        expect(MosDescriptions.textFor(code), isNull);
      }
    });

    test('forMos reads the map when the entry carries no description', () {
      // 68W carries no description of its own in the roster today; the sheet
      // still has to find one.
      final Mos med = MosRepository.byCode('68W')!;
      expect(med.description, isNull);
      expect(MosDescriptions.forMos(med), same(MosDescriptions.forCode('68W')));
    });

    test("an entry's own description wins over the merged map", () {
      // The model field is the more specific record: a value put there
      // deliberately must not be shadowed by the catalogue-wide map.
      final SourcedText own = SourcedText(
        text:
            'Drives heavy trucks over highways, unimproved roads and blackout '
            'routes as part of a convoy.',
        sourceUrl: 'https://www.goarmy.com/careers-and-jobs.html',
        retrievedOn: DateTime(2026, 10, 26),
        sourceKind: MosSourceKind.serviceSite,
      );
      final Mos entry = Mos(
        code: '68W',
        title: 'Combat Medic Specialist',
        category: MosRepository.byCode('68W')!.category,
        gate: MosRepository.byCode('68W')!.gate,
        description: own,
      );
      expect(MosDescriptions.forMos(entry), same(own));
      expect(
        MosDescriptions.forMos(entry)!.text,
        isNot(MosDescriptions.textFor('68W')),
        reason: 'the entry-specific sentence is what the sheet would print',
      );
    });
  });

  group('the text', () {
    test('no two codes share the same words', () {
      final firstByText = <String, String>{};
      final problems = <String>[];
      for (final MapEntry<String, SourcedText> entry in merged.entries) {
        final String text = entry.value.text.trim();
        final String? earlier = firstByText[text];
        if (earlier != null) {
          problems.add('${entry.key} repeats $earlier word for word');
        } else {
          firstByText[text] = entry.key;
        }
      }
      expect(
        problems,
        isEmpty,
        reason:
            'two code keys carrying one sentence means one of them is being '
            'told the wrong job: ${problems.join('; ')}',
      );
    });

    test('68W and 11B each describe their own job', () {
      final String? medic = MosDescriptions.textFor('68W');
      final String? infantry = MosDescriptions.textFor('11B');
      expect(medic, isNotNull);
      expect(infantry, isNotNull);
      expect(medic!.toLowerCase(), contains('medic'));
      expect(infantry!.toLowerCase(), contains('infantry'));
      expect(medic, isNot(infantry));
    });
  });
}
