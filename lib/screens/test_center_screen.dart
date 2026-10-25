import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routes.dart';
import '../core/theme/tokens.dart';
import '../data/models/catalog.dart';
import '../data/bank/question_bank.dart';
import '../engines/adaptive_engine.dart';
import '../engines/exam_builder.dart';
import '../state/app_state.dart';
import '../widgets/primitives.dart';
import '../widgets/puzzle_view.dart';

/// Where you choose what to sit: a full mock, one subtest, or a drill on the
/// skills currently costing you the most.
class TestCenterScreen extends StatelessWidget {
  const TestCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final report = app.lastReport;
    final c = context.colors;
    final seed = DateTime.now().millisecondsSinceEpoch % 100000;

    return Scaffold(
      body: SafeArea(
        child: PageBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Test centre', style: context.text.headlineMedium),
              const SizedBox(height: 2),
              Text(
                'Timing mirrors the CAT-ASVAB: 135 items, 197 minutes, official '
                'section order.',
                style: context.text.bodySmall?.copyWith(color: c.textMuted),
              ),
              const SizedBox(height: Space.lg),
              _BigTestCard(
                icon: Icons.timer_outlined,
                title: 'Full mock ASVAB',
                body:
                    'Every subtest in the order MEPS administers them, with the '
                    'real per-section clock. The only rehearsal that counts.',
                meta: '135 questions  -  197 minutes',
                primary: true,
                onTap: () =>
                    AppRoutes.exam(context, ExamBuilder.fullMock(seed: seed)),
              ),
              const SizedBox(height: Space.md),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _SmallTestCard(
                      icon: Icons.explore_outlined,
                      title: 'Diagnostic',
                      body: '27 items across all nine subtests.',
                      onTap: () => AppRoutes.exam(
                        context,
                        ExamBuilder.diagnostic(seed: seed),
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: _SmallTestCard(
                      icon: Icons.bolt_outlined,
                      title: 'Weak-spot drill',
                      body: report == null
                          ? 'Needs a scored attempt first.'
                          : 'Built from your five weakest skills.',
                      enabled: report != null,
                      onTap: () => AppRoutes.exam(
                        context,
                        ExamBuilder.drill(
                          skillIds: AdaptiveEngine.weakSkillIds(
                            report!,
                            limit: 5,
                          ),
                          seed: seed,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Space.xl),
              Text(
                'Single-subtest practice',
                style: context.text.titleMedium?.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                'Official item count and time limit for one section. Use these when '
                'one subtest is the bottleneck.',
                style: context.text.bodySmall?.copyWith(color: c.textMuted),
              ),
              const SizedBox(height: Space.md),
              for (final s in Subtest.administrationOrder)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.sm),
                  child: AppCard(
                    onTap: () => AppRoutes.exam(
                      context,
                      ExamBuilder.section(s, seed: seed),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Space.lg,
                      vertical: Space.md,
                    ),
                    child: Row(
                      children: <Widget>[
                        SubtestGlyph(abbr: s.abbr, size: 34),
                        const SizedBox(width: Space.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    s.label,
                                    style: context.text.titleSmall?.copyWith(
                                      color: c.textPrimary,
                                    ),
                                  ),
                                  if (s.feedsAfqt) ...<Widget>[
                                    const SizedBox(width: Space.sm),
                                    const Pill(
                                      'AFQT',
                                      tone: PillTone.accent,
                                      dense: true,
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                '${s.questionCount} questions  -  ${s.minutes} min  -  '
                                '${QuestionBank.countFor(s)} in the bank',
                                style: context.text.bodySmall?.copyWith(
                                  color: c.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (report?.subtestScores[s] != null)
                          Padding(
                            padding: const EdgeInsets.only(right: Space.md),
                            child: Text(
                              'SS ${report!.subtestScores[s]!.standardScore}',
                              style: context.text.labelMedium?.copyWith(
                                color: c.textMuted,
                              ),
                            ),
                          ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: c.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: Space.xl),
              const Callout(
                icon: Icons.info_outline_rounded,
                title: 'Practice is allowed to be forgiving',
                text:
                    'These attempts are untimed only where the exam builder says '
                    'so. On the real CAT-ASVAB a blank item is scored as a random '
                    'guess, so the habit to build now is simple: answer everything, '
                    'even if you have to guess.',
              ),
              const SizedBox(height: Space.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _BigTestCard extends StatelessWidget {
  const _BigTestCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.meta,
    required this.onTap,
    this.primary = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final String meta;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      onTap: onTap,
      elevated: primary,
      accent: primary ? c.primary : null,
      padding: const EdgeInsets.all(Space.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primary ? c.primary : c.primarySoft,
              borderRadius: BorderRadius.circular(Radii.md),
            ),
            child: Icon(
              icon,
              size: 20,
              color: primary ? c.onPrimary : c.primary,
            ),
          ),
          const SizedBox(width: Space.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: context.text.titleMedium?.copyWith(
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(body, style: context.text.bodySmall),
                const SizedBox(height: Space.sm),
                Text(
                  meta,
                  style: context.text.labelSmall?.copyWith(color: c.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallTestCard extends StatelessWidget {
  const _SmallTestCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: AppCard(
        onTap: enabled ? onTap : null,
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, size: 18, color: c.primary),
            const SizedBox(height: Space.md),
            Text(
              title,
              style: context.text.titleSmall?.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: 2),
            Text(
              body,
              style: context.text.bodySmall?.copyWith(
                color: c.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
