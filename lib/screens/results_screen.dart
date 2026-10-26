import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routes.dart';
import '../core/theme/tokens.dart';
import '../data/models/catalog.dart';
import '../data/models/line_score.dart';
import '../data/models/score.dart';
import '../engines/adaptive_engine.dart';
import '../engines/eligibility_engine.dart';
import '../engines/exam_builder.dart';
import '../state/app_state.dart';
import '../widgets/charts.dart';
import '../widgets/puzzle_view.dart';
import '../widgets/primitives.dart';

/// The score report. Everything the candidate needs to understand where they
/// stand, why, and what to do about it, in that order.
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.attempt});

  final Attempt attempt;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final report = attempt.report;
    final previous = _previous(app, attempt);

    return Scaffold(
      appBar: AppBar(
        title: Text(attempt.kind.label),
        actions: <Widget>[
          // With the system font size turned up, the labelled action and the
          // title together are wider than the bar; the icon carries the same
          // meaning and the tooltip keeps it named.
          if (MediaQuery.textScalerOf(context).scale(1) > 1.3)
            IconButton(
              onPressed: () => AppRoutes.review(context, attempt),
              tooltip: 'Review answers',
              icon: const Icon(Icons.fact_check_outlined),
            )
          else
            TextButton.icon(
              onPressed: () => AppRoutes.review(context, attempt),
              icon: const Icon(Icons.fact_check_outlined, size: 16),
              label: const Text('Review answers'),
            ),
          const SizedBox(width: Space.sm),
        ],
      ),
      body: PageBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Hero(report: report, previous: previous),
            const SizedBox(height: Space.lg),
            const Callout(
              tone: PillTone.warning,
              icon: Icons.info_outline_rounded,
              title: 'An estimate, and practice tends to flatter',
              text:
                  'Candidates routinely score higher on an untimed run '
                  'than at MEPS, and the home PiCAT is known to inflate. Treat '
                  'this as a direction rather than a prediction, and confirm '
                  'anything that matters on the real test.',
            ),
            const SizedBox(height: Space.lg),
            _SectionTitle('Line scores'),
            const SizedBox(height: Space.sm),
            _LineScoreTable(report: report, goal: app.goal),
            const SizedBox(height: Space.xl),
            _SectionTitle('Subtest profile'),
            const SizedBox(height: Space.md),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 720;
                final radar = SubtestRadar(
                  labels: <String>[
                    for (final s in Subtest.administrationOrder) s.abbr,
                  ],
                  values: <int>[
                    for (final s in Subtest.administrationOrder)
                      report.subtestScores[s]?.standardScore ?? 50,
                  ],
                  size: wide ? 300 : 260,
                );
                final bars = Column(
                  children: <Widget>[
                    for (final s in Subtest.administrationOrder)
                      if (report.subtestScores[s]?.hasData ?? false)
                        _SubtestRow(
                          score: report.subtestScores[s]!,
                          trend: app.trendFor(s),
                        ),
                  ],
                );
                if (!wide) {
                  return Column(
                    children: <Widget>[
                      Center(child: radar),
                      const SizedBox(height: Space.lg),
                      bars,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    radar,
                    const SizedBox(width: Space.xl),
                    Expanded(child: bars),
                  ],
                );
              },
            ),
            const SizedBox(height: Space.xl),
            _SectionTitle('What to work on next'),
            const SizedBox(height: Space.sm),
            _WeakSkills(report: report, goal: app.goal),
            const SizedBox(height: Space.xl),
            _SectionTitle('Jobs this score opens'),
            const SizedBox(height: Space.sm),
            _EligibilityBlock(report: report),
            const SizedBox(height: Space.xl),
            _SectionTitle('Pace'),
            const SizedBox(height: Space.sm),
            _PaceBlock(attempt: attempt),
            const SizedBox(height: Space.xxl),
            // Two long button labels in a Row overflow a phone by a third
            // of the screen, so they stack instead.
            Wrap(
              spacing: Space.md,
              runSpacing: Space.sm,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: () {
                    final skills = AdaptiveEngine.weakSkillIds(
                      report,
                      limit: 5,
                    );
                    AppRoutes.exam(
                      context,
                      ExamBuilder.drill(
                        skillIds: skills,
                        seed: DateTime.now().millisecondsSinceEpoch % 100000,
                      ),
                    );
                  },
                  icon: const Icon(Icons.bolt_rounded, size: 18),
                  label: const Text('Drill my weak spots'),
                ),
                const SizedBox(width: Space.md),
                OutlinedButton.icon(
                  onPressed: () => AppRoutes.review(context, attempt),
                  icon: const Icon(Icons.fact_check_outlined, size: 16),
                  label: const Text('Review every answer'),
                ),
              ],
            ),
            const SizedBox(height: Space.huge),
          ],
        ),
      ),
    );
  }

  Attempt? _previous(AppState app, Attempt current) {
    final idx = app.attempts.indexWhere((a) => a.id == current.id);
    if (idx <= 0) return null;
    return app.attempts[idx - 1];
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: context.text.titleMedium);
}

