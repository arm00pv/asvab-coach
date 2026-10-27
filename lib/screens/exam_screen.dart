import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/routes.dart';
import '../core/screen_awake.dart';
import '../core/theme/tokens.dart';
import '../data/models/catalog.dart';
import '../data/models/exam.dart';
import '../data/models/exam_snapshot.dart';
import '../data/models/score.dart';
import '../state/app_state.dart';
import '../state/exam_session.dart';
import '../widgets/charts.dart';
import '../widgets/primitives.dart';
import '../widgets/sketch_view.dart';
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
  const ExamScreen({super.key, required this.exam, this.snapshot});

  final Exam exam;

  /// When set, the runner picks this attempt up exactly where it stopped.
  final ExamSnapshot? snapshot;

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> with WidgetsBindingObserver {
  late final ExamSession session;
  final FocusNode _focus = FocusNode();
  bool _sectionIntro = true;
  int? _introIndex;

  /// What the last saved snapshot described, so the attempt is written after a
  /// real change rather than on every one-second notification.
  String _savedSignature = '';

  @override
  void initState() {
    super.initState();
    final resumed = widget.snapshot;
    session = resumed == null
        ? ExamSession(
            exam: widget.exam,
            seed: DateTime.now().millisecondsSinceEpoch,
            onSectionComplete: _handleSectionComplete,
          )
        : ExamSession.resume(
            exam: widget.exam,
            seed: DateTime.now().millisecondsSinceEpoch,
            snapshot: resumed,
            onSectionComplete: _handleSectionComplete,
          );
    session.addListener(_onSession);
    _introIndex = 0;
    // Resuming drops straight back onto the question that was on screen; the
    // section introduction has already been read.
    _sectionIntro = resumed == null;
    WidgetsBinding.instance.addObserver(this);
    // The screen must not sleep in the middle of a timed section.
    ScreenAwake.keepOn(true);
    if (_sectionIntro) {
      // Reading the introduction is not part of the section's time.
      session.pause();
    } else {
      session.start();
    }
    // After the first frame: the first save can notify listeners, and doing
    // that from initState would rebuild a watching screen mid-build.
    WidgetsBinding.instance.addPostFrameCallback((_) => _persist());
  }

  void _onSession() {
    if (!mounted) return;
    setState(() {});
    _persist();
  }

  /// Writes the attempt in progress.
  ///
  /// A phone can kill a backgrounded app at any moment, and a full mock lasts
  /// three hours. Saving on every change is what turns "the app closed and I
  /// lost everything" into "reopen and carry on".
  void _persist() {
    if (!mounted || session.finished) return;
    final signature =
        '${session.sectionIndex}:${session.questionIndex}:'
        '${session.totalAnswered}:${session.elapsedSeconds ~/ 30}:'
        '$_sectionIntro';
    if (signature == _savedSignature) return;
    _savedSignature = signature;
    final app = context.read<AppState>();
    app.setPending(session.toSnapshot());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    switch (state) {
      case AppLifecycleState.resumed:
        // The clock kept running while the app was away: charging the real
        // interval is what stops a backgrounded app from gifting time.
        session.catchUp();
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        // Last chance to save before the platform may kill us.
        _persist();
    }
  }

  @override
  void dispose() {
    ScreenAwake.keepOn(false);
    WidgetsBinding.instance.removeObserver(this);
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
        // Clamp defensively: an index one past the end would be a broken
        // section intro rather than a report.
        _introIndex = (index + 1).clamp(0, session.exam.sections.length - 1);
      });
      // The next section's clock starts when the candidate starts it.
      session.pause();
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
        title: const Text('Abandon this attempt?'),
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
              // Leaving on purpose is not an interruption: there is nothing to
              // resume, so the half-attempt must not be offered back.
              context.read<AppState>().clearPending();
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
              : 'Finish ${session.section.displayLabel}?',
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
                      session.resume();
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
    // Centred when it fits, scrollable when it does not: with the system font
    // size enlarged this card is taller than a phone held sideways.
    return PageBody(
      maxWidth: 520,
      centerVertically: true,
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
                      section.displayLabel,
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
          // A Wrap, not a Row: on a phone the two labels together are wider
          // than the column, and a Row answers that by painting an overflow
          // stripe over the primary action.
          Wrap(
            spacing: Space.md,
            runSpacing: Space.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              FilledButton(
                onPressed: onBegin,
                child: const Text('Begin section'),
              ),
              TextButton(
                onPressed: onQuit,
                child: const Text('Abandon attempt'),
              ),
            ],
          ),
        ],
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
          // Expanded, so an enlarged value wraps inside the card instead of
          // pushing the row past its edge.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  value,
                  style: context.text.titleLarge?.copyWith(
                    color: c.textPrimary,
                  ),
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
            scrollable: false,
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? Space.xxl : Space.lg,
              vertical: Space.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // The question body scrolls and the footer stays pinned.
                //
                // This column used to sit directly inside a scroll view with a
                // Spacer to push the footer down, which is a layout Flutter
                // rejects: a flex child inside an unbounded parent throws. Long
                // Paragraph Comprehension and Assembling Objects items need to
                // scroll, so the scroll belongs here and the flex belongs to the
                // bounded column above it.
                Expanded(
                  child: SingleChildScrollView(
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
                                          // Medium was neutral, which on a
                                          // light card is grey on grey: the
                                          // weakest of the three readings sat
                                          // on the most common difficulty.
                                          : PillTone.accent),
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
                          SketchView(
                            figure: q.figure!,
                            // Generous, because the drawing is the question on
                            // Mechanical Comprehension and on shop tool items. It only
                            // binds on tall diagrams, which would otherwise push the
                            // options off the fold.
                            maxHeight: isWide ? 330 : 250,
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
                              // A puzzle's figures live in bank order, while
                              // the tile in display slot i shows the option the
                              // permutation put there. Painting silhouette(i)
                              // would show one figure and grade another, so the
                              // figure is always looked up through the served
                              // order, exactly like the four option texts.
                              for (var i = 0; i < 4; i++)
                                AssemblyOption(
                                  label: String.fromCharCode(65 + i),
                                  poly: q.puzzle!.silhouette(served.order[i]),
                                  selected: displaySelected == i,
                                  cell: isWide ? 15 : 13,
                                  labels: q.puzzle!.optionLabels(
                                    served.order[i],
                                  ),
                                  onTap: () => session.answer(i),
                                ),
                            ],
                          )
                        else
                          Column(
                            children: <Widget>[
                              for (
                                var i = 0;
                                i < served.displayChoices.length;
                                i++
                              )
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: Space.sm,
                                  ),
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
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 15,
                                    ),
                                    label: const Text('Clear answer'),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Space.md),
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
                  session.section.displayLabel,
                  style: context.text.titleSmall?.copyWith(
                    color: c.textPrimary,
                  ),
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
          // Finishing early is allowed, and it runs through the same
          // confirmation as the footer. Leaving this disabled until every item
          // was answered made the control look broken rather than careful: a
          // candidate tapping it on question one got no dialog, no message and
          // no change, while the clock kept running.
          TextButton(
            onPressed: onFinishSection,
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
            // A control that does nothing must look like it does nothing:
            // on the first item there is nowhere to go back to, and the
            // outline button alone was not enough to tell the two states
            // apart - the arrow looked identical and simply did nothing.
            IconButton.outlined(
              onPressed: session.questionIndex > 0 ? session.previous : null,
              icon: Icon(
                Icons.arrow_back_rounded,
                size: 18,
                color: session.questionIndex > 0
                    ? null
                    : context.colors.textSecondary.withValues(alpha: 0.35),
              ),
              tooltip: session.questionIndex > 0
                  ? 'Previous question'
                  : 'Already at the first question',
            ),
            const SizedBox(width: Space.sm),
            // The label goes away on a phone so the primary action keeps its
            // full width instead of being squeezed off the edge.
            if (context.isCompact)
              IconButton.outlined(
                onPressed: session.toggleFlag,
                tooltip: 'Flag for review',
                icon: Icon(
                  session.isFlagged(session.current.id)
                      ? Icons.flag_rounded
                      : Icons.flag_outlined,
                  size: 18,
                  color: session.isFlagged(session.current.id)
                      ? c.accent
                      : null,
                ),
              )
            else
              TextButton.icon(
                onPressed: session.toggleFlag,
                icon: Icon(
                  session.isFlagged(session.current.id)
                      ? Icons.flag_rounded
                      : Icons.flag_outlined,
                  size: 16,
                  color: session.isFlagged(session.current.id)
                      ? c.accent
                      : null,
                ),
                label: const Text('Flag'),
              ),
            const Spacer(),
            if (session.questionIndex == session.sectionQuestionCount - 1)
              FilledButton.icon(
                onPressed: onFinishSection,
                icon: const Icon(Icons.check_rounded, size: 17),
                // On a phone the full label plus the back and flag buttons run
                // past the edge of the screen, and the header already names the
                // action, so the footer keeps the short form.
                label: Text(
                  session.isLastSection
                      ? 'Submit exam'
                      : (context.isCompact ? 'Finish' : 'Finish section'),
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
        AppRoutes.resultsReplacing(context, attempt);
      }
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
