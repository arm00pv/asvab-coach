import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routes.dart';
import '../core/theme/tokens.dart';
import '../data/bank/question_bank.dart';
import '../data/models/catalog.dart';
import '../data/models/exam.dart';
import '../data/models/question.dart';
import '../data/models/score.dart';
import '../state/app_state.dart';
import '../widgets/primitives.dart';
import '../widgets/sketch_view.dart';
import '../widgets/puzzle_view.dart';

enum _Filter { all, missed, flagged }

/// Answer-by-answer review. This is the second half of the teaching loop: the
/// score report says what went wrong, this says why.
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key, required this.attempt});

  final Attempt attempt;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  _Filter _filter = _Filter.missed;
  Subtest? _subtest;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final orders = app.ordersFor(widget.attempt.id);
    final responseById = <String, QuestionResponse>{
      for (final r in widget.attempt.responses) r.questionId: r,
    };

    final items = <_ReviewItem>[];
    for (final id in widget.attempt.questionIds) {
      final q = QuestionBank.byId(id);
      if (q == null) continue;
      final order =
          orders[id] ?? List<int>.generate(q.choices.length, (i) => i);
      final served = ServedQuestion(base: q, order: order);
      final response = responseById[id];
      items.add(_ReviewItem(served: served, response: response));
    }

    final filtered = items.where((it) {
      if (_subtest != null && it.served.base.subtest != _subtest) return false;
      switch (_filter) {
        case _Filter.all:
          return true;
        case _Filter.missed:
          return !it.correct;
        case _Filter.flagged:
          return it.response?.flagged ?? false;
      }
    }).toList();

    final present = <Subtest>[
      for (final s in Subtest.administrationOrder)
        if (items.any((i) => i.served.base.subtest == s)) s,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: Space.lg,
              vertical: Space.sm,
            ),
            child: Row(
              children: <Widget>[
                for (final f in _Filter.values) ...<Widget>[
                  _FilterChip(
                    label: switch (f) {
                      _Filter.all => 'All (${items.length})',
                      _Filter.missed =>
                        'Missed (${items.where((i) => !i.correct).length})',
                      _Filter.flagged =>
                        'Flagged (${items.where((i) => i.response?.flagged ?? false).length})',
                    },
                    selected: _filter == f,
                    onTap: () => setState(() => _filter = f),
                  ),
                  const SizedBox(width: Space.sm),
                ],
                Container(width: 1, height: 20, color: context.colors.border),
                const SizedBox(width: Space.sm),
                _FilterChip(
                  label: 'All subtests',
                  selected: _subtest == null,
                  onTap: () => setState(() => _subtest = null),
                ),
                for (final s in present) ...<Widget>[
                  const SizedBox(width: Space.sm),
                  _FilterChip(
                    label: s.abbr,
                    selected: _subtest == s,
                    onTap: () => setState(() => _subtest = s),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      body: PageBody(
        child: Column(
          children: <Widget>[
            if (filtered.isEmpty)
              const SizedBox(
                height: 320,
                child: EmptyState(
                  icon: Icons.check_circle_outline_rounded,
                  title: 'Nothing here',
                  body: 'No questions match this filter. Try another tab.',
                ),
              ),
            for (final item in filtered)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.md),
                child: _ReviewCard(item: item),
              ),
            const SizedBox(height: Space.xxl),
          ],
        ),
      ),
    );
  }
}

class _ReviewItem {
  _ReviewItem({required this.served, required this.response});

  final ServedQuestion served;
  final QuestionResponse? response;

  bool get correct => served.isCorrect(response?.selectedIndex);

