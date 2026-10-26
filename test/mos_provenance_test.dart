/// Provenance for the plain-language prose about an MOS.
///
/// A description of a job is the one field in the catalogue that cannot be
/// checked against a number. "Airborne ISR systems" and "aviation sensor work"
/// are both true and they are different jobs, so the only thing that makes the
/// sentence safe to show is where it came from. This file enforces that
/// mechanically, over the whole roster, for [Mos.description] and
/// [Mos.civilianNote]: a dated https:// citation, a named kind of source, a
/// length a candidate will actually read, and wording that means a human wrote
/// it.
///
/// It is deliberately not a count. On the day this landed, 0 of 156 entries were
/// described, and the test passes on that number because an absent description is
/// honest and an invented one is not. What it refuses is a description that
/// arrives without its working - which is the only way this field can do harm.
/// The coverage line it prints is there so the number stops being invisible.
library;

import 'dart:io';

import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// The length a description may be, in characters. Short enough to be a
/// paragraph on a phone, long enough that it has to say something specific.
const int minDescriptionLength = 40;
const int maxDescriptionLength = 320;

/// Wording that means nobody wrote anything. Matched case-insensitively on word
/// boundaries so that "N/A" is caught while "National Guard" and "navigate" are
/// left alone.
final RegExp placeholderWords = RegExp(
  r'\b(?:todo|tbd|lorem)\b|\bn/?a\b',
  caseSensitive: false,
);

/// The five kinds of source the model recognises, as the brief names them. If a
/// kind is added or renamed, whatever labels it for the candidate has to change
/// with it, so the list is asserted rather than assumed.
const List<String> expectedSourceKinds = <String>[
  'pamphlet',
  'stp',
  'cool',
  'onet',
  'serviceSite',
];

