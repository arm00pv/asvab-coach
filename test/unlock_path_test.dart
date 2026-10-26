import 'package:asvab_guard_coach/data/models/line_score.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/engines/unlock_path.dart';
import 'package:flutter_test/flutter_test.dart';

/// The catalogue's compact gate grammar, re-implemented here on purpose:
/// '|' separates OR alternatives, '&' ANDs requirements inside one, and every
/// requirement is 'ABBR MIN', exactly as the MOS data file writes them.
///
/// The engine must not depend on the catalogue's data or its parser, and nor
/// may this test, so the roster can be rewritten underneath both without
/// breaking either.
AptitudeGate gateOf(String spec) {
  if (spec.trim().isEmpty) {
    return const AptitudeGate(<List<LineScoreRequirement>>[]);
  }
  return AptitudeGate(<List<LineScoreRequirement>>[
    for (final alternative in spec.split('|'))
      <LineScoreRequirement>[
        for (final part in alternative.split('&')) _requirement(part.trim()),
      ],
  ]);
}

LineScoreRequirement _requirement(String part) {
  final bits = part.split(' ');
  expect(bits.length, 2, reason: 'gate row "$part" is not "ABBR MIN"');
  return LineScoreRequirement(_lineScore(bits[0]), int.parse(bits[1]));
}

LineScore _lineScore(String abbr) =>
    LineScore.values.firstWhere((score) => score.abbr == abbr.toUpperCase());

/// A score sheet written the way the app reports it: area abbreviation to score.
/// Anything left out is simply not on record.
Map<LineScore, int> sheetOf(Map<String, int> byAbbr) => <LineScore, int>{
  for (final entry in byAbbr.entries) _lineScore(entry.key): entry.value,
};

/// An MOS with an empty gate: either "no requirement published" or "not on
/// record", depending on whether something explains the absence.
Mos mosOf({
  String code = '99X',
  String title = 'Test MOS',
  String category = 'Combat Arms',
  AptitudeGate? gate,
  String? note,
  String? extraTest,
  bool securityClearance = false,
  int? asvabMinimum,
}) => Mos(
  code: code,
  title: title,
  category: category,
  gate: gate ?? const AptitudeGate(<List<LineScoreRequirement>>[]),
  note: note,
  extraTest: extraTest,
  securityClearance: securityClearance,
  asvabMinimum: asvabMinimum,
);

