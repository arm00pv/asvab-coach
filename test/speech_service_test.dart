import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:asvab_guard_coach/core/routes.dart';
import 'package:asvab_guard_coach/core/speech.dart';
import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/engines/narration.dart';
import 'package:asvab_guard_coach/widgets/listen_button.dart';

/// A speech engine that records instead of speaking.
class FakeBackend implements SpeechBackend {
  FakeBackend({this.available = true, List<SpeechVoice>? voices})
    : _voices = voices ?? defaultVoices;

  static const defaultVoices = <SpeechVoice>[
    SpeechVoice(
      name: 'English United States',
      locale: 'en-US',
      isLocal: true,
      quality: 400,
    ),
    SpeechVoice(
      name: 'English India',
      locale: 'en-IN',
      isLocal: true,
      quality: 300,
    ),
    SpeechVoice(name: 'Spanish Spain', locale: 'es-ES', isLocal: true),
    SpeechVoice(
      name: 'Spanish Mexico (network)',
      locale: 'es-MX',
      isLocal: false,
    ),
  ];

  final bool available;
  final List<SpeechVoice> _voices;

  final List<({String text, String locale, double rate, String voice})> spoken =
      <({String text, String locale, double rate, String voice})>[];
  int stops = 0;

  void Function(SpeechEvent event)? _handler;

  /// Pretends the engine reached the end of the utterance.
  void finish() => _handler?.call(SpeechEvent.finished);

  @override
  set onEvent(void Function(SpeechEvent event)? handler) => _handler = handler;

  @override
  bool get isSupported => available;

  @override
  Future<List<SpeechVoice>> voices() async => available ? _voices : const [];

  @override
  Future<void> speak(
    String text, {
    required String locale,
    required double rate,
    required String voice,
  }) async {
    spoken.add((text: text, locale: locale, rate: rate, voice: voice));
  }

  @override
  Future<void> stop() async => stops++;

  int voiceSettingsOpened = 0;

  /// What the volume ends up at when the app asks, and how often it asked.
  int volumeAfter = 7;
  int volumeRaised = 0;

  @override
  Future<int> turnUpVolume() async {
    volumeRaised += 1;
    return volumeAfter;
  }

  @override
  Future<bool> openVoiceSettings() async {
    voiceSettingsOpened += 1;
    return true;
  }
}

const _sample = NarrationDoc(
  screenId: 'unit-test',
  title: 'Test screen',
  paragraphs: <String>['This is a test.'],
);

