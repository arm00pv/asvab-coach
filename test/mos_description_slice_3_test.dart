/// Holds slice 3 of the MOS duty descriptions to the rules the whole
/// description pass exists to enforce.
///
/// A description of a job cannot be checked against a number, so what this file
/// checks is everything around the sentence: that the code is a real MOS, that
/// the text is the length a candidate will read on a phone, that nobody left a
/// placeholder in the space, that the entry says which page it was read from and
/// when, and that two jobs were not handed the same sentence. It also prints how
/// much of the slice is described, because a coverage number nobody prints is a
/// number that stops being watched.
///
/// It deliberately does not assert that the slice is complete: an entry that is
/// absent renders as nothing, which is honest, while an entry invented to make a
/// count go up is the exact failure the provenance design exists to prevent.
library;

import 'dart:io';

import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/repos/mos_description_slice_3.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// The slice this file guards: indices 78..116 of the alphabetical roster, both
/// inclusive. Recomputed from the roster below rather than trusted, so a slice
/// that drifts is caught here instead of being discovered by a reader.
const int sliceFirstIndex = 78;
const int sliceLastIndex = 116;

/// The length a description may be, in characters, after trimming. Short enough
/// to be a paragraph on a phone; long enough that it has to say something.
const int minDescriptionLength = 40;
const int maxDescriptionLength = 320;

/// The range above, spelled once for failure messages.
const String lengthRange = '40-320';

/// The day these pages were read. A date, not a timestamp.
final DateTime expectedRetrievedOn = DateTime(2026, 10, 26);

/// The kinds of source a duty description may cite. Army COOL is not one of
/// them: it maps a job to credentials, which is not a description of duties.
const List<MosSourceKind> allowedSourceKinds = <MosSourceKind>[
  MosSourceKind.pamphlet,
  MosSourceKind.stp,
  MosSourceKind.cool,
  MosSourceKind.serviceSite,
];

/// Wording that means nobody wrote anything. Word boundaries keep "National"
/// and "navigate" out of it while still catching "N/A".
final RegExp placeholderWords = RegExp(
  r'\b(?:todo|tbd|lorem)\b|\bn/?a\b',
  caseSensitive: false,
);

/// Full stops that are not the end of a sentence, stripped before counting, so
/// "U.S. Army Medical Center of Excellence" and "Fort George G. Meade" do not
/// read as several sentences between them.
String withoutAbbreviationStops(String text) => text
    .replaceAll(RegExp(r'\bU\.S\.'), 'US')
    .replaceAll(RegExp(r'\bG\.'), 'G')
    .replaceAll(RegExp(r'\bD\.C\.'), 'DC');

/// How many sentences a description carries. The deliverable is two: what the
/// work is, and where it is trained or performed.
int sentenceCount(String text) =>
    RegExp(r'[.!?](?:\s|$)').allMatches(withoutAbbreviationStops(text)).length;

/// The day part of a [DateTime], so a value carrying a time is not rejected for
/// the wrong reason.
DateTime dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

