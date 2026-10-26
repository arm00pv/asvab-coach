/// Provenance and coverage for slice 2 of the MOS duty descriptions.
///
/// The map under test is lib/data/repos/mos_description_slice_2.dart: 39 codes,
/// indices 39..77 of the roster sorted alphabetically. This file holds every
/// entry in it to the same rules the catalogue-wide provenance test holds
/// [Mos.description] to - a dated https:// citation, a kind of source, a length
/// a candidate reads on a phone, no placeholder wording - and adds the two
/// checks a slice needs on its own: the keys must be inside the slice the
/// roster arithmetic produces, and no two entries may share a sentence, because
/// a template filled in per code is not a description of that code.
///
/// It is deliberately not a count. An omitted code passes: a missing
/// description renders as nothing, which is honest, and an invented one is the
/// failure this whole provenance design exists to prevent. The coverage line it
/// prints names the omissions so the number stops being invisible.
library;

import 'dart:io';

import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/repos/mos_description_slice_2.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// The index range this slice owns in the alphabetically sorted roster:
/// indices 39..77 inclusive, which is 39 codes.
const int sliceFirstIndex = 39;
const int sliceLastIndex = 77;

/// The length a description may be, in characters, matching the catalogue rule.
const int minDescriptionLength = 40;
const int maxDescriptionLength = 320;

/// The day every entry in this slice was read. Written as a literal here, not
/// imported from the data file, so that a wrong date in the data file fails
/// rather than agreeing with itself.
final DateTime expectedRetrievedOn = DateTime(2026, 10, 26);

/// Wording that means nobody wrote anything, matched on word boundaries so that
/// "National Guard" and "navigate" are left alone.
final RegExp placeholderWords = RegExp(
  r'\b(?:todo|tbd|lorem)\b|\bn/?a\b',
  caseSensitive: false,
);

/// The kinds of source a description in this slice may claim.
const List<MosSourceKind> allowedKinds = <MosSourceKind>[
  MosSourceKind.pamphlet,
  MosSourceKind.stp,
  MosSourceKind.cool,
  MosSourceKind.serviceSite,
];

String _day(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

void main() {
  final roster = MosRepository.all;

  /// The slice, computed from the roster rather than transcribed: the roster
  /// sorted by code, indices 39..77. Recomputing it here is what proves this
  /// slice does not overlap a neighbouring one.
  final sortedCodes = roster.map((m) => m.code).toList()..sort();
  final slice = sortedCodes.sublist(sliceFirstIndex, sliceLastIndex + 1);
  final rosterCodes = roster.map((m) => m.code).toSet();

  group('slice 2 describes only its own codes', () {
    test('the roster still has the 156 codes the slice was cut from', () {
      expect(
        roster,
        hasLength(156),
        reason:
            'the slice indices were computed against 156 codes; a shorter '
            'roster would silently shift every slice',
      );
    });

    test('every key is inside indices 39..77 of the sorted roster', () {
      final strays = <String>[
        for (final code in mosDescriptionSlice2.keys)
          if (!slice.contains(code)) code,
      ];
      expect(
        strays,
        isEmpty,
        reason:
            'these codes are outside slice 2 and belong to another worker: '
            '${strays.join(', ')}',
      );
    });

    test('every key is a code the roster actually carries', () {
      final unknown = <String>[
        for (final code in mosDescriptionSlice2.keys)
          if (!rosterCodes.contains(code)) code,
      ];
      expect(
        unknown,
        isEmpty,
        reason:
            'not in the roster, so nothing can be shown for them: '
            '${unknown.join(', ')}',
      );
    });
  });

  group('every description carries its working', () {
    test('text is readable, written and its own words', () {
      final problems = <String>[];
      for (final entry in mosDescriptionSlice2.entries) {
        final sourced = entry.value;
        final text = sourced.text.trim();
        if (text.length < minDescriptionLength ||
            text.length > maxDescriptionLength) {
          problems.add(
            '${entry.key}: text is ${text.length} characters, outside the '
            '$minDescriptionLength-$maxDescriptionLength the app shows',
          );
        }
        final placeholder = placeholderWords.firstMatch(sourced.text);
        if (placeholder != null) {
          problems.add(
            '${entry.key}: text contains the placeholder '
            '"${placeholder.group(0)}"',
          );
        }
      }
      expect(
        problems,
        isEmpty,
        reason:
            'a description a candidate cannot read is not one they were shown:'
            '\n  ${problems.join('\n  ')}',
      );
    });

    test('every entry cites an https:// page, a kind and the same date', () {
      final problems = <String>[];
      for (final entry in mosDescriptionSlice2.entries) {
        final sourced = entry.value;
        final url = sourced.sourceUrl.trim();
        if (!url.startsWith('https://') || url.length == 'https://'.length) {
          problems.add(
            '${entry.key}: sourceUrl "$url" is not an https:// page',
          );
        }
        if (!allowedKinds.contains(sourced.sourceKind)) {
          problems.add(
            '${entry.key}: sourceKind ${sourced.sourceKind} is not one of the '
            'kinds a description in this slice may claim',
          );
        }
        final retrieved = DateTime(
          sourced.retrievedOn.year,
          sourced.retrievedOn.month,
          sourced.retrievedOn.day,
        );
        if (retrieved != expectedRetrievedOn) {
          problems.add(
            '${entry.key}: retrievedOn ${_day(sourced.retrievedOn)} is not the '
            '${_day(expectedRetrievedOn)} these pages were read',
          );
        }
      }
      expect(
        problems,
        isEmpty,
        reason:
            'a description without a dated https citation is a guess shown as a '
            'fact:\n  ${problems.join('\n  ')}',
      );
    });

    test('no two entries share the same sentence', () {
      // A per-code template filled in from one paragraph would pass every other
      // rule here and still tell a candidate nothing about the job in front of
      // them, so identical prose is a failure rather than a tidy-up.
      final byText = <String, List<String>>{};
      for (final entry in mosDescriptionSlice2.entries) {
        byText
            .putIfAbsent(entry.value.text.trim(), () => <String>[])
            .add(entry.key);
      }
      final shared = <String>[
        for (final pair in byText.entries)
          if (pair.value.length > 1) pair.value.join(' == '),
      ];
      expect(
        shared,
        isEmpty,
        reason:
            'these codes were given the same description: '
            '${shared.join('; ')}',
      );
    });
  });

  test('the coverage line counts described against omitted', () {
    final described = slice.where(mosDescriptionSlice2.containsKey).toList();
    final omitted = slice
        .where((code) => !mosDescriptionSlice2.containsKey(code))
        .toList();

    // Printed, not asserted: the number is the honest progress of the data pass.
    // An omitted code is a pass, and the line names it so the gap is visible.
    stdout.writeln(
      'MOS description slice 2 coverage: ${slice.length} codes '
      '(${slice.first}..${slice.last}), '
      '${described.length} described, ${omitted.length} omitted'
      '${omitted.isEmpty ? '' : ' (${omitted.join(', ')})'}',
    );

    expect(
      described.length + omitted.length,
      slice.length,
      reason: 'every code in the slice is either described or counted missing',
    );
    expect(
      mosDescriptionSlice2,
      hasLength(described.length),
      reason: 'the map holds no code that is not in the slice',
    );
  });
}
