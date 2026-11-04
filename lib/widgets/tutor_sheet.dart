import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/speech.dart';
import '../core/theme/tokens.dart';
import '../core/tutor.dart';
import '../data/models/lesson.dart';
import '../data/models/question.dart';
import '../engines/tutor_prompt.dart';
import 'listen_button.dart' show speechOf;
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
/// It is deliberately reached from Review and not from the exam runner: a model
/// that answers the question while the clock runs is not a study aid, it is a
/// way to score a mock the candidate did not earn.
Future<void> showTutorSheet(
  BuildContext context, {
  required Question question,
  required List<int> order,
  String? candidateAnswer,
}) {
  final options = <String>[
    for (final index in order)
      if (index >= 0 && index < question.choices.length)
        question.choices[index],
  ];
  return _show(
    context,
    title: 'The tutor, on this device',
    promptFor: (TutorLanguage language) => TutorPrompt.forQuestion(
      question,
      order: order,
      keyedIndex: question.answerIndex,
      explanation: question.explanation,
      candidateAnswer: candidateAnswer,
      language: language,
    ),
    options: options,
    keyedSlot: order.indexOf(question.answerIndex),
  );
}

/// The tutor on a whole lesson.
///
/// Every theme a candidate studies can now be explained: the lesson is the
/// audited text, and this asks the model to say it another way for the student it
/// did not land with. There is no key here to check, so the sheet's "it reached a
/// different option" warning is absent by construction, and the prompt forbids
/// adding facts the lesson does not contain.
Future<void> showLessonTutorSheet(
  BuildContext context, {
  required Lesson lesson,
}) {
  return _show(
    context,
    title: 'The tutor, on this lesson',
    promptFor: (TutorLanguage language) =>
        TutorPrompt.forLesson(lesson, language: language),
  );
}

Future<void> _show(
  BuildContext context, {
  required String title,
  required String Function(TutorLanguage language) promptFor,
  List<String>? options,
  int? keyedSlot,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => ChangeNotifierProvider<TutorService>.value(
      value: tutorOf(context),
      child: _TutorSheet(
        title: title,
        promptFor: promptFor,
        options: options,
        keyedSlot: keyedSlot,
      ),
    ),
  );
}

class _TutorSheet extends StatefulWidget {
  const _TutorSheet({
    required this.title,
    required this.promptFor,
    this.options,
    this.keyedSlot,
  });

  final String title;

  /// Built per language, so changing the chip regenerates in the new one.
  final String Function(TutorLanguage language) promptFor;

  /// The options as the screen draws them, for the disagreement warning. Null on
  /// a lesson, where there is nothing to disagree with.
  final List<String>? options;
  final int? keyedSlot;

  @override
  State<_TutorSheet> createState() => _TutorSheetState();
}

class _TutorSheetState extends State<_TutorSheet> {
  /// The screen id the sheet speaks under, so leaving the sheet can stop it and
  /// nothing else.
  static const _speechScreen = 'tutor';

  TutorLanguage _language = TutorLanguage.english;

  /// Held for [dispose]: a State may not read the tree once it is being torn
  /// down, and a tutor still talking after the sheet closes is a bug.
  SpeechService? _speech;

  /// The answer already read out, so handing the same text to the voice twice
  /// does not happen on a rebuild.
  String? _spoken;

