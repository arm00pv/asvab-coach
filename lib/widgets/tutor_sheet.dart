import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/tokens.dart';
import '../core/tutor.dart';
import '../data/models/question.dart';
import '../engines/tutor_prompt.dart';
import 'primitives.dart';

/// The tutor service, or a stand-in that reports itself unavailable.
///
/// Screens are built without the app around them in the widget tests, and a
/// missing tutor must not be a crash.
TutorService tutorOf(BuildContext context) {
  try {
    return Provider.of<TutorService>(context, listen: false);
  } catch (_) {
    return TutorService();
  }
}

/// Opens the tutor on one question.
///
/// It is deliberately reached from Review and not from the exam runner: a
/// model that answers the question while the clock runs is not a study aid,
/// it is a way to score a mock the candidate did not earn.
Future<void> showTutorSheet(
  BuildContext context, {
  required Question question,
  required List<int> order,
  String? candidateAnswer,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => ChangeNotifierProvider<TutorService>.value(
      value: tutorOf(context),
      child: _TutorSheet(
        question: question,
        order: order,
        candidateAnswer: candidateAnswer,
      ),
    ),
  );
}

class _TutorSheet extends StatefulWidget {
  const _TutorSheet({
    required this.question,
    required this.order,
    this.candidateAnswer,
  });

  final Question question;
  final List<int> order;
  final String? candidateAnswer;

  @override
  State<_TutorSheet> createState() => _TutorSheetState();
}

class _TutorSheetState extends State<_TutorSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    final tutor = context.read<TutorService>();
    await tutor.ask(
      TutorPrompt.forQuestion(
        widget.question,
        order: widget.order,
        candidateAnswer: widget.candidateAnswer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tutor = context.watch<TutorService>();
    final c = context.colors;
    final answer = tutor.answer;
    final finished = !tutor.generating && answer.isNotEmpty;
    final options = <String>[
      for (final index in widget.order)
        if (index >= 0 && index < widget.question.choices.length)
          widget.question.choices[index],
    ];
    final choice = finished ? TutorPrompt.readChoice(answer, options) : null;
    final keyedSlot = widget.order.indexOf(widget.question.answerIndex);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.psychology_alt_outlined,
                    size: 18,
                    color: c.primary,
                  ),
                  const SizedBox(width: Space.sm),
                  Expanded(
                    child: Text(
                      'The tutor, on this device',
                      style: context.text.titleSmall,
                    ),
                  ),
                  if (tutor.generating)
                    TextButton(
                      onPressed: () => tutor.cancelGenerate(),
                      child: const Text('Stop'),
                    ),
                ],
              ),
              const SizedBox(height: Space.sm),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (answer.isEmpty && tutor.error == null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Space.lg,
                          ),
                          child: Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: Space.md),
                              Text(
                                'Working it through...',
                                style: context.text.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      Text(
                        _visible(answer),
                        style: context.text.bodyMedium?.copyWith(
                          height: 1.6,
                          color: c.textPrimary,
                        ),
                      ),
                      if (tutor.error != null) ...<Widget>[
                        const SizedBox(height: Space.md),
                        Callout(text: tutor.error!),
                      ],
                      if (choice != null) ...<Widget>[
                        const SizedBox(height: Space.lg),
                        _Verdict(
                          agrees: choice.index == keyedSlot,
                          named: choice.said,
                          keyed: keyedSlot >= 0 && keyedSlot < options.length
                              ? options[keyedSlot]
                              : '',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Space.md),
              Text(
                _footnote(tutor),
                style: context.text.bodySmall?.copyWith(
                  color: c.textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _visible(String answer) {
    if (answer.isEmpty) return '';
    final body = TutorPrompt.body(answer);
    return body.isEmpty ? answer : body;
  }

  String _footnote(TutorService tutor) {
    final millis = tutor.lastMillis;
    final seconds = millis == null ? null : (millis / 1000).toStringAsFixed(1);
    final took = seconds == null ? '' : 'Took $seconds s. ';
    return 'Generated on this phone by LFM3-Omni, with no network. $took'
        'The written explanation above this sheet is the one that has been '
        'checked; this is a second voice on the same problem.';
  }
}

/// What to do about the option the tutor named.
class _Verdict extends StatelessWidget {
  const _Verdict({
    required this.agrees,
    required this.named,
    required this.keyed,
  });

  final bool agrees;
  final String named;
  final String keyed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Space.md),
      decoration: BoxDecoration(
        color: agrees ? c.primarySoft : c.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            agrees
                ? 'It lands on the same option this app does.'
                : 'It landed somewhere else.',
            style: context.text.titleSmall?.copyWith(
              color: agrees ? c.primary : c.warning,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            agrees
                ? '“$named” - matching the keyed answer.'
                : 'It chose “$named”. This app’s checked answer is '
                      '“$keyed”. Keep the checked one: the model is a second '
                      'explanation, not a second opinion you can check.',
            style: context.text.bodySmall,
          ),
        ],
      ),
    );
  }
}
