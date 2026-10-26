import 'package:flutter/material.dart';

import '../core/theme/tokens.dart';
import '../data/models/mos.dart';
import '../data/repos/mos_civilian.dart';
import 'primitives.dart';

/// The two sourced blocks a job sheet carries above its aptitude gate: what the
/// job is, and what it transfers to in civilian life.
///
/// Both are silent when the data behind them is absent, and the silence is the
/// feature. [Mos.description] is null on every entry today, and the O*NET
/// crosswalk does not cover six of the codes this app carries. A block that
/// printed a heading over an empty card would read as "this job is nothing",
/// and a block that filled the gap with a plausible sentence would be a careers
/// claim with no source behind it - the one mistake that costs a candidate
/// years. So nothing here writes its own copy about a job: every sentence on
/// screen is a value, and every value arrives with its attribution.

/// The wording for one [MosSourceKind], for the provenance line under a sourced
/// description.
///
/// The enum names are for the code; a candidate reads "DA Pam 611-21", not
/// "pamphlet". The switch is exhaustive with no default arm on purpose: a sixth
/// kind of source has to be labelled here before it can reach a screen, rather
/// than falling into a catch-all that would print a raw enum name.
String mosSourceKindLabel(MosSourceKind kind) => switch (kind) {
  MosSourceKind.pamphlet => 'DA Pam 611-21',
  MosSourceKind.stp => 'a Soldier Training Publication',
  MosSourceKind.cool => 'Army Credentialing Opportunities On-Line (COOL)',
  MosSourceKind.onet => 'O*NET',
  MosSourceKind.serviceSite => 'an official service site',
};

/// A retrieval day written the way a person reads it: "26 October 2026".
///
/// Day granularity, because [SourcedText.retrievedOn] is a date and a clock
/// time would claim more than the transcription did. The same shape
/// [MosCivilian.retrievedOn] prints in, so two dates on one sheet read alike.
String mosRetrievedOnLabel(DateTime day) =>
    '${day.day} ${_months[day.month - 1]} '
    '${day.year.toString().padLeft(4, '0')}';

const List<String> _months = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Where a sourced sentence came from, in the one line the sheet has room for.
///
/// Plain text, no link. The kind of source is the part that carries weight - the
/// pamphlet states what the job is, a recruiting page states what it says about
/// itself - and the date is what a candidate can use to judge whether the claim
/// has gone stale. The URL stays in the data for whoever wants to verify it; a
/// half-link inside a sheet that is itself dragged and scrolled is a trap for a
/// thumb, and it would still not open anything from a bottom sheet without a
/// browser.
String mosProvenanceLine(SourcedText sourced) =>
    'Source: ${mosSourceKindLabel(sourced.sourceKind)}, '
    'retrieved ${mosRetrievedOnLabel(sourced.retrievedOn)}';

/// "What this job is": the plain-language sentence about the work, with the
/// provenance that makes it safe to show underneath.
///
/// Renders nothing at all when [Mos.description] is null, which is every entry
/// in the catalogue today. The space is left empty rather than filled: see
/// test/mos_provenance_test.dart, which holds any description that does arrive
/// to a dated https:// citation.
class MosDescriptionCard extends StatelessWidget {
  const MosDescriptionCard({super.key, required this.mos});

  final Mos mos;

  @override
  Widget build(BuildContext context) {
    final description = mos.description;
    if (description == null) return const SizedBox.shrink();
    final c = context.colors;
    // A column of two paragraphs, never a row: at 2x system text on a 360 dp
    // phone a sentence and its citation cannot share a line, and both are
    // whole sentences that may not be cut.
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Eyebrow('What this job is'),
          const SizedBox(height: Space.sm),
          Text(
            description.text,
            style: context.text.bodySmall?.copyWith(height: 1.5),
          ),
          const SizedBox(height: Space.sm),
          Text(
            mosProvenanceLine(description),
            style: context.text.bodySmall?.copyWith(
              color: c.textMuted,
              fontSize: 11,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

/// "In civilian life": the O*NET crosswalk's own occupation titles for this MOS,
/// with the credit the CC BY 4.0 licence requires printed under them.
///
/// Renders nothing at all for a code the crosswalk does not cover - 19C, 08H,
/// 15X, 40D, 42T and 88P today. A civilian job title is the one piece of copy on
/// this sheet a candidate can enlist on, so an uncovered code says nothing
/// rather than something plausible; docs/MOS_CIVILIAN.md names each gap and why.
///
/// The credit is a licence condition, not a nicety. O*NET content is CC BY 4.0,
/// which obliges whoever shows it to carry the attribution, the licence link and
/// a statement of what was changed. [MosCivilian.creditLine] is that whole
/// string in one value, and this card prints all of it at the smallest size the
/// sheet uses wherever a title appears - there is no shorter variant to reach
/// for, because dropping half of it is what the licence forbids.
class MosCivilianCard extends StatelessWidget {
  const MosCivilianCard({super.key, required this.code});

  /// The MOS code to look up. Codes reach a screen from stored state and from a
  /// search field, so [MosCivilian.inCivilianLife] forgives case and spacing.
  final String code;

  @override
  Widget build(BuildContext context) {
    final sentence = MosCivilian.inCivilianLife(code);
    if (sentence == null) return const SizedBox.shrink();
    final c = context.colors;
    // The sentence carries its own label - MosCivilian.prefix is
    // "In civilian life: " - so the card prints it as written and does not
    // repeat it as an eyebrow above itself.
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(sentence, style: context.text.bodySmall?.copyWith(height: 1.5)),
          const SizedBox(height: Space.sm),
          // Wraps over as many lines as it needs. A licence text is allowed to
          // be long; what it may not be is cut off or hidden behind a tap.
          Text(
            MosCivilian.creditLine,
            style: context.text.bodySmall?.copyWith(
              color: c.textMuted,
              fontSize: 11,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
