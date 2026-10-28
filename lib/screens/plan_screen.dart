import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routes.dart';
import '../core/theme/tokens.dart';
import '../data/bank/lessons_index.dart';
import '../data/bank/question_bank.dart';
import '../data/models/catalog.dart';
import '../data/models/lesson.dart';
import '../data/models/mos.dart';
import '../engines/adaptive_engine.dart';
import '../engines/study_planner.dart';
import '../engines/study_schedule.dart';
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: Space.md),
                      child: _TodayCard(plan: plan, goal: app.goal),
                    ),
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
                        Expanded(
                          child: Text(
                            s.label,
                            style: context.text.titleSmall?.copyWith(
                              color: c.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: Space.sm),
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
          // The verdict pill was pushed to the right by a Spacer, so a long
          // label ("Not enough time", "No time budget") overflowed the header
          // by 102 px on a small phone at 2x text. Wrapping means the pill
          // drops to its own line instead of painting a hazard stripe.
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Icon(Icons.calendar_month_outlined, size: 17, color: c.primary),
              Text(
                'Your schedule',
                style: context.text.titleSmall?.copyWith(color: c.textPrimary),
              ),
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

String _minutes(int n) => '$n minute${n == 1 ? '' : 's'}';

String _days(int n) => '$n day${n == 1 ? '' : 's'}';

/// The plain reading of where the plan stands against the date and the budget.
String _contextLine(StudySchedule schedule) {
  switch (schedule.status) {
    case ScheduleStatus.nothingPlanned:
      return 'No steps outstanding.';
    case ScheduleStatus.noTargetDate:
      return 'No target date set, so there is nothing to divide the work over. '
          'This is one step at a time until there is a date to pace against.';
    case ScheduleStatus.datePassed:
      return 'The target date has passed. What is left is '
          '${_minutes(schedule.neededMinutes)} of work.';
    case ScheduleStatus.noBudget:
      return 'No daily minutes set. The work left needs '
          '${_minutes(schedule.requiredDailyMinutes ?? 0)} a day.';
    case ScheduleStatus.fits:
    case ScheduleStatus.needsMoreTime:
      return '${_days(schedule.daysRemaining ?? 0)} left at '
          '${_minutes(schedule.dailyMinutes)} a day is '
          '${_minutes(schedule.availableMinutes ?? 0)}. The plan needs '
          '${_minutes(schedule.neededMinutes)}.';
  }
}

/// What to do today, how far through the plan that puts the candidate, and -
/// when the stated minutes a day cannot cover the work - the pace it needs
/// instead.
///
/// The plan below is ordered by what each step is worth and says nothing about
/// when to do it. This card is the answer to "when", computed once from the
/// steps, the target date and the daily budget.
class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.plan, required this.goal});

  final List<PlanStep> plan;
  final GoalProfile? goal;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final schedule = StudyScheduler.forPlan(
      plan: plan,
      goal: goal,
      today: DateTime.now(),
    );
    final percent = (schedule.progressAfterToday * 100).round();
    final tomorrow = schedule.tomorrowSteps;

    return AppCard(
      padding: const EdgeInsets.all(Space.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.today_outlined, size: 17, color: c.primary),
              const SizedBox(width: Space.sm),
              Expanded(
                child: Text(
                  'Today',
                  style: context.text.titleSmall?.copyWith(
                    color: c.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.sm),
          Text(
            _contextLine(schedule),
            style: context.text.bodySmall?.copyWith(
              color: c.textMuted,
              height: 1.4,
            ),
          ),
          if (schedule.status == ScheduleStatus.needsMoreTime) ...<Widget>[
            const SizedBox(height: Space.xs),
            Text(
              'It needs ${_minutes(schedule.requiredDailyMinutes ?? 0)} a day '
              'instead of ${schedule.dailyMinutes}.',
              style: context.text.bodySmall?.copyWith(
                color: c.warning,
                height: 1.4,
              ),
            ),
          ],
          if (schedule.todaySteps.isNotEmpty) ...<Widget>[
            const SizedBox(height: Space.md),
            for (final step in schedule.todaySteps)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.xs),
                child: _TodayStepRow(step: step),
              ),
          ],
          if (schedule.stepCount > 0) ...<Widget>[
            const SizedBox(height: Space.sm),
            MeterBar(
              value: schedule.progressAfterToday,
              height: 6,
              color: c.primary,
            ),
            const SizedBox(height: Space.xs),
            Text(
              '${schedule.stepsThroughToday} of ${schedule.stepCount} steps - '
              '$percent percent of the plan.',
              style: context.text.bodySmall?.copyWith(
                color: c.textMuted,
                height: 1.4,
              ),
            ),
          ],
          if (tomorrow.isNotEmpty) ...<Widget>[
            const SizedBox(height: Space.xs),
            Text(
              tomorrow.length == 1
                  ? 'Tomorrow: ${tomorrow.single.label}.'
                  : 'Tomorrow: ${tomorrow.first.label} and '
                        '${tomorrow.length - 1} more.',
              style: context.text.bodySmall?.copyWith(
                color: c.textMuted,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// One thing to do today, as a way to start it rather than a note about it.
///
/// The card used to list the day's work and stop there, so a candidate reading
/// "Numbers & order of operations - 13 minutes" had to scroll to the plan, find
/// that same skill in the list and tap it there. Telling someone what to do and
/// then not letting them start it is the gap between a plan and a suggestion.
///
/// The row goes where the plan step below it goes: [AppRoutes.lesson] on the
/// same skill id, because the schedule carries the plan step's id through
/// unchanged. The whole row is the target, not just the label, and it never gets
/// shorter than [minimumTapTarget] however small the text is. The chevron is the
/// affordance, so the card reads as a list of things to open rather than a wall
/// of buttons.
class _TodayStepRow extends StatelessWidget {
  const _TodayStepRow({required this.step});

  final ScheduleStep step;

  /// A row shorter than this is a text line with a gesture attached, not a
  /// thumb target.
  static const double minimumTapTarget = 48;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(Radii.sm);
    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: () => AppRoutes.lesson(context, step.id),
        borderRadius: radius,
        splashColor: c.primary.withValues(alpha: 0.06),
        highlightColor: c.primary.withValues(alpha: 0.04),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: minimumTapTarget),
          child: Row(
            children: <Widget>[
              Text(
                '\u00b7',
                style: context.text.bodySmall?.copyWith(color: c.primary),
              ),
              const SizedBox(width: Space.sm),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Space.xs),
                  child: Text(
                    '${step.label} - ${_minutes(step.minutes)}',
                    style: context.text.bodySmall?.copyWith(
                      color: c.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Space.sm),
              Icon(Icons.chevron_right_rounded, size: 18, color: c.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