class _Hero extends StatelessWidget {
  const _Hero({required this.report, required this.previous});

  final ScoreReport report;
  final Attempt? previous;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final delta = previous == null
        ? null
        : report.afqtPercentile - previous!.report.afqtPercentile;
    return AppCard(
      elevated: true,
      padding: const EdgeInsets.all(Space.xl),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;
          final gauge = ReadinessGauge(
            value: report.afqtPercentile,
            max: 99,
            label: 'AFQT percentile',
            sublabel: 'Category ${report.category}',
            color: report.meetsArmyFloor ? c.primary : c.danger,
            size: compact ? 148 : 164,
            bandLabel: report.meetsArmyFloor ? 'QUALIFIES' : 'BELOW FLOOR',
          );
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                report.meetsArmyFloor
                    ? 'You clear the Army National Guard floor'
                    : 'Below the AFQT 31 enlistment floor',
                style: context.text.headlineSmall?.copyWith(
                  color: report.meetsArmyFloor ? c.textPrimary : c.danger,
                ),
              ),
              const SizedBox(height: Space.sm),
              Text(
                report.meetsArmyFloor
                    ? 'AFQT 31 is the minimum for a diploma graduate. Every point '
                          'above it widens the jobs open to you and strengthens your '
                          'negotiating position.'
                    : 'AFQT 31 is the floor for a high school diploma graduate. The '
                          'fastest route up is Arithmetic Reasoning and Mathematics '
                          'Knowledge, both of which are weighted directly into AFQT.',
                style: context.text.bodyMedium,
              ),
              if (delta != null) ...<Widget>[
                const SizedBox(height: Space.md),
                Row(
                  children: <Widget>[
                    Icon(
                      delta >= 0
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 16,
                      color: delta >= 0 ? c.success : c.danger,
                    ),
                    const SizedBox(width: Space.xs),
                    Text(
                      delta == 0
                          ? 'No change from your previous attempt'
                          : '${delta.abs()} percentile point${delta.abs() == 1 ? '' : 's'} '
                                '${delta > 0 ? 'up' : 'down'} from your previous attempt',
                      style: context.text.bodySmall?.copyWith(
                        color: delta >= 0 ? c.success : c.danger,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: Space.lg),
              Wrap(
                spacing: Space.xl,
                runSpacing: Space.md,
                children: <Widget>[
                  StatTile(
                    label: 'GT',
                    value: '${report.gt}',
                    caption: 'officer gate 110',
                    compact: true,
                  ),
                  StatTile(
                    label: 'Verbal',
                    value: '${report.ve}',
                    caption: 'VE composite',
                    compact: true,
                  ),
                  StatTile(
                    label: 'Correct',
                    value: '${report.totalCorrect}',
                    suffix: '/${report.totalAnswered}',
                    compact: true,
                  ),
                ],
              ),
            ],
          );
          if (compact) {
            return Column(
              children: <Widget>[
                gauge,
                const SizedBox(height: Space.lg),
                details,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              gauge,
              const SizedBox(width: Space.xl),
              Expanded(child: details),
            ],
          );
        },
      ),
    );
  }
}

class _LineScoreTable extends StatelessWidget {
  const _LineScoreTable({required this.report, required this.goal});

