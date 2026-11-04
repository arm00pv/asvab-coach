import 'package:flutter/foundation.dart';

import '../data/repos/storage.dart';
import '../engines/narration.dart';
import 'neural_voice.dart';
import 'speech_backend_web.dart' if (dart.library.io) 'speech_backend_io.dart';

/// One voice the device can speak with.
class SpeechVoice {
  const SpeechVoice({
    required this.name,
    required this.locale,
    this.isLocal = true,
    this.quality = 0,
  });

  /// The engine's own name for the voice, shown when a language has several.
  final String name;

  /// A BCP-47 tag such as "en-US". Normalised from whatever the engine calls
  /// it, because engines disagree about the separator.
  final String locale;

  /// False for a voice that needs a network connection to sound. Offered, but
  /// labelled: the app promises offline speech, and a network voice is the one
  /// thing that would break that promise silently.
  final bool isLocal;

  /// Engine-specific quality, higher is better. Used only to choose a default.
  final int quality;

  /// The primary subtag, lower case: "en" for "en-US".
  String get language => locale.split(RegExp('[-_]')).first.toLowerCase();

  /// "English (United States)". The form a person recognises in a list.
  String get label {
    final name = SpeechLanguages.nameOf(language);
    final region = locale.contains('-')
        ? SpeechLanguages.regionOf(locale.split('-').last)
        : '';
    return region.isEmpty ? name : '$name ($region)';
  }

  bool get isNetwork => !isLocal;
}

/// Human names for the language and region subtags a speech engine reports.
///
/// This is presentation only: the code that is spoken with is always the
/// engine's own tag, so an unknown language still works, it just shows its tag
/// instead of a name a person would recognise.
abstract final class SpeechLanguages {
  static const _names = <String, String>{
    'af': 'Afrikaans',
    'am': 'Amharic',
    'ar': 'Arabic',
    'az': 'Azerbaijani',
    'be': 'Belarusian',
    'bg': 'Bulgarian',
    'bn': 'Bengali',
    'bs': 'Bosnian',
    'ca': 'Catalan',
    'cs': 'Czech',
    'cy': 'Welsh',
    'da': 'Danish',
    'de': 'German',
    'el': 'Greek',
    'en': 'English',
    'es': 'Spanish',
    'et': 'Estonian',
    'eu': 'Basque',
    'fa': 'Persian',
    'fi': 'Finnish',
    'fil': 'Filipino',
    'fr': 'French',
    'ga': 'Irish',
    'gl': 'Galician',
    'gu': 'Gujarati',
    'he': 'Hebrew',
    'hi': 'Hindi',
    'hr': 'Croatian',
    'hu': 'Hungarian',
    'hy': 'Armenian',
    'id': 'Indonesian',
    'is': 'Icelandic',
    'it': 'Italian',
    'ja': 'Japanese',
    'jv': 'Javanese',
    'ka': 'Georgian',
    'kk': 'Kazakh',
    'km': 'Khmer',
    'kn': 'Kannada',
    'ko': 'Korean',
    'lo': 'Lao',
    'lt': 'Lithuanian',
    'lv': 'Latvian',
    'mk': 'Macedonian',
    'ml': 'Malayalam',
    'mn': 'Mongolian',
    'mr': 'Marathi',
    'ms': 'Malay',
    'my': 'Burmese',
    'ne': 'Nepali',
    'nl': 'Dutch',
    'no': 'Norwegian',
    'pa': 'Punjabi',
    'pl': 'Polish',
    'pt': 'Portuguese',
    'ro': 'Romanian',
    'ru': 'Russian',
    'si': 'Sinhala',
    'sk': 'Slovak',
    'sl': 'Slovenian',
    'sq': 'Albanian',
    'sr': 'Serbian',
    'su': 'Sundanese',
    'sv': 'Swedish',
    'sw': 'Swahili',
    'ta': 'Tamil',
    'te': 'Telugu',
    'th': 'Thai',
    'tr': 'Turkish',
    'uk': 'Ukrainian',
    'ur': 'Urdu',
    'uz': 'Uzbek',
    'vi': 'Vietnamese',
    'zh': 'Chinese',
    'zu': 'Zulu',
  };

