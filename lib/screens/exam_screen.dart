import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/routes.dart';
import '../core/theme/tokens.dart';
import '../data/models/catalog.dart';
import '../data/models/exam.dart';
import '../data/models/score.dart';
import '../state/app_state.dart';
import '../state/exam_session.dart';
import '../widgets/charts.dart';
import '../widgets/primitives.dart';
import '../widgets/mc_figure_view.dart';
import '../widgets/puzzle_view.dart';

/// The test runner.
///
/// Design commitments, in priority order:
///  * one question on screen, always, with the answer options as large targets;
///  * the clock visible but never noisy - it only turns red inside the last
///    minute of a timed section;
///  * no accidental loss: answers are recorded the moment they are tapped;
///  * keyboard operable, because a real ASVAB is mouse-or-keyboard.
class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key, required this.exam});

  final Exam exam;

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late final ExamSession session;
  final FocusNode _focus = FocusNode();
  bool _sectionIntro = true;
  int? _introIndex;

  @override
  void initState() {
    super.initState();
    session = ExamSession(
      exam: widget.exam,
      seed: DateTime.now().millisecondsSinceEpoch,
      onSectionComplete: _handleSectionComplete,
    )..addListener(_onSession);
    session.start();
    _introIndex = 0;
  }

  void _onSession() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    session.removeListener(_onSession);
    session.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _handleSectionComplete(int index) async {
    if (session.finished) {
      await _submit();
      return;
    }
    if (mounted) {
      setState(() {
        _sectionIntro = true;
        _introIndex = index + 1;
      });
    }
  }

  Future<void> _submit() async {
    final report = session.finish();
    final attempt = session.toAttempt(report);
    final app = context.read<AppState>();
    await app.addAttempt(attempt, session.orders);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => _ResultsForwarder(attempt: attempt),
      ),
    );
  }

  void _confirmQuit() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave this attempt?'),
        content: const Text(
          'Progress in this attempt will not be scored. Your earlier results are '
          'untouched.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep going'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Discard attempt'),
          ),
        ],
      ),
    );
  }

  void _confirmFinishSection() {
    final unanswered =
        session.sectionQuestionCount - session.answeredInSection();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          session.isLastSection
              ? 'Finish the exam?'
              : 'Finish ${session.section.subtest.label}?',
        ),
        content: Text(
          unanswered == 0
              ? 'Every question in this section is answered.'
              : '$unanswered question${unanswered == 1 ? '' : 's'} '
                    'still blank. A blank answer scores zero, so guess instead.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Review'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              session.completeSection();
            },
            child: Text(
              session.isLastSection ? 'Submit exam' : 'Finish section',
            ),
          ),
        ],
      ),
    );
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (_sectionIntro) return KeyEventResult.ignored;
    final key = event.logicalKey;
    final digits = <LogicalKeyboardKey, int>{
      LogicalKeyboardKey.digit1: 0,
      LogicalKeyboardKey.digit2: 1,
      LogicalKeyboardKey.digit3: 2,
      LogicalKeyboardKey.digit4: 3,
      LogicalKeyboardKey.numpad1: 0,
      LogicalKeyboardKey.numpad2: 1,
      LogicalKeyboardKey.numpad3: 2,
      LogicalKeyboardKey.numpad4: 3,
    };
    if (digits.containsKey(key)) {
      final index = digits[key]!;
      if (index < session.current.displayChoices.length) {
        session.answer(index);
        return KeyEventResult.handled;
      }
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      session.next();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      session.previous();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.keyF) {
      session.toggleFlag();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmQuit();
      },
      child: Focus(
        focusNode: _focus,
        autofocus: true,
        onKeyEvent: _onKey,
        child: Scaffold(
          body: SafeArea(
            child: _sectionIntro
                ? _SectionIntro(
                    exam: widget.exam,
                    index: _introIndex ?? 0,
                    onBegin: () {
                      setState(() => _sectionIntro = false);
                      _focus.requestFocus();
                    },
                    onQuit: _confirmQuit,
                  )
                : _QuestionView(
                    session: session,
                    onFinishSection: _confirmFinishSection,
                  ),
          ),
        ),
      ),
    );
  }
}

class _SectionIntro extends StatelessWidget {
  const _SectionIntro({
    required this.exam,
    required this.index,
    required this.onBegin,
    required this.onQuit,
  });

  final Exam exam;
  final int index;
  final VoidCallback onBegin;
  final VoidCallback onQuit;