  final ScoreReport report;
  final dynamic goal;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final rows = LineScore.values.toList();
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.lg,
        vertical: Space.sm,
      ),
      child: Column(
        children: <Widget>[
          for (var i = 0; i < rows.length; i++) ...<Widget>[
            if (i > 0) Divider(height: 1, color: c.border),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 40,
                    child: Text(
                      rows[i].abbr,
                      style: context.text.labelMedium?.copyWith(
                        color: rows[i].abbr == 'GT' ? c.accent : c.textMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          rows[i].label,
                          style: context.text.bodySmall?.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          rows[i].nominalFormula,
                          style: context.text.bodySmall?.copyWith(
                            color: c.textMuted,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Space.md),
                  SizedBox(
                    width: 96,
                    child: MeterBar(
                      value: rows[i].isVe
                          ? (report.lineFor(rows[i]) / 99).clamp(0.0, 1.0)
                          : (report.lineFor(rows[i]) / 200).clamp(0.0, 1.0),
                      target: 0.5,
                      height: 6,
                      color: rows[i].isVe
                          ? c.info
                          : (report.lineFor(rows[i]) >= 100
                                ? c.success
                                : c.warning),
                    ),
                  ),
                  const SizedBox(width: Space.md),
                  SizedBox(
                    width: 34,
                    child: Text(
                      '${report.lineFor(rows[i])}',
                      textAlign: TextAlign.right,
                      style: context.text.titleSmall?.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SubtestRow extends StatelessWidget {
  const _SubtestRow({required this.score, required this.trend});

  final SubtestScore score;
  final List<int> trend;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 34,
            child: Text(
              score.subtest.abbr,
              style: context.text.labelMedium?.copyWith(color: c.textMuted),
            ),
          ),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${score.correct}/${score.total} correct',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.bodySmall?.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: Space.sm),
                    Text(
                      'SS ${score.standardScore}',
                      maxLines: 1,
                      style: context.text.labelMedium?.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                MeterBar(
                  value: score.standardScore / 99,
                  target: 0.5,
                  height: 6,
                  color: score.standardScore >= 60
                      ? c.success
                      : (score.standardScore >= 45 ? c.primary : c.warning),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeakSkills extends StatelessWidget {
  const _WeakSkills({required this.report, required this.goal});

  final ScoreReport report;
  final dynamic goal;

  @override
  Widget build(BuildContext context) {
    final priorities = AdaptiveEngine.priorities(
      report,
      officerTrack: goal?.officerTrack == true,
    ).take(4).toList();
    if (priorities.isEmpty) {
      return AppCard(
        child: Text(
          'No skill-level data in this attempt.',
          style: context.text.bodySmall,
        ),
      );
    }
    final c = context.colors;
    return Column(
      children: <Widget>[
        for (final p in priorities)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: AppCard(
              onTap: () => AppRoutes.lesson(context, p.skill.id),
              padding: const EdgeInsets.symmetric(
                horizontal: Space.lg,
                vertical: Space.md,
              ),
              child: Row(
                children: <Widget>[
                  SubtestGlyph(abbr: p.skill.subtest.abbr, size: 32),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          p.skill.label,
                          style: context.text.titleSmall?.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                        Text(
                          '${p.correct}/${p.attempts} correct on this skill',
                          style: context.text.bodySmall?.copyWith(
                            color: c.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Space.md),
                  Text(
                    'Lesson',
                    style: context.text.labelMedium?.copyWith(color: c.primary),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 18, color: c.primary),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _EligibilityBlock extends StatelessWidget {
  const _EligibilityBlock({required this.report});
  final ScoreReport report;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final summary = EligibilityEngine.summarise(report);
    return AppCard(
      padding: const EdgeInsets.all(Space.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              // A display figure, clamped rather than scaled without limit: at
              // 2x this number alone is wider than the card.
              MediaQuery.withClampedTextScaling(
                maxScaleFactor: 1.3,
                child: Text(
                  '${summary.qualified.length} of ${summary.total}',
                  style: context.text.displaySmall?.copyWith(fontSize: 26),
                ),
              ),
              const SizedBox(width: Space.md),
              Expanded(
                child: Text(
                  'catalogued jobs currently clear their published aptitude gate.',
                  style: context.text.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.md),
          MeterBar(
            value: summary.total == 0
                ? 0
                : summary.qualified.length / summary.total,
            height: 8,
          ),
          if (summary.nearMiss.isNotEmpty) ...<Widget>[
            const SizedBox(height: Space.md),
            Text(
              'Within reach (8 points or fewer):',
              style: context.text.labelMedium?.copyWith(color: c.textMuted),
            ),
            const SizedBox(height: Space.xs),
            Wrap(
              spacing: Space.sm,
              runSpacing: Space.sm,
              children: <Widget>[
                for (final m in summary.nearMiss.take(8))
                  Pill(
                    '${m.code} ${m.title.split(' ').first}',
                    tone: PillTone.warning,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PaceBlock extends StatelessWidget {
  const _PaceBlock({required this.attempt});
  final Attempt attempt;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final report = attempt.report;
    final answered = report.totalAnswered;
    final secondsUsed = attempt.duration.inSeconds < 0
        ? 0
        : attempt.duration.inSeconds;
    final perQuestion = answered == 0 ? 0 : (secondsUsed / answered).round();
    final flagged = attempt.responses.where((r) => r.flagged).length;
    final blank = attempt.responses.where((r) => !r.isAnswered).length;
    return AppCard(
      padding: const EdgeInsets.all(Space.lg),
      child: Wrap(
        spacing: Space.xxl,
        runSpacing: Space.lg,
        children: <Widget>[
          StatTile(
            label: 'Time used',
            value: '${(secondsUsed / 60).floor()}',
            suffix: 'min',
            compact: true,
          ),
          StatTile(
            label: 'Per question',
            value: '$perQuestion',
            suffix: 's',
            compact: true,
          ),
          StatTile(
            label: 'Flagged',
            value: '$flagged',
            caption: 'marked for review',
            compact: true,
          ),
          StatTile(
            label: 'Left blank',
            value: '$blank',
            caption: blank > 0
                ? 'a blank is a guaranteed zero'
                : 'nothing skipped',
            tone: blank > 0 ? c.danger : null,
            compact: true,
          ),
        ],
      ),
    );
  }
}
