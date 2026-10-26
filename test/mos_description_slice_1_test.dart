/// Provenance and shape of the slice 1 duty descriptions.
///
/// `lib/data/repos/mos_description_slice_1.dart` is one worker's share of the
/// roster, so the things that can go wrong are specific: a code that is not a
/// real MOS, a sentence that drifted out of the length the app shows, a citation
/// that cannot be opened, an entry with no date or no kind, or two entries
/// carrying the same words because one was pasted twice.
///
/// This file holds every entry in that map to the rules, and prints the coverage
/// line - how many codes the slice owns, how many are described, how many are
/// omitted - because an omitted code is the honest outcome when no description
/// could be sourced, and the number should be visible in the log rather than
/// inferred from silence.
///
/// It does not assert a coverage count: a slice that describes 39 codes and one
/// that describes 31 are both passes, and pinning the number would only fail the
/// data work it is meant to invite. What it refuses is a description that arrives
/// without its working.
library;

import 'dart:io';

import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/repos/mos_description_slice_1.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// The slice as assigned, in the order it was computed: the 156 roster codes
/// sorted alphabetically, indices 0..38 inclusive.
///
/// Written out rather than recomputed so that a code silently disappearing from
/// either the roster or the map shows up as a mismatch instead of shrinking the
/// denominator.
const List<String> sliceOneCodes = <String>[
  '08H', '11B', '11C', '12B', '12C', '12D', '12G', '12H', '12K', '12M', //
  '12N', '12P', '12Q', '12R', '12T', '12W', '12Y', '13B', '13F', '13J', //
  '13M', '13R', '14E', '14G', '14H', '14P', '14T', '15B', '15C', '15D', //
  '15E', '15F', '15G', '15H', '15M', '15N', '15P', '15Q', '15R', //
];

/// The length a description may be, in characters - the same window
/// `test/mos_provenance_test.dart` holds the roster to.
const int minDescriptionLength = 40;
const int maxDescriptionLength = 320;

/// Wording that means nobody wrote anything. Matched case-insensitively on word
/// boundaries, so "N/A" is caught while "National Guard" is not.
final RegExp placeholderWords = RegExp(
  r'\b(?:todo|tbd|lorem)\b|\bn/?a\b',
  caseSensitive: false,
);

/// The day the pass was made. Every entry in this slice shares it: one reading of
/// one document on one day.
final DateTime expectedRetrievedOn = DateTime(2026, 10, 26);

/// The kinds a description in this slice may claim. The citation is the pamphlet
/// chapter, so anything else means an entry was sourced somewhere else without
/// saying so.
const Set<MosSourceKind> allowedKinds = <MosSourceKind>{
  MosSourceKind.pamphlet,
  MosSourceKind.stp,
  MosSourceKind.cool,
  MosSourceKind.serviceSite,
};

