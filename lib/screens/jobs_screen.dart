import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/tokens.dart';
import '../data/models/career_field.dart';
import '../data/models/line_score.dart';
import '../data/models/mos.dart';
import '../data/models/score.dart';
import '../data/repos/mos_civilian.dart';
import '../data/repos/mos_descriptions.dart';
import '../data/repos/mos_repository.dart';
import '../engines/eligibility_engine.dart';
import '../engines/unlock_path.dart';
import '../state/app_state.dart';
import '../widgets/mos_sourced_blocks.dart';
import '../widgets/primitives.dart';

/// The jobs explorer. Its job is to answer one question honestly: which National
/// Guard jobs does this score actually open, and what would it take to open the
/// rest.
class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key, this.now});

  /// The day the screen is read against, for the rescission dates the pamphlet
  /// prints. Null means today. A widget cannot own a clock and a test cannot
  /// wait for October to end, so the one date-sensitive comparison on this
  /// screen is passed in rather than read from [DateTime.now] deep in a row.
  final DateTime? now;

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String _query = '';
  String? _fieldPrefix;
  OfficerTrack? _track;
  _Type _type = _Type.all;
  _Mode _mode = _Mode.qualified;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final report = app.lastReport;
    final c = context.colors;
    final now = widget.now ?? DateTime.now();

    final all = MosRepository.search(_query)
        .where(
          (m) =>
              _fieldPrefix == null || CareerField.of(m)?.prefix == _fieldPrefix,
        )
        .toList();
    final routes = MosRepository.officerPathways
        .where((p) => _track == null || OfficerTrack.of(p)?.id == _track!.id)
        .toList(growable: false);
    final summary = report == null ? null : EligibilityEngine.summarise(report);

    final shown = switch (_mode) {
      _Mode.qualified =>
        report == null
            ? all
            : all.where((m) => summary!.isQualified(m)).toList(),
      _Mode.near =>
        report == null
            ? <Mos>[]
            : all.where((m) => summary!.isNearMiss(m)).toList(),
      _Mode.all => all,
    };

    return Scaffold(
      body: SafeArea(
        child: PageBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Jobs', style: context.text.headlineMedium),
              const SizedBox(height: 2),
              Text(
                report == null
                    ? 'Sit an attempt to unlock personalised eligibility.'
                    : 'Scored against your latest attempt (AFQT ${report.afqtPercentile}, '
                          'GT ${report.gt}).',
                style: context.text.bodySmall?.copyWith(color: c.textMuted),
              ),
              const SizedBox(height: Space.xs),
              // A requirement with no date on it cannot be checked, so the date
              // it was last checked against the pamphlet travels with the list.
              Text(
                '${MosRepository.enlistedCount} enlisted MOS transcribed from '
                'DA Pam 611-21 chapter 10 section C, verified '
                '${MosRepository.rosterVerifiedAsOf}.',
                style: context.text.bodySmall?.copyWith(color: c.textMuted),
              ),
              const SizedBox(height: Space.lg),
              if (summary != null) _SummaryStrip(summary: summary),
              const SizedBox(height: Space.lg),
              const _EnlistmentFacts(),
              const SizedBox(height: Space.lg),
              TextField(
                decoration: const InputDecoration(
                  // Short enough to survive a narrow phone without being cut off.
                  hintText: 'Search jobs',
                  prefixIcon: Icon(Icons.search_rounded, size: 18),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: Space.md),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    _Chip(
                      label: report == null
                          ? 'All jobs'
                          : 'Qualified (${summary!.qualified.length})',
                      selected: _mode == _Mode.qualified,
                      onTap: () => setState(() => _mode = _Mode.qualified),
                    ),
                    const SizedBox(width: Space.sm),
                    _Chip(
                      label: report == null
                          ? 'Near miss'
                          : 'Within reach (${summary!.nearMiss.length})',
                      selected: _mode == _Mode.near,
                      onTap: () => setState(() => _mode = _Mode.near),
                    ),
                    const SizedBox(width: Space.sm),
                    _Chip(
                      label: 'Every job (${all.length})',
                      selected: _mode == _Mode.all,
                      onTap: () => setState(() => _mode = _Mode.all),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Space.sm),
              // Enlisted or officer first, because that is the decision a
              // candidate has actually made before any job code matters.
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    _Chip(
                      label: 'Every type',
                      selected: _type == _Type.all,
                      onTap: () => setState(() => _type = _Type.all),
                    ),
                    const SizedBox(width: Space.xs),
                    _Chip(
                      label: 'Enlisted (${all.length})',
                      selected: _type == _Type.enlisted,
                      onTap: () => setState(() => _type = _Type.enlisted),
                    ),
                    const SizedBox(width: Space.xs),
                    _Chip(
                      label: 'Officer & warrant (${routes.length})',
                      selected: _type == _Type.officer,
                      onTap: () => setState(() => _type = _Type.officer),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Space.sm),
              if (_type != _Type.officer)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      _Chip(
                        label: 'All fields',
                        selected: _fieldPrefix == null,
                        onTap: () => setState(() => _fieldPrefix = null),
                      ),
                      for (final field
                          in MosRepository.careerFields) ...<Widget>[
                        const SizedBox(width: Space.xs),
                        _Chip(
                          label: field.label,
                          selected: _fieldPrefix == field.prefix,
                          onTap: () =>
                              setState(() => _fieldPrefix = field.prefix),
                        ),
                      ],
                    ],
                  ),
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      _Chip(
                        label: 'All routes',
                        selected: _track == null,
                        onTap: () => setState(() => _track = null),
                      ),
                      for (final track
                          in MosRepository.officerTracks) ...<Widget>[
                        const SizedBox(width: Space.xs),
                        _Chip(
                          label: track.label,
                          selected: _track?.id == track.id,
                          onTap: () => setState(() => _track = track),
                        ),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: Space.lg),
              if (shown.isEmpty)
                // Padding rather than a fixed height: at 2x system text the
                // empty state is taller than any height worth guessing, and a
                // guessed one paints an overflow stripe instead of the message.
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Space.xxl),
                  child: EmptyState(
                    icon: Icons.search_off_rounded,
                    title: _mode == _Mode.near && report != null
                        ? 'No near misses'
                        : 'Nothing matches',
                    body: _mode == _Mode.near && report != null
                        ? 'Every remaining job is more than eight points away.'
                        : 'Try a different search or field.',
                  ),
                ),
              if (_type != _Type.officer)
                for (final m in shown)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Space.sm),
                    child: _MosRow(
                      mos: m,
                      report: report,
                      now: now,
                      onTap: () => _openDetail(context, m, report, now),
                    ),
                  ),
              if (_type != _Type.enlisted) ...<Widget>[
                const SizedBox(height: Space.xl),
                _OfficerSection(report: report, routes: routes),
              ],
              const SizedBox(height: Space.lg),
              Callout(
                tone: PillTone.warning,
                icon: Icons.gavel_rounded,
                title: 'Verify before you sign',
                text:
                    'These gates are transcribed from published Army aptitude '
                    'tables and were last checked against DA Pam 611-21 chapter '
                    '10 section C on ${MosRepository.rosterVerifiedAsOf}. That '
                    'pamphlet is revised, and the Army re-issues single sections '
                    'between revisions, so a recruiter confirms the current '
                    'requirement in the accession system. '
                    '${MosRepository.notGuardFielded.length} of these jobs are '
                    'restricted by the pamphlet to another component and are '
                    'marked as not Guard jobs. '
                    '${MosRepository.rescindMarked.length} entries the same '
                    'pamphlet marks rescinded are kept and shown as retired or '
                    'retiring, so you recognise the code rather than because '
                    'they are jobs worth aiming at. Treat this screen as a '
                    'planning tool, not an authority.',
              ),
              const SizedBox(height: Space.xxl),
            ],
          ),
        ),
      ),
    );
  }

  void _openDetail(
    BuildContext context,
    Mos mos,
    ScoreReport? report,
    DateTime now,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.xl)),
      ),
      builder: (context) => _MosDetail(mos: mos, report: report, now: now),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? c.primary : c.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? c.primary : c.border),
        ),
        child: Text(
          label,
          style: context.text.labelMedium?.copyWith(
            color: selected ? c.onPrimary : c.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({required this.summary});
  final EligibilitySummary summary;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: const EdgeInsets.all(Space.lg),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Eyebrow('Eligibility'),
                const SizedBox(height: Space.xs),
                Text(
                  '${summary.qualified.length} of ${summary.total} jobs open',
                  style: context.text.titleLarge,
                ),
                const SizedBox(height: Space.sm),
                MeterBar(
                  value: summary.total == 0
                      ? 0
                      : summary.qualified.length / summary.total,
                  height: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: Space.lg),
          // Flexible, not a bare Column: at 2x system text "44 within reach"
          // is wider than this card, and the row would carry the overflow off
          // the right edge. The pill wraps onto a second line instead.
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Pill(
                  '${summary.nearMiss.length} within reach',
                  tone: PillTone.warning,
                  dense: true,
                  maxLines: 2,
                ),
                const SizedBox(height: Space.xs),
                Text(
                  '${summary.outOfReach.length} further out',
                  textAlign: TextAlign.end,
                  style: context.text.bodySmall?.copyWith(color: c.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MosRow extends StatelessWidget {
  const _MosRow({
    required this.mos,
    required this.report,
    required this.now,
    required this.onTap,
  });

  final Mos mos;
  final ScoreReport? report;
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // A job the pamphlet restricts to another component is not one the Guard can
    // give this candidate, so it never reads as "Qualified" here.
    final notGuard = !mos.guardFielded;
    final evaluable = mos.gateIsKnown && mos.hasGate;
    final evaluation = (report == null || !evaluable)
        ? null
        : EligibilityEngine.evaluate(mos.gate, report!);
    // A rescinded MOS is not a verdict at all, in either direction: "Qualified"
    // offers a job that no longer exists and "8 pts short" invites a candidate to
    // chase one. The date is the fact, and it wins over the gate.
    final retired = mos.retiredAt(now);
    final retiring = mos.retiringAt(now);
    final rescindLine = mos.rescindHeadline(now);
    final String label;
    final PillTone tone;
    if (retired) {
      label = 'Retired';
      tone = PillTone.danger;
    } else if (retiring) {
      label = 'Retiring';
      tone = PillTone.warning;
    } else if (notGuard) {
      label = 'Not a Guard job';
      tone = PillTone.neutral;
    } else if (evaluation == null) {
      label = mos.hasGate ? mos.gate.label : mos.gateSummary;
      tone = PillTone.neutral;
    } else if (evaluation.qualified) {
      label = 'Qualified';
      tone = PillTone.success;
    } else {
      label = '${evaluation.bestShortfall} pts short';
      tone = evaluation.nearMiss ? PillTone.warning : PillTone.danger;
    }
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: Space.lg,
        vertical: Space.md,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 46,
            child: Text(
              mos.code,
              style: context.text.titleSmall?.copyWith(color: c.primary),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  mos.title,
                  style: context.text.bodyMedium?.copyWith(
                    color: c.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Dated, spelled out and coloured like a warning rather than a
                // grey footnote: a candidate scanning the list has to be able to
                // tell this row from an open job without opening anything.
                if (rescindLine != null) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    rescindLine,
                    style: context.text.bodySmall?.copyWith(
                      color: retired ? c.danger : c.warning,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ],
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        mos.hasGate ? mos.gate.label : mos.gateSummary,
                        style: context.text.bodySmall?.copyWith(
                          color: c.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    if (mos.securityClearance) ...<Widget>[
                      const SizedBox(width: Space.sm),
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 11,
                        color: c.textMuted,
                      ),
                    ],
                    if (mos.extraTest != null) ...<Widget>[
                      const SizedBox(width: Space.sm),
                      Icon(
                        Icons.assignment_outlined,
                        size: 11,
                        color: c.textMuted,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: Space.sm),
          // A gate label can be long enough to run the card off a phone, so the
          // pill is allowed to shrink - but it wraps onto a second line rather
          // than cutting the verdict off, because "Qualified" and "Short by 8"
          // are the whole reason the row exists.
          Flexible(child: Pill(label, tone: tone, dense: true, maxLines: 2)),
        ],
      ),
    );
  }
}

class _MosDetail extends StatelessWidget {
  const _MosDetail({
    required this.mos,
    required this.report,
    required this.now,
  });

  final Mos mos;
  final ScoreReport? report;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // A retired MOS has no verdict to give and nothing to raise: no line score
    // opens it, so "You qualify" and "raise EL by 3" would both be lies about a
    // job that no longer exists.
    final retired = mos.retiredAt(now);
    final retiring = mos.retiringAt(now);
    final evaluation = (report == null || retired)
        ? null
        : EligibilityEngine.evaluate(mos.gate, report!);
    // "What would it take?" is answered by the unlock engine, from the same line
    // scores this sheet already shows. With no attempt on record there is
    // nothing to raise from, so the sheet asks for one rather than reading every
    // gate as a zero - a false floor is worse than no floor at all.
    final path = (report == null || retired)
        ? null
        : UnlockPathEngine.forMos(mos, report!.lineScores);
    final Widget? unlock = retired
        ? null
        : (report == null
              ? (mos.hasGate ? const _ScoredAttemptNeeded() : null)
              : (path!.qualified ? null : _UnlockPathCard(path: path)));
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      maxChildSize: 0.94,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.all(Space.xl),
        children: <Widget>[
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: c.borderStrong,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: Space.lg),
          Row(
            children: <Widget>[
              Text(mos.code, style: context.text.displaySmall),
              const SizedBox(width: Space.md),
              Expanded(
                child: Text(
                  mos.title,
                  style: context.text.titleMedium?.copyWith(
                    color: c.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.sm),
          Text(
            mos.category,
            style: context.text.bodySmall?.copyWith(color: c.textMuted),
          ),
          const SizedBox(height: Space.lg),
          // The rescission comes first, before anything that reads like a job
          // description or a gate, because it is the answer to the question the
          // sheet was opened to ask.
          if (mos.rescindMarked) ...<Widget>[
            Callout(
              tone: retiring ? PillTone.warning : PillTone.danger,
              icon: retiring
                  ? Icons.schedule_rounded
                  : Icons.event_busy_rounded,
              title:
                  '${retiring ? 'Retiring' : 'Retired'} '
                  '${mos.rescindMonthLabel}',
              text: mos.rescindDetail(now)!,
            ),
            const SizedBox(height: Space.md),
          ],
          // The two sourced blocks sit directly above the gate: what the job is,
          // then where it leads afterwards. Each renders nothing when its source
          // is silent - the merged description catalogue reports any code it
          // does not describe, and the crosswalk misses six - so the condition
          // is repeated here to keep the sheet from opening with a gap where a
          // block would be.
          if (MosDescriptions.forMos(mos) != null) ...<Widget>[
            MosDescriptionCard(mos: mos),
            const SizedBox(height: Space.md),
          ],
          if (MosCivilian.covers(mos.code)) ...<Widget>[
            MosCivilianCard(code: mos.code),
            const SizedBox(height: Space.md),
          ],
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Eyebrow(
                  mos.retiredAt(now)
                      ? 'Aptitude gate (no longer opens an enlistment)'
                      : 'Aptitude gate',
                ),
                const SizedBox(height: Space.sm),
                if (!mos.hasGate)
                  Text(
                    mos.gateStatus == MosGateStatus.noRequirement
                        ? 'The pamphlet states no aptitude-area requirement for '
                              'this MOS, so there is no line score to reach.'
                        : 'The aptitude gate for this MOS has not been verified '
                              'against the pamphlet here, so this app will not '
                              'tell you either way.',
                    style: context.text.bodySmall?.copyWith(height: 1.5),
                  ),
                // A Wrap, not a Row: 12P asks for three areas at once and at
                // 2x text three pills do not fit across a 360 dp phone.
                for (final alt in mos.gate.alternatives)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Space.md),
                    child: Wrap(
                      spacing: Space.sm,
                      runSpacing: Space.xs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        for (var i = 0; i < alt.length; i++) ...<Widget>[
                          if (i > 0)
                            Text(
                              'and',
                              style: context.text.bodySmall?.copyWith(
                                color: c.textMuted,
                              ),
                            ),
                          _ScorePill(
                            req: alt[i],
                            actual: report?.lineFor(alt[i].score),
                          ),
                        ],
                      ],
                    ),
                  ),
                if (mos.gate.alternatives.length > 1)
                  Text(
                    'Either alternative satisfies the requirement.',
                    style: context.text.bodySmall?.copyWith(
                      color: c.textMuted,
                      fontSize: 11,
                    ),
                  ),
                const SizedBox(height: Space.md),
                Text(
                  'Scored with the operational Army composite weights, not the '
                  'textbook sums. Averages to 100 for an average applicant.',
                  style: context.text.bodySmall?.copyWith(
                    color: c.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (evaluation != null) ...<Widget>[
            const SizedBox(height: Space.md),
            AppCard(
              accent: evaluation.qualified ? c.success : c.warning,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Pill(
                    evaluation.qualified ? 'You qualify' : 'Not yet',
                    tone: evaluation.qualified
                        ? PillTone.success
                        : PillTone.warning,
                  ),
                  const SizedBox(height: Space.sm),
                  Text(
                    EligibilityEngine.gapAdvice(mos, report!),
                    style: context.text.bodySmall?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
          if (unlock != null) ...<Widget>[
            const SizedBox(height: Space.md),
            unlock,
          ],
          if (!mos.guardFielded) ...<Widget>[
            const SizedBox(height: Space.md),
            Callout(
              tone: PillTone.warning,
              icon: Icons.flag_outlined,
              title: 'Not an Army National Guard job',
              text:
                  'The pamphlet prints (${mos.componentLimit}) for this MOS. A '
                  'Guard recruiter cannot put you in it, so the gate above only '
                  'matters if you are also weighing another component.',
            ),
          ],
          if (mos.securityClearance) ...<Widget>[
            const SizedBox(height: Space.md),
            const Callout(
              icon: Icons.lock_outline_rounded,
              title: 'Security clearance',
              text:
                  'Requires eligibility for a national security clearance: a '
                  'background investigation, fingerprinting and a credit and '
                  'record check. A line score alone will not get you in.',
            ),
          ],
          if (mos.extraTest != null) ...<Widget>[
            const SizedBox(height: Space.md),
            Callout(
              tone: PillTone.accent,
              icon: Icons.assignment_outlined,
              title: 'Extra selection requirement',
              text: mos.extraTest!,
            ),
          ],
          if (mos.note != null) ...<Widget>[
            const SizedBox(height: Space.md),
            Text(
              mos.note!,
              style: context.text.bodySmall?.copyWith(height: 1.5),
            ),
          ],
          const SizedBox(height: Space.xxl),
        ],
      ),
    );
  }
}

/// One job's answer to "what would it take", taken whole from the unlock
/// engine.
///
/// The message is the engine's own sentence: it already names the cheapest
/// raise that unlocks the MOS, and says so plainly when no single raise does.
/// The routes under it are the same arithmetic broken out one line score at a
/// time, cheapest first, each with the points needed and what it leaves short.
/// Nothing here computes a figure of its own - the sheet shows the engine's
/// working or it shows nothing.
class _UnlockPathCard extends StatelessWidget {
  const _UnlockPathCard({required this.path});

  final UnlockPath path;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      accent: path.hasRoute ? c.warning : c.borderStrong,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Eyebrow('What it would take'),
          const SizedBox(height: Space.sm),
          Text(
            path.message,
            style: context.text.bodySmall?.copyWith(height: 1.5),
          ),
          if (path.routes.length > 1) ...<Widget>[
            const SizedBox(height: Space.sm),
            Text(
              'Cheapest first.',
              style: context.text.bodySmall?.copyWith(
                color: c.textMuted,
                fontSize: 11,
              ),
            ),
          ],
          for (final route in path.routes) ...<Widget>[
            const SizedBox(height: Space.md),
            _UnlockRouteRow(route: route, mosCode: path.mosCode),
          ],
          if (path.caveats.isNotEmpty) ...<Widget>[
            const SizedBox(height: Space.md),
            // A clearance, an audition or an AFQT floor is not a line score, so
            // no route above reaches it. Saying so is the difference between
            // "this is what it takes" and "this is what the arithmetic can see".
            Text(
              'Also required, and not reachable by raising a line score:',
              style: context.text.bodySmall?.copyWith(
                color: c.textMuted,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: Space.xs),
            for (final caveat in path.caveats)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  caveat,
                  style: context.text.bodySmall?.copyWith(
                    color: c.textMuted,
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// One route: the badge for scanning, the raise as a sentence, and what the
/// raise leaves behind.
///
/// A column rather than a row of badge and text: at 2x system text a badge and
/// a full sentence will not sit side by side on a 360 dp phone, and the sentence
/// is the part that must not be cut.
class _UnlockRouteRow extends StatelessWidget {
  const _UnlockRouteRow({required this.route, required this.mosCode});

  final UnlockRoute route;
  final String mosCode;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Pill(
          '${route.score.abbr} +${route.pointsNeeded}',
          tone: route.unlocksAlone ? PillTone.success : PillTone.warning,
          dense: true,
        ),
        const SizedBox(height: Space.xs),
        Text(route.action, style: context.text.labelLarge),
        const SizedBox(height: 2),
        Text(
          _outcome,
          style: context.text.bodySmall?.copyWith(color: c.textMuted),
        ),
      ],
    );
  }

  /// What this raise achieves, in the engine's own reading of the gate: either
  /// the job opens, or these areas are still short afterwards.
  String get _outcome {
    if (!route.unlocksAlone) {
      final short = route.remaining.map((row) => row.readable).join(' and ');
      return short.isEmpty
          ? 'That is not enough on its own.'
          : 'Still short after this: $short.';
    }
    return route.remaining.isEmpty
        ? 'That alone opens $mosCode.'
        : 'Opens $mosCode through another published alternative.';
  }
}

/// The sheet's answer when no scored attempt exists yet.
///
/// Reading every gate as zero would print a shortfall the candidate may not
/// have, so the sheet asks for the attempt instead of inventing a floor.
class _ScoredAttemptNeeded extends StatelessWidget {
  const _ScoredAttemptNeeded();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Eyebrow('What it would take'),
          const SizedBox(height: Space.sm),
          Text(
            'Sit a scored attempt first. Without one there are no line scores to '
            'measure against this gate, and reading every area as zero would '
            'state a shortfall that is not real.',
            style: context.text.bodySmall?.copyWith(height: 1.5),
          ),
          const SizedBox(height: Space.sm),
          Text(
            'With a score on record this sheet names the line score that is '
            'short, by how many points, and whether one raise is enough.',
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

class _ScorePill extends StatelessWidget {
  const _ScorePill({required this.req, required this.actual});

  final LineScoreRequirement req;
  final int? actual;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final met = actual != null && actual! >= req.min;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.md,
        vertical: Space.sm,
      ),
      decoration: BoxDecoration(
        color: met ? c.successSoft : c.surfaceSunken,
        borderRadius: BorderRadius.circular(Radii.sm),
        border: Border.all(color: met ? c.success : c.border),
      ),
      // The two figures wrap rather than overflow: at 2x text on a 360 dp
      // phone "GT 110" plus "you: 104" is wider than the card.
      child: Wrap(
        spacing: Space.sm,
        runSpacing: 2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Text(
            '${req.score.abbr} ${req.min}',
            style: context.text.labelLarge?.copyWith(
              color: met ? c.success : c.textPrimary,
            ),
          ),
          if (actual != null)
            Text(
              'you: $actual',
              style: context.text.labelSmall?.copyWith(
                color: met ? c.success : c.warning,
              ),
            ),
        ],
      ),
    );
  }
}

class _OfficerSection extends StatelessWidget {
  const _OfficerSection({required this.report, required this.routes});

  final ScoreReport? report;

  /// Already filtered by the track chips, so the section shows what was asked
  /// for rather than everything again.
  final List<OfficerPathway> routes;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Becoming an officer', style: context.text.titleMedium),
        const SizedBox(height: 2),
        Text(
          'Every commissioning route in the National Guard turns on the GT score.',
          style: context.text.bodySmall?.copyWith(color: c.textMuted),
        ),
        const SizedBox(height: Space.md),
        for (final p in routes)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: AppCard(
              padding: const EdgeInsets.all(Space.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          p.title,
                          style: context.text.titleSmall?.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: Space.sm),
                      // The gate label is the reason this card exists, so it
                      // keeps its place beside the route name by shrinking and
                      // wrapping onto a second line - the same rule the job
                      // rows use - instead of running off the card at 2x text.
                      Flexible(
                        child: Pill(
                          p.gtLabel,
                          tone: p.gtMinimum == null
                              ? PillTone.neutral
                              : (report != null && report!.gt >= p.gtMinimum!
                                    ? PillTone.success
                                    : PillTone.warning),
                          dense: true,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Space.xs),
                  Text(p.summary, style: context.text.bodySmall),
                  const SizedBox(height: Space.sm),
                  // Requirements are sentences, not labels. A chip holding a
                  // sentence has to either run off the card or cut itself off,
                  // and both lose the requirement; a short bulleted list says
                  // the whole thing.
                  for (final requirement in p.otherRequirements)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 6, right: 6),
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: c.border,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              requirement,
                              style: context.text.bodySmall?.copyWith(
                                color: c.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (p.whyNote != null) ...<Widget>[
                    const SizedBox(height: Space.sm),
                    Text(
                      p.whyNote!,
                      style: context.text.bodySmall?.copyWith(
                        color: c.textMuted,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// The numbers a candidate actually needs before any MOS even matters.
class _EnlistmentFacts extends StatelessWidget {
  const _EnlistmentFacts();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    const facts = <(String, String, String)>[
      (
        'Minimum AFQT',
        '31',
        'Category IIIB. The lowest accepted test score category in AR 601-210.',
      ),
      (
        'Age',
        '17 to 42',
        'Non-prior service. Older applicants need an age waiver.',
      ),
      (
        'Officer gate',
        'GT 110',
        'OCS, warrant officer and WOFT. Explicitly not waiverable for WOCS.',
      ),
      (
        'Score waivers',
        'None',
        'There is no score waiver. Only a retest after the waiting period.',
      ),
      (
        'Retest spacing',
        '30 / 30 / 180 days',
        'Then every six months. A Cat IV retest may need an AFQT gain of 20 points.',
      ),
      (
        'Computer test',
        'Answer everything',
        'On the CAT-ASVAB a blank item scores as though you guessed at random.',
      ),
    ];
    return AppCard(
      padding: const EdgeInsets.all(Space.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.military_tech_outlined, size: 17, color: c.primary),
              const SizedBox(width: Space.sm),
              Flexible(
                child: Text(
                  'Enlistment requirements',
                  style: context.text.titleSmall?.copyWith(
                    color: c.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.md),
          for (final fact in facts)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 118,
                    child: Text(
                      fact.$1,
                      style: context.text.bodySmall?.copyWith(
                        color: c.textMuted,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 108,
                    child: Text(
                      fact.$2,
                      style: context.text.labelMedium?.copyWith(
                        color: c.primary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      fact.$3,
                      style: context.text.bodySmall?.copyWith(
                        color: c.textSecondary,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Text(
            'Sources: AR 601-210 (20 Mar 2026) paragraphs 2-8 and 9-10, '
            'goarmy.com eligibility, and the official ASVAB fact sheet. '
            'Confirm with a recruiter - these change.',
            style: context.text.bodySmall?.copyWith(
              color: c.textMuted,
              fontSize: 10.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

enum _Mode { qualified, near, all }

/// Enlisted, officer, or both - the first decision, before any code.
enum _Type { all, enlisted, officer }