String _day(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Everything wrong with one piece of sourced prose, prefixed by the rule it
/// broke. An empty list means it is safe to show.
///
/// Shared by the roster scan and by the self-check below, so the self-check is
/// evidence about the same rules the catalogue is held to rather than a second,
/// weaker copy of them.
List<String> provenanceProblems(String label, SourcedText? sourced) {
  if (sourced == null) return const <String>[];
  final problems = <String>[];

  // 1. A citation that can be opened.
  final url = sourced.sourceUrl.trim();
  if (url.isEmpty) {
    problems.add('$label: sourceUrl is empty, so nothing can be checked');
  } else if (!url.startsWith('https://') || url.length == 'https://'.length) {
    problems.add('$label: sourceUrl "$url" is not an https:// page');
  }

  // 2. A date that has already happened. retrievedOn is non-nullable in the
  // model, so "is there a date" is answered by the type; what is left to test is
  // whether the date is possible. Compared by day, because the field is a date:
  // writing today's date should not fail because the clock says 09:00.
  final now = DateTime.now();
  final retrieved = DateTime(
    sourced.retrievedOn.year,
    sourced.retrievedOn.month,
    sourced.retrievedOn.day,
  );
  final today = DateTime(now.year, now.month, now.day);
  if (retrieved.isAfter(today)) {
    problems.add(
      '$label: retrievedOn ${_day(sourced.retrievedOn)} is in the future '
      '(today is ${_day(now)})',
    );
  }

  // 3. A kind of source the model recognises.
  if (!MosSourceKind.values.contains(sourced.sourceKind)) {
    problems.add(
      '$label: sourceKind ${sourced.sourceKind} is not a known kind',
    );
  }

  // 4. A length a candidate will read on a phone.
  final text = sourced.text.trim();
  if (text.length < minDescriptionLength ||
      text.length > maxDescriptionLength) {
    problems.add(
      '$label: text is ${text.length} characters, outside the '
      '$minDescriptionLength-$maxDescriptionLength the app shows',
    );
  }

  // 5. No placeholder wording dressed up as a description.
  final placeholder = placeholderWords.firstMatch(sourced.text);
  if (placeholder != null) {
    problems.add(
      '$label: text contains the placeholder "${placeholder.group(0)}"',
    );
  }

  return problems;
}

void main() {
  final roster = MosRepository.all;

  /// Every slot the catalogue has for sourced prose, keyed by the label a
  /// failure message should use.
  final slots = <String, SourcedText?>{
    for (final m in roster) '${m.code} description': m.description,
    for (final m in roster) '${m.code} civilianNote': m.civilianNote,
  };

  group('catalogue provenance', () {
    test('the scan reaches every entry and both fields', () {
      // A provenance test that checks no values passes forever, so the scan
      // itself is asserted: every entry has both slots.
      expect(roster, isNotEmpty);
      expect(
        slots,
        hasLength(roster.length * 2),
        reason: 'every entry has a description slot and a civilian-note slot',
      );
    });

    test('every sourced text is dated, https, its own words and readable', () {
      final problems = <String>[];
      for (final entry in slots.entries) {
        problems.addAll(provenanceProblems(entry.key, entry.value));
      }
      expect(
        problems,
        isEmpty,
        reason:
            'a description without a dated https citation is a guess shown as a '
            'fact:\n  ${problems.join('\n  ')}',
      );
    });

    test('the model still names the five kinds of source', () {
      expect(
        MosSourceKind.values.map((k) => k.name).toList(),
        expectedSourceKinds,
      );
    });

    test('the coverage line counts described against undescribed', () {
      final described = roster.where((m) => m.description != null).length;
      final noted = roster.where((m) => m.civilianNote != null).length;
      final undescribed = roster.length - described;
      final percent = roster.isEmpty
          ? '0'
          : '${100 * described ~/ roster.length}';

      // Printed, not asserted: the number is the honest progress of the data
      // pass and belongs in the CI log where it can be watched go up. Asserting
      // it could only fail the data work it is meant to invite.
      stdout.writeln(
        'MOS provenance coverage: ${roster.length} entries, '
        '$described described ($percent%), '
        '$noted with a civilian note, '
        '$undescribed without a description',
      );

      expect(described + undescribed, roster.length);
      expect(described, inInclusiveRange(0, roster.length));
      expect(noted, inInclusiveRange(0, roster.length));
    });
  });

  group('the rules bite', () {
    // The roster carries no descriptions yet, so the scan above cannot fail on
    // its own. These cases are what makes that pass mean something: each hands
    // the same checker a value a data pass could plausibly produce and requires
    // it to be rejected for the right reason. None of this text describes any
    // MOS - it is bait.
    final today = DateTime.now();
    final good = SourcedText(
      text:
          'Drives heavy trucks over highways, unimproved roads and blackout '
          'routes as part of a convoy.',
      sourceUrl: 'https://www.goarmy.com/careers-and-jobs.html',
      retrievedOn: DateTime(today.year, today.month, today.day),
      sourceKind: MosSourceKind.serviceSite,
    );

    SourcedText variant({
      String? text,
      String? sourceUrl,
      DateTime? retrievedOn,
      MosSourceKind? sourceKind,
    }) => SourcedText(
      text: text ?? good.text,
      sourceUrl: sourceUrl ?? good.sourceUrl,
      retrievedOn: retrievedOn ?? good.retrievedOn,
      sourceKind: sourceKind ?? good.sourceKind,
    );

    test('a properly cited description passes', () {
      expect(provenanceProblems('88M description', good), isEmpty);
    });

    final cases = <({String what, SourcedText value, String fragment})>[
      (
        what: 'a plain-http citation',
        value: variant(sourceUrl: 'http://www.goarmy.com/careers.html'),
        fragment: 'is not an https:// page',
      ),
      (
        what: 'a URL with no scheme at all',
        value: variant(sourceUrl: 'nationalguard.com/mos-jobs'),
        fragment: 'is not an https:// page',
      ),
      (
        what: 'an empty citation',
        value: variant(sourceUrl: '   '),
        fragment: 'sourceUrl is empty',
      ),
      (
        what: 'a retrieval date in the future',
        value: variant(retrievedOn: today.add(const Duration(days: 2))),
        fragment: 'is in the future',
      ),
      (
        what: 'a text too short to say anything',
        value: variant(text: 'Drives trucks.'),
        fragment: 'characters',
      ),
      (
        what: 'a text too long for a phone',
        value: variant(
          text: List<String>.filled(
            20,
            'Drives the Army heavy truck over the roads in a convoy. ',
          ).join(),
        ),
        fragment: 'characters',
      ),
      (
        what: 'a TODO left in place',
        value: variant(
          text: 'TODO: transcribe the duty description from the pamphlet here.',
        ),
        fragment: 'placeholder',
      ),
      (
        what: 'a TBD left in place',
        value: variant(
          text: 'Duty description TBD once the proponent page is reachable ok.',
        ),
        fragment: 'placeholder',
      ),
      (
        what: 'an N/A left in place',
        value: variant(
          text:
              'N/A - no plain-language description has been written yet here.',
        ),
        fragment: 'placeholder',
      ),
      (
        what: 'lorem ipsum filling the space',
        value: variant(
          text:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do.',
        ),
        fragment: 'placeholder',
      ),
    ];

    for (final c in cases) {
      test('rejects ${c.what}', () {
        final problems = provenanceProblems('test description', c.value);
        expect(
          problems,
          isNotEmpty,
          reason:
              'accepted ${c.what}, so the roster scan above is not protecting '
              'anything',
        );
        expect(
          problems.join(' | '),
          contains(c.fragment),
          reason: '${c.what} was rejected for the wrong reason: $problems',
        );
      });
    }

    test('an absent description is absent, not broken', () {
      // The honest starting point: no entry is described yet, and that is a
      // pass. Only a description that exists has to prove itself.
      expect(provenanceProblems('11B description', null), isEmpty);
    });
  });
}
