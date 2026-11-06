import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'speech.dart';

/// Android's own text-to-speech engine, through the app's method channel.
///
/// The engine is the phone's, not the app's: it speaks offline with whatever
/// voices the device already has, needs no download, and sends nothing to a
/// server. That is the whole reason the spoken guide is built on it rather than
/// on a model the app would have to carry.
class ChannelSpeechBackend implements SpeechBackend {
  ChannelSpeechBackend() {
    _channel.setMethodCallHandler(_handle);
  }

  static const MethodChannel _channel = MethodChannel('asvabcoach/speech');

  void Function(SpeechEvent event)? _onEvent;

  @override
  set onEvent(void Function(SpeechEvent event)? handler) => _onEvent = handler;

  @override
  bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<List<SpeechVoice>> voices() async {
    if (!isSupported) return const <SpeechVoice>[];
    try {
      final raw = await _channel.invokeListMethod<dynamic>('voices');
      if (raw == null) return const <SpeechVoice>[];
      final out = <SpeechVoice>[];
      for (final entry in raw) {
        if (entry is! Map) continue;
        final locale = (entry['locale'] as String?)?.trim() ?? '';
        if (locale.isEmpty) continue;
        out.add(
          SpeechVoice(
            name: (entry['name'] as String?)?.trim() ?? locale,
            locale: locale,
            isLocal: entry['local'] != false,
            quality: (entry['quality'] as num?)?.toInt() ?? 0,
          ),
        );
      }
      return out;
    } catch (error) {
      debugPrint('ASVAB coach: could not list voices: $error');
      return const <SpeechVoice>[];
    }
  }

  @override
  Future<void> speak(
    String text, {
    required String locale,
    required double rate,
    required String voice,
  }) async {
    if (!isSupported) throw StateError('No speech engine on this platform.');
    await _channel.invokeMethod<void>('speak', <String, Object>{
      'text': text,
      'locale': locale,
      'rate': rate,
      // Google's engine installs dozens of English voices; naming the one the
      // candidate picked is the difference between a setting and a gesture.
      'voice': voice,
    });
  }

  @override
  Future<int> turnUpVolume() async {
    if (!isSupported) return 0;
    try {
      return await _channel.invokeMethod<int>('turnUpVolume') ?? 0;
    } catch (error) {
      debugPrint('ASVAB coach: could not turn the volume up: $error');
      return 0;
    }
  }

  @override
  Future<bool> openVoiceSettings() async {
    if (!isSupported) return false;
    try {
      return await _channel.invokeMethod<bool>('openVoiceSettings') ?? false;
    } catch (error) {
      debugPrint('ASVAB coach: could not open voice settings: $error');
      return false;
    }
  }

  @override
  Future<void> stop() async {
    if (!isSupported) return;
    try {
      await _channel.invokeMethod<void>('stop');
    } catch (error) {
      debugPrint('ASVAB coach: could not stop speech: $error');
    }
  }

  Future<void> _handle(MethodCall call) async {
    switch (call.method) {
      case 'started':
        _onEvent?.call(SpeechEvent.started);
      case 'finished':
        _onEvent?.call(SpeechEvent.finished);
      case 'failed':
        _onEvent?.call(SpeechEvent.failed);
    }
  }
}

SpeechBackend createSpeechBackend() => ChannelSpeechBackend();
