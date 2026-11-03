import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:asvab_guard_coach/core/tutor.dart';

/// The tutor as the app drives it, against a fake platform.
///
/// These exist because of a real failure on a real phone: the model is loaded on
/// a worker thread and the platform acknowledges the request before the load
/// has happened, so a question asked during the warm-up was sent to an engine
/// with no model in it. The sheet then said "The tutor could not start
/// answering" on the very first question after opening Review - the way nearly
/// everyone reaches the tutor. Nothing on a host machine showed it; this does.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel methodChannel = MethodChannel('asvabcoach/llm');
  const EventChannel eventChannel = EventChannel('asvabcoach/llm_events');

  late List<String> calls;
  late bool loaded;
  MockStreamHandlerEventSink? events;

  /// Lets the mock platform channels deliver everything they have queued.
  Future<void> settle() async {
    for (int i = 0; i < 8; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  setUp(() {
    calls = <String>[];
    loaded = false;
    events = null;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (MethodCall call) async {
          calls.add(call.method);
          switch (call.method) {
            case 'status':
              return <String, Object?>{
                'supported': true,
                'installed': true,
                'loaded': loaded,
                'bytes': 1099630080,
                'expectedBytes': 1099630080,
                'abi': 'arm64-v8a',
              };
            case 'load':
              // The platform answers at once and loads on its own thread: that
              // asymmetry is the whole point of this test.
              return <String, Object?>{'started': true};
            case 'generate':
              return true;
            case 'unload':
              loaded = false;
              return null;
          }
          return null;
        });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
          eventChannel,
          MockStreamHandler.inline(
            onListen: (Object? arguments, MockStreamHandlerEventSink sink) {
              events = sink;
            },
          ),
        );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(eventChannel, null);
  });

  test('a question waits for the load the warm-up already started', () async {
    final TutorService tutor = TutorService();
    await tutor.initialise();
    await settle();
    expect(events, isNotNull);

    // Opening Review warms the tutor up.
    unawaited(tutor.warmUp());
    await settle();
    expect(calls.where((String call) => call == 'load'), hasLength(1));

    // The candidate taps "Explain another way" before the model is in memory.
    final Future<String> pending = tutor.ask('prompt');
    await settle();
    expect(
      calls,
      isNot(contains('generate')),
      reason: 'the engine had no model yet, so asking it would fail',
    );

    loaded = true;
    events!.success(<String, Object?>{'type': 'loaded', 'millis': 4200});
    await settle();
    expect(calls, contains('generate'));

    events!.success(<String, Object?>{'type': 'token', 'text': 'Hel'});
    events!.success(<String, Object?>{
      'type': 'done',
      'text': 'Hello',
      'millis': 2000,
      'tokens': 8,
    });

    expect(await pending, 'Hello');
    expect(tutor.error, isNull);
    expect(tutor.lastLoadMillis, 4200);
    expect(tutor.tokensPerSecond, closeTo(4, 0.0001));
  });

  test('a second request during a load does not start another load', () async {
    final TutorService tutor = TutorService();
    await tutor.initialise();
    await settle();

    unawaited(tutor.warmUp());
    await settle();
    unawaited(tutor.warmUp());
    unawaited(tutor.ensureLoaded());
    await settle();

    // Two loads would mean two copies of a 1.1 GB model on one worker.
    expect(calls.where((String call) => call == 'load'), hasLength(1));

    loaded = true;
    events!.success(<String, Object?>{'type': 'loaded', 'millis': 300});
    await settle();
    expect(tutor.loaded, isTrue);
  });

  test('a load that fails is reported and the engine is never asked', () async {
    final TutorService tutor = TutorService();
    await tutor.initialise();
    await settle();

    final Future<String> pending = tutor.ask('prompt');
    await settle();
    expect(calls, contains('load'));

    // The platform reports a failed load as an event, not as a channel error.
    events!.success(<String, Object?>{
      'type': 'error',
      'message': 'The model could not be loaded into memory.',
    });
    await settle();

    expect(await pending, '');
    expect(calls, isNot(contains('generate')));
    expect(tutor.error, 'The model could not be loaded into memory.');
    expect(tutor.generating, isFalse);
  });

  test('nothing is asked of a phone that cannot run the tutor', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (MethodCall call) async {
          calls.add(call.method);
          return <String, Object?>{'supported': false, 'installed': false};
        });

    final TutorService tutor = TutorService();
    await tutor.initialise();
    await settle();

    expect(await tutor.ask('prompt'), '');
    expect(calls, isNot(contains('generate')));
    expect(calls, isNot(contains('load')));
  });
}
