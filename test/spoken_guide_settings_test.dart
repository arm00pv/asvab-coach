import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:asvab_guard_coach/core/speech.dart';
import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/screens/settings_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';

/// A phone whose engine has exactly the voices it is given, and a record of
/// whether the settings screen was asked for.
class _Phone implements SpeechBackend {
  _Phone(this.installed);

  final List<SpeechVoice> installed;
  int settingsOpened = 0;

  @override
  Future<int> turnUpVolume() async => 0;

  @override
  bool get isSupported => true;

  @override
  set onEvent(void Function(SpeechEvent event)? handler) {}

  @override
  Future<List<SpeechVoice>> voices() async => installed;

  @override
  Future<void> speak(
    String text, {
    required String locale,
    required double rate,
    required String voice,
  }) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<bool> openVoiceSettings() async {
    settingsOpened += 1;
    return true;
  }
}

Future<void> _pump(WidgetTester tester, SpeechService speech) async {
  tester.view.physicalSize = const Size(1000, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final AppState state = AppState();
  await state.init();
  await tester.pumpWidget(
    MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<AppState>.value(value: state),
        ChangeNotifierProvider<SpeechService>.value(value: speech),
      ],
      child: MaterialApp(
        theme: AppTheme.build(Brightness.light),
        home: const SettingsScreen(),
      ),
    ),
  );
  for (int i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 120));
  }
  await tester.pumpAndSettle();
}

void main() {
  // The candidate's report: "in settings the only language shown is English".
  // That is the design - the guide's scripts are written in English - but the
  // card said nothing about why, and offered no way out of it.
  testWidgets('a phone with English only is told where the rest come from', (
    tester,
  ) async {
    final _Phone phone = _Phone(<SpeechVoice>[
      const SpeechVoice(name: 'en-us-x-sfg', locale: 'en-US', quality: 400),
    ]);
    final SpeechService speech = SpeechService(backend: phone, persist: false);
    await speech.initialise();
    await _pump(tester, speech);

    await tester.ensureVisible(find.text('Language and voice'));
    expect(find.text('English (United States)'), findsOneWidget);
    expect(
      find.textContaining('Android installs more languages'),
      findsOneWidget,
      reason: 'the reason for an English-only list has to be on the card',
    );
  });

  testWidgets('the install button opens the phone own voice settings', (
    tester,
  ) async {
    final _Phone phone = _Phone(<SpeechVoice>[
      const SpeechVoice(name: 'en-us-x-sfg', locale: 'en-US'),
    ]);
    final SpeechService speech = SpeechService(backend: phone, persist: false);
    await speech.initialise();
    await _pump(tester, speech);

    await tester.ensureVisible(find.text('Install or change voices'));
    await tester.tap(find.text('Install or change voices'));
    await tester.pump(const Duration(milliseconds: 200));

    expect(phone.settingsOpened, 1);
  });

  testWidgets('a Spanish or Italian voice is named as the tutor voice', (
    tester,
  ) async {
    final _Phone phone = _Phone(<SpeechVoice>[
      const SpeechVoice(name: 'en-us-x-sfg', locale: 'en-US'),
      const SpeechVoice(name: 'es-es-x-eef', locale: 'es-ES'),
      const SpeechVoice(name: 'it-it-x-kda', locale: 'it-IT'),
    ]);
    final SpeechService speech = SpeechService(backend: phone, persist: false);
    await speech.initialise();
    await _pump(tester, speech);

    await tester.ensureVisible(find.text('Language and voice'));
    final Finder line = find.textContaining(
      'which is what the tutor reads its answers with',
    );
    expect(line, findsOneWidget);
    expect(
      tester.widget<Text>(line).data,
      allOf(contains('Spanish'), contains('Italian')),
    );
  });

  testWidgets('unrelated languages are named once, and not offered', (
    tester,
  ) async {
    final _Phone phone = _Phone(<SpeechVoice>[
      const SpeechVoice(name: 'en-us-x-sfg', locale: 'en-US'),
      const SpeechVoice(name: 'de-de-x-abc', locale: 'de-DE'),
      const SpeechVoice(name: 'fr-fr-x-def', locale: 'fr-FR'),
      // A code the app cannot name must not be printed at the candidate.
      const SpeechVoice(name: 'brx-x-ghi', locale: 'brx-IN'),
    ]);
    final SpeechService speech = SpeechService(backend: phone, persist: false);
    await speech.initialise();
    await _pump(tester, speech);

    await tester.ensureVisible(find.text('Language and voice'));
    final Finder line = find.textContaining('It also has voices in');
    expect(line, findsOneWidget);
    expect(
      tester.widget<Text>(line).data,
      allOf(contains('French'), contains('German')),
    );
    expect(
      tester.widget<Text>(line).data,
      isNot(contains('BRX')),
      reason: 'a raw code is not a choice a person can make',
    );
    expect(
      find.textContaining("another language's sounds are noise"),
      findsOneWidget,
    );
  });
}
