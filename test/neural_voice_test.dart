import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:asvab_guard_coach/core/neural_voice.dart';
import 'package:asvab_guard_coach/core/speech.dart';

/// The downloaded voices, against a fake platform.
///
/// The pieces worth pinning are the ones a phone would otherwise be the only
/// place to find: a pack that is installed is used for its language, a download
/// that is in progress reports progress and cannot be started twice, and a
/// finished utterance releases whoever is waiting for it.
/// A system engine that records what it was asked to say.
class _SystemEngine implements SpeechBackend {
  final List<String> spoken = <String>[];

  @override
  bool get isSupported => true;

  @override
  set onEvent(void Function(SpeechEvent event)? handler) {}

  @override
  Future<List<SpeechVoice>> voices() async => const <SpeechVoice>[
    SpeechVoice(name: 'en-us-x-sfg', locale: 'en-US'),
  ];

  @override
  Future<void> speak(
    String text, {
    required String locale,
    required double rate,
    required String voice,
  }) async {
    spoken.add(text);
  }

  @override
  Future<void> stop() async {}

  @override
  Future<bool> openVoiceSettings() async => false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel voiceChannel = MethodChannel('asvabcoach/voice');
  const EventChannel voiceEvents = EventChannel('asvabcoach/voice_events');

  late List<String> calls;
  late Map<String, Object?> statusPacks;
  MockStreamHandlerEventSink? events;

  Future<void> settle() async {
    for (int i = 0; i < 8; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  setUp(() {
    calls = <String>[];
    statusPacks = <String, Object?>{};
    events = null;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(voiceChannel, (MethodCall call) async {
          calls.add(call.method);
          switch (call.method) {
            case 'status':
              return <String, Object?>{'supported': true, 'packs': statusPacks};
            case 'install':
            case 'speak':
            case 'stop':
            case 'delete':
            case 'cancelInstall':
              return true;
          }
          return null;
        });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
          voiceEvents,
          MockStreamHandler.inline(
            onListen: (Object? arguments, MockStreamHandlerEventSink sink) {
              events = sink;
            },
          ),
        );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(voiceChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(voiceEvents, null);
  });

  test('a pack that is on the phone is the voice for its language', () async {
    statusPacks = <String, Object?>{
      'en-kokoro': <String, Object?>{'installed': true, 'bytes': 94210357},
      'es-piper': <String, Object?>{'installed': false, 'bytes': 0},
    };
    final NeuralVoice neural = NeuralVoice();
    await neural.initialise();
    await settle();

    expect(neural.supported, isTrue);
    expect(neural.canSpeak('en'), isTrue);
    expect(neural.canSpeak('es'), isFalse);
    expect(neural.canSpeak('it'), isFalse);
    expect(neural.bytesOnDisk('en-kokoro'), 94210357);
  });

  test('a download reports progress, then installs', () async {
    final NeuralVoice neural = NeuralVoice();
    await neural.initialise();
    await settle();

    final VoicePack pack = VoiceCatalogue.byId('es-piper')!;
    unawaited(neural.install(pack));
    await settle();
    expect(neural.downloading, 'es-piper');
    expect(calls, contains('install'));

    events!.success(<String, Object?>{
      'type': 'download',
      'id': 'es-piper',
      'received': 7000000,
      'total': 14121495,
    });
    await settle();
    expect(neural.progressOf('es-piper'), closeTo(0.5, 0.02));

    events!.success(<String, Object?>{'type': 'installed', 'id': 'es-piper'});
    await settle();
    expect(neural.downloading, isNull);
    expect(neural.canSpeak('es'), isTrue);
  });

  test('a failed download says so and does not look installed', () async {
    final NeuralVoice neural = NeuralVoice();
    await neural.initialise();
    await settle();
    unawaited(neural.install(VoiceCatalogue.byId('en-kokoro')!));
    await settle();

    events!.success(<String, Object?>{
      'type': 'error',
      'id': 'en-kokoro',
      'message': 'The voice download did not match its checksum.',
    });
    await settle();

    expect(neural.downloading, isNull);
    expect(neural.isInstalled('en-kokoro'), isFalse);
    expect(neural.error, contains('checksum'));
  });

  test('speaking waits for the engine to finish', () async {
    statusPacks = <String, Object?>{
      'en-kokoro': <String, Object?>{'installed': true, 'bytes': 94210357},
    };
    final NeuralVoice neural = NeuralVoice();
    await neural.initialise();
    await settle();

    final Future<String?> spoken = neural.speak('en', 'Hello there.');
    await settle();
    expect(neural.speaking, isTrue);
    expect(calls, contains('speak'));

    events!.success(<String, Object?>{'type': 'finished', 'id': 'en-kokoro'});
    expect(await spoken, isNull);
    expect(neural.speaking, isFalse);
  });

  test('a downloaded voice is preferred over the system one', () async {
    statusPacks = <String, Object?>{
      'en-kokoro': <String, Object?>{'installed': true, 'bytes': 94210357},
    };
    final NeuralVoice neural = NeuralVoice();
    await neural.initialise();
    await settle();
    final _SystemEngine system = _SystemEngine();
    final SpeechService speech = SpeechService(
      backend: system,
      persist: false,
      neural: neural,
    );
    await speech.initialise();

    final Future<void> spoken = speech.speakText('Read this, please.');
    await settle();
    expect(calls, contains('speak'), reason: 'the pack should be used');
    events!.success(<String, Object?>{'type': 'finished', 'id': 'en-kokoro'});
    await spoken;

    expect(
      system.spoken,
      isEmpty,
      reason: 'the system voice must not read the same sentence too',
    );
  });

  test('a phone without the engine is asked for nothing', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(voiceChannel, (MethodCall call) async {
          calls.add(call.method);
          return <String, Object?>{
            'supported': false,
            'packs': <String, Object?>{},
          };
        });
    final NeuralVoice neural = NeuralVoice();
    await neural.initialise();
    await settle();

    expect(neural.supported, isFalse);
    expect(await neural.speak('en', 'Hello.'), contains('No downloaded voice'));
    expect(calls, isNot(contains('speak')));
  });
}