String _day(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

void main() {
  final Map<String, SourcedText> slice = mosDescriptionSlice1;
  final Set<String> rosterCodes = <String>{
    for (final Mos m in MosRepository.all) m.code,
  };

  group('slice 1 is the assignment', () {
    test('the slice carries no code it was not assigned', () {
      final extras = slice.keys.where((k) => !sliceOneCodes.contains(k));
      expect(
        extras,
        isEmpty,
        reason:
            'these codes are outside indices 0..38 and belong to another '
            'slice: ${extras.join(', ')}',
      );
    });

    test('every assigned code is either described or reported as omitted', () {
      // A key that is absent is an omission, and an omission is allowed. A key
      // that is present but not assigned is not - that is the collision this
      // whole one-file-per-slice arrangement exists to prevent. So the only
      // thing asserted about coverage is that it is a subset, and the count is
      // printed by the coverage test below.
      expect(slice.keys, everyElement(isIn(sliceOneCodes)));
      expect(sliceOneCodes.toSet(), hasLength(sliceOneCodes.length));
    });

    test('every described code exists in the roster', () {
      final unknown = slice.keys
          .where((k) => !rosterCodes.contains(k))
          .toList();
      expect(
        unknown,
        isEmpty,
        reason:
            'a description keyed to a code the catalogue does not carry can '
            'never be shown to anyone: ${unknown.join(', ')}',
      );
    });
  });

  group('every entry is sourced, dated, https and its own words', () {
    test('there is something to check', () {
      // A provenance test over an empty map passes forever, so the scan itself is
      // asserted.
      expect(slice, isNotEmpty);
    });

    test('the text is a length a candidate will read on a phone', () {
      final problems = <String>[];
      for (final MapEntry<String, SourcedText> e in slice.entries) {
        final String text = e.value.text.trim();
        if (text.length < minDescriptionLength ||
            text.length > maxDescriptionLength) {
          problems.add(
            '${e.key}: ${text.length} characters, outside the '
            '$minDescriptionLength-$maxDescriptionLength the app shows',
          );
        }
      }
      expect(problems, isEmpty, reason: problems.join('\n  '));
    });

    test('no entry is a placeholder dressed up as a description', () {
      final problems = <String>[];
      for (final MapEntry<String, SourcedText> e in slice.entries) {
        final RegExpMatch? hit = placeholderWords.firstMatch(e.value.text);
        if (hit != null) {
          problems.add('${e.key}: contains "${hit.group(0)}"');
        }
      }
      expect(problems, isEmpty, reason: problems.join('\n  '));
    });

    test('every citation is an https:// page that can be opened', () {
      final problems = <String>[];
      for (final MapEntry<String, SourcedText> e in slice.entries) {
        final String url = e.value.sourceUrl.trim();
        if (!url.startsWith('https://') || url == 'https://') {
          problems.add('${e.key}: sourceUrl "$url" is not an https:// page');
        }
      }
      expect(problems, isEmpty, reason: problems.join('\n  '));
    });

    test('every entry is dated the day the pass was made', () {
      final problems = <String>[];
      for (final MapEntry<String, SourcedText> e in slice.entries) {
        final DateTime got = e.value.retrievedOn;
        if (got.year != expectedRetrievedOn.year ||
            got.month != expectedRetrievedOn.month ||
            got.day != expectedRetrievedOn.day) {
          problems.add(
            '${e.key}: retrievedOn ${_day(got)}, '
            'expected ${_day(expectedRetrievedOn)}',
          );
        }
      }
      expect(problems, isEmpty, reason: problems.join('\n  '));
    });

    test('every entry names a kind of source the app recognises', () {
      final problems = <String>[];
      for (final MapEntry<String, SourcedText> e in slice.entries) {
        final MosSourceKind kind = e.value.sourceKind;
        if (!allowedKinds.contains(kind)) {
          problems.add('${e.key}: sourceKind ${kind.name} is not allowed here');
        }
        // This slice is read out of one document, so every entry says so. A value
        // that claimed "cool" while citing the pamphlet chapter would be a
        // description whose own citation lies about what it is.
        if (kind != MosSourceKind.pamphlet) {
          problems.add(
            '${e.key}: sourceKind ${kind.name}, but the citation is the '
            'pamphlet chapter',
          );
        }
      }
      expect(problems, isEmpty, reason: problems.join('\n  '));
    });

    test('no two entries carry the same words', () {
      final Map<String, String> firstByText = <String, String>{};
      final problems = <String>[];
      for (final MapEntry<String, SourcedText> e in slice.entries) {
        final String text = e.value.text.trim();
        final String? earlier = firstByText[text];
        if (earlier != null) {
          problems.add('${e.key} repeats $earlier word for word');
        } else {
          firstByText[text] = e.key;
        }
      }
      expect(problems, isEmpty, reason: problems.join('\n  '));
    });
  });

  test('the coverage line counts described against omitted', () {
    final int owned = sliceOneCodes.length;
    final int described = sliceOneCodes.where(slice.containsKey).length;
    final List<String> omitted = sliceOneCodes
        .where((k) => !slice.containsKey(k))
        .toList();
    final int percent = owned == 0 ? 0 : 100 * described ~/ owned;

    // Printed, not asserted: what is left undescribed is a fact about the source
    // material, not a defect in the code.
    stdout.writeln(
      'MOS description slice 1 coverage: $owned codes assigned, '
      '$described described ($percent%), '
      '${omitted.length} omitted'
      '${omitted.isEmpty ? '' : ': ${omitted.join(', ')}'}',
    );

    expect(described + omitted.length, owned);
    expect(described, inInclusiveRange(0, owned));
    expect(slice, hasLength(described));
  });
}
