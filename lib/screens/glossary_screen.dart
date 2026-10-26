import 'package:flutter/material.dart';

import '../core/theme/tokens.dart';
import '../data/models/catalog.dart';
import '../widgets/primitives.dart';

/// One entry: the term as it is printed, and what it actually means.
class GlossaryEntry {
  const GlossaryEntry(this.term, this.plain, {this.detail});

  final String term;

  /// One sentence, in the words a candidate would use.
  final String plain;

  /// Where the number comes from, or what to do about it.
  final String? detail;
}

class GlossarySection {
  const GlossarySection(this.title, this.blurb, this.entries);

  final String title;
  final String blurb;
  final List<GlossaryEntry> entries;
}

/// Everything the app prints in shorthand, spelled out.
///
/// The score report is full of three-letter words - AFQT, VE, SS, GT - that mean
/// nothing until somebody explains them, and a candidate who does not know what
/// a number is cannot act on it. This is that explanation, reachable from the
/// dashboard, the report and Settings.
abstract final class Glossary {
  static final List<GlossarySection> sections = <GlossarySection>[
    GlossarySection(
      'The four numbers on the dashboard',
      'These are the ones that decide where you can go.',
      <GlossaryEntry>[
        GlossaryEntry(
          'AFQT',
          'Armed Forces Qualification Test: your overall percentile, 1 to 99.',
          detail:
              'It is not the average of your subtests. It is built from '
              'Arithmetic Reasoning, Mathematics Knowledge and Verbal '
              'Expression, then read off the 1997 national norm sample - so '
              'AFQT 62 means you scored at or above about 62 percent of the '
              'people it was normed on.',
        ),
        GlossaryEntry(
          'Percentile',
          'How many people out of 100 you scored at or above. Percentile 50 is '
              'the middle, not 50 percent correct.',
        ),
        GlossaryEntry(
          'Category',
          'The AFQT band the Army sorts applicants into: I (93-99), II (65-92), '
              'IIIA (50-64), IIIB (31-49), IVA-IVC below that.',
          detail:
              'Category IIIB and above is the usual enlistment floor with a '
              'diploma; a GED holder needs a higher AFQT, and the Army also '
              'caps how many lower-category applicants it takes each year.',
        ),
        GlossaryEntry(
          'GT',
          'General Technical: the line score every commissioning route and many '
              'enlisted jobs ask about.',
          detail:
              'Army GT is Verbal Expression plus Arithmetic Reasoning, reported '
              'on a scale where 100 is an average applicant and the spread is '
              '20 points. Officer routes usually want GT 110 or better.',
        ),
        GlossaryEntry(
          'Streak',
          'Days in a row you have done something in the app.',
        ),
      ],
    ),
    GlossarySection(
      'Subtests',
      'The nine tests the ASVAB is made of, and the two-letter names the app '
          'uses for them.',
      <GlossaryEntry>[
        for (final s in Subtest.administrationOrder)
          GlossaryEntry('${s.abbr} - ${s.label}', s.blurb),
      ],
    ),
    GlossarySection(
      'Scores and line scores',
      'What the numbers on the report are, and why there are so many.',
      <GlossaryEntry>[
        GlossaryEntry(
          'SS - standard score',
          'Your score on one subtest, scaled so 50 is average and most people '
              'fall between 40 and 60.',
          detail:
              'It is not a percentage and not a count of right answers. 60 is '
              'strong, 40 is below average, and the scale is the same for every '
              'subtest so the numbers can be compared.',
        ),
        GlossaryEntry(
          'VE - Verbal Expression',
          'A combined verbal score made from Word Knowledge and Paragraph '
              'Comprehension.',
          detail:
              'The two subtests are weighted rather than simply averaged, '
              'which is why VE is not the midpoint of WK and PC.',
        ),
        GlossaryEntry(
          'Line scores',
          'Ten Army composites - GT, ST, CL, CO, EL, FA, GM, MM, OF, SC - each a '
              'weighted mix of subtests, printed on a scale where 100 is an '
              'average applicant.',
          detail:
              'Jobs are gated on these, not on your AFQT. That is why a '
              'candidate can clear a job gate while their overall percentile '
              'looks unremarkable.',
        ),
        GlossaryEntry(
          'Correct / total',
          'How many questions you got right out of how many that subtest had.',
          detail:
              'Useful for spotting a weak area, but the standard score is what '
              'the Army uses, because it accounts for how hard the questions '
              'were.',
        ),
      ],
    ),
    GlossarySection(
      'Jobs and gates',
      'What "eligible" means, and where those requirements come from.',
      <GlossaryEntry>[
        GlossaryEntry(
          'MOS',
          'Military Occupational Specialty: the Army job code, such as 68W for '
              'combat medic.',
        ),
        GlossaryEntry(
          'Aptitude gate',
          'The minimum line scores or AFQT a job requires. Every MOS in this '
              'app has its gate recorded, with the paragraph it came from.',
          detail:
              'Gates come from DA Pam 611-21 chapter 10 and change; a recruiter '
              'has the current list, and this app is a guide to it, not a '
              'substitute for it.',
        ),
        GlossaryEntry(
          'Qualified / short by N',
          '"Qualified" means you clear every score requirement for that job '
              'already. "Short by 9" means you are nine points under on the one '
              'gate that is holding you back.',
        ),
        GlossaryEntry(
          'Security clearance',
          'A background investigation, not a score. Some jobs need one; it does '
              'not depend on your ASVAB.',
        ),
      ],
    ),
    GlossarySection(
      'Test day',
      'The words a recruiter will use, and what they mean for you.',
      <GlossaryEntry>[
        GlossaryEntry(
          'PiCAT',
          'The pre-screening version of the ASVAB taken without a proctor. You '
              'still have to confirm it at a military entrance station.',
        ),
        GlossaryEntry(
          'Vtest',
          'The short proctored check that confirms an unverified PiCAT score.',
          detail:
              'If you take the PiCAT at home and do not confirm the score, you '
              'take the full test again. That is the usual reason a good score '
              'does not stick.',
        ),
        GlossaryEntry(
          'MEPS',
          'Military Entrance Processing Station: where the confirmed test, the '
              'physical and the contract happen.',
        ),
        GlossaryEntry(
          'DEP',
          'Delayed Entry Program: the hold before you leave for training.',
        ),
        GlossaryEntry(
          'CAT-ASVAB',
          'The computer version of the test: 135 questions over 197 minutes, '
              'which is what this app simulates.',
          detail:
              'The paper version is longer but more forgiving - it has no '
              'guessing penalty, while the computer version scores a blank as '
              'though you had guessed. Never leave one blank.',
        ),
      ],
    ),
  ];
}