  int? get displaySelected {
    final s = response?.selectedIndex;
    if (s == null) return null;
    return served.order.indexOf(s);
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? c.primary : c.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? c.primary : c.border),
        ),
        child: Text(
          label,
          style: context.text.labelMedium?.copyWith(
            color: selected ? c.onPrimary : c.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.item});
  final _ReviewItem item;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final q = item.served.base;
    final ok = item.correct;
    return AppCard(
      padding: const EdgeInsets.all(Space.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SubtestGlyph(abbr: q.subtest.abbr, size: 28),
              const SizedBox(width: Space.sm),
              Pill(
                ok ? 'Correct' : 'Missed',
                tone: ok ? PillTone.success : PillTone.danger,
                icon: ok ? Icons.check_rounded : Icons.close_rounded,
                dense: true,
              ),
              if (item.response?.flagged ?? false) ...<Widget>[
                const SizedBox(width: Space.xs),
                const Pill('Flagged', tone: PillTone.accent, dense: true),
              ],
              const Spacer(),
              Text(
                '${item.response?.secondsSpent ?? 0}s',
                style: context.text.labelSmall?.copyWith(color: c.textMuted),
              ),
            ],
          ),
          if (q.passage != null) ...<Widget>[
            const SizedBox(height: Space.md),
            Container(
              padding: const EdgeInsets.all(Space.md),
              decoration: BoxDecoration(
                color: c.surfaceSunken,
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
              child: Text(
                q.passage!,
                style: context.text.bodySmall?.copyWith(height: 1.55),
              ),
            ),
          ],
          if (q.figure != null) ...<Widget>[
            const SizedBox(height: Space.md),
            SketchView(figure: q.figure!, maxHeight: 220),
          ],
          const SizedBox(height: Space.md),
          Text(
            q.stem,
            style: context.text.titleSmall?.copyWith(
              color: c.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: Space.md),
          if (q.puzzle != null) ...<Widget>[
            LoosePieces(
              pieces: q.puzzle!.pieces,
              cell: 18,
              stemLabels: q.puzzle!.stemLabels,
            ),
            const SizedBox(height: Space.md),
            Wrap(
              spacing: Space.sm,
              runSpacing: Space.sm,
              children: <Widget>[
                for (var i = 0; i < 4; i++)
                  // Width only. A fixed 96 pixel height cut the drawing and the
                  // option letter off the bottom of every assembly tile, and the
                  // four tiles are structurally identical, so they still line up.
                  SizedBox(
                    width: 108,
                    child: AssemblyOption(
                      label: String.fromCharCode(65 + i),
                      // The figures are held in bank order; the tile in this
                      // slot plays whatever the attempt's permutation put there,
                      // so replaying an attempt shows the same picture again.
                      poly: q.puzzle!.silhouette(item.served.order[i]),
                      selected: item.displaySelected == i,
                      cell: 11,
                      labels: q.puzzle!.optionLabels(item.served.order[i]),
                      onTap: () {},
                      state: i == item.served.displayAnswerIndex
                          ? OptionState.correct
                          : (item.displaySelected == i
                                ? OptionState.wrong
                                : null),
                    ),
                  ),
              ],
            ),
          ] else
            for (var i = 0; i < item.served.displayChoices.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _ReviewOption(
                  letter: String.fromCharCode(65 + i),
                  text: item.served.displayChoices[i],
                  state: i == item.served.displayAnswerIndex
                      ? OptionState.correct
                      : (item.displaySelected == i ? OptionState.wrong : null),
                ),
              ),
          const SizedBox(height: Space.md),
          Container(
            padding: const EdgeInsets.all(Space.md),
            decoration: BoxDecoration(
              color: c.primarySoft,
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 14,
                      color: c.primary,
                    ),
                    const SizedBox(width: Space.xs),
                    Text(
                      'Why',
                      style: context.text.labelMedium?.copyWith(
                        color: c.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Space.xs),
                Text(
                  q.explanation,
                  style: context.text.bodySmall?.copyWith(
                    color: c.textSecondary,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
          _DistractorNotes(served: item.served, picked: item.displaySelected),
          const SizedBox(height: Space.md),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: <Widget>[
              for (final sid in q.skills)
                if (Skills.maybeById(sid) != null)
                  ActionChip(
                    label: Text(Skills.byId(sid).label),
                    avatar: Icon(
                      Icons.school_outlined,
                      size: 14,
                      color: c.primary,
                    ),
                    onPressed: () => AppRoutes.lesson(context, sid),
                    backgroundColor: c.surface,
                    side: BorderSide(color: c.border),
                    labelStyle: context.text.labelSmall?.copyWith(
                      color: c.textSecondary,
                      fontSize: 11,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewOption extends StatelessWidget {
  const _ReviewOption({
    required this.letter,
    required this.text,
    required this.state,
  });

  final String letter;
  final String text;
  final OptionState? state;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (bg, border, fg) = switch (state) {
      OptionState.correct => (c.successSoft, c.success, c.textPrimary),
      OptionState.wrong => (c.dangerSoft, c.danger, c.textPrimary),
      _ => (Colors.transparent, c.border, c.textSecondary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.md,
        vertical: Space.sm,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Radii.sm),
        border: Border.all(color: border),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 18,
            child: Text(
              letter,
              style: context.text.labelMedium?.copyWith(color: border),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: context.text.bodySmall?.copyWith(color: fg, height: 1.45),
            ),
          ),
          if (state == OptionState.correct)
            Icon(Icons.check_rounded, size: 15, color: c.success),
          if (state == OptionState.wrong)
            Icon(Icons.close_rounded, size: 15, color: c.danger),
        ],
      ),
    );
  }
}

/// Why the options the candidate did not pick are wrong.
///
/// The "Why" box above explains the correct answer. That is not where a
/// candidate who picked B learns anything: the lesson is in why B seemed
/// right and is not. Renders nothing for items not yet annotated.
class _DistractorNotes extends StatelessWidget {
  const _DistractorNotes({required this.served, required this.picked});

  final ServedQuestion served;
  final int? picked;

  @override
  Widget build(BuildContext context) {
    final question = served.base;
    if (question.choiceNotes.isEmpty) return const SizedBox.shrink();

    final rows = <Widget>[];
    for (var i = 0; i < served.displayChoices.length; i++) {
      final bank = served.order[i];
      if (bank == question.answerIndex) continue;
      final note = question.noteFor(bank);
      if (note == null) continue;
      final chosen = picked == i;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: Space.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 18,
                child: Text(
                  String.fromCharCode(65 + i),
                  style: context.text.labelMedium?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  chosen ? '$note (your answer)' : note,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: Space.md),
        Text(
          rows.length == 1
              ? 'Why the other option fails'
              : 'Why the others fail',
          style: context.text.labelMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        const SizedBox(height: Space.xs),
        ...rows,
      ],
    );
  }
}
