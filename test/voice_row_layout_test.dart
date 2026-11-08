import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:asvab_guard_coach/core/neural_voice.dart';
import 'package:asvab_guard_coach/core/speech.dart';
import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/screens/settings_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';

/// A phone with no system voice and a channel that reports two Spanish packs.
///
/// This exists because of what the real phone drew: at 2x system text, the row
/// that names a downloaded voice put its name, "Use this voice", "Hear it" and
/// "Remove" on one line, and "Spanish (Mexico)" was squeezed to four characters
/// per line - the name was unreadable and the row was seven lines tall.
class _Phone implements SpeechBackend {
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
  }) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<int> turnUpVolume() async => 0;

  @override
  Future<bool> openVoiceSettings() async => false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel voiceChannel = MethodChannel('asvabcoach/voice');
  const EventChannel voiceEvents = EventChannel('asvabcoach/voice_events');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(voiceChannel, (MethodCall call) async {
          if (call.method == 'status') {
            return <String, Object?>{
              'supported': true,
              'packs': <String, Object?>{
                'es-piper': <String, Object?>{
                  'installed': true,
                  'bytes': 14121495,
                },
                'es-mx-piper': <String, Object?>{
                  'installed': true,
                  'bytes': 14171852,
                },
              },
            };
          }
          return true;
        });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
          voiceEvents,
          MockStreamHandler.inline(
            onListen: (Object? arguments, MockStreamHandlerEventSink sink) {},
          ),
        );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(voiceChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(voiceEvents, null);
  });

  testWidgets('two voices for one language stay readable at 2x text', (
    tester,
  ) async {
    await _pumpSettings(tester, size: const Size(360, 800), textScale: 2);

    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.text('Spanish (Mexico)'));
    await tester.pumpAndSettle();

    // Both accents are named, and each name gets a line wide enough to read: the
    // squeezed row drew four characters of it per line.
    expect(find.text('Spanish (Spain)'), findsOneWidget);
    expect(find.text('Spanish (Mexico)'), findsOneWidget);
    expect(
      tester.getSize(find.text('Spanish (Mexico)')).width,
      greaterThan(120),
      reason: 'the name must not be squeezed by the buttons beside it',
    );
    expect(find.text('Use this voice'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the accent the candidate picks is marked there and then', (
    tester,
  ) async {
    final SpeechService speech = await _pumpSettings(tester);

    await tester.ensureVisible(find.text('Spanish (Mexico)'));
    await tester.pumpAndSettle();

    // Spain comes first in the catalogue, so it is the pack in use until the
    // candidate says otherwise, and the row says so above the Mexican row.
    expect(speech.packIdFor('es'), 'es-piper');
    expect(find.text('In use'), findsOneWidget);
    final double spainRow = tester.getTopLeft(find.text('Spanish (Spain)')).dy;
    final double mexicoRow = tester
        .getTopLeft(find.text('Spanish (Mexico)'))
        .dy;
    final double marked = tester.getTopLeft(find.text('In use')).dy;
    expect(marked, greaterThan(spainRow));
    expect(marked, lessThan(mexicoRow));

    await tester.ensureVisible(find.text('Use this voice'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Use this voice'));
    await tester.pump(const Duration(milliseconds: 300));

    // Tapping saved the choice but left the page looking untouched: the section
    // listened to the packs, and the choice lives on the speech service, so
    // nothing repainted and the tap read as a dead button on the phone.
    expect(speech.packIdFor('es'), 'es-mx-piper');
    expect(
      tester.getTopLeft(find.text('In use')).dy,
      greaterThan(tester.getTopLeft(find.text('Spanish (Mexico)')).dy),
      reason: 'the row that marks the choice has to repaint when it is made',
    );
    expect(find.text('Use this voice'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

/// Pumps the settings page with both Spanish packs installed and returns the
/// speech service the page is reading, so a test can check what a tap saved.
Future<SpeechService> _pumpSettings(
  WidgetTester tester, {
  Size size = const Size(400, 900),
  double textScale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues(<String, Object>{});
  final AppState state = AppState();
  await state.init();
  final NeuralVoice neural = NeuralVoice();
  await neural.initialise();
  final SpeechService speech = SpeechService(
    backend: _Phone(),
    persist: false,
    neural: neural,
  );
  await speech.initialise();

  await tester.pumpWidget(
    MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<AppState>.value(value: state),
        ChangeNotifierProvider<SpeechService>.value(value: speech),
        ChangeNotifierProvider<NeuralVoice>.value(value: neural),
      ],
      child: MaterialApp(
        theme: AppTheme.build(Brightness.light),
        home: Builder(
          builder: (BuildContext context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: const SettingsScreen(),
          ),
        ),
      ),
    ),
  );
  for (int i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 120));
  }
  return speech;
}
