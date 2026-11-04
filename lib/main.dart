import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/neural_voice.dart';
import 'core/speech.dart';
import 'core/tutor.dart';
import 'state/app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // One neural-voice object: the settings page downloads with it, and the guide
  // and the tutor speak through it, so a pack that is installed is a pack that
  // is used everywhere without a second setting saying so.
  final NeuralVoice neural = NeuralVoice();
  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<AppState>(create: (_) => AppState()..init()),
        // The spoken guide outlives any one screen: the settings page, the
        // speaker in every title bar and the auto-read in the shell all read
        // the same object, so they cannot disagree about the language.
        ChangeNotifierProvider<SpeechService>(
          create: (_) => SpeechService(neural: neural)..initialise(),
        ),
        ChangeNotifierProvider<NeuralVoice>.value(value: neural..initialise()),
        // The on-device tutor: a downloaded model, running on this phone.
        //
        // Not lazy: read the phone's status at launch, so the first screen that
        // offers the tutor already knows whether this phone has the model. A
        // lazy provider built the tutor at the moment a sheet opened, and the
        // sheet's first question reached a service that had not read the status
        // yet - which answered with nothing.
        ChangeNotifierProvider<TutorService>(
          lazy: false,
          create: (_) => TutorService()..initialise(),
        ),
      ],
      child: const AsvabCoachApp(),
    ),
  );
}
