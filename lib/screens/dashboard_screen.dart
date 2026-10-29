import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routes.dart';
import '../core/theme/tokens.dart';
import '../data/models/catalog.dart';
import '../data/models/mos.dart';
import '../data/models/score.dart';
import '../engines/adaptive_engine.dart';
import '../engines/eligibility_engine.dart';
import '../engines/exam_builder.dart';
import '../state/app_state.dart';
import '../widgets/charts.dart';
import '../widgets/primitives.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.onNavigate, this.now});

  final ValueChanged<int> onNavigate;

  /// The day the eligibility count is read against. Null means today.
  ///
  /// Passed in for the same reason the jobs screen takes one: which jobs the
  /// Army has retired is a fact about a date, and a test cannot wait for
  /// October.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final report = app.lastReport;
    final goal = app.goal;
    final c = context.colors;
    final today = now ?? DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: PageBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Hello, ${goal?.displayName ?? 'Candidate'}',
                          style: context.text.headlineMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _subtitle(app),
                          style: context.text.bodySmall?.copyWith(
                            color: c.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Beside the settings button at every width: the first
                  // question a new candidate asks is what these numbers mean.
                  IconButton(
                    onPressed: () => AppRoutes.glossary(context),
                    tooltip: 'What the terms mean',
                    icon: const Icon(Icons.menu_book_outlined),
                  ),
                  if (!context.isMediumUp)
                    IconButton(
                      onPressed: () => AppRoutes.settings(context),
                      tooltip: 'Settings',
                      icon: const Icon(Icons.settings_outlined),
                    ),
                ],
              ),
              if (app.hasPendingAttempt) ...<Widget>[
                const SizedBox(height: Space.lg),
                _ResumeNotice(app: app),
              ],
              if (app.availableUpdate != null) ...<Widget>[
                const SizedBox(height: Space.lg),
                _UpdateNotice(app: app),
              ],
              if (app.storageRecovered) ...<Widget>[
                const SizedBox(height: Space.lg),
                _StorageNotice(
                  app: app,
                  onOpenSettings: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SettingsScreen(),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: Space.xl),
              if (report == null)
                _FirstRunCard(onStart: () => _startDiagnostic(context))
              else
                _ReadinessHero(report: report, app: app),
              const SizedBox(height: Space.md),
              const _ReviewQueueCard(),
              const SizedBox(height: Space.lg),
              if (report != null)
                _NextActionCard(
                  app: app,
                  report: report,
                  onNavigate: onNavigate,
                ),
              const SizedBox(height: Space.lg),
              _QuickActions(
                onDiagnostic: () => _startDiagnostic(context),
                onMock: () => _startMock(context),
                onDrill: () => _startDrill(context, report),
                onNavigate: onNavigate,
              ),
              const SizedBox(height: Space.xl),
              if (report != null) ...<Widget>[
                _SectionHeader(
                  title: 'Subtest snapshot',
                  trailing: 'See all',
                  onTrailing: () => onNavigate(2),
                ),
                const SizedBox(height: Space.md),
                _SubtestSnapshot(report: report, app: app),
                const SizedBox(height: Space.xl),
                _EligibilityTeaser(report: report, now: today),
                const SizedBox(height: Space.xl),
              ],
              _SectionHeader(
                title: 'Recent activity',
                trailing: app.attempts.isEmpty ? null : 'History',
                onTrailing: () => onNavigate(4),
              ),
              const SizedBox(height: Space.md),
              if (app.attempts.isEmpty)
                AppCard(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.history_rounded, size: 18, color: c.textMuted),
                      const SizedBox(width: Space.md),
                      Expanded(
                        child: Text(
                          'Nothing yet. Your first diagnostic will appear here.',
                          style: context.text.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: <Widget>[
                    for (final a in app.history.take(4))
                      Padding(
                        padding: const EdgeInsets.only(bottom: Space.sm),
                        child: _AttemptRow(attempt: a),
                      ),
                  ],
                ),
              const SizedBox(height: Space.xxl),
            ],
          ),
        ),
      ),
    );
  }

  /// The one line under the greeting.
  ///
  /// It used to chain three clauses with hyphens - "Officer track - GT 110
  /// target - 59 days to your target date" - which is wide enough that on a
  /// phone the last word, "date", was pushed onto a line of its own, and it
  /// repeated a target date the goal card in Settings already carries. Two
  /// short clauses: who the plan is for, and how long is left. The officer GT
  /// gate is not lost with the clause, it is captioned on the GT figure in the
  /// readiness card below.
  String _subtitle(AppState app) {
    final goal = app.goal;
    if (goal == null) return 'Army National Guard';
    // Compare whole calendar days. Subtracting a clock reading that carries a
    // time of day from a midnight target truncates the part day away, which
    // put this subtitle one day behind the plan screen for the whole of any
    // evening - the same off-by-one the plan screen had.
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = goal.targetDate;
    final days = target == null
        ? null
        : DateTime(
            target.year,
            target.month,
            target.day,
          ).difference(today).inDays;
    final base = goal.officerTrack ? 'Officer track' : 'Army National Guard';
    if (days == null) return base;
    if (days <= 0) return '$base - test date is today';
    if (days == 1) return '$base - test in 1 day';
    return '$base - test in $days days';
  }

  void _startDiagnostic(BuildContext context) {
    final seed = DateTime.now().millisecondsSinceEpoch % 100000;
    AppRoutes.exam(context, ExamBuilder.diagnostic(seed: seed));
  }

  void _startMock(BuildContext context) {
    final seed = DateTime.now().millisecondsSinceEpoch % 100000;
    AppRoutes.exam(context, ExamBuilder.fullMock(seed: seed));
  }

  void _startDrill(BuildContext context, ScoreReport? report) {
    final seed = DateTime.now().millisecondsSinceEpoch % 100000;
    final skills = report == null
        ? <String>[for (final s in Skills.all.take(6)) s.id]
        : AdaptiveEngine.weakSkillIds(report, limit: 5);
    AppRoutes.exam(context, ExamBuilder.drill(skillIds: skills, seed: seed));
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing, this.onTrailing});

  final String title;
  final String? trailing;
  final VoidCallback? onTrailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // Flexible, not Spacer: with the system font size turned up the title
        // and its action together are wider than the phone.
        Flexible(
          child: Text(
            title,
            style: context.text.titleMedium?.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: Space.sm),
        if (trailing != null)
          TextButton(
            onPressed: onTrailing,
            // A 44 dp floor, not Size.zero: the persona UX audit found this
            // action painting at 17 dp tall, which is a target a thumb misses.
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 44),
              padding: const EdgeInsets.symmetric(horizontal: Space.sm),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(trailing!),
          ),
      ],
    );
  }
}

