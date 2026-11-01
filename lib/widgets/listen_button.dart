import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/speech.dart';
import '../core/theme/tokens.dart';
import '../engines/narration.dart';

/// The app's speech service, or a silent stand-in.
///
/// A screen can be built without the app around it - which is exactly what the
/// widget tests do - and a missing guide must not be a crash. The stand-in
/// reports no voices, so the button says so instead of pretending to speak.
SpeechService speechOf(BuildContext context) {
  try {
    return Provider.of<SpeechService>(context, listen: false);
  } catch (_) {
    return SpeechService.silent;
  }
}

/// The speaker that sits beside every screen's title.
///
/// One button, one behaviour, wherever it is: tap to hear this screen explained
/// in the chosen language, tap again to stop. When the guide is set to read
/// screens by itself, a screen speaks as it comes to the front - [active] is how
/// a screen that stays mounted in a tab stack says whether it is the one on
/// show, so five tabs do not all start talking at once.
class ListenButton extends StatefulWidget {
  const ListenButton({
    super.key,
    required this.doc,
    this.active = true,
    this.iconSize = 22,
  });

  /// The script for the screen this button belongs to.
  ///
  /// Rebuilt with the screen, so the numbers spoken are the numbers shown.
  final NarrationDoc doc;

  /// Whether this screen is the one in front. False leaves the button live but
  /// stops auto-read from firing while the candidate is looking elsewhere.
  final bool active;

  final double iconSize;

  @override
  State<ListenButton> createState() => _ListenButtonState();
}

class _ListenButtonState extends State<ListenButton> {
  /// Held so [dispose] can reach the guide: a State may not read the tree once
  /// it is being torn down.
  SpeechService? _speech;

  @override
  void initState() {
    super.initState();
    _maybeReadAloud();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _speech = speechOf(context);
  }

  @override
  void dispose() {
    final speech = _speech;
    // Leaving a screen must stop its script. Without this, walking out of a
    // lesson while it is being read leaves the voice explaining a screen the
    // candidate is no longer looking at.
    if (speech != null &&
        speech.speaking &&
        speech.speakingScreen == widget.doc.screenId) {
      speech.stop();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(ListenButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.active && widget.active) _maybeReadAloud();
  }

  /// Auto-read, after the frame: speaking during build would notify listeners
  /// while the tree is being built.
  void _maybeReadAloud() {
    if (!widget.active) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final speech = speechOf(context);
      if (!speech.supported) return;
      if (!speech.ready) {
        // The app asks for the voices at launch; a screen built on its own has
        // to ask for them itself.
        speech.initialise();
        return;
      }
      if (!speech.autoRead || speech.voices.isEmpty) return;
      speech.speak(widget.doc);
    });
  }

  Future<void> _toggle(SpeechService speech) async {
    if (speech.speaking && speech.speakingScreen == widget.doc.screenId) {
      await speech.stop();
      return;
    }
    if (!speech.ready) await speech.initialise();
    if (!speech.supported) {
      _say(
        'This build has no speech engine here. The guide speaks on the phone, '
        'and in a web page whose device has voices installed.',
      );
      return;
    }
    if (speech.voices.isEmpty) {
      _say(
        'This device has no voice installed for the app to use. Add a text to '
        'speech voice in the system settings, then open this screen again.',
      );
      return;
    }
    await speech.speak(widget.doc);
  }

  void _say(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final speech = speechOf(context);
    return ListenableBuilder(
      listenable: speech,
      builder: (context, _) {
        final playing =
            speech.speaking && speech.speakingScreen == widget.doc.screenId;
        final c = context.colors;
        return IconButton(
          onPressed: () => _toggle(speech),
          tooltip: playing
              ? 'Stop the guide'
              : 'Hear this screen explained out loud',
          iconSize: widget.iconSize,
          icon: Icon(
            playing ? Icons.stop_circle_outlined : Icons.volume_up_outlined,
            color: playing ? c.primary : null,
          ),
        );
      },
    );
  }
}