  /// Why the answer could not be read aloud, when this phone has no voice for
  /// the language the tutor answered in.
  String? _readProblem;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _speech = speechOf(context);
  }

  @override
  void dispose() {
    final speech = _speech;
    if (speech != null &&
        speech.speaking &&
        speech.speakingScreen == _speechScreen) {
      speech.stop();
    }
    super.dispose();
  }

  /// Reads the answer aloud, or stops it, in the language it was written in.
  Future<void> _toggleRead() async {
    final speech = _speech ?? speechOf(context);
    final body = TutorPrompt.body(context.read<TutorService>().answer);
    if (body.isEmpty) return;
    if (speech.speaking && speech.speakingScreen == _speechScreen) {
      await speech.stop();
      return;
    }
    final problem = await speech.speakIn(
      body,
      _language.code,
      screen: _speechScreen,
    );
    if (!mounted) return;
    setState(() => _readProblem = problem);
  }

  Future<void> _run() async {
    final tutor = context.read<TutorService>();
    await tutor.ask(widget.promptFor(_language));
  }

  @override
  Widget build(BuildContext context) {
    final tutor = context.watch<TutorService>();
    final speech = speechOf(context);
    final c = context.colors;
    final answer = tutor.answer;
    final body = TutorPrompt.body(answer);
    _autoReadWhenFinished(tutor, speech);
    final options = widget.options ?? const <String>[];
    final keyedSlot = widget.keyedSlot;
    final ownAnswer = (tutor.generating || options.isEmpty || keyedSlot == null)
        ? null
        : TutorPrompt.readOwnAnswer(answer, options);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
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
                    child: Text(widget.title, style: context.text.titleSmall),
                  ),
                  if (speech.supported)
                    ListenableBuilder(
                      listenable: speech,
                      builder: (BuildContext context, Widget? child) {
                        final reading =
                            speech.speaking &&
                            speech.speakingScreen == _speechScreen;
                        return IconButton(
                          tooltip: reading ? 'Stop reading' : 'Read it aloud',
                          visualDensity: VisualDensity.compact,
                          iconSize: 20,
                          onPressed: tutor.generating ? null : _toggleRead,
                          icon: Icon(
                            reading
                                ? Icons.stop_circle_outlined
                                : Icons.volume_up_outlined,
                          ),
                        );
                      },
                    ),
                  if (tutor.generating)
                    TextButton(
                      onPressed: () => tutor.cancelGenerate(),
                      child: const Text('Stop'),
                    ),
                ],
              ),
              const SizedBox(height: Space.sm),
              _languageRow(context, tutor),
              const SizedBox(height: Space.sm),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Only while work is actually happening: an answer that
                      // came back empty used to leave this spinning for ever.
                      if (tutor.generating || tutor.loading)
                        _waiting(context, tutor),
                      Text(
                        body,
                        style: context.text.bodyMedium?.copyWith(
                          height: 1.6,
                          color: c.textPrimary,
                        ),
                      ),
                      if (body.isEmpty &&
                          answer.isNotEmpty &&
                          !tutor.generating &&
                          tutor.error == null) ...<Widget>[
                        const SizedBox(height: Space.md),
                        const Callout(
                          text:
                              'The tutor answered without explaining it. Try '
                              'again, or ask it in another language.',
                        ),
                      ],
                      if (_readProblem != null) ...<Widget>[
                        const SizedBox(height: Space.md),
                        Callout(text: _readProblem!),
                      ],
                      if (tutor.error != null) ...<Widget>[
                        const SizedBox(height: Space.md),
                        Callout(text: tutor.error!),
                        const SizedBox(height: Space.sm),
                        FilledButton.tonalIcon(
                          onPressed: _run,
                          icon: const Icon(Icons.refresh_rounded, size: 16),
                          label: const Text('Try again'),
                        ),
                      ],
                      if (ownAnswer != null &&
                          keyedSlot != null &&
                          ownAnswer.index != keyedSlot) ...[
                        const SizedBox(height: Space.lg),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(Space.md),
                          decoration: BoxDecoration(
                            color: c.warning.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(Radii.md),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Its own working reached a different option',
                                style: context.text.titleSmall?.copyWith(
                                  color: c.warning,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'It says it gets “${ownAnswer.said}”. The app '
                                'marked this question ${_keyedText(options, keyedSlot)}'
                                ' and that is the answer to learn. Treat the '
                                'working above as a second explanation, not as a '
                                'correction.',
                                style: context.text.bodySmall,
                              ),
                            ],
                          ),
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

  /// Speaks the finished answer by itself when the guide is set to read screens
  /// as they open.
  ///
  /// The tutor is for someone whose eyes are on something else - a steering
  /// wheel, a walking route, a workout - and the speaker they already turned on
  /// for the studied screens is the one they expect here too.
  void _autoReadWhenFinished(TutorService tutor, SpeechService speech) {
    if (!speech.autoRead || !speech.supported || tutor.generating) return;
    final body = TutorPrompt.body(tutor.answer);
    if (body.isEmpty || body == _spoken) return;
    _spoken = body;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final problem = await speech.speakIn(
        body,
        _language.code,
        screen: _speechScreen,
      );
      if (!mounted) return;
      setState(() => _readProblem = problem);
    });
  }

  String _keyedText(List<String> options, int slot) =>
      slot >= 0 && slot < options.length ? '“${options[slot]}”' : 'correct';

  Widget _languageRow(BuildContext context, TutorService tutor) {
    return Wrap(
      spacing: Space.sm,
      children: <Widget>[
        for (final language in TutorLanguage.values)
          ChoiceChip(
            label: Text(language.label),
            selected: _language == language,
            onSelected: (_) {
              if (_language == language) return;
              setState(() => _language = language);
              if (tutor.generating) tutor.cancelGenerate();
              _run();
            },
            labelStyle: context.text.labelSmall?.copyWith(fontSize: 11),
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }

  Widget _waiting(BuildContext context, TutorService tutor) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.lg),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  tutor.loading
                      ? 'Preparing the tutor...'
                      : 'Working it through...',
                  style: context.text.bodySmall,
                ),
                if (tutor.loading)
                  Text(
                    'The model is being loaded into memory. The first question '
                    'after opening the app is the slow one.',
                    style: context.text.bodySmall?.copyWith(color: c.textMuted),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _footnote(TutorService tutor) {
    final millis = tutor.lastMillis;
    final seconds = millis == null ? null : (millis / 1000).toStringAsFixed(1);
    final readMillis = tutor.lastReadMillis;
    final readSeconds = readMillis == null
        ? null
        : (readMillis / 1000).toStringAsFixed(1);
    final write = tutor.writeTokensPerSecond;
    final tokens = tutor.lastTokens;
    // The measured speeds, not an estimate: a candidate deciding whether to tap
    // this again deserves the numbers from their own phone. Reading the
    // question and writing the answer are counted apart, because on a phone they
    // differ by an order of magnitude.
    final took = seconds == null
        ? ''
        : 'Took $seconds s'
              '${readSeconds == null ? '' : ' ($readSeconds s of it reading the question)'}'
              '${write == null ? '' : ', then ${tokens ?? 0} tokens at ${write.toStringAsFixed(1)} tokens/s'}'
              '. ';
    final language = _language == TutorLanguage.english
        ? ''
        : 'Answering in ${_language.englishName}, from its own working; the '
              'written explanation above stays in English. ';
    return '$took$language'
        'Generated on this phone by LFM3-Omni, with no network. The written '
        'explanation above this sheet is the one that has been checked and it '
        'is the answer to learn.';
  }
}