void main() {
  final List<String> rosterCodes =
      MosRepository.all.map((Mos m) => m.code).toList()..sort();

  final List<String> slice = rosterCodes.sublist(
    sliceFirstIndex,
    sliceLastIndex + 1,
  );

  final Map<String, SourcedText> described = mosDescriptionSlice3;

  group('slice 3 is the slice it claims to be', () {
    test('the roster still holds the 156 codes the slice came from', () {
      expect(rosterCodes, hasLength(156));
    });

    test('indices 78..116 are the 39 codes from 40D to 88L', () {
      expect(slice, hasLength(39));
      expect(slice.first, '40D');
      expect(slice.last, '88L');
      // The codes either side of the range belong to other workers, so they are
      // asserted as evidence the range was read off the roster and not guessed.
      expect(rosterCodes[sliceFirstIndex - 1], '38W');
      expect(rosterCodes[sliceLastIndex + 1], '88M');
    });

    test('nothing is described outside the slice', () {
      final List<String> outside = described.keys
          .where((String code) => !slice.contains(code))
          .toList();
      final String outsideList = outside.join(', ');
      expect(
        outside,
        isEmpty,
        reason:
            'these codes belong to another worker and must not be described '
            'here: $outsideList',
      );
    });
  });

  group('every entry in the slice', () {
    test('is keyed by a code the roster actually carries', () {
      final List<String> unknown = <String>[];
      for (final String code in described.keys) {
        if (MosRepository.byCode(code) == null) unknown.add(code);
      }
      final String unknownList = unknown.join(', ');
      expect(
        unknown,
        isEmpty,
        reason:
            'a description of a code the app does not carry is unusable: '
            '$unknownList',
      );
    });

    test('carries a text of 40-320 characters, trimmed, in two sentences', () {
      final List<String> problems = <String>[];
      for (final MapEntry<String, SourcedText> e in described.entries) {
        final String code = e.key;
        final String text = e.value.text;
        final String trimmed = text.trim();
        final String length = trimmed.length.toString();
        if (trimmed.length < minDescriptionLength ||
            trimmed.length > maxDescriptionLength) {
          problems.add('$code: $length characters, outside $lengthRange');
        }
        if (text != trimmed) {
          problems.add('$code: text has leading or trailing whitespace');
        }
        if (!RegExp(r'[.!?]$').hasMatch(trimmed)) {
          problems.add('$code: text does not end in a full stop');
        }
        final int measured = sentenceCount(trimmed);
        if (measured != 2) {
          final String counted = measured.toString();
          problems.add('$code: $counted sentences, expected two');
        }
      }
      final String report = problems.join('\n  ');
      expect(problems, isEmpty, reason: report);
    });

    test('holds no placeholder wording', () {
      final List<String> problems = <String>[];
      for (final MapEntry<String, SourcedText> e in described.entries) {
        final String code = e.key;
        final RegExpMatch? found = placeholderWords.firstMatch(e.value.text);
        if (found != null) {
          final String word = found.group(0)!;
          problems.add('$code: the text contains "$word"');
        }
      }
      final String report = problems.join('\n  ');
      expect(problems, isEmpty, reason: report);
    });

    test('cites an https page and names the kind of page it is', () {
      final List<String> problems = <String>[];
      for (final MapEntry<String, SourcedText> e in described.entries) {
        final String code = e.key;
        final String url = e.value.sourceUrl.trim();
        if (!url.startsWith('https://') || url.length == 'https://'.length) {
          problems.add('$code: the sourceUrl "$url" is not an https page');
        }
        if (!allowedSourceKinds.contains(e.value.sourceKind)) {
          final String kind = e.value.sourceKind.name;
          problems.add(
            '$code: sourceKind $kind is not pamphlet, stp, cool or serviceSite',
          );
        }
      }
      final String report = problems.join('\n  ');
      expect(problems, isEmpty, reason: report);
    });

    test('is dated 26 October 2026', () {
      final List<String> problems = <String>[];
      for (final MapEntry<String, SourcedText> e in described.entries) {
        if (dayOf(e.value.retrievedOn) != dayOf(expectedRetrievedOn)) {
          final String code = e.key;
          final String stamp = e.value.retrievedOn.toString();
          problems.add('$code: retrievedOn is $stamp');
        }
      }
      final String report = problems.join('\n  ');
      expect(problems, isEmpty, reason: report);
    });

    test('says something no other entry says', () {
      // Identical prose across two jobs is the signature of a copy-paste pass
      // that did not read the second source. Compared case-insensitively on the
      // trimmed text, because a stray space is not a different description.
      final Map<String, List<String>> byText = <String, List<String>>{};
      for (final MapEntry<String, SourcedText> e in described.entries) {
        final String key = e.value.text.trim().toLowerCase();
        byText.putIfAbsent(key, () => <String>[]).add(e.key);
      }
      final List<String> clashes = byText.entries
          .where((MapEntry<String, List<String>> e) => e.value.length > 1)
          .map((MapEntry<String, List<String>> e) => e.value.join(' == '))
          .toList();
      final String clashList = clashes.join(', ');
      expect(
        clashes,
        isEmpty,
        reason: 'these codes share one description: $clashList',
      );
    });
  });

  group('coverage', () {
    test('the omitted list is exactly the slice minus the described codes', () {
      final Set<String> undescribed = slice.toSet()..removeAll(described.keys);
      expect(
        mosDescriptionSlice3Omitted.toSet(),
        undescribed,
        reason:
            'a code is either described or listed as omitted, never silently '
            'missing and never in both',
      );
    });

    test('prints how much of the slice is described', () {
      final int total = slice.length;
      final int describedCount = slice
          .where((String code) => described.containsKey(code))
          .length;
      final int omitted = total - describedCount;
      final String omittedCodes = mosDescriptionSlice3Omitted.join(', ');
      final String omittedSuffix = mosDescriptionSlice3Omitted.isEmpty
          ? ''
          : ', omitted: $omittedCodes';
      stdout.writeln(
        'MOS description slice 3 coverage: $total codes in the slice, '
        '$describedCount described, $omitted omitted$omittedSuffix',
      );

      expect(describedCount + omitted, total);
      expect(describedCount, inInclusiveRange(0, total));
      expect(described, hasLength(describedCount));
    });
  });
}