  static const _regions = <String, String>{
    'US': 'United States',
    'GB': 'United Kingdom',
    'IE': 'Ireland',
    'AU': 'Australia',
    'CA': 'Canada',
    'NZ': 'New Zealand',
    'IN': 'India',
    'PK': 'Pakistan',
    'BD': 'Bangladesh',
    'LK': 'Sri Lanka',
    'NP': 'Nepal',
    'PH': 'Philippines',
    'SG': 'Singapore',
    'MY': 'Malaysia',
    'ID': 'Indonesia',
    'VN': 'Vietnam',
    'TH': 'Thailand',
    'CN': 'China',
    'TW': 'Taiwan',
    'HK': 'Hong Kong',
    'JP': 'Japan',
    'KR': 'South Korea',
    'MX': 'Mexico',
    'ES': 'Spain',
    'AR': 'Argentina',
    'CO': 'Colombia',
    'CL': 'Chile',
    'PE': 'Peru',
    'VE': 'Venezuela',
    'BR': 'Brazil',
    'PT': 'Portugal',
    'FR': 'France',
    'BE': 'Belgium',
    'CH': 'Switzerland',
    'AT': 'Austria',
    'DE': 'Germany',
    'IT': 'Italy',
    'NL': 'Netherlands',
    'SE': 'Sweden',
    'NO': 'Norway',
    'DK': 'Denmark',
    'FI': 'Finland',
    'PL': 'Poland',
    'CZ': 'Czechia',
    'SK': 'Slovakia',
    'HU': 'Hungary',
    'RO': 'Romania',
    'BG': 'Bulgaria',
    'GR': 'Greece',
    'TR': 'Turkey',
    'RU': 'Russia',
    'UA': 'Ukraine',
    'IL': 'Israel',
    'SA': 'Saudi Arabia',
    'AE': 'UAE',
    'EG': 'Egypt',
    'MA': 'Morocco',
    'ZA': 'South Africa',
    'NG': 'Nigeria',
    'KE': 'Kenya',
    'ET': 'Ethiopia',
    'NG_': 'Nigeria',
  };

  /// "en" to "English"; an unknown tag is shown as it stands, upper-cased,
  /// rather than hidden - a language the app cannot name is still a language a
  /// candidate may need.
  static String nameOf(String language) {
    final key = language.toLowerCase();
    return _names[key] ?? key.toUpperCase();
  }

  /// "US" to "United States"; an unknown region shows as its code.
  static String regionOf(String region) =>
      _regions[region.toUpperCase()] ?? region.toUpperCase();
}

/// Something the engine tells the app after speech starts.
enum SpeechEvent { started, finished, failed }

/// What a platform speech engine has to be able to do.
///
/// Two implementations ship: Android's [TextToSpeech] through a method channel,
/// and the browser's own speech synthesiser for the web build. Everything above
/// this line is the same on both, which is the point - the screens never know
/// which engine is underneath.
abstract class SpeechBackend {
  /// The voices installed on this device. Empty when the engine has none.
  Future<List<SpeechVoice>> voices();

  /// Speaks [text] with a voice for [locale], replacing anything already
  /// playing.
  ///
  /// [voice] is the engine's own name for the voice the candidate picked, or
  /// empty to let the engine choose for the language. An engine that cannot
  /// address a voice by name ignores it and honours the language.
  Future<void> speak(
    String text, {
    required String locale,
    required double rate,
    required String voice,
  });

  Future<void> stop();

  /// Called when the engine starts, finishes or gives up on an utterance.
  set onEvent(void Function(SpeechEvent event)? handler);

  /// False where there is no engine at all, which is what the web build reports
  /// when the browser has no speech synthesiser.
  bool get isSupported;

  /// Opens the system screen where voices are downloaded.
  ///
  /// Voices belong to the engine, not to this app: Google ships one language and
  /// the rest are installed from Android's own settings. Returns false where
  /// there is no such screen, which is the web build and every test.
  Future<bool> openVoiceSettings() async => false;
}

/// A stand-in for a build with no engine behind it, and for a screen built
/// outside the app that has no guide at all.
class NoSpeechBackend implements SpeechBackend {
  @override
  bool get isSupported => false;

  @override
  Future<bool> openVoiceSettings() async => false;

  @override
  set onEvent(void Function(SpeechEvent event)? handler) {}

  @override
  Future<List<SpeechVoice>> voices() async => const <SpeechVoice>[];

