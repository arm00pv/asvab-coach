import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routes.dart';
import '../core/theme/tokens.dart';
import '../data/bank/lessons_index.dart';
import '../data/bank/question_bank.dart';
import '../data/models/catalog.dart';
import '../data/models/lesson.dart';
import '../engines/adaptive_engine.dart';
import '../engines/study_planner.dart';
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
              const _ScheduleCard(),
              const SizedBox(height: Space.xl),
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

/// Week-by-week pacing against the target date, with the arithmetic shown.
class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final c = context.colors;
    final goal = app.goal;
    final report = app.lastReport;
    if (goal == null) return const SizedBox.shrink();

    final plan = StudyPlanner.build(
      report: report,
      goal: goal,
      now: DateTime.now(),
    );
    final tone = switch (plan.verdict) {
      PlanVerdict.comfortable || PlanVerdict.sufficient => PillTone.success,
      PlanVerdict.tight => PillTone.warning,
      _ => PillTone.danger,
    };

    return AppCard(
      padding: const EdgeInsets.all(Space.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.calendar_month_outlined, size: 17, color: c.primary),
              const SizedBox(width: Space.sm),
              Text(
                'Your schedule',
                style: context.text.titleSmall?.copyWith(color: c.textPrimary),
              ),
              const Spacer(),
              Pill(plan.verdictLabel, tone: tone, dense: true),
            ],
          ),
          const SizedBox(height: Space.md),
          Row(
            children: <Widget>[
              Expanded(
                child: StatTile(
                  label: 'Days left',
                  value: '${plan.daysUntilTest}',
                  compact: true,
                ),
              ),
              Expanded(
                child: StatTile(
                  label: 'Time available',
                  value: '${(plan.availableMinutes / 60).round()}',
                  suffix: 'h',
                  compact: true,
                ),
              ),
              Expanded(
                child: StatTile(
                  label: 'Work outstanding',
                  value: '${(plan.neededMinutes / 60).round()}',
                  suffix: 'h',
                  compact: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.md),
          MeterBar(
            value: plan.neededMinutes == 0
                ? 1
                : (plan.availableMinutes / plan.neededMinutes).clamp(0.0, 1.0),
            height: 6,
            color: tone == PillTone.success ? c.success : c.warning,
          ),
          const SizedBox(height: Space.xs),
          Text(
            plan.availableMinutes >= plan.neededMinutes
                ? 'You have enough time for ${plan.focus.length} skill cycles '
                      'and ${plan.mocksPlanned} full mock${plan.mocksPlanned == 1 ? '' : 's'}.'
                : 'The outstanding work needs about ${plan.neededMinutes - plan.availableMinutes} '
                      'more minutes than you have.',
            style: context.text.bodySmall?.copyWith(color: c.textMuted),
          ),
          if (plan.weeks.isNotEmpty) ...<Widget>[
            const SizedBox(height: Space.md),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  for (final w in plan.weeks.take(8))
                    Padding(
                      padding: const EdgeInsets.only(right: Space.sm),
                      child: Container(
                        width: 132,
                        padding: const EdgeInsets.all(Space.sm),
                        decoration: BoxDecoration(
                          color: c.surfaceSunken,
                          borderRadius: BorderRadius.circular(Radii.sm),
                          border: Border.all(color: c.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Week ${w.index}',
                              style: context.text.labelSmall?.copyWith(
                                color: c.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              w.skills.isEmpty
                                  ? 'Consolidate'
                                  : w.skillObjects.first.label,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.bodySmall?.copyWith(
                                color: c.textPrimary,
                                fontSize: 11,
                                height: 1.3,
                              ),
                            ),
                            if (w.mockThisWeek) ...<Widget>[
                              const SizedBox(height: 4),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 10,
                                    color: c.accent,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Mock',
                                    style: context.text.labelSmall?.copyWith(
                                      color: c.accent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          for (final note in plan.notes)
            Padding(
              padding: const EdgeInsets.only(top: Space.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.info_outline_rounded,
                    size: 13,
                    color: c.textMuted,
                  ),
                  const SizedBox(width: Space.sm),
                  Expanded(
                    child: Text(
                      note,
                      style: context.text.bodySmall?.copyWith(
                        color: c.textMuted,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