void main() {
  group('the spoken guide', () {
    test('starts quiet, at ordinary speed', () async {
      final backend = FakeBackend();
      final speech = SpeechService(backend: backend, persist: false);
      await speech.initialise();
      expect(speech.rate, 1.0);
      expect(speech.autoRead, isFalse);
      expect(speech.speaking, isFalse);
      expect(speech.ready, isTrue);
    });

    test('speaks the whole script in the chosen language', () async {
      final backend = FakeBackend();
      final speech = SpeechService(backend: backend, persist: false);
      await speech.initialise();
      await speech.setLanguage('en-US');
      await speech.speak(_sample);

      expect(backend.spoken, hasLength(1));
      expect(backend.spoken.single.text, _sample.text);
      expect(backend.spoken.single.locale, 'en-US');
      expect(speech.speaking, isTrue);
      expect(speech.speakingScreen, 'unit-test');
    });

    test('goes quiet when the engine says it finished', () async {
      final backend = FakeBackend();
      final speech = SpeechService(backend: backend, persist: false);
      await speech.initialise();
      await speech.speak(_sample);
      backend.finish();
      expect(speech.speaking, isFalse);
      expect(speech.speakingScreen, isNull);
    });

    test('stops on request and tells the engine to stop', () async {
      final backend = FakeBackend();
      final speech = SpeechService(backend: backend, persist: false);
      await speech.initialise();
      await speech.speak(_sample);
      await speech.stop();
      expect(backend.stops, 1);
      expect(speech.speaking, isFalse);
    });

    test('the voice the candidate picked is named to the engine', () async {
      final backend = FakeBackend();
      final speech = SpeechService(backend: backend, persist: false);
      await speech.initialise();
      await speech.setLanguage('en-IN');
      await speech.speak(_sample);
      expect(backend.spoken.single.locale, 'en-IN');
      // A device with a dozen English voices needs to be told which one: the
      // language alone leaves the engine choosing.
      expect(backend.spoken.single.voice, 'English India');
    });

    test('a speed change reaches the engine on the next utterance', () async {
      final backend = FakeBackend();
      final speech = SpeechService(backend: backend, persist: false);
      await speech.initialise();
      await speech.setRate(0.8);
      await speech.speak(_sample);
      expect(backend.spoken.single.rate, closeTo(0.8, 1e-9));
    });

    test('speed is clamped to what a lesson can bear', () async {
      final speech = SpeechService(backend: FakeBackend(), persist: false);
      await speech.initialise();
      await speech.setRate(4.0);
      expect(speech.rate, 1.3);
      await speech.setRate(0.1);
      expect(speech.rate, 0.7);
    });

    test('a voice is chosen from the ones installed, local first', () async {
      final speech = SpeechService(backend: FakeBackend(), persist: false);
      await speech.initialise();
      final best = speech.voiceFor('es-MX');
      expect(best, isNotNull);
      // es-MX itself is installed, so the exact tag wins over the local es-ES.
      expect(best!.locale, 'es-MX');

      final byLanguage = speech.voiceFor('es');
      expect(byLanguage!.locale, 'es-ES', reason: 'local beats network');
    });

    test(
      'an unknown language falls back to the same language, then to any',
      () {
        final speech = SpeechService(backend: FakeBackend(), persist: false);
        // Not initialised: no voices, so nothing to offer.
        expect(speech.voiceFor('fr-FR'), isNull);
      },
    );

    test('languages are listed once each, in a stable order', () async {
      final speech = SpeechService(backend: FakeBackend(), persist: false);
      await speech.initialise();
      expect(speech.languages, <String>['en', 'es']);
      expect(speech.voicesFor('en'), hasLength(2));
    });

    test('the language label reads like a person would say it', () async {
      final speech = SpeechService(backend: FakeBackend(), persist: false);
      await speech.initialise();
      await speech.setLanguage('es-ES');
      expect(speech.localeLabel, 'Spanish (Spain)');
    });

    test(
      'a device with no voices says so instead of failing silently',
      () async {
        final backend = FakeBackend(voices: const <SpeechVoice>[]);
        final speech = SpeechService(backend: backend, persist: false);
        await speech.initialise();
        await speech.speak(_sample);
        expect(backend.spoken, isEmpty);
        expect(speech.speaking, isFalse);
        expect(speech.lastError, contains('no voice'));
      },
    );

    test('a build with no engine reports that it cannot speak', () {
      expect(SpeechService.silent.supported, isFalse);
      expect(SpeechService.silent.voices, isEmpty);
    });

    test('empty text never reaches the engine', () async {
      final backend = FakeBackend();
      final speech = SpeechService(backend: backend, persist: false);
      await speech.initialise();
      await speech.speakText('   ');
      expect(backend.spoken, isEmpty);
    });

    test('erasing settings puts the guide back to its defaults', () async {
      final speech = SpeechService(backend: FakeBackend(), persist: false);
      await speech.initialise();
      await speech.setRate(1.2);
      await speech.setAutoRead(true);
      await speech.resetSettings();
      expect(speech.rate, 1.0);
      expect(speech.autoRead, isFalse);
    });
  });

  group('the speaker button', () {
    // The app's own theme, because every screen reads its colours from the
    // theme extension and a bare MaterialApp has none.
    Widget host(SpeechService speech, {bool active = true}) => MaterialApp(
      theme: AppTheme.build(Brightness.light),
      home: ChangeNotifierProvider<SpeechService>.value(
        value: speech,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Screen'),
            actions: <Widget>[ListenButton(doc: _sample, active: active)],
          ),
        ),
      ),
    );

    testWidgets('speaks when tapped, and stops when tapped again', (
      tester,
    ) async {
      final backend = FakeBackend();
      final speech = SpeechService(backend: backend, persist: false);
      await speech.initialise();
      await tester.pumpWidget(host(speech));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.volume_up_outlined));
      await tester.pumpAndSettle();
      expect(backend.spoken, hasLength(1));
      expect(backend.spoken.single.text, _sample.text);

      await tester.tap(find.byIcon(Icons.stop_circle_outlined));
      await tester.pumpAndSettle();
      expect(backend.stops, 1);
    });

    testWidgets('reads itself when the guide is set to, once it is in front', (
      tester,
    ) async {
      final backend = FakeBackend();
      final speech = SpeechService(backend: backend, persist: false);
      await speech.initialise();
      await speech.setAutoRead(true);

      await tester.pumpWidget(host(speech, active: false));
      await tester.pumpAndSettle();
      expect(
        backend.spoken,
        isEmpty,
        reason: 'a tab that is not in front must stay quiet',
      );

      await tester.pumpWidget(host(speech, active: true));
      await tester.pumpAndSettle();
      expect(backend.spoken, hasLength(1));
    });

    testWidgets('stays quiet on its own when the guide is off', (tester) async {
      final backend = FakeBackend();
      final speech = SpeechService(backend: backend, persist: false);
      await speech.initialise();
      await tester.pumpWidget(host(speech));
      await tester.pumpAndSettle();
      expect(backend.spoken, isEmpty);
    });

    testWidgets('speaks again when the candidate comes back to it', (
      tester,
    ) async {
      final backend = FakeBackend();
      final speech = SpeechService(backend: backend, persist: false);
      await speech.initialise();
      await speech.setAutoRead(true);

      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.build(Brightness.light),
          navigatorKey: navigator,
          navigatorObservers: <NavigatorObserver>[AppRoutes.observer],
          home: ChangeNotifierProvider<SpeechService>.value(
            value: speech,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Screen'),
                actions: <Widget>[ListenButton(doc: _sample)],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(backend.spoken, hasLength(1), reason: 'reads itself on arrival');

      navigator.currentState!.push(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('somewhere else')),
        ),
      );
      await tester.pumpAndSettle();
      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      expect(
        backend.spoken,
        hasLength(2),
        reason: 'a tab never re-mounts, so coming back has to speak again',
      );
    });

    testWidgets('leaving a screen stops the voice explaining it', (
      tester,
    ) async {
      final backend = FakeBackend();
      final speech = SpeechService(backend: backend, persist: false);
      await speech.initialise();
      await tester.pumpWidget(host(speech));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.volume_up_outlined));
      await tester.pumpAndSettle();
      expect(speech.speaking, isTrue);

      // The candidate walks away from the screen mid-sentence.
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.build(Brightness.light), home: Container()),
      );
      await tester.pumpAndSettle();
      expect(
        backend.stops,
        1,
        reason: 'the guide kept talking about a screen no longer on show',
      );
      expect(speech.speaking, isFalse);
    });

    testWidgets('explains itself when the device has no voice', (tester) async {
      final backend = FakeBackend(voices: const <SpeechVoice>[]);
      final speech = SpeechService(backend: backend, persist: false);
      // Not awaited here: with no voices the engine is re-asked on a delay, and
      // inside a widget test only the pump loop advances that clock.
      await tester.pumpWidget(host(speech));
      await tester.pump(const Duration(seconds: 3));

      await tester.tap(find.byIcon(Icons.volume_up_outlined));
      await tester.pump(const Duration(seconds: 3));
      expect(find.textContaining('no voice installed'), findsOneWidget);
      expect(backend.spoken, isEmpty);
    });
  });

  group('a phone whose media volume is at zero', () {
    test('the app can raise it and knows where it ended up', () async {
      final backend = FakeBackend();
      final speech = SpeechService(backend: backend, persist: false);
      await speech.initialise();
      expect(speech.volumeProblem, isFalse);
      expect(await speech.turnUpVolume(), 7);
      expect(backend.volumeRaised, 1);
    });

    test('the engine own sentence is recognised, and nothing else is', () {
      // Exactly what VoiceTts.kt reports after the engine wrote no samples,
      // and the reason the tutor sheet offers a button instead of advice.
      expect(
        SpeechService.isVolumeProblem(
          'The media volume on this phone is at zero, so the voice cannot be '
          'heard. Turn it up and try again.',
        ),
        isTrue,
      );
      expect(
        SpeechService.isVolumeProblem(
          'This phone has no Italian voice installed.',
        ),
        isFalse,
      );
      expect(SpeechService.isVolumeProblem(null), isFalse);
    });
  });
}