  @override
  Widget build(BuildContext context) {
    final section = exam.sections[index];
    final total = exam.sections.length;
    final timed = section.seconds < 32000;
    return PageBody(
      maxWidth: 520,
      scrollable: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                SubtestGlyph(abbr: section.subtest.abbr, size: 44),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Eyebrow('Section ${index + 1} of $total'),
                      const SizedBox(height: 2),
                      Text(
                        section.subtest.label,
                        style: context.text.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Space.lg),
            Text(section.subtest.blurb, style: context.text.bodyMedium),
            const SizedBox(height: Space.xl),
            Row(
              children: <Widget>[
                Expanded(
                  child: _IntroStat(
                    icon: Icons.format_list_numbered_rounded,
                    value: '${section.questions.length}',
                    label: 'questions',
                  ),
                ),
                const SizedBox(width: Space.md),
                Expanded(
                  child: _IntroStat(
                    icon: Icons.timer_outlined,
                    value: timed ? '${section.minutes}' : 'None',
                    label: timed ? 'minutes' : 'time limit',
                  ),
                ),
              ],
            ),
            const SizedBox(height: Space.lg),
            if (timed)
              Callout(
                tone: PillTone.warning,
                icon: Icons.speed_rounded,
                title: 'Pace',
                text:
                    'That is about ${(section.minutes * 60 / section.questions.length).round()} '
                    'seconds per question. On the real CAT-ASVAB a blank item is '
                    'scored as a random guess, so never leave one empty.',
              ),
            const SizedBox(height: Space.xl),
            Row(
              children: <Widget>[
                FilledButton(
                  onPressed: onBegin,
                  child: const Text('Begin section'),
                ),
                const SizedBox(width: Space.md),
                TextButton(onPressed: onQuit, child: const Text('Leave exam')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroStat extends StatelessWidget {
  const _IntroStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: const EdgeInsets.all(Space.md),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 18, color: c.primary),
          const SizedBox(width: Space.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                value,
                style: context.text.titleLarge?.copyWith(color: c.textPrimary),
              ),
              Text(
                label,
                style: context.text.bodySmall?.copyWith(
                  color: c.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView({required this.session, required this.onFinishSection});

  final ExamSession session;
  final VoidCallback onFinishSection;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final served = session.current;
    final q = served.base;
    final selected = session.selectedFor(q.id);
    final displaySelected = selected == null
        ? null
        : served.order.indexOf(selected);
    final isWide = context.isMediumUp;

    return Column(
      children: <Widget>[
        _ExamHeader(session: session, onFinishSection: onFinishSection),
        Expanded(
          child: PageBody(
            maxWidth: 780,
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? Space.xxl : Space.lg,
              vertical: Space.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Eyebrow('Question'),
                    const SizedBox(width: Space.xs),
                    Text(
                      '${session.questionIndex + 1} of ${session.sectionQuestionCount}',
                      style: context.text.labelMedium?.copyWith(
                        color: c.textMuted,
                      ),
                    ),
                    const Spacer(),
                    // The real CAT never tells you how hard an item is, so the
                    // label is withheld during a mock and offered during
                    // practice, where it is useful for calibration.
                    if (session.exam.kind != ExamKind.fullMock &&
                        session.exam.kind != ExamKind.diagnostic)
                      Pill(
                        q.difficulty.label,
                        tone: q.difficulty == Difficulty.hard
                            ? PillTone.danger
                            : (q.difficulty == Difficulty.easy
                                  ? PillTone.success
                                  : PillTone.neutral),
                        dense: true,
                      ),
                  ],
                ),
                const SizedBox(height: Space.md),
                if (q.passage != null) ...<Widget>[
                  _PassageCard(text: q.passage!),
                  const SizedBox(height: Space.lg),
                ],
                if (q.figure != null) ...<Widget>[
                  McFigureView(
                    figure: q.figure!,
                    maxHeight: isWide ? 230 : 190,
                  ),
                  const SizedBox(height: Space.lg),
                ],
                if (q.puzzle != null)
                  LoosePieces(
                    pieces: q.puzzle!.pieces,
                    cell: isWide ? 24 : 20,
                    stemLabels: q.puzzle!.stemLabels,
                  ),
                if (q.puzzle != null) const SizedBox(height: Space.lg),
                Text(
                  q.stem,
                  style: context.text.headlineSmall?.copyWith(
                    fontSize: 19,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: Space.lg),
                if (q.puzzle != null)
                  GridView.count(
                    crossAxisCount: isWide ? 4 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: Space.md,
                    crossAxisSpacing: Space.md,
                    childAspectRatio: 0.95,
                    children: <Widget>[
                      for (var i = 0; i < 4; i++)
                        AssemblyOption(
                          label: String.fromCharCode(65 + i),
                          poly: q.puzzle!.silhouette(i),
                          selected: displaySelected == i,
                          cell: isWide ? 15 : 13,
                          labels: q.puzzle!.optionLabels(i),
                          onTap: () => session.answer(i),
                        ),
                    ],
                  )
                else
                  Column(
                    children: <Widget>[
                      for (var i = 0; i < served.displayChoices.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: Space.sm),
                          child: _OptionTile(
                            index: i,
                            text: served.displayChoices[i],
                            selected: displaySelected == i,
                            onTap: () => session.answer(i),
                          ),
                        ),
                      if (displaySelected != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () => session.answer(null),
                            icon: const Icon(Icons.close_rounded, size: 15),
                            label: const Text('Clear answer'),
                          ),
                        ),
                    ],
                  ),
                const Spacer(),
                _ExamFooter(session: session, onFinishSection: onFinishSection),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PassageCard extends StatelessWidget {
  const _PassageCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: c.surfaceSunken,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border(left: BorderSide(color: c.accent, width: 3)),
      ),
      child: Text(
        text,
        style: context.text.bodyMedium?.copyWith(
          color: c.textSecondary,
          height: 1.6,
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.index,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final int index;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.md),
        child: AnimatedContainer(
          duration: Motion.fast,
          padding: const EdgeInsets.symmetric(
            horizontal: Space.md,
            vertical: Space.md,
          ),
          decoration: BoxDecoration(
            color: selected ? c.primarySoft : c.surface,
            borderRadius: BorderRadius.circular(Radii.md),
            border: Border.all(
              color: selected ? c.primary : c.border,
              width: selected ? 1.8 : 1,
            ),
          ),
          child: Row(
            children: <Widget>[
              AnimatedContainer(
                duration: Motion.fast,
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? c.primary : c.surfaceSunken,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  String.fromCharCode(65 + index),
                  style: context.text.labelMedium?.copyWith(
                    color: selected ? c.onPrimary : c.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: Space.md),
              Expanded(
                child: Text(
                  text,
                  style: context.text.bodyLarge?.copyWith(
                    color: selected ? c.textPrimary : c.textSecondary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExamHeader extends StatelessWidget {
  const _ExamHeader({required this.session, required this.onFinishSection});

  final ExamSession session;
  final VoidCallback onFinishSection;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.lg,
        vertical: Space.sm,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: Row(
        children: <Widget>[
          SubtestGlyph(abbr: session.section.subtest.abbr, size: 30),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  session.exam.kind.label,
                  style: context.text.labelSmall?.copyWith(color: c.textMuted),
                ),
                Text(
                  session.section.subtest.label,
                  style: context.text.titleSmall?.copyWith(
                    color: c.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: Space.md),
          if (session.isTimed)
            TimeRing(
              label: session.timeLabel,
              fraction: session.remainingSeconds / session.section.seconds,
              critical: session.timeCritical,
            )
          else
            const Pill('Untimed'),
          const SizedBox(width: Space.md),
          TextButton(
            onPressed: session.sectionAllAnswered ? onFinishSection : null,
            child: Text(session.isLastSection ? 'Submit' : 'Finish section'),
          ),
        ],
      ),
    );
  }
}

class _ExamFooter extends StatelessWidget {
  const _ExamFooter({required this.session, required this.onFinishSection});

  final ExamSession session;
  final VoidCallback onFinishSection;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: session.sectionProgress,
            minHeight: 3,
            backgroundColor: c.surfaceSunken,
            color: c.primary,
          ),
        ),
        const SizedBox(height: Space.md),
        Row(
          children: <Widget>[
            IconButton.outlined(
              onPressed: session.questionIndex > 0 ? session.previous : null,
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              tooltip: 'Previous (left arrow)',
            ),
            const SizedBox(width: Space.sm),
            TextButton.icon(
              onPressed: session.toggleFlag,
              icon: Icon(
                session.isFlagged(session.current.id)
                    ? Icons.flag_rounded
                    : Icons.flag_outlined,
                size: 16,
                color: session.isFlagged(session.current.id) ? c.accent : null,
              ),
              label: const Text('Flag'),
            ),
            const Spacer(),
            if (session.questionIndex == session.sectionQuestionCount - 1)
              FilledButton.icon(
                onPressed: onFinishSection,
                icon: const Icon(Icons.check_rounded, size: 17),
                label: Text(
                  session.isLastSection ? 'Submit exam' : 'Finish section',
                ),
              )
            else
              FilledButton.icon(
                onPressed: session.next,
                icon: const Icon(Icons.arrow_forward_rounded, size: 17),
                label: const Text('Next'),
              ),
          ],
        ),
      ],
    );
  }
}

/// Small shim so the runner does not depend on the results screen directly.
class _ResultsForwarder extends StatelessWidget {
  const _ResultsForwarder({required this.attempt});
  final Attempt attempt;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        AppRoutes.results(context, attempt);
      }
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
