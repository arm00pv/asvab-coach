import 'package:flutter_test/flutter_test.dart';

import 'package:asvab_guard_coach/core/speech.dart';

/// A phone with a fixed set of voices, and a record of what was said.
class _FakeBackend implements SpeechBackend {
  _FakeBackend(this.installed);

  final List<SpeechVoice> installed;
  final List<String> said = <String>[];
  final List<String> used = <String>[];

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
  }) async {
    said.add(text);
    used.add('$locale|$voice|$rate');
  }

  @override
  Future<void> stop() async {}
}

SpeechVoice _voice(String locale, {String? name, int quality = 0}) =>
    SpeechVoice(name: name ?? locale, locale: locale, quality: quality);

void main() {
  test(
    'a Spanish answer is read with the Spanish voice, not the guide one',
    () async {
      final _FakeBackend backend = _FakeBackend(<SpeechVoice>[
        _voice('en-US', name: 'en-us-x-sfg#male_1-local', quality: 400),
        _voice('es-US', name: 'es-us-x-esd-local', quality: 300),
      ]);
      final SpeechService speech = SpeechService(
        backend: backend,
        persist: false,
      );
      await speech.initialise();

      // The guide itself is set to English; the tutor answered in Spanish.
      expect(speech.locale, 'en-US');

      final String? problem = await speech.speakIn(
        'Multiplicar dos negativos da positivo.',
        'es',
        screen: 'tutor',
      );

      expect(problem, isNull);
      expect(speech.speaking, isTrue);
      expect(speech.speakingScreen, 'tutor');
      expect(backend.used.single, startsWith('es-US|es-us-x-esd-local|'));
    },
  );

  test(
    'a language with no voice says so instead of reading it wrongly',
    () async {
      final _FakeBackend backend = _FakeBackend(<SpeechVoice>[
        _voice('en-US', name: 'en-us-x-sfg#male_1-local'),
      ]);
      final SpeechService speech = SpeechService(
        backend: backend,
        persist: false,
      );
      await speech.initialise();

      final String? problem = await speech.speakIn('La soluzione e 5.', 'it');

      expect(problem, isNotNull);
      expect(problem, contains('Italian'));
      expect(backend.said, isEmpty);
      expect(speech.speaking, isFalse);
      // A missing voice is not a failure of the guide, so it is not stored as one.
      expect(speech.lastError, isNull);
    },
  );

  test('the candidate\'s reading speed is kept for the tutor too', () async {
    final _FakeBackend backend = _FakeBackend(<SpeechVoice>[_voice('en-US')]);
    final SpeechService speech = SpeechService(
      backend: backend,
      persist: false,
    );
    await speech.initialise();
    await speech.setRate(0.8);

    await speech.speakIn('Because the two negatives cancel.', 'en');

    expect(backend.used.single, contains('|0.8'));
  });

  test('nothing is spoken from empty text', () async {
    final _FakeBackend backend = _FakeBackend(<SpeechVoice>[_voice('en-US')]);
    final SpeechService speech = SpeechService(
      backend: backend,
      persist: false,
    );
    await speech.initialise();

    expect(await speech.speakIn('   ', 'en'), isNull);
    expect(backend.said, isEmpty);
  });
}
