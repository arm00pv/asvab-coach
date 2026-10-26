import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routes.dart';
import '../core/theme/tokens.dart';
import '../data/models/catalog.dart';
import '../data/models/score.dart';
import '../engines/adaptive_engine.dart';
import '../state/app_state.dart';
import '../widgets/charts.dart';
import '../widgets/puzzle_view.dart';
import '../widgets/primitives.dart';

/// Longitudinal view: is the work actually moving the score?
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final c = context.colors;
    final attempts = app.history;

    return Scaffold(
      body: SafeArea(
        child: PageBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Progress', style: context.text.headlineMedium),
              const SizedBox(height: 2),
              Text(
                attempts.isEmpty
                    ? 'Your history will appear here after your first attempt.'
                    : '${attempts.length} attempt${attempts.length == 1 ? '' : 's'} recorded, '
                          '${app.streakDays}-day streak.',
                style: context.text.bodySmall?.copyWith(color: c.textMuted),
              ),
              const SizedBox(height: Space.lg),
              if (attempts.isEmpty)
                const SizedBox(
                  height: 340,
                  child: EmptyState(
                    icon: Icons.insights_outlined,
                    title: 'No history yet',
                    body:
                        'Sit the placement diagnostic and this page fills in with '
                        'trends, streaks and per-skill mastery.',
                  ),
                )
              else ...<Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: AppCard(
                        padding: const EdgeInsets.all(Space.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Eyebrow('Best AFQT'),
                            const SizedBox(height: Space.xs),
                            Text(
                              '${app.bestAfqt}',
                              style: context.text.displaySmall,
                            ),
                            const SizedBox(height: Space.sm),
                            Sparkline(values: app.afqtTrend, height: 40),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: Space.md),
                    Expanded(
                      child: AppCard(
                        padding: const EdgeInsets.all(Space.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Eyebrow('Best GT'),
                            const SizedBox(height: Space.xs),
                            Text(
                              '${app.bestGt}',
                              style: context.text.displaySmall,
                            ),
                            const SizedBox(height: Space.sm),
                            Text(
                              app.bestGt >= 110
                                  ? 'Clears the officer gate.'
                                  : '${110 - app.bestGt} points from the officer gate.',
                              style: context.text.bodySmall?.copyWith(
                                color: app.bestGt >= 110
                                    ? c.success
                                    : c.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Space.xl),
                Text(
                  'Subtest trends',
                  style: context.text.titleMedium?.copyWith(
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: Space.md),
                AppCard(
                  padding: const EdgeInsets.all(Space.lg),
                  child: Column(
                    children: <Widget>[
                      for (final s in Subtest.administrationOrder)
                        Padding(
                          padding: const EdgeInsets.only(bottom: Space.md),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 34,
                                child: Text(
                                  s.abbr,
                                  style: context.text.labelMedium?.copyWith(
                                    color: c.textMuted,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Sparkline(
                                  values: app.trendFor(s),
                                  height: 30,
                                  color: c.primary,
                                  showArea: false,
                                ),
                              ),
                              const SizedBox(width: Space.md),
                              SizedBox(
                                width: 30,
                                child: Text(
                                  _latest(app, s),
                                  textAlign: TextAlign.right,
                                  style: context.text.labelMedium?.copyWith(
                                    color: c.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: Space.xl),
                Text(
                  'Skill mastery',
                  style: context.text.titleMedium?.copyWith(
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Averaged across every attempt. Anything under 60 percent is worth '
                  'a lesson.',
                  style: context.text.bodySmall?.copyWith(color: c.textMuted),
                ),
                const SizedBox(height: Space.md),
                _SkillGrid(report: app.lastReport),
                const SizedBox(height: Space.xl),
                Text(
                  'History',
                  style: context.text.titleMedium?.copyWith(
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: Space.md),
                for (final a in attempts)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Space.sm),
                    child: _HistoryRow(attempt: a),
                  ),
                const SizedBox(height: Space.xxl),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _latest(AppState app, Subtest s) {
    final trend = app.trendFor(s);
    return trend.isEmpty ? '-' : '${trend.last}';
  }
}

class _SkillGrid extends StatelessWidget {
  const _SkillGrid({required this.report});
  final ScoreReport? report;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    if (report == null) {
      return AppCard(
        child: Text('No skill data yet.', style: context.text.bodySmall),
      );
    }
    final priorities = AdaptiveEngine.priorities(report!);
    return Wrap(
      spacing: Space.sm,
      runSpacing: Space.sm,
      children: <Widget>[
        for (final p in priorities)
          InkWell(
            onTap: () => AppRoutes.lesson(context, p.skill.id),
            borderRadius: BorderRadius.circular(Radii.sm),
            child: Container(
              width: 168,
              padding: const EdgeInsets.all(Space.md),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(Radii.sm),
                border: Border.all(color: c.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SubtestGlyph(abbr: p.skill.subtest.abbr, size: 22),
                      const SizedBox(width: Space.sm),
                      Expanded(
                        child: Text(
                          p.skill.label,
                          style: context.text.bodySmall?.copyWith(
                            color: c.textPrimary,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Space.sm),
                  MeterBar(
                    value: p.mastery,
                    height: 5,
                    color: p.mastery >= 0.75
                        ? c.success
                        : (p.mastery >= 0.5 ? c.primary : c.warning),
                  ),
                  const SizedBox(height: Space.xs),
                  Text(
                    '${(p.mastery * 100).round()}%  -  ${p.correct}/${p.attempts}',
                    style: context.text.labelSmall?.copyWith(
                      color: c.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.attempt});
  final Attempt attempt;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final d = attempt.finishedAt;
    final date =
        '${d.year}-${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
    return AppCard(
      onTap: () => AppRoutes.results(context, attempt),
      padding: const EdgeInsets.symmetric(
        horizontal: Space.lg,
        vertical: Space.md,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 40,
            child: Text(
              '${attempt.report.afqtPercentile}',
              style: context.text.titleSmall?.copyWith(color: c.primary),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  attempt.kind.label,
                  style: context.text.bodySmall?.copyWith(
                    color: c.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$date  -  ${attempt.duration.inMinutes} min  -  '
                  '${attempt.report.totalCorrect}/${attempt.report.totalAnswered} correct',
                  style: context.text.labelSmall?.copyWith(color: c.textMuted),
                ),
              ],
            ),
          ),
          Pill('GT ${attempt.report.gt}', dense: true),
          Icon(Icons.chevron_right_rounded, size: 18, color: c.textMuted),
        ],
      ),
    );
  }
}