  @override
  Future<void> speak(
    String text, {
    required String locale,
    required double rate,
    required String voice,
  }) async {}

  @override
  Future<void> stop() async {}
}

/// The spoken study guide.
///
/// One object owns every speech setting - language, speed, whether a screen
/// reads itself - so the settings page, the speaker button and the screens that
/// auto-read all read the same value and cannot disagree.
class SpeechService extends ChangeNotifier {
  SpeechService({SpeechBackend? backend, this.persist = true, this.neural})
    : _backend = backend ?? createSpeechBackend() {
    _backend.onEvent = _onEvent;
  }

  /// The guide a screen falls back to when the app is not around to provide
  /// one. It has no voices, so the button that uses it explains itself rather
  /// than failing.
  static final SpeechService silent = SpeechService(
    backend: NoSpeechBackend(),
    persist: false,
  );

  final SpeechBackend _backend;

  /// The downloaded voices, when the app has them. A pack that is installed is
  /// used instead of the system engine for its language: that is the whole
  /// point of downloading it, and it needs no second switch.
  final NeuralVoice? neural;

  /// Whether this instance writes preferences back. False in tests that only
  /// exercise the engine, and for [silent].
  final bool persist;

  List<SpeechVoice> _voices = const <SpeechVoice>[];
  bool _initialised = false;
  bool _speaking = false;
  String? _speakingScreen;
  String _locale = '';

  /// The engine's name for the chosen voice, or empty to let the engine pick
  /// for the language. Held beside the locale so a device with twelve English
  /// voices can be told which one the candidate actually picked.
  String _voiceName = '';
  double _rate = 1.0;
  bool _autoRead = false;
  String? _lastError;

  /// The voices this device has, sorted by language then name.
  List<SpeechVoice> get voices => List<SpeechVoice>.unmodifiable(_voices);

  /// True once the voice list has been read at least once.
  bool get ready => _initialised;

  /// False when the platform has no speech engine at all.
  bool get supported => _backend.isSupported;

  /// Whether anything is being said right now.
  bool get speaking => _speaking;

  /// Which screen's script is playing, so a screen can light its own button.
  String? get speakingScreen => _speakingScreen;

  /// The chosen voice's locale tag, e.g. "es-US".
  String get locale => _locale;

  /// "Spanish (United States)", or "no voice installed".
  String get localeLabel {
    if (_locale.isEmpty) return 'no voice installed';
    final match = voiceFor(_locale);
    return match?.label ?? SpeechLanguages.nameOf(_locale.split('-').first);
  }

  /// Speaking speed, 0.7 to 1.3. Below 1 is slower than the engine's default,
  /// which is what a lesson needs when the words are new.
  double get rate => _rate;

  /// Whether a screen reads itself as soon as it is the one on show.
  bool get autoRead => _autoRead;

  /// Why the last attempt to speak failed, or null.
  String? get lastError => _lastError;

  /// Languages that have at least one voice, best voice first.
  List<String> get languages {
    final seen = <String>{};
    final out = <String>[];
    for (final voice in _voices) {
      if (seen.add(voice.language)) out.add(voice.language);
    }
    return out;
  }

  /// The voices for one language subtag.
  List<SpeechVoice> voicesFor(String language) =>
      _voices.where((v) => v.language == language).toList(growable: false);

  /// The voice to speak [locale] with: an exact tag if there is one, otherwise
  /// the best local voice in the same language, otherwise the first of that
  /// language, otherwise the first voice there is.
  SpeechVoice? voiceFor(String locale) {
    if (_voices.isEmpty) return null;
    for (final v in _voices) {
      if (v.locale.toLowerCase() == locale.toLowerCase()) return v;
    }
    final language = locale.split(RegExp('[-_]')).first.toLowerCase();
    final sameLanguage = _voices.where((v) => v.language == language).toList()
      ..sort((a, b) {
        // Local before network, then quality, then name, so the choice does not
        // depend on the order the engine happened to list them in.
        if (a.isLocal != b.isLocal) return a.isLocal ? -1 : 1;
        if (a.quality != b.quality) return b.quality.compareTo(a.quality);
        return a.name.compareTo(b.name);
      });
    if (sameLanguage.isNotEmpty) return sameLanguage.first;
    return _voices.first;
  }

