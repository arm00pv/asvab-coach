import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/line_score.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/engines/recruiter_sheet.dart';
import 'package:flutter_test/flutter_test.dart';

/// The catalogue's compact gate grammar, re-implemented here on purpose: '|'
/// separates OR alternatives, '&' ANDs requirements inside one, and every
/// requirement is 'ABBR MIN'. The sheet must not depend on the catalogue's data
/// or its parser, and nor may this test, so the roster can be rewritten
/// underneath both without breaking either.
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

/// A line-score sheet written the way the app reports it. Anything left out is
/// simply not on record, which is exactly the case the sheet must not turn into
/// a zero.
Map<LineScore, int> sheetOf(Map<String, int> byAbbr) => <LineScore, int>{
  for (final entry in byAbbr.entries) _lineScore(entry.key): entry.value,
};

Mos mosOf({
  required String code,
  required String title,
  required String gate,
  String category = 'Combat Arms',
  MosGateStatus gateStatus = MosGateStatus.published,
  String? componentLimit,
  String? extraTest,
  bool securityClearance = false,
  int? asvabMinimum,
}) => Mos(
  code: code,
  title: title,
  category: category,
  gate: gateOf(gate),
  gateStatus: gateStatus,
  componentLimit: componentLimit,
  extraTest: extraTest,
  securityClearance: securityClearance,
  asvabMinimum: asvabMinimum,
);

ScoreReport reportOf({
  Map<String, int> lines = const <String, int>{},
  int afqtComposite = 202,
  int afqtPercentile = 63,
  int ve = 50,
}) => ScoreReport(
  subtestScores: const <Subtest, SubtestScore>{},
  skillMastery: const <String, SkillMastery>{},
  ve: ve,
  afqtComposite: afqtComposite,
  afqtPercentile: afqtPercentile,
  lineScores: sheetOf(lines),
  elapsedSeconds: 3600,
  totalAnswered: 135,
  totalCorrect: 90,
);

/// The page with every run of whitespace turned into one space, so a phrase
/// that spans a wrapped line can still be searched for.
String flat(String sheet) => sheet.replaceAll(RegExp(r'\s+'), ' ');

final DateTime may4 = DateTime.utc(2026, 5, 4);

const Map<String, int> workedLines = <String, int>{
  'GT': 105,
  'ST': 109,
  'CL': 110,
  'CO': 100,
  'EL': 103,
  'FA': 112,
  'GM': 100,
  'MM': 100,
  'OF': 100,
  'SC': 100,
  'VE': 50,
};

final List<Mos> workedJobs = <Mos>[
  mosOf(code: '11B', title: 'Infantryman', gate: 'CO 90'),
  mosOf(code: '11C', title: 'Indirect Fire Infantryman', gate: 'CO 95'),
  mosOf(code: '68W', title: 'Combat Medic Specialist', gate: 'ST 101|GT 100'),
  mosOf(
    code: '25U',
    title: 'Signal Support Systems Specialist',
    gate: 'EL 100',
  ),
  mosOf(code: '12N', title: 'Horizontal Construction Engineer', gate: 'GT 110'),
  mosOf(code: '92A', title: 'Automated Logistical Specialist', gate: 'CL 118'),
  mosOf(code: '13B', title: 'Cannon Crewmember', gate: 'FA 130'),
  mosOf(
    code: '35N',
    title: 'Signals Intelligence Analyst',
    gate: 'ST 115&EL 115',
  ),
  mosOf(
    code: '89B',
    title: 'Ammunition Specialist',
    gate: '',
    gateStatus: MosGateStatus.unverified,
  ),
  mosOf(code: '79V', title: 'Retention NCO', gate: ''),
  mosOf(
    code: '68K',
    title: 'Medical Laboratory Specialist',
    gate: 'ST 100',
    componentLimit: MosComponent.activeComponentOnly,
  ),
];

