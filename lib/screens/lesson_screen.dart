import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routes.dart';
import '../core/theme/tokens.dart';
import '../data/bank/lessons_index.dart';
import '../data/bank/question_bank.dart';
import '../data/models/lesson.dart';
import '../engines/exam_builder.dart';
import '../state/app_state.dart';
import '../widgets/primitives.dart';
import '../widgets/puzzle_view.dart';

/// A single reinforcement lesson, then a mastery check built from the bank.
class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key, required this.skillId});

  final String skillId;

  @override
  Widget build(BuildContext context) {
    final lesson = LessonRepository.bySkill(skillId);
    final c = context.colors;
    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          icon: Icons.construction_rounded,
          title: 'Lesson not written yet',
          body:
              'This skill has questions but no lesson content yet. Try a drill '
              'instead - the explanations in review teach the same material.',
        ),
      );
    }

    final app = context.watch<AppState>();
    final mastery = app.lastReport?.skillMastery[skillId]?.mastery;
    final questionCount = QuestionBank.all
        .where((q) => q.skills.contains(skillId))
        .length;

    final bool stack = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    final Widget checkCopy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Mastery check',
          style: context.text.titleSmall?.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 2),
        Text(
          '$questionCount questions in the bank test this skill. '
          'Four of them will tell you whether the lesson landed.',
          style: context.text.bodySmall,
        ),
      ],
    );
    final Widget checkButton = FilledButton(
      onPressed: () => AppRoutes.exam(
        context,
        ExamBuilder.lessonQuiz(
          skillId,
          seed: DateTime.now().millisecondsSinceEpoch % 100000,
        ),
      ),
      child: const Text('Check myself'),
    );

    return Scaffold(
      // The reading time used to sit in the bar, where it took the width the
      // subtest name needed and cut "Auto & Shop Information" short. It belongs
      // with the content, not with the title.
      appBar: AppBar(title: Text(lesson.subtest.label)),
      body: PageBody(
        maxWidth: 720,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                SubtestGlyph(abbr: lesson.subtest.abbr, size: 40),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Eyebrow('Reinforcement lesson'),
                      const SizedBox(height: 2),
                      Text(lesson.title, style: context.text.headlineSmall),
                      const SizedBox(height: 2),
                      Text(
                        '${lesson.minutes} min read',
                        style: context.text.bodySmall?.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Space.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Space.lg),
              decoration: BoxDecoration(
                color: c.accentSoft,
                borderRadius: BorderRadius.circular(Radii.md),
                border: Border(left: BorderSide(color: c.accent, width: 3)),
              ),
              child: Text(
                lesson.hook,
                style: context.text.bodyLarge?.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w600,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: Space.md),
            Text(lesson.whyItMatters, style: context.text.bodyMedium),
            if (mastery != null) ...<Widget>[
              const SizedBox(height: Space.md),
              Row(
                children: <Widget>[
                  const Pill(
                    'Your mastery',
                    tone: PillTone.neutral,
                    dense: true,
                  ),
                  const SizedBox(width: Space.sm),
                  Expanded(
                    child: MeterBar(
                      value: mastery,
                      height: 6,
                      color: mastery >= 0.75
                          ? c.success
                          : (mastery >= 0.5 ? c.primary : c.warning),
                    ),
                  ),
                  const SizedBox(width: Space.sm),
                  Text(
                    '${(mastery * 100).round()}%',
                    style: context.text.labelMedium?.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: Space.xl),
            for (final section in lesson.sections) ...<Widget>[
              _Section(section: section),
              const SizedBox(height: Space.lg),
            ],
            Text(
              'Worked examples',
              style: context.text.titleMedium?.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: Space.sm),
            for (final ex in lesson.examples) ...<Widget>[
              _ExampleCard(example: ex),
              const SizedBox(height: Space.md),
            ],
            if (lesson.commonMistakes.isNotEmpty) ...<Widget>[
              const SizedBox(height: Space.sm),
              Text(
                lesson.commonMistakes.length == 1
                    ? 'The common mistake'
                    : 'Common mistakes',
                style: context.text.titleMedium?.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: Space.sm),
              for (final m in lesson.commonMistakes) ...<Widget>[
                _MistakeCard(mistake: m),
                const SizedBox(height: Space.md),
              ],
            ],
            const SizedBox(height: Space.sm),
            Text(
              'Rules worth memorising',
              style: context.text.titleMedium?.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: Space.sm),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (var i = 0; i < lesson.quickRules.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Space.sm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.check_rounded, size: 15, color: c.success),
                          const SizedBox(width: Space.sm),
                          Expanded(
                            child: Text(
                              lesson.quickRules[i],
                              style: context.text.bodySmall?.copyWith(
                                color: c.textPrimary,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: Space.lg),
            Text(
              'What goes wrong',
              style: context.text.titleMedium?.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: Space.sm),
            for (final p in lesson.pitfalls)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.sm),
                child: Callout(
                  tone: PillTone.danger,
                  icon: Icons.warning_amber_rounded,
                  text: p,
                ),
              ),
            const SizedBox(height: Space.xl),
            AppCard(
              accent: c.primary,
              padding: const EdgeInsets.all(Space.lg),
              // The button keeps its own width, so beside the copy it can only
              // survive while the copy still has room. At an enlarged system
              // font the label alone is wider than the card, so the pair stacks
              // instead of painting an overflow stripe over the check.
              child: stack
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        checkCopy,
                        const SizedBox(height: Space.md),
                        checkButton,
                      ],
                    )
                  : Row(
                      children: <Widget>[
                        Expanded(child: checkCopy),
                        const SizedBox(width: Space.md),
                        checkButton,
                      ],
                    ),
            ),
            const SizedBox(height: Space.xxl),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.section});
  final LessonSection section;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          section.heading,
          style: context.text.titleSmall?.copyWith(
            color: c.textPrimary,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: Space.sm),
        Text(
          section.body,
          style: context.text.bodyMedium?.copyWith(height: 1.65),
        ),
        if (section.bullets.isNotEmpty) ...<Widget>[
          const SizedBox(height: Space.sm),
          for (final b in section.bullets)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.xs, left: Space.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: c.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Text(
                      b,
                      style: context.text.bodySmall?.copyWith(
                        color: c.textSecondary,
                        height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

/// The wrong answer a lesson expects, set apart from the worked examples so
/// the two are never confused: this is the value to stop writing down.
class _MistakeCard extends StatelessWidget {
  const _MistakeCard({required this.mistake});
  final CommonMistake mistake;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      accent: c.danger,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // A fixed icon beside wrapping text is safe at any font scale,
              // where a fixed width label would clip the answer itself.
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(Icons.close_rounded, size: 15, color: c.danger),
              ),
              const SizedBox(width: Space.sm),
              Expanded(
                child: Text(
                  mistake.answer,
                  style: context.text.bodyMedium?.copyWith(
                    color: c.danger,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.sm),
          Text(
            mistake.why,
            style: context.text.bodySmall?.copyWith(
              color: c.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.example});
  final WorkedExample example;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            example.prompt,
            style: context.text.bodyMedium?.copyWith(
              color: c.textPrimary,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: Space.md),
          for (var i = 0; i < example.steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 18,
                    child: Text(
                      '${i + 1}.',
                      style: context.text.labelSmall?.copyWith(
                        color: c.textMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      example.steps[i],
                      style: context.text.bodySmall?.copyWith(
                        color: c.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: Space.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Space.md,
              vertical: Space.sm,
            ),
            decoration: BoxDecoration(
              color: c.successSoft,
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Text(
              'Answer: ${example.answer}',
              style: context.text.labelLarge?.copyWith(color: c.success),
            ),
          ),
        ],
      ),
    );
  }
}