  /// Reads the installed voices and the saved preferences.
  ///
  /// With [persist] false nothing is read or written, which is what a test that
  /// only exercises the engine wants: preference storage is a platform plugin,
  /// and asking a bare test binding for it is a wait that never ends rather than
  /// an error that can be caught.
  Future<void> initialise() async {
    if (_initialised) return;
    var saved = const SpeechSettings();
    if (persist) {
      try {
        saved = await Storage.loadSpeech();
      } catch (_) {
        saved = const SpeechSettings();
      }
    }
    _rate = saved.rate;
    _autoRead = saved.autoRead;
    await _loadVoices(preferred: saved.locale);
    _initialised = true;
    notifyListeners();
  }

  /// Browser engines report their voices a beat after the page loads, and a
  /// fresh install can report none until the engine finishes initialising, so
  /// an empty answer is retried rather than believed.
  Future<void> _loadVoices({String preferred = ''}) async {
    for (var attempt = 0; attempt < 6; attempt++) {
      final found = await _backend.voices();
      if (found.isNotEmpty) {
        _voices = found;
        break;
      }
      if (attempt < 5) {
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
    }
    _voices = List<SpeechVoice>.of(_voices)
      ..sort((a, b) {
        final byLanguage = a.language.compareTo(b.language);
        if (byLanguage != 0) return byLanguage;
        return a.label.compareTo(b.label);
      });
    if (_voices.isEmpty) {
      _locale = '';
      _voiceName = '';
      return;
    }
    // The saved choice wins when it still exists, because a device that gained
    // voices must not quietly change the language a candidate chose. Then the
    // device's own language, then English, then whatever is there.
    final candidates = <String>[
      preferred,
      defaultLocale(),
      'en-US',
      _voices.first.locale,
    ];
    for (final candidate in candidates) {
      if (candidate.isEmpty) continue;
      final match = voiceFor(candidate);
      if (match != null &&
          match.locale.toLowerCase() == candidate.toLowerCase()) {
        _locale = match.locale;
        return;
      }
    }
    _locale =
        voiceFor(preferred.isEmpty ? _voices.first.locale : preferred)
            ?.locale ??
        _voices.first.locale;
  }

  /// The device's own language, or "en-US" when the platform will not say.
  String defaultLocale() {
    try {
      final locales = PlatformDispatcher.instance.locales;
      if (locales.isNotEmpty) {
        final tag = locales.first.toLanguageTag();
        if (tag.isNotEmpty) return tag;
      }
    } catch (_) {
      // No dispatcher (a plain unit test): fall through to the default.
    }
    return 'en-US';
  }

  /// Speaks [doc], replacing anything already playing.
  Future<void> speak(NarrationDoc doc) async {
    await speakText(doc.text, screen: doc.screenId);
  }

  /// Speaks [text] in the chosen language.
  Future<void> speakText(String text, {String screen = ''}) async {
    if (text.trim().isEmpty) return;
    if (!_initialised) await initialise();
    // A downloaded English voice wins over the system one: the guide is written
    // in English, and the pack is the reason the candidate spent 94 MB.
    if (await _speakWithNeural(text, 'en', screen)) return;
    if (_voices.isEmpty) {
      _lastError = 'This device has no voice installed for the app to use.';
      notifyListeners();
      return;
    }
    await _say(text, locale: _locale, voice: _voiceName, screen: screen);
  }

  /// Reads [text] in [language] - "es", "it", "en" - rather than in the
  /// language the guide is set to.
  ///
  /// The tutor answers in the language the candidate picked in its sheet, and
  /// an English voice reading Spanish is not a study aid, it is noise. Returns
  /// null once it has started speaking, or a sentence to show instead when this
  /// phone has no voice for that language: it is the candidate's phone, and an
  /// installed voice is something they can fix.
  Future<String?> speakIn(
    String text,
    String language, {
    String screen = '',
  }) async {
    if (text.trim().isEmpty) return null;
    if (!_initialised) await initialise();
    if (await _speakWithNeural(text, language, screen)) return null;
    final wanted = language.toLowerCase();
    final matching = voicesFor(wanted);
    if (matching.isEmpty) {
      final name = SpeechLanguages.nameOf(wanted);
      return _voices.isEmpty
          ? 'This device has no voice installed for the app to use.'
          : 'This phone has no $name voice installed, so it cannot read that '
                'answer aloud. The text above is still the explanation.';
    }
    final voice = voiceFor(matching.first.locale) ?? matching.first;
    final started = await _say(
      text,
      locale: voice.locale,
      voice: voice.name,
      screen: screen,
    );
    return started ? null : 'The voice stopped before it started.';
  }

  /// Speaks through a downloaded voice when one is installed for [language].
  ///
  /// Returns true when the neural engine took the utterance - successfully or
  /// not - so the caller does not fall through to the system voice and say the
  /// same sentence twice.
  Future<bool> _speakWithNeural(
    String text,
    String language,
    String screen,
  ) async {
    final neural = this.neural;
    if (neural == null || !neural.supported) return false;
    if (!neural.canSpeak(language)) return false;
    _lastError = null;
    _speaking = true;
    _speakingScreen = screen;
    notifyListeners();
    // The speed control is shared: a candidate who slowed the guide down gets
    // the same pace from the downloaded voice.
    final problem = await neural.speak(language, text, speed: _rate);
    _speaking = false;
    _speakingScreen = null;
    if (problem != null) _lastError = problem;
    notifyListeners();
    return true;
  }

  /// Hands one utterance to the engine. Returns false when it could not start.
  Future<bool> _say(
    String text, {
    required String locale,
    required String voice,
    required String screen,
  }) async {
    _lastError = null;
    _speaking = true;
    _speakingScreen = screen;
    notifyListeners();
    try {
      await _backend.speak(text, locale: locale, rate: _rate, voice: voice);
      return true;
    } catch (error) {
      _speaking = false;
      _speakingScreen = null;
      _lastError = 'The voice stopped before it started.';
      debugPrint('ASVAB coach: speech failed: $error');
      notifyListeners();
      return false;
    }
  }

  /// Takes the candidate to the phone's own voice settings, where more languages
  /// and better voices can be installed. False when there is nowhere to go.
  Future<bool> openVoiceSettings() async {
    try {
      return await _backend.openVoiceSettings();
    } catch (error) {
      debugPrint('ASVAB coach: could not open voice settings: $error');
      return false;
    }
  }

  /// A short sample in the current language, for the settings page.
  Future<void> preview() => speakText(
    'This is the voice that will read the screens to you.',
    screen: 'preview',
  );

  Future<void> stop() async {
    if (!_speaking) return;
    _speaking = false;
    _speakingScreen = null;
    notifyListeners();
    try {
      await _backend.stop();
    } catch (error) {
      debugPrint('ASVAB coach: could not stop speech: $error');
    }
    try {
      await neural?.stop();
    } catch (error) {
      debugPrint('ASVAB coach: could not stop the downloaded voice: $error');
    }
  }

  void _onEvent(SpeechEvent event) {
    if (event == SpeechEvent.started) return;
    // A late event from an utterance the candidate already replaced must not
    // clear the button that is now playing the next one.
    if (!_speaking) return;
    _speaking = false;
    _speakingScreen = null;
    if (event == SpeechEvent.failed) {
      _lastError = 'The voice could not finish that sentence.';
    }
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    if (language.isEmpty) return;
    final match = voiceFor(language);
    if (match == null) return;
    final speakingNow = _speaking;
    _locale = match.locale;
    _voiceName = match.name;
    notifyListeners();
    await _save();
    // Changing language mid-sentence leaves the old voice reading the old
    // language, so anything playing is restarted in the new one.
    if (speakingNow) await stop();
  }

  Future<void> setRate(double value) async {
    _rate = value.clamp(0.7, 1.3);
    notifyListeners();
    await _save();
  }

  Future<void> setAutoRead(bool value) async {
    _autoRead = value;
    if (!value) await stop();
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    if (!persist) return;
    try {
      await Storage.saveSpeech(
        SpeechSettings(locale: _locale, rate: _rate, autoRead: _autoRead),
      );
    } catch (error) {
      debugPrint('ASVAB coach: could not save speech settings: $error');
    }
  }

  /// Puts the guide back to its defaults, for the erase-everything path.
  Future<void> resetSettings() async {
    await stop();
    _rate = 1.0;
    _autoRead = false;
    _lastError = null;
    notifyListeners();
    await _save();
  }
}
