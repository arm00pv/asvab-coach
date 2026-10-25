import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/tokens.dart';
import '../data/models/line_score.dart';
import '../data/models/mos.dart';
import '../data/models/score.dart';
import '../data/repos/mos_repository.dart';
import '../engines/eligibility_engine.dart';
import '../state/app_state.dart';
import '../widgets/primitives.dart';

/// The jobs explorer. Its job is to answer one question honestly: which National
/// Guard jobs does this score actually open, and what would it take to open the
/// rest.
class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String _query = '';
  String? _category;
  _Mode _mode = _Mode.qualified;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final report = app.lastReport;
    final c = context.colors;

    final all = MosRepository.search(_query)
        .where((m) => _category == null || m.category == _category)
        .toList();
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
              const SizedBox(height: Space.lg),
              if (summary != null) _SummaryStrip(summary: summary),
              const SizedBox(height: Space.lg),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search by code, title or category',
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    _Chip(
                      label: 'All fields',
                      selected: _category == null,
                      onTap: () => setState(() => _category = null),
                    ),
                    for (final cat in MosRepository.categories) ...<Widget>[
                      const SizedBox(width: Space.xs),
                      _Chip(
                        label: cat,
                        selected: _category == cat,
                        onTap: () => setState(() => _category = cat),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: Space.lg),
              if (shown.isEmpty)
                SizedBox(
                  height: 260,
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
              for (final m in shown)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.sm),
                  child: _MosRow(
                    mos: m,
                    report: report,
                    onTap: () => _openDetail(context, m, report),
                  ),
                ),
              const SizedBox(height: Space.xl),
              _OfficerSection(report: report),
              const SizedBox(height: Space.lg),
              const Callout(
                tone: PillTone.warning,
                icon: Icons.gavel_rounded,
                title: 'Verify before you sign',
                text:
                    'These gates are reference values from published Army '
                    'aptitude tables. DA PAM 611-21 is revised regularly and a '
                    'recruiter confirms the current requirement in the accession '
                    'system. Treat this screen as a planning tool, not an '
                    'authority.',
              ),
              const SizedBox(height: Space.xxl),
            ],
          ),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, Mos mos, ScoreReport? report) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.xl)),
      ),
      builder: (context) => _MosDetail(mos: mos, report: report),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Pill(
                '${summary.nearMiss.length} within reach',
                tone: PillTone.warning,
                dense: true,
              ),
              const SizedBox(height: Space.xs),
              // ignore: avoid_print
              Text(
                '${summary.outOfReach.length} further out',
                style: context.text.bodySmall?.copyWith(color: c.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MosRow extends StatelessWidget {
  const _MosRow({required this.mos, required this.report, required this.onTap});

  final Mos mos;
  final ScoreReport? report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final evaluation = report == null
        ? null
        : EligibilityEngine.evaluate(mos.gate, report!);
    final tone = evaluation == null
        ? PillTone.neutral
        : (evaluation.qualified
              ? PillTone.success
              : (evaluation.nearMiss ? PillTone.warning : PillTone.danger));
    final label = evaluation == null
        ? mos.gate.label
        : (evaluation.qualified
              ? 'Qualified'
              : '${evaluation.bestShortfall} pts short');
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodyMedium?.copyWith(
                    color: c.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      mos.gate.label,
                      style: context.text.bodySmall?.copyWith(
                        color: c.textMuted,
                        fontSize: 11,
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
          Pill(label, tone: tone, dense: true),
        ],
      ),
    );
  }
}

class _MosDetail extends StatelessWidget {
  const _MosDetail({required this.mos, required this.report});

  final Mos mos;
  final ScoreReport? report;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final evaluation = report == null
        ? null
        : EligibilityEngine.evaluate(mos.gate, report!);
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
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Eyebrow('Aptitude gate'),
                const SizedBox(height: Space.sm),
                for (final alt in mos.gate.alternatives)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Space.md),
                    child: Row(
                      children: <Widget>[
                        for (var i = 0; i < alt.length; i++) ...<Widget>[
                          if (i > 0)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Space.sm,
                              ),
                              child: Text(
                                'and',
                                style: context.text.bodySmall?.copyWith(
                                  color: c.textMuted,
                                ),
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
          if (report != null) ...<Widget>[
            const SizedBox(height: Space.md),
            AppCard(
              accent: evaluation!.qualified ? c.success : c.warning,
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '${req.score.abbr} ${req.min}',
            style: context.text.labelLarge?.copyWith(
              color: met ? c.success : c.textPrimary,
            ),
          ),
          if (actual != null) ...<Widget>[
            const SizedBox(width: Space.sm),
            Text(
              'you: $actual',
              style: context.text.labelSmall?.copyWith(
                color: met ? c.success : c.warning,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OfficerSection extends StatelessWidget {
  const _OfficerSection({required this.report});
  final ScoreReport? report;

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
        for (final p in MosRepository.officerPathways)
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
                      Pill(
                        p.gtLabel,
                        tone: p.gtMinimum == null
                            ? PillTone.neutral
                            : (report != null && report!.gt >= p.gtMinimum!
                                  ? PillTone.success
                                  : PillTone.warning),
                        dense: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: Space.xs),
                  Text(p.summary, style: context.text.bodySmall),
                  const SizedBox(height: Space.sm),
                  Wrap(
                    spacing: Space.sm,
                    runSpacing: Space.xs,
                    children: <Widget>[
                      for (final r in p.otherRequirements) Pill(r, dense: true),
                    ],
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

enum _Mode { qualified, near, all }
