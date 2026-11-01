import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/speech.dart';
import 'state/app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<AppState>(create: (_) => AppState()..init()),
        // The spoken guide outlives any one screen: the settings page, the
        // speaker in every title bar and the auto-read in the shell all read
        // the same object, so they cannot disagree about the language.
        ChangeNotifierProvider<SpeechService>(
          create: (_) => SpeechService()..initialise(),
        ),
      ],
      child: const AsvabCoachApp(),
    ),
  );
}