void main() {
  group('already qualified', () {
    test('a gate the candidate meets returns no routes and says nothing is '
        'short', () {
      final path = UnlockPathEngine.forGate(
        mosCode: '13B',
        gate: gateOf('GT 87'),
        lineScores: sheetOf(<String, int>{'GT': 92}),
      );

      expect(path.status, UnlockStatus.alreadyQualified);
      expect(path.qualified, isTrue);
      expect(path.gateTrusted, isTrue);
      expect(path.hasRoute, isFalse);
      expect(path.routes, isEmpty);
      expect(path.shortfalls, isEmpty);
      expect(path.cheapest, isNull);
      expect(path.cheapestUnlock, isNull);
      expect(path.pointsToUnlock, isNull);
      expect(path.message, contains('You already clear the 13B gate'));
      expect(path.message, contains('Nothing is short'));
    });

    test('exactly the published minimum is a pass, not a near miss', () {
      final path = UnlockPathEngine.forGate(
        mosCode: '11B',
        gate: gateOf('CO 77'),
        lineScores: sheetOf(<String, int>{'CO': 77}),
      );

      expect(path.status, UnlockStatus.alreadyQualified);
      expect(path.routes, isEmpty);
    });

    test('clearing any one alternative is enough', () {
      final path = UnlockPathEngine.forGate(
        mosCode: '99A',
        gate: gateOf('CO 90&ST 95|EL 105'),
        lineScores: sheetOf(<String, int>{'CO': 60, 'ST': 60, 'EL': 105}),
      );

      expect(path.status, UnlockStatus.alreadyQualified);
      expect(path.message, contains('EL 105'));
    });
  });

  group('one shortfall', () {
    test('names the area, the points and that it unlocks the job alone', () {
      final path = UnlockPathEngine.forGate(
        mosCode: '11B',
        gate: gateOf('CO 77'),
        lineScores: sheetOf(<String, int>{'CO': 70}),
      );

      expect(path.status, UnlockStatus.routesAvailable);
      expect(path.qualified, isFalse);
      expect(path.routes, hasLength(1));

      final route = path.routes.single;
      expect(route.score, LineScore.co);
      expect(route.actual, 70);
      expect(route.minimum, 77);
      expect(route.pointsNeeded, 7);
      expect(route.unlocksAlone, isTrue);
      expect(route.viaAlternativeIndex, 0);
      expect(route.unlocksThroughOtherAlternative, isFalse);
      expect(route.remaining, isEmpty);
      expect(route.remainingPoints, 0);
      expect(route.action, 'Raise CO from 70 to 77 (+7 points)');
      expect(route.summary, contains('that alone unlocks the job'));

      expect(path.cheapest, same(route));
      expect(path.cheapestUnlock, same(route));
      expect(path.pointsToUnlock, 7);
      expect(path.shortfallAlternativeIndex, 0);
      expect(path.shortfalls.map((row) => row.readable), <String>['CO 70/77']);
      expect(path.message, contains('raising CO by 7 points (70 -> 77)'));
    });

    test('a one-point gap reads as one point, not one points', () {
      final path = UnlockPathEngine.forGate(
        mosCode: '11B',
        gate: gateOf('CO 77'),
        lineScores: sheetOf(<String, int>{'CO': 76}),
      );

      expect(path.routes.single.pointsNeeded, 1);
      expect(path.routes.single.action, 'Raise CO from 76 to 77 (+1 point)');
      expect(path.message, contains('by 1 point (76 -> 77)'));
    });
  });

  group('several shortfalls', () {
    test('the cheapest raise is not the one that unlocks the job', () {
      // The OR shape DA Pam publishes when one MOS accepts two aptitude areas:
      // the first alternative needs two areas at once, the second a single
      // higher one. CO is one point short but climbing it leaves ST behind,
      // while the dearer five-point EL raise finishes the job outright.
      final path = UnlockPathEngine.forGate(
        mosCode: '99T',
        gate: gateOf('CO 90&ST 95|EL 105'),
        lineScores: sheetOf(<String, int>{'CO': 89, 'ST': 80, 'EL': 100}),
      );

      expect(path.status, UnlockStatus.routesAvailable);
      expect(
        path.routes.map(
          (route) => '${route.score.abbr} +${route.pointsNeeded}',
        ),
        <String>['CO +1', 'EL +5', 'ST +15'],
      );

      final cheapest = path.cheapest!;
      expect(cheapest.score, LineScore.co);
      expect(cheapest.pointsNeeded, 1);
      expect(cheapest.unlocksAlone, isFalse);
      expect(cheapest.viaAlternativeIndex, isNull);
      expect(cheapest.remaining.map((row) => row.readable), <String>[
        'ST 80/95',
      ]);
      expect(cheapest.remainingPoints, 15);
      expect(cheapest.summary, contains('ST 80/95 is still short'));

      final unlock = path.cheapestUnlock!;
      expect(unlock.score, LineScore.el);
      expect(unlock.pointsNeeded, 5);
      expect(unlock.unlocksAlone, isTrue);
      expect(unlock.viaAlternativeIndex, 1);
      expect(unlock.remaining, isEmpty);
      expect(path.pointsToUnlock, 5);

      // The closest alternative is the EL one: a single row, five points out.
      // The two-row CO-and-ST alternative is further away in total, so it is not
      // what "why you miss it today" should describe.
      expect(path.shortfallAlternativeIndex, 1);
      expect(path.shortfalls.map((row) => row.readable), <String>[
        'EL 100/105',
      ]);
      expect(
        path.message,
        contains('cheapest single improvement that unlocks 99T is raising EL'),
      );
      expect(
        path.message,
        contains('cheapest raise of any kind is CO by 1 point'),
      );
    });

    test(
      'when one alternative needs three areas, no single raise unlocks it',
      () {
        // The catalogue's own 12P gate shape.
        final path = UnlockPathEngine.forGate(
          mosCode: '12P',
          gate: gateOf('ST 107&EL 107&GT 110'),
          lineScores: sheetOf(<String, int>{'ST': 104, 'EL': 104, 'GT': 108}),
        );

        expect(path.routes, hasLength(3));
        expect(path.routes.every((route) => !route.unlocksAlone), isTrue);
        expect(path.cheapestUnlock, isNull);
        expect(path.pointsToUnlock, isNull);
        expect(
          path.routes.map(
            (route) => '${route.score.abbr} +${route.pointsNeeded}',
          ),
          <String>['GT +2', 'ST +3', 'EL +3'],
        );
        expect(path.message, contains('No single line score unlocks 12P'));

        final cheapest = path.cheapest!;
        expect(cheapest.remaining.map((row) => row.readable), <String>[
          'ST 104/107',
          'EL 104/107',
        ]);
        expect(cheapest.remainingPoints, 6);
        // Two leftover areas read "are still short", not "is still short".
        expect(
          cheapest.summary,
          'Raise GT by 2 points (108 -> 110), but ST 104/107 and '
          'EL 104/107 are still short.',
        );
      },
    );

    test('a route can unlock through another alternative and still say what is '
        'left in the one it climbs', () {
      final path = UnlockPathEngine.forGate(
        mosCode: '99U',
        gate: gateOf('CO 90&ST 95|ST 95'),
        lineScores: sheetOf(<String, int>{'CO': 80, 'ST': 90}),
      );

      final route = path.routes.first;
      expect(route.score, LineScore.st);
      expect(route.pointsNeeded, 5);
      expect(route.alternativeIndex, 0);
      expect(route.viaAlternativeIndex, 1);
      expect(route.unlocksAlone, isTrue);
      expect(route.unlocksThroughOtherAlternative, isTrue);
      expect(route.remaining.map((row) => row.readable), <String>['CO 80/90']);
      expect(
        route.summary,
        contains('unlocks the job through another published alternative'),
      );
    });
  });

  group('ties', () {
    test('equal-cost routes break the same way on every call', () {
      Map<LineScore, int> sheet() => sheetOf(<String, int>{'CO': 89, 'ST': 94});

      final first = UnlockPathEngine.forGate(
        mosCode: '99V',
        gate: gateOf('CO 90&ST 95'),
        lineScores: sheet(),
      );
      final second = UnlockPathEngine.forGate(
        mosCode: '99V',
        gate: gateOf('CO 90&ST 95'),
        lineScores: sheet(),
      );

      expect(first.routes.every((route) => route.pointsNeeded == 1), isTrue);
      // Neither finishes the job, so the tie falls to LineScore's declaration
      // order: ST is declared before CO.
      expect(first.routes.map((route) => route.score.abbr), <String>[
        'ST',
        'CO',
      ]);
      expect(
        first.routes.map((route) => route.score.abbr),
        second.routes.map((route) => route.score.abbr),
      );
      expect(first.cheapestUnlock, isNull);

      // Writing the same requirements in the other order in the data does not
      // change the answer: the tie-break is a property of the model, not of the
      // row order in the gate.
      final reversed = UnlockPathEngine.forGate(
        mosCode: '99V',
        gate: gateOf('ST 95&CO 90'),
        lineScores: sheet(),
      );
      expect(reversed.routes.map((route) => route.score.abbr), <String>[
        'ST',
        'CO',
      ]);
    });

    test('at equal cost the route that finishes the job comes first', () {
      final path = UnlockPathEngine.forGate(
        mosCode: '99W',
        gate: gateOf('CO 90&ST 95|EL 94'),
        lineScores: sheetOf(<String, int>{'CO': 89, 'ST': 90, 'EL': 93}),
      );

      expect(
        path.routes.map(
          (route) => '${route.score.abbr} +${route.pointsNeeded}',
        ),
        <String>['EL +1', 'CO +1', 'ST +5'],
      );
      expect(path.cheapest!.score, LineScore.el);
      expect(path.cheapest!.unlocksAlone, isTrue);
    });
  });

  group('a gate the app does not hold', () {
    test('an unknown gate is named as unknown rather than guessed', () {
      final path = UnlockPathEngine.forMos(
        mosOf(code: '99Z', title: 'Gate Not On Record'),
        sheetOf(<String, int>{'GT': 120, 'CO': 120}),
      );

      expect(path.status, UnlockStatus.gateUnknown);
      expect(path.gateTrusted, isFalse);
      expect(path.qualified, isFalse);
      expect(path.hasRoute, isFalse);
      expect(path.routes, isEmpty);
      expect(path.shortfalls, isEmpty);
      expect(path.cheapest, isNull);
      expect(path.message, contains('no line-score gate on record for 99Z'));
      expect(path.message, contains('rather than guessed'));
    });
  });

  group('a gate record that cannot be trusted', () {
    test('an alternative with no requirement rows is malformed', () {
      final path = UnlockPathEngine.forGate(
        mosCode: '99M',
        gate: const AptitudeGate(<List<LineScoreRequirement>>[
          <LineScoreRequirement>[],
        ]),
        lineScores: sheetOf(<String, int>{'CO': 90}),
      );

      expect(path.status, UnlockStatus.gateMalformed);
      expect(path.gateTrusted, isFalse);
      expect(path.qualified, isFalse);
      expect(path.routes, isEmpty);
      expect(path.shortfalls, isEmpty);
      expect(path.message, contains('malformed'));
      expect(
        path.message,
        contains('alternative 1 lists no requirement at all'),
      );
    });

    test('a floor below the scale is malformed', () {
      final path = UnlockPathEngine.forGate(
        mosCode: '99M',
        gate: gateOf('CO 0'),
        lineScores: sheetOf(<String, int>{'CO': 90}),
      );

      expect(path.status, UnlockStatus.gateMalformed);
      expect(path.routes, isEmpty);
      expect(path.message, contains('CO has a minimum of 0'));
    });

    test('a floor above the scale ceiling is malformed', () {
      final path = UnlockPathEngine.forGate(
        mosCode: '99M',
        gate: gateOf('CO 240'),
        lineScores: sheetOf(<String, int>{'CO': 200}),
      );

      expect(path.status, UnlockStatus.gateMalformed);
      expect(path.routes, isEmpty);
      expect(path.message, contains('stops at 220'));
    });

    test('no path exists only for an unknown or malformed gate', () {
      final unknown = UnlockPathEngine.forGate(
        mosCode: '99Z',
        gate: const AptitudeGate(<List<LineScoreRequirement>>[]),
        lineScores: const <LineScore, int>{},
      );
      final malformed = UnlockPathEngine.forGate(
        mosCode: '99M',
        gate: const AptitudeGate(<List<LineScoreRequirement>>[
          <LineScoreRequirement>[],
        ]),
        lineScores: const <LineScore, int>{},
      );
      final published = UnlockPathEngine.forGate(
        mosCode: '11B',
        gate: gateOf('CO 77'),
        lineScores: const <LineScore, int>{},
      );

      expect(unknown.hasRoute, isFalse);
      expect(malformed.hasRoute, isFalse);
      expect(published.hasRoute, isTrue);
      expect(unknown.gateTrusted, isFalse);
      expect(malformed.gateTrusted, isFalse);
      expect(published.gateTrusted, isTrue);
    });
  });

  group('no requirement at all', () {
    test('an MOS that publishes no line-score gate has nothing to raise', () {
      final path = UnlockPathEngine.forMos(
        mosOf(
          code: '42R',
          title: 'Musician',
          category: 'Army Band',
          note:
              'No aptitude-area (line-score) requirement published; '
              'qualification is by audition',
          extraTest: 'Instrument audition (ACASP)',
        ),
        sheetOf(<String, int>{'GT': 60}),
      );

      expect(path.status, UnlockStatus.noRequirement);
      expect(path.qualified, isTrue);
      expect(path.gateTrusted, isTrue);
      expect(path.routes, isEmpty);
      expect(path.hasRoute, isFalse);
      expect(path.message, contains('publishes no line-score gate'));
      expect(path.message, contains('Instrument audition'));
      expect(
        path.caveats.any((line) => line.contains('Instrument audition')),
        isTrue,
      );
    });

    test('a note that says so is enough, with no extra test to point at', () {
      final path = UnlockPathEngine.forMos(
        mosOf(
          code: '42S',
          note:
              'No line-score requirement; must be acceptable to the band '
              'commander',
        ),
        sheetOf(<String, int>{'GT': 40}),
      );

      expect(path.status, UnlockStatus.noRequirement);
      expect(path.qualified, isTrue);
      expect(path.message, contains('Selection is on other criteria.'));
    });

    test('an empty gate nothing explains is unknown, not a free pass', () {
      final path = UnlockPathEngine.forMos(
        mosOf(code: '99Y', note: 'National Guard-only MOS'),
        sheetOf(<String, int>{'GT': 120}),
      );

      expect(path.status, UnlockStatus.gateUnknown);
      expect(path.qualified, isFalse);
    });
  });

  group('a candidate with no scores yet', () {
    test('every gate reads zero and the route is the gate itself', () {
      final path = UnlockPathEngine.forMos(
        mosOf(code: '11B', gate: gateOf('CO 77')),
        const <LineScore, int>{},
      );

      expect(path.hasScores, isFalse);
      expect(path.status, UnlockStatus.routesAvailable);
      expect(path.routes, hasLength(1));
      expect(path.routes.single.actual, 0);
      expect(path.routes.single.pointsNeeded, 77);
      expect(path.routes.single.unlocksAlone, isTrue);
      expect(path.shortfalls.single.readable, 'CO 0/77');
      expect(path.message, contains('No line scores are on record yet'));
    });

    test('a missing area is read as zero, never as met', () {
      final path = UnlockPathEngine.forGate(
        mosCode: '25B',
        gate: gateOf('ST 95'),
        lineScores: sheetOf(<String, int>{'GT': 130}),
      );

      expect(path.hasScores, isTrue);
      expect(path.routes.single.score, LineScore.st);
      expect(path.routes.single.actual, 0);
      expect(path.routes.single.pointsNeeded, 95);
      expect(path.message, isNot(contains('No line scores are on record yet')));
    });
  });

  group('worked example on a gate transcribed from the catalogue', () {
    test('12P gate: ST 107 and EL 107 and GT 110', () {
      final path = UnlockPathEngine.forMos(
        mosOf(
          code: '12P',
          title: 'Prime Power Production Specialist',
          category: 'Combat Support Engineer',
          gate: gateOf('ST 107&EL 107&GT 110'),
          note: 'SECRET required for award and retention',
          securityClearance: true,
        ),
        sheetOf(<String, int>{'ST': 104, 'EL': 111, 'GT': 106}),
      );

      // EL is already clear; the two short areas are named with their values.
      expect(path.shortfalls.map((row) => row.readable), <String>[
        'ST 104/107',
        'GT 106/110',
      ]);
      expect(
        path.routes.map(
          (route) => '${route.score.abbr} +${route.pointsNeeded}',
        ),
        <String>['ST +3', 'GT +4'],
      );
      // Three areas are required together, so no single raise opens the job.
      expect(path.cheapestUnlock, isNull);
      expect(path.cheapest!.score, LineScore.st);
      expect(path.cheapest!.remaining.map((row) => row.readable), <String>[
        'GT 106/110',
      ]);
      expect(
        path.caveats.any((line) => line.contains('security clearance')),
        isTrue,
      );
    });

    test('an AFQT floor is stated as something no line score reaches', () {
      final path = UnlockPathEngine.forMos(
        mosOf(
          code: '99F',
          gate: gateOf('GT 110'),
          securityClearance: true,
          asvabMinimum: 31,
        ),
        sheetOf(<String, int>{'GT': 100}),
      );

      expect(path.routes.single.pointsNeeded, 10);
      expect(
        path.caveats.any((line) => line.contains('AFQT percentile')),
        isTrue,
      );
      expect(path.caveats, hasLength(2));
    });
  });
}