class _FirstRunCard extends StatelessWidget {
  const _FirstRunCard({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      elevated: true,
      padding: const EdgeInsets.all(Space.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Space.md,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: c.accentSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'STEP 1 OF 3',
                  style: context.text.labelSmall?.copyWith(color: c.accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.md),
          Text(
            'Find out where you actually stand',
            style: context.text.headlineMedium,
          ),
          const SizedBox(height: Space.sm),
          Text(
            'The placement diagnostic is 27 questions across all nine subtests. '
            'It is deliberately short, so do not sweat individual answers - it '
            'exists to point the coaching in the right direction.',
            style: context.text.bodyMedium,
          ),
          const SizedBox(height: Space.lg),
          Wrap(
            spacing: Space.md,
            runSpacing: Space.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              FilledButton(
                onPressed: onStart,
                child: const Text('Begin diagnostic'),
              ),
              Text(
                'about 30 minutes',
                style: context.text.bodySmall?.copyWith(color: c.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tells the candidate a newer build exists without nagging: one line, one
/// button, and it never reappears once the app is up to date.
class _UpdateNotice extends StatelessWidget {
  const _UpdateNotice({required this.app});

  final AppState app;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final update = app.availableUpdate;
    if (update == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: c.surfaceSunken,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border(left: BorderSide(color: c.accent, width: 3)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: Space.sm,
        runSpacing: Space.xs,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.system_update_alt_rounded, size: 18, color: c.accent),
              const SizedBox(width: Space.sm),
              Flexible(
                child: Text(
                  'Version ${update.version} is available',
                  style: context.text.titleSmall?.copyWith(
                    color: c.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () => AppRoutes.settings(context),
            child: const Text('See what changed'),
          ),
        ],
      ),
    );
  }
}

/// Offers back an attempt that stopped part-way: the app was closed, the
/// battery died, or the phone reclaimed memory in the middle of a mock.
///
/// Without this the runner is only as durable as the process: a candidate three
/// hours into a full mock would come back to an empty dashboard.
class _ResumeNotice extends StatelessWidget {
  const _ResumeNotice({required this.app});

  final AppState app;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final snapshot = app.pendingAttempt;
    final exam = app.pendingExam;
    if (snapshot == null || exam == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: c.primarySoft,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border(left: BorderSide(color: c.primary, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.play_circle_outline_rounded,
                size: 18,
                color: c.primary,
              ),
              const SizedBox(width: Space.sm),
              Flexible(
                child: Text(
                  'Attempt in progress',
                  style: context.text.titleSmall?.copyWith(
                    color: c.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.xs),
          Text(
            '${snapshot.title} was interrupted. ${snapshot.progressLabel}, '
            '${snapshot.answeredLabel}. The clock picks up where it stopped.',
            style: context.text.bodySmall?.copyWith(
              color: c.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: Space.md),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.xs,
            children: <Widget>[
              FilledButton(
                onPressed: () => AppRoutes.resumeExam(context, exam, snapshot),
                child: const Text('Resume'),
              ),
              TextButton(
                onPressed: () => _confirmDiscard(context),
                child: const Text('Discard'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDiscard(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard this attempt?'),
        content: const Text(
          'The answers you have given so far are thrown away. Your finished '
          'results are not affected.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await app.clearPending();
  }
}

/// Tells the candidate when part of their saved history did not load.
///
/// The alternative is worse than it sounds. An app that quietly shows an empty
/// history looks like it deleted everything, and a candidate who has been
/// practising for a month cannot tell a partial recovery from a reset.
class _StorageNotice extends StatelessWidget {
  const _StorageNotice({required this.app, required this.onOpenSettings});

  final AppState app;
  final VoidCallback onOpenSettings;

  static const _labelled = <String, String>{
    'all': 'saved history',
    'goal': 'your goal',
    'attempts': 'your attempt history',
    'orders': 'the answer orderings kept for review',
    'reviews': 'your review queue',
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final keys = <String>[
      for (final key in app.unreadableKeys) _labelled[key] ?? key,
    ];
    final what = keys.isEmpty
        ? 'part of your saved history'
        : keys.toSet().join(', ');
    final skipped = app.skippedRecords;
    final records = skipped == 1 ? 'record' : 'records';
    final tail = skipped == 0
        ? 'Everything else is intact and new activity saves normally.'
        : '$skipped saved $records could not be read. Everything else is '
              'intact.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: c.warningSoft,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border(left: BorderSide(color: c.warning, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.report_gmailerrorred_rounded,
                size: 18,
                color: c.warning,
              ),
              const SizedBox(width: Space.sm),
              Flexible(
                child: Text(
                  'Some saved data could not be read',
                  style: context.text.titleSmall?.copyWith(
                    color: c.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.xs),
          Text(
            'On this device, $what did not load. $tail Nothing was deleted, '
            'and you can clear the leftovers in Settings if you prefer a clean '
            'start.',
            style: context.text.bodySmall?.copyWith(
              color: c.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: Space.md),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.xs,
            children: <Widget>[
              FilledButton(
                onPressed: app.dismissStorageWarning,
                child: const Text('Got it'),
              ),
              TextButton(
                onPressed: onOpenSettings,
                child: const Text('Open settings'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReadinessHero extends StatelessWidget {
  const _ReadinessHero({required this.report, required this.app});

  final ScoreReport report;
  final AppState app;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final goal = app.goal;
    final target = goal?.targetAfqt ?? 60;
    final tone = report.afqtPercentile >= target
        ? c.success
        : (report.meetsArmyFloor ? c.primary : c.danger);
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
            color: tone,
            target: target,
            bandLabel: report.meetsArmyFloor ? 'QUALIFIES' : 'BELOW FLOOR',
            size: compact ? 150 : 168,
          );
          final stats = <Widget>[
            StatTile(
              label: 'GT score',
              value: '${report.gt}',
              caption: goal?.officerTrack == true
                  ? (report.gt >= 110
                        ? 'Clears the officer gate'
                        : 'Officer gate is 110')
                  : 'Officer gate is 110',
              compact: true,
            ),
            StatTile(
              label: 'Correct',
              value: '${report.totalCorrect}',
              suffix: '/ ${report.totalAnswered}',
              compact: true,
            ),
            StatTile(
              label: 'Streak',
              value: '${app.streakDays}',
              suffix: app.streakDays == 1 ? ' day' : ' days',
              compact: true,
            ),
          ];
          if (compact) {
            return Column(
              children: <Widget>[
                gauge,
                const SizedBox(height: Space.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    for (var i = 0; i < stats.length; i++) ...<Widget>[
                      if (i > 0) const SizedBox(width: Space.md),
                      Expanded(child: stats[i]),
                    ],
                  ],
                ),
              ],
            );
          }
          return Row(
            children: <Widget>[
              gauge,
              const SizedBox(width: Space.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _headline(report, goal),
                      style: context.text.titleLarge,
                    ),
                    const SizedBox(height: Space.sm),
                    Text(_explain(report), style: context.text.bodyMedium),
                    const SizedBox(height: Space.lg),
                    // A Wrap: the hero keeps the gauge beside the figures on a
                    // wide window, and the figures stack rather than overflowing
                    // when the card is narrowed by a narrower window.
                    Wrap(
                      spacing: Space.xl,
                      runSpacing: Space.md,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: stats,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _headline(ScoreReport report, dynamic goal) {
    if (!report.meetsArmyFloor) {
      return 'You are below the Army floor right now';
    }
    if (report.afqtPercentile >= 93) {
      return 'Category I. You are in the top 7 percent.';
    }
    if (report.afqtPercentile >= 65) {
      return 'Category II. Ahead of roughly three in four test takers.';
    }
    if (report.afqtPercentile >= 50) {
      return 'Category IIIA. At or above the national median.';
    }
    return 'Category IIIB. Over the floor - now build margin from here.';
  }

  String _explain(ScoreReport report) {
    final weakest = report.subtestScores.values.where((s) => s.hasData).toList()
      ..sort(
        (a, b) => a.difficultyAdjustedRate.compareTo(b.difficultyAdjustedRate),
      );
    if (weakest.isEmpty) return 'Sit a test to see your profile.';
    final w = weakest.first;
    return 'Your AFQT is built from AR, MK and the WK/PC verbal pair. The subtest '
        'holding you back most is ${w.subtest.abbr} (${w.correct}/${w.total}).';
  }
}

class _NextActionCard extends StatelessWidget {
  const _NextActionCard({
    required this.app,
    required this.report,
    required this.onNavigate,
  });

  final AppState app;
  final ScoreReport report;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final action = AdaptiveEngine.nextAction(
      lastReport: report,
      history: app.attempts,
      goal: app.goal ?? GoalProfile.defaults,
      diagnosticCount: app.diagnosticCount,
      dueReviews: app.dueReviewCount,
    );
    return AppCard(
      accent: c.primary,
      padding: const EdgeInsets.all(Space.lg),
      // The call to action sits under the copy rather than beside it: with the
      // system font size enlarged its label alone is wider than the card.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c.primary,
                  borderRadius: BorderRadius.circular(Radii.md),
                ),
                child: Icon(
                  _iconFor(action.kind),
                  size: 20,
                  color: c.onPrimary,
                ),
              ),
              const SizedBox(width: Space.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Eyebrow('Do this next'),
                    const SizedBox(height: 2),
                    Text(
                      action.title,
                      style: context.text.titleMedium?.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(action.body, style: context.text.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.md),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: () {
                switch (action.kind) {
                  case NextActionKind.diagnostic:
                    AppRoutes.exam(
                      context,
                      ExamBuilder.diagnostic(
                        seed: DateTime.now().millisecondsSinceEpoch % 100000,
                      ),
                    );
                  case NextActionKind.mock:
                    AppRoutes.exam(
                      context,
                      ExamBuilder.fullMock(
                        seed: DateTime.now().millisecondsSinceEpoch % 100000,
                      ),
                    );
                  case NextActionKind.lesson:
                    {
                      final id = action.skillId;
                      if (id != null) {
                        AppRoutes.lesson(context, id);
                      } else {
                        onNavigate(1);
                      }
                    }
                  case NextActionKind.review:
                    AppRoutes.exam(
                      context,
                      ExamBuilder.review(
                        app.dueReviewQuestions,
                        seed: DateTime.now().millisecondsSinceEpoch % 100000,
                      ),
                    );
                  case NextActionKind.drill:
                    AppRoutes.exam(
                      context,
                      ExamBuilder.drill(
                        skillIds: AdaptiveEngine.weakSkillIds(report, limit: 5),
                        seed: DateTime.now().millisecondsSinceEpoch % 100000,
                      ),
                    );
                  case NextActionKind.jobs:
                    onNavigate(3);
                }
              },
              child: Text(action.cta),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(NextActionKind kind) => switch (kind) {
    NextActionKind.diagnostic => Icons.explore_outlined,
    NextActionKind.lesson => Icons.auto_stories_outlined,
    NextActionKind.drill => Icons.bolt_outlined,
    NextActionKind.mock => Icons.timer_outlined,
    NextActionKind.jobs => Icons.workspaces_outline,
    NextActionKind.review => Icons.refresh_rounded,
  };
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onDiagnostic,
    required this.onMock,
    required this.onDrill,
    required this.onNavigate,
  });

  final VoidCallback onDiagnostic;
  final VoidCallback onMock;
  final VoidCallback onDrill;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, String, VoidCallback)>[
      (Icons.timer_outlined, 'Full mock', '135 items', onMock),
      (Icons.bolt_outlined, 'Drill', 'Weakest skills', onDrill),
      (
        Icons.workspaces_outline,
        'Jobs',
        'Check eligibility',
        () => onNavigate(3),
      ),
      (Icons.explore_outlined, 'Re-diagnose', '27 items', onDiagnostic),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 760 ? 4 : 2;
        final width =
            (constraints.maxWidth - (columns - 1) * Space.md) / columns;
        return Wrap(
          spacing: Space.md,
          runSpacing: Space.md,
          children: <Widget>[
            for (final item in items)
              SizedBox(
                width: width,
                child: AppCard(
                  onTap: item.$4,
                  padding: const EdgeInsets.all(Space.md),
                  child: Row(
                    children: <Widget>[
                      Icon(item.$1, size: 18, color: context.colors.primary),
                      const SizedBox(width: Space.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              item.$2,
                              style: context.text.titleSmall?.copyWith(
                                color: context.colors.textPrimary,
                              ),
                            ),
                            Text(
                              item.$3,
                              style: context.text.bodySmall?.copyWith(
                                color: context.colors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SubtestSnapshot extends StatelessWidget {
  const _SubtestSnapshot({required this.report, required this.app});

  final ScoreReport report;
  final AppState app;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final rows = Subtest.administrationOrder
        .where((s) => report.subtestScores[s]?.hasData ?? false)
        .toList();
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.lg,
        vertical: Space.md,
      ),
      child: Column(
        children: <Widget>[
          for (var i = 0; i < rows.length; i++) ...<Widget>[
            if (i > 0) Divider(height: 1, color: c.border),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.sm),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 34,
                    child: Text(
                      rows[i].abbr,
                      style: context.text.labelMedium?.copyWith(
                        color: c.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                rows[i].shortLabel,
                                style: context.text.bodySmall?.copyWith(
                                  color: c.textPrimary,
                                ),
                              ),
                            ),
                            if (rows[i].feedsAfqt) ...<Widget>[
                              const SizedBox(width: Space.sm),
                              const Pill(
                                'AFQT',
                                tone: PillTone.accent,
                                dense: true,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 5),
                        MeterBar(
                          value:
                              (report.subtestScores[rows[i]]?.standardScore ??
                                  0) /
                              99,
                          target: 0.5,
                          color: _tone(context, rows[i]),
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Space.md),
                  SizedBox(
                    width: 34,
                    child: Text(
                      '${report.subtestScores[rows[i]]?.standardScore ?? 0}',
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

  Color _tone(BuildContext context, Subtest s) {
    final score = report.subtestScores[s]?.standardScore ?? 0;
    final c = context.colors;
    if (score >= 60) return c.success;
    if (score >= 45) return c.primary;
    return c.warning;
  }
}

class _EligibilityTeaser extends StatelessWidget {
  const _EligibilityTeaser({required this.report, required this.now});
  final ScoreReport report;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final summary = EligibilityEngine.summarise(report, now: now);
    final closed = summary.nearMiss.take(3).toList();
    return AppCard(
      onTap: null,
      padding: const EdgeInsets.all(Space.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // spaceBetween keeps the count on the right when both fit, and drops
          // it onto its own line when an enlarged label cannot share the width.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: Space.sm,
            runSpacing: Space.xs,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.workspaces_outline, size: 18, color: c.primary),
                  const SizedBox(width: Space.sm),
                  Flexible(
                    child: Text(
                      'Job eligibility',
                      style: context.text.titleSmall?.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              Pill(
                '${summary.qualified.length} of ${summary.total} open',
                tone: PillTone.primary,
                dense: true,
              ),
            ],
          ),
          // The denominator is the catalogue that can be enlisted into today,
          // not the roster, so the entries it leaves out are named rather than
          // silently subtracted.
          if (summary.retiredNote != null) ...<Widget>[
            const SizedBox(height: Space.xs),
            Text(
              summary.retiredNote!,
              style: context.text.labelSmall?.copyWith(color: c.textMuted),
            ),
          ],
          if (closed.isNotEmpty) ...<Widget>[
            const SizedBox(height: Space.md),
            Text(
              'Closest gates you do not clear yet:',
              style: context.text.bodySmall?.copyWith(color: c.textMuted),
            ),
            const SizedBox(height: Space.sm),
            for (final m in closed)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.xs),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 44,
                      child: Text(
                        m.code,
                        style: context.text.labelMedium?.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        m.title,
                        style: context.text.bodySmall?.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: Space.xs),
                    Text(
                      '${EligibilityEngine.evaluate(m.gate, report).bestShortfall} pts short',
                      style: context.text.labelSmall?.copyWith(
                        color: c.warning,
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

class _AttemptRow extends StatelessWidget {
  const _AttemptRow({required this.attempt});
  final Attempt attempt;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      onTap: () => AppRoutes.results(context, attempt),
      padding: const EdgeInsets.symmetric(
        horizontal: Space.lg,
        vertical: Space.md,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.primarySoft,
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Text(
              '${attempt.report.afqtPercentile}',
              style: context.text.titleSmall?.copyWith(color: c.primary),
            ),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  attempt.kind.label,
                  style: context.text.titleSmall?.copyWith(
                    color: c.textPrimary,
                  ),
                ),
                Text(
                  _when(attempt.finishedAt),
                  style: context.text.bodySmall?.copyWith(color: c.textMuted),
                ),
              ],
            ),
          ),
          Text(
            '${attempt.report.totalCorrect}/${attempt.report.totalAnswered}',
            style: context.text.bodySmall?.copyWith(color: c.textMuted),
          ),
          const SizedBox(width: Space.sm),
          Icon(Icons.chevron_right_rounded, size: 18, color: c.textMuted),
        ],
      ),
    );
  }

  String _when(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} h ago';
    if (diff.inDays == 1) return 'yesterday';
    return '${diff.inDays} days ago';
  }
}

/// The spaced-repetition backlog. Shown only when something is actually due, so
/// it earns its space on the dashboard.
class _ReviewQueueCard extends StatelessWidget {
  const _ReviewQueueCard();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final due = app.dueReviews();
    if (due.isEmpty) return const SizedBox.shrink();
    final questions = app.dueReviewQuestions;
    if (questions.isEmpty) return const SizedBox.shrink();
    final c = context.colors;
    final oldest = due.first;
    final overdue = DateTime.now().difference(oldest.dueAt).inDays;

    return AppCard(
      accent: c.accent,
      padding: const EdgeInsets.all(Space.lg),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.accentSoft,
              borderRadius: BorderRadius.circular(Radii.md),
            ),
            child: Text(
              '${due.length}',
              style: context.text.titleMedium?.copyWith(color: c.accent),
            ),
          ),
          const SizedBox(width: Space.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  due.length == 1
                      ? 'One question is due for review'
                      : '${due.length} questions are due for review',
                  style: context.text.titleSmall?.copyWith(
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  overdue > 0
                      ? 'Oldest is $overdue day${overdue == 1 ? '' : 's'} overdue. '
                            'Coming back to what you missed is worth more than new material.'
                      : 'Scheduled retrieval of what you missed. This is how it sticks.',
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: Space.md),
          FilledButton(
            onPressed: () => AppRoutes.exam(
              context,
              ExamBuilder.review(
                questions,
                seed: DateTime.now().millisecondsSinceEpoch % 100000,
              ),
            ),
            child: const Text('Review now'),
          ),
        ],
      ),
    );
  }
}
