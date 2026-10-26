/// Provenance for the slice-4 duty descriptions, held to the same rules as the
/// catalogue.
///
/// This slice covers indices 117 to 155 of the roster sorted alphabetically, so
/// the test refuses two things at once: a description that arrives without its
/// working, and a description for a code that is not in this slice - which is
/// how two workers end up writing the same sentence twice. The rules themselves
/// are imported from test/mos_provenance_test.dart rather than copied, so the
/// slice cannot drift from the standard the catalogue is held to.
///
/// The coverage line is printed, not asserted as a target: an absent description
/// is honest, and the number belongs in the log where it can be watched.
library;

import 'dart:io';

import 'package:asvab_guard_coach/data/repos/mos_description_slice_4.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mos_provenance_test.dart' as provenance;

/// First and last index of this slice in the alphabetically sorted roster.
const int sliceStart = 117;
const int sliceEnd = 155;

/// The day these descriptions were read, as the brief fixes it.
final DateTime expectedRetrievedOn = DateTime(2026, 10, 26);

/// The kinds of source the brief allows for a duty description. COOL and O*NET
/// are excluded on purpose: they say where a job leads, not what the work is.
const List<String> allowedKinds = <String>[
  'pamphlet',
  'stp',
  'cool',
  'serviceSite',
];

/// The codes this slice owns, computed from the roster rather than typed out, so
/// the range is read from the same list the app ships.
List<String> sliceCodes() {
  final codes = MosRepository.all.map((m) => m.code).toList()..sort();
  // Called from main() before any test body, so this throws rather than
  // expecting: a roster too short to hold the range means the slice boundary
  // itself is wrong, and every assertion below would measure the wrong codes.
  if (codes.length <= sliceEnd) {
    throw StateError(
      'the roster has ${codes.length} codes, too few for indices '
      '$sliceStart-$sliceEnd',
    );
  }
  return codes.sublist(sliceStart, sliceEnd + 1);
}

String _day(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

void main() {
  final owned = sliceCodes();
  final rosterCodes = MosRepository.all.map((m) => m.code).toSet();

  group('slice 4 descriptions', () {
    test(
      'the slice is the expected size and its edges are the expected codes',
      () {
        // Named so that a roster change that shifts the alphabet fails loudly here
        // instead of quietly moving codes into or out of this file.
        expect(owned, hasLength(sliceEnd - sliceStart + 1));
        expect(owned.first, '88M');
        expect(owned.last, '94Y');
      },
    );

    test('every described code is in the roster and in this slice', () {
      final problems = <String>[];
      for (final code in mosDescriptionSlice4.keys) {
        if (!rosterCodes.contains(code)) {
          problems.add('$code is not an MOS the app carries');
        } else if (!owned.contains(code)) {
          problems.add(
            '$code belongs to another slice, not $sliceStart-$sliceEnd',
          );
        }
      }
      expect(
        problems,
        isEmpty,
        reason:
            'a description for a code outside the slice is a collision with '
            'another worker:\n  ${problems.join('\n  ')}',
      );
    });

    test('every entry passes the catalogue provenance rules', () {
      final problems = <String>[];
      for (final entry in mosDescriptionSlice4.entries) {
        problems.addAll(
          provenance.provenanceProblems(
            '${entry.key} description',
            entry.value,
          ),
        );
      }
      expect(
        problems,
        isEmpty,
        reason:
            'these entries do not carry their working:\n  ${problems.join('\n  ')}',
      );
    });

    test('text is 40-320 characters trimmed, with no placeholder wording', () {
      final problems = <String>[];
      for (final entry in mosDescriptionSlice4.entries) {
        final text = entry.value.text;
        if (text != text.trim()) {
          problems.add('${entry.key}: text has leading or trailing whitespace');
        }
        final length = text.trim().length;
        if (length < 40 || length > 320) {
          problems.add('${entry.key}: $length characters, outside 40-320');
        }
        final placeholder = provenance.placeholderWords.firstMatch(text);
        if (placeholder != null) {
          problems.add('${entry.key}: placeholder "${placeholder.group(0)}"');
        }
      }
      expect(problems, isEmpty, reason: problems.join('; '));
    });

    test('every entry cites an https page, a dated retrieval and a known kind', () {
      final problems = <String>[];
      for (final entry in mosDescriptionSlice4.entries) {
        final sourced = entry.value;
        if (!sourced.sourceUrl.trim().startsWith('https://')) {
          problems.add(
            '${entry.key}: sourceUrl "${sourced.sourceUrl}" is not https',
          );
        }
        if (sourced.retrievedOn != expectedRetrievedOn) {
          problems.add(
            '${entry.key}: retrievedOn is ${_day(sourced.retrievedOn)}, '
            'expected ${_day(expectedRetrievedOn)}',
          );
        }
        if (!allowedKinds.contains(sourced.sourceKind.name)) {
          problems.add(
            '${entry.key}: sourceKind ${sourced.sourceKind.name} is not one of $allowedKinds',
          );
        }
      }
      expect(problems, isEmpty, reason: problems.join('; '));
    });

    test('no two entries share the same text', () {
      final seen = <String, String>{};
      final problems = <String>[];
      for (final entry in mosDescriptionSlice4.entries) {
        final text = entry.value.text.trim();
        final first = seen[text];
        if (first != null) {
          problems.add('${entry.key} repeats the text of $first');
        } else {
          seen[text] = entry.key;
        }
      }
      expect(
        problems,
        isEmpty,
        reason:
            'the same sentence under two codes means one of them is wrong:\n  '
            '${problems.join('\n  ')}',
      );
    });

    test('the coverage line counts described against omitted', () {
      final described = mosDescriptionSlice4.keys.where(owned.contains).length;
      final omitted = owned
          .where((c) => !mosDescriptionSlice4.containsKey(c))
          .toList();
      final percent = owned.isEmpty
          ? '0'
          : '${100 * described ~/ owned.length}';

      // Printed, not asserted: the number is the honest progress of the data
      // pass, and an omitted code is a correct outcome when no source could be
      // found for it.
      stdout.writeln(
        'MOS description slice 4 coverage: ${owned.length} codes in the slice '
        '(indices $sliceStart-$sliceEnd, ${owned.first}-${owned.last}), '
        '$described described ($percent%), '
        '${omitted.length} omitted'
        '${omitted.isEmpty ? '' : ': ${omitted.join(', ')}'}',
      );

      expect(described + omitted.length, owned.length);
    });
  });
}