/// The page the worked example below must produce, verbatim.
const String workedSheet = '''ASVAB GUARD COACH
Candidate score summary - for your recruiter
Candidate: Alex Rivera
Prepared 2026-05-04

ESTIMATE ONLY - NOT AN OFFICIAL ASVAB RECORD.
The scores below are estimates calculated on
this device by the ASVAB Guard Coach app from
the practice questions you answered. They are
not an official ASVAB record and carry no
official standing with the Army. Only the test
you take at a Military Entrance Processing
Station or an approved test site produces
official ASVAB scores.

AFQT
Composite 202.
Percentile 63, category IIIA.
Percentile 63 is at or above the Army National
Guard enlistment floor for a high school
diploma graduate.

LINE SCORES
GT  105 General Technical
ST  109 Skilled Technical
CL  110 Clerical
CO  100 Combat
EL  103 Electronics
FA  112 Field Artillery
GM  100 General Maintenance
MM  100 Mechanical Maintenance
OF  100 Operators and Food
SC  100 Surveillance and Communications
VE   50 Verbal Expression

Aptitude areas are on the Army scale where the
average applicant scores 100.

JOBS YOU MEET (4)
INFANTRY
11B  Infantryman
11C  Indirect Fire Infantryman

SIGNAL
25U  Signal Support Systems Specialist

MEDICAL
68W  Combat Medic Specialist

JOBS YOU ARE CLOSE TO (2)
Jobs missed by 8 points or less, with the
raise that would clear the published gate.

12N  Horizontal Construction Engineer
  Raise GT by 5 points (105 -> 110): that
  alone unlocks the job.

92A  Automated Logistical Specialist
  Raise CL by 8 points (110 -> 118): that
  alone unlocks the job.

JOBS WITH AN UNKNOWN GATE (2)
The app holds no gate it can trust for these,
so it says nothing about them either way. They
are counted as neither met nor missed.

79V  Retention NCO
  Gate unknown: the catalogue entry carries no
  requirement on record, so the app cannot
  say whether you meet it.

89B  Ammunition Specialist
  Gate unknown: the requirement has not been
  checked against a primary source, so the
  app cannot say whether you meet it.

NOT OPEN TO THE ARMY NATIONAL GUARD (1)
Your scores clear these, but they are
restricted to a component the Army National
Guard cannot access you into.

68K  Medical Laboratory Specialist
  Restricted to: Active Component only.

Not close at this time: 2 other jobs. Ask the
app for the full list whenever you want it.
Produced on this device from practice scores.
Nothing on this sheet was uploaded anywhere.''';

