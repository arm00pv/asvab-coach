import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'speech.dart';

/// The browser's own speech synthesiser.
///
/// Same bargain as the Android engine: the voices already belong to the
/// device's operating system, so the page ships no model and says nothing to a
/// server. Chrome, Edge and Safari all expose this; a browser that does not
/// reports no voices, and the app says so instead of showing a dead button.
class BrowserSpeechBackend implements SpeechBackend {
  void Function(SpeechEvent event)? _onEvent;

  @override
  set onEvent(void Function(SpeechEvent event)? handler) => _onEvent = handler;

  static JSObject? get _synthesis {
    final synth = globalContext['speechSynthesis'];
    return synth != null && synth.isA<JSObject>() ? synth as JSObject : null;
  }

  @override
  bool get isSupported =>
      _synthesis != null && globalContext['SpeechSynthesisUtterance'] != null;

  @override
  Future<List<SpeechVoice>> voices() async {
    final synth = _synthesis;
    if (synth == null) return const <SpeechVoice>[];
    final out = <SpeechVoice>[];
    try {
      final raw = synth.callMethod<JSAny?>('getVoices'.toJS);
      if (raw == null || !raw.isA<JSArray<JSAny?>>()) {
        return const <SpeechVoice>[];
      }
      for (final item in (raw as JSArray<JSAny?>).toDart) {
        if (item == null || !item.isA<JSObject>()) continue;
        final entry = item as JSObject;
        final tag = entry.getProperty<JSString?>('lang'.toJS)?.toDart ?? '';
        if (tag.trim().isEmpty) continue;
        final name = entry.getProperty<JSString?>('name'.toJS)?.toDart ?? tag;
        out.add(SpeechVoice(name: name, locale: tag.replaceAll('_', '-')));
      }
    } catch (_) {
      return const <SpeechVoice>[];
    }
    return out;
  }

  @override
  Future<void> speak(
    String text, {
    required String locale,
    required double rate,
  }) async {
    final synth = _synthesis;
    final ctor = globalContext['SpeechSynthesisUtterance'];
    if (synth == null || ctor == null || !ctor.isA<JSFunction>()) {
      throw StateError('This browser has no speech synthesiser.');
    }
    synth.callMethod<JSAny?>('cancel'.toJS);
    final utterance = (ctor as JSFunction).callAsConstructor<JSObject>(
      text.toJS,
    );
    utterance.setProperty('lang'.toJS, locale.toJS);
    utterance.setProperty('rate'.toJS, rate.toJS);
    // Choosing the voice by name is the only way the browser lets a page pick
    // one; lang alone is a request the engine may ignore.
    final match = _voiceMatching(locale);
    if (match != null) utterance.setProperty('voice'.toJS, match);
    utterance.setProperty(
      'onend'.toJS,
      (() => _onEvent?.call(SpeechEvent.finished)).toJS,
    );
    utterance.setProperty(
      'onerror'.toJS,
      (() => _onEvent?.call(SpeechEvent.failed)).toJS,
    );
    synth.callMethod<JSAny?>('speak'.toJS, utterance);
  }

  JSObject? _voiceMatching(String locale) {
    final synth = _synthesis;
    if (synth == null) return null;
    final wanted = locale.toLowerCase().replaceAll('_', '-');
    try {
      final raw = synth.callMethod<JSAny?>('getVoices'.toJS);
      if (raw == null || !raw.isA<JSArray<JSAny?>>()) return null;
      JSObject? languageMatch;
      for (final item in (raw as JSArray<JSAny?>).toDart) {
        if (item == null || !item.isA<JSObject>()) continue;
        final entry = item as JSObject;
        final tag = (entry.getProperty<JSString?>('lang'.toJS)?.toDart ?? '')
            .toLowerCase()
            .replaceAll('_', '-');
        if (tag == wanted) return entry;
        if (languageMatch == null &&
            tag.split('-').first == wanted.split('-').first) {
          languageMatch = entry;
        }
      }
      return languageMatch;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> stop() async {
    try {
      _synthesis?.callMethod<JSAny?>('cancel'.toJS);
    } catch (_) {
      // Nothing playing, or nothing to play with.
    }
  }
}

SpeechBackend createSpeechBackend() => BrowserSpeechBackend();
