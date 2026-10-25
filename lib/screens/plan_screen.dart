import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routes.dart';
import '../core/theme/tokens.dart';
import '../data/bank/lessons_index.dart';
import '../data/bank/question_bank.dart';
import '../data/models/catalog.dart';
import '../data/models/lesson.dart';
import '../engines/adaptive_engine.dart';
import '../state/app_state.dart';
import '../widgets/primitives.dart';
import '../widgets/puzzle_view.dart';

/// The study plan and the lesson library. The plan is ordered by what the score
/// report says will move the needle; the library is there for when you already
/// know what you want to work on.
class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final report = app.lastReport;
    final c = context.colors;
    final plan = report == null
        ? <PlanStep>[]
        : AdaptiveEngine.buildPlan(report, goal: app.goal, limit: 6);

    return Scaffold(
      body: SafeArea(
        child: PageBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Your plan', style: context.text.headlineMedium),
              const SizedBox(height: 2),
              Text(
                report == null
                    ? 'Sit the diagnostic to generate a personalised plan.'
                    : 'Ordered by how many points each skill is worth to you right now.',
                style: context.text.bodySmall?.copyWith(color: c.textMuted),
              ),
              const SizedBox(height: Space.lg),
              if (report == null)
                const Callout(
                  tone: PillTone.info,
                  title: 'No plan yet',
                  text:
                      'The coach builds your plan from a scored attempt. Until then, '
                      'browse the lesson library below - every skill has one.',
                )
              else
                Column(
                  children: <Widget>[
                    for (final step in plan)
                      Padding(
                        padding: const EdgeInsets.only(bottom: Space.sm),
                        child: _PlanCard(step: step),
                      ),
                  ],
                ),
              const SizedBox(height: Space.xl),
              Text(
                'Lesson library',
                style: context.text.titleMedium?.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                '${LessonRepository.count} lessons, one per skill. Every lesson ends '
                'with a mastery check.',
                style: context.text.bodySmall?.copyWith(color: c.textMuted),
              ),
              const SizedBox(height: Space.md),
              for (final s in Subtest.administrationOrder) ...<Widget>[
                if (Skills.forSubtest(s).isNotEmpty) ...<Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: Space.md,
                      bottom: Space.sm,
                    ),
                    child: Row(
                      children: <Widget>[
                        SubtestGlyph(abbr: s.abbr, size: 24),
                        const SizedBox(width: Space.sm),
                        Text(
                          s.label,
                          style: context.text.titleSmall?.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${Skills.forSubtest(s).length} skills',
                          style: context.text.labelSmall?.copyWith(
                            color: c.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    spacing: Space.sm,
                    runSpacing: Space.sm,
                    children: <Widget>[
                      for (final sk in Skills.forSubtest(s))
                        _SkillLessonChip(skill: sk, app: app, report: report),
                    ],
                  ),
                ],
              ],
              const SizedBox(height: Space.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.step});
  final PlanStep step;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      onTap: () => AppRoutes.lesson(context, step.skillId),
      padding: const EdgeInsets.all(Space.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.primarySoft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${step.priority + 1}',
              style: context.text.labelMedium?.copyWith(color: c.primary),
            ),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        step.skill.label,
                        style: context.text.titleSmall?.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                    Pill(step.kind.label, tone: PillTone.primary, dense: true),
                  ],
                ),
                const SizedBox(height: 2),
                Text(step.reason, style: context.text.bodySmall),
                const SizedBox(height: Space.xs),
                Text(
                  step.estimatedGain,
                  style: context.text.labelSmall?.copyWith(color: c.primary),
                ),
              ],
            ),
          ),
          const SizedBox(width: Space.sm),
          Icon(Icons.chevron_right_rounded, size: 18, color: c.textMuted),
        ],
      ),
    );
  }
}

class _SkillLessonChip extends StatelessWidget {
  const _SkillLessonChip({
    required this.skill,
    required this.app,
    required this.report,
  });

  final Skill skill;
  final AppState app;
  final dynamic report;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final mastery = report == null
        ? null
        : (report.skillMastery[skill.id]?.mastery as double?);
    final available = LessonRepository.has(skill.id);
    return InkWell(
      onTap: available ? () => AppRoutes.lesson(context, skill.id) : null,
      borderRadius: BorderRadius.circular(Radii.md),
      child: Container(
        width: 210,
        padding: const EdgeInsets.all(Space.md),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              skill.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.text.bodySmall?.copyWith(
                color: c.textPrimary,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
            const SizedBox(height: Space.sm),
            if (mastery != null)
              MeterBar(
                value: mastery,
                height: 4,
                color: mastery >= 0.75
                    ? c.success
                    : (mastery >= 0.5 ? c.primary : c.warning),
              )
            else
              Text(
                '${QuestionBank.all.where((q) => q.skills.contains(skill.id)).length} questions',
                style: context.text.labelSmall?.copyWith(color: c.textMuted),
              ),
            const SizedBox(height: Space.xs),
            Row(
              children: <Widget>[
                Text(
                  mastery == null ? 'Lesson' : '${(mastery * 100).round()}%',
                  style: context.text.labelSmall?.copyWith(
                    color: mastery == null ? c.primary : c.textMuted,
                  ),
                ),
                const Spacer(),
                if (available)
                  Icon(Icons.arrow_forward_rounded, size: 13, color: c.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