void main() {
  group('what the sheet says', () {
    test(
      'a candidate who meets some jobs lists them under their career field',
      () {
        final report = reportOf(lines: workedLines);
        final sheet = RecruiterSheet.render(
          report: report,
          jobs: workedJobs,
          generatedOn: may4,
        );
        final content = RecruiterSheet.build(
          report: report,
          jobs: workedJobs,
          generatedOn: may4,
        );

        expect(content.groups.map((g) => g.label), <String>[
          'Infantry',
          'Signal',
          'Medical',
        ]);
        expect(content.metCount, 4);
        expect(sheet, contains('JOBS YOU MEET (4)'));
        expect(sheet, contains('11B  Infantryman'));
        expect(sheet, contains('68W  Combat Medic Specialist'));
        expect(sheet, contains('INFANTRY'));
      },
    );

    test(
      'a candidate who meets no jobs is told so rather than shown a blank',
      () {
        final sheet = RecruiterSheet.render(
          report: reportOf(
            lines: <String, int>{'GT': 20, 'ST': 21, 'CO': 22},
            afqtPercentile: 8,
            afqtComposite: 88,
          ),
          jobs: <Mos>[
            mosOf(code: '11B', title: 'Infantryman', gate: 'GT 110'),
            mosOf(
              code: '68W',
              title: 'Combat Medic Specialist',
              gate: 'ST 100',
            ),
          ],
          generatedOn: may4,
        );

        expect(sheet, contains('JOBS YOU MEET (0)'));
        expect(flat(sheet), contains('No job in the catalogue is met'));
        expect(sheet, isNot(contains('INFANTRY')));
      },
    );

    test('a job with an unpublished gate gets its own section and is never '
        'counted as met', () {
      final sheet = RecruiterSheet.render(
        report: reportOf(lines: workedLines),
        jobs: <Mos>[
          mosOf(code: '11B', title: 'Infantryman', gate: 'CO 90'),
          // Unverified: an empty gate here means "not known", never a pass.
          mosOf(
            code: '89B',
            title: 'Ammunition Specialist',
            gate: '',
            gateStatus: MosGateStatus.unverified,
          ),
          // Published but nothing on record: a data defect, still no claim.
          mosOf(code: '79V', title: 'Retention NCO', gate: ''),
        ],
        generatedOn: may4,
      );

      expect(sheet, contains('JOBS YOU MEET (1)'));
      expect(sheet, contains('JOBS WITH AN UNKNOWN GATE (2)'));
      expect(sheet, contains('89B  Ammunition Specialist'));
      expect(sheet, contains('79V  Retention NCO'));
      final met = sheet.split('JOBS WITH AN UNKNOWN GATE').first;
      expect(met, isNot(contains('89B')));
      expect(met, isNot(contains('79V')));
      expect(flat(sheet), contains('counted as neither met nor missed'));
    });

    test(
      'an aptitude area that was never scored prints as unknown, not zero',
      () {
        final sheet = RecruiterSheet.render(
          report: reportOf(lines: <String, int>{'GT': 105, 'CO': 100}),
          jobs: <Mos>[mosOf(code: '11B', title: 'Infantryman', gate: 'CO 90')],
          generatedOn: may4,
        );

        expect(sheet, contains('GT  105 General Technical'));
        expect(sheet, contains('CO  100 Combat'));
        expect(
          sheet,
          contains('ST ${RecruiterSheet.unknownValue} Skilled Technical'),
        );
        expect(flat(sheet), contains('was not scored on this attempt'));
      },
    );

    test('the composite and the percentile are both printed', () {
      final sheet = RecruiterSheet.render(
        report: reportOf(lines: workedLines),
        jobs: workedJobs,
        generatedOn: may4,
      );
      expect(sheet, contains('AFQT'));
      expect(sheet, contains('Composite 202.'));
      expect(sheet, contains('Percentile 63, category IIIA.'));
    });

    test('a met job still prints every published condition the scores do not '
        'cover', () {
      final sheet = RecruiterSheet.render(
        report: reportOf(lines: workedLines),
        jobs: <Mos>[
          mosOf(
            code: '11B',
            title: 'Infantryman',
            gate: 'CO 90',
            securityClearance: true,
            extraTest: 'DLAB',
            asvabMinimum: 40,
          ),
        ],
        generatedOn: may4,
      );
      final page = flat(sheet);
      expect(sheet, contains('JOBS YOU MEET (1)'));
      expect(page, contains('also needs an AFQT percentile of 40'));
      expect(page, contains('also needs a security clearance'));
      expect(page, contains('also needs DLAB'));
    });

    test('a job the authority says carries no aptitude requirement is met, and '
        'says why', () {
      final sheet = RecruiterSheet.render(
        report: reportOf(lines: <String, int>{}),
        jobs: <Mos>[
          mosOf(
            code: '18F',
            title: 'Special Forces Assistant',
            gate: '',
            gateStatus: MosGateStatus.noRequirement,
          ),
        ],
        generatedOn: may4,
      );
      expect(sheet, contains('JOBS YOU MEET (1)'));
      expect(
        flat(sheet),
        contains('18F Special Forces Assistant (no aptitude gate published)'),
      );
    });

    test('the estimate disclaimer is on the page and says both things', () {
      final sheet = RecruiterSheet.render(
        report: reportOf(lines: workedLines),
        jobs: workedJobs,
        generatedOn: may4,
      );
      final page = flat(sheet);
      expect(page, contains('ESTIMATE ONLY'));
      expect(page, contains('not an official ASVAB record'));
      expect(page, contains('estimates calculated on this device'));
      expect(page, contains(flat(RecruiterSheet.estimateDisclaimer)));
    });

    test('the jobs the candidate misses by a few points carry the raise the '
        'unlock engine named', () {
      final sheet = RecruiterSheet.render(
        report: reportOf(lines: workedLines),
        jobs: workedJobs,
        generatedOn: may4,
      );
      final page = flat(sheet);
      expect(sheet, contains('JOBS YOU ARE CLOSE TO (2)'));
      expect(page, contains('12N Horizontal Construction Engineer'));
      expect(page, contains('Raise GT by 5 points (105 -> 110)'));
      expect(page, contains('Raise CL by 8 points (110 -> 118)'));
      // Beyond the threshold: counted, never listed.
      expect(sheet, isNot(contains('Cannon Crewmember')));
      expect(page, contains('Not close at this time: 2 other jobs.'));
    });

    test('a job the Guard cannot access the candidate into is listed apart '
        'from the jobs they meet', () {
      final content = RecruiterSheet.build(
        report: reportOf(lines: workedLines),
        jobs: workedJobs,
        generatedOn: may4,
      );
      expect(content.otherComponentJobs.map((m) => m.code), <String>['68K']);
      expect(
        content.groups.expand((g) => g.jobs).map((m) => m.code),
        isNot(contains('68K')),
      );
    });

    test('the sheet is a small list of sections as well as one string', () {
      final sections = RecruiterSheet.sections(
        report: reportOf(lines: workedLines),
        jobs: workedJobs,
        generatedOn: may4,
        width: 60,
      );
      expect(sections.first.heading, isNull);
      expect(
        sections.map((s) => s.heading).whereType<String>().toList(),
        <String>[
          'AFQT',
          'LINE SCORES',
          'JOBS YOU MEET (4)',
          'JOBS YOU ARE CLOSE TO (2)',
          'JOBS WITH AN UNKNOWN GATE (2)',
          'NOT OPEN TO THE ARMY NATIONAL GUARD (1)',
        ],
      );
      for (final section in sections) {
        for (final line in section.lines) {
          expect(line.length, lessThanOrEqualTo(60), reason: line);
        }
      }
    });
  });

  group('line wrapping', () {
    test('a line that fits exactly at the width is not broken', () {
      expect(RecruiterSheet.wrap('aaaa bbbb', width: 9), <String>['aaaa bbbb']);
    });

    test('a word is moved whole to the next line rather than split', () {
      expect(RecruiterSheet.wrap('aaaa bbbb', width: 8), <String>[
        'aaaa',
        'bbbb',
      ]);
      expect(RecruiterSheet.wrap('one two three', width: 7), <String>[
        'one two',
        'three',
      ]);
    });

    test('a single word longer than the width is broken, never allowed to '
        'overflow', () {
      expect(RecruiterSheet.wrap('abcdefghij', width: 4), <String>[
        'abcd',
        'efgh',
        'ij',
      ]);
    });

    test('a continuation line is indented and still inside the width', () {
      expect(RecruiterSheet.wrap('aaa bbb', width: 6, indent: '  '), <String>[
        'aaa',
        '  bbb',
      ]);
      expect(RecruiterSheet.hanging('aaa bbb', width: 7), <String>[
        '  aaa',
        '  bbb',
      ]);
    });

    test('no line of the worked sheet exceeds the default width', () {
      final sheet = RecruiterSheet.render(
        report: reportOf(lines: workedLines),
        jobs: workedJobs,
        generatedOn: may4,
      );
      for (final line in sheet.split('\n')) {
        expect(
          line.length,
          lessThanOrEqualTo(RecruiterSheet.defaultWidth),
          reason: 'over-wide line: "$line"',
        );
        expect(line, isNot(contains('\t')), reason: 'tab in "$line"');
        expect(line, equals(line.trimRight()), reason: 'trailing space');
      }
    });
  });

  group('determinism', () {
    test('the same report, jobs and date render the same page twice', () {
      String render() => RecruiterSheet.render(
        report: reportOf(lines: workedLines),
        jobs: workedJobs,
        generatedOn: may4,
      );
      expect(render(), render());
    });

    test('the date printed comes from the caller, not from the clock', () {
      final dayOne = RecruiterSheet.render(
        report: reportOf(lines: workedLines),
        jobs: workedJobs,
        generatedOn: DateTime.utc(2026, 3, 4),
      );
      final dayTwo = RecruiterSheet.render(
        report: reportOf(lines: workedLines),
        jobs: workedJobs,
        generatedOn: DateTime.utc(2026, 11, 30),
      );
      expect(dayOne, contains('Prepared 2026-03-04'));
      expect(dayTwo, contains('Prepared 2026-11-30'));
      expect(dayOne, isNot(contains('2026-11-30')));
      final one = dayOne.split('\n');
      final two = dayTwo.split('\n');
      expect(one.length, two.length);
      final differing = <int>[
        for (var i = 0; i < one.length; i++)
          if (one[i] != two[i]) i,
      ];
      expect(differing.length, 1, reason: 'only the date line may differ');
      expect(one[differing.single], contains('Prepared 2026-03-04'));
      expect(RecruiterSheet.formatDate(DateTime.utc(2026, 1, 2)), '2026-01-02');
    });

    test('the order the jobs arrive in does not change the page', () {
      final forward = RecruiterSheet.render(
        report: reportOf(lines: workedLines),
        jobs: workedJobs,
        generatedOn: may4,
      );
      final reversed = RecruiterSheet.render(
        report: reportOf(lines: workedLines),
        jobs: workedJobs.reversed.toList(),
        generatedOn: may4,
      );
      expect(reversed, forward);
    });
  });

  // The whole page, character for character. A human asked for a sheet they can
  // hand over, so the thing worth pinning is not a set of fragments but the
  // artefact itself: if wrapping, wording or ordering moves, this test moves
  // with it on purpose.
  test('worked example', () {
    final sheet = RecruiterSheet.render(
      report: reportOf(lines: workedLines),
      jobs: workedJobs,
      generatedOn: may4,
      candidateName: 'Alex Rivera',
    );
    expect(sheet, workedSheet);
  });
}