class GlossaryScreen extends StatelessWidget {
  const GlossaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(title: const Text('What the terms mean')),
      body: PageBody(
        maxWidth: 720,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Everything this app prints in shorthand, in plain words.',
              style: context.text.bodyMedium?.copyWith(color: c.textMuted),
            ),
            const SizedBox(height: Space.lg),
            for (final section in Glossary.sections) ...<Widget>[
              Text(section.title, style: context.text.titleMedium),
              const SizedBox(height: 2),
              Text(
                section.blurb,
                style: context.text.bodySmall?.copyWith(color: c.textMuted),
              ),
              const SizedBox(height: Space.md),
              for (final entry in section.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.md),
                  child: AppCard(
                    padding: const EdgeInsets.all(Space.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          entry.term,
                          style: context.text.titleSmall?.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.plain,
                          style: context.text.bodySmall?.copyWith(
                            color: c.textSecondary,
                            height: 1.45,
                          ),
                        ),
                        if (entry.detail != null) ...<Widget>[
                          const SizedBox(height: Space.sm),
                          Text(
                            entry.detail!,
                            style: context.text.bodySmall?.copyWith(
                              color: c.textMuted,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: Space.md),
            ],
            Callout(
              tone: PillTone.info,
              icon: Icons.verified_outlined,
              title: 'Where this comes from',
              text:
                  'The score scales and composite weights follow the 1997 '
                  'ASVAB score scale; item counts and time limits follow the '
                  'official ASVAB fact sheet; job gates follow DA Pam 611-21. '
                  'The full sources are in the project documentation.',
            ),
            const SizedBox(height: Space.xl),
          ],
        ),
      ),
    );
  }
}
