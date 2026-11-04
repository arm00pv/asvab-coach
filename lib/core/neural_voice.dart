import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// One downloadable voice: a model, its phoneme data, and a language.
class VoicePack {
  const VoicePack({
    required this.id,
    required this.language,
    required this.label,
    required this.engine,
    required this.bytes,
    required this.sha256,
    this.speakers = const <String>[],
  });

  /// The archive's name, and the folder the app unpacks it into.
  final String id;

  /// The language subtag the app asks for: "en", "es", "it".
  final String language;

  /// What the candidate reads in the list.
  final String label;

  /// What makes the sound, named on the row: it is a real difference, not
  /// marketing - Kokoro is a different model from a Piper VITS voice.
  final String engine;

  final int bytes;
  final String sha256;

  /// The names of the speakers a multi-speaker model offers, in the order the
  /// model numbers them. Empty for a single-voice pack.
  final List<String> speakers;

  bool get hasSpeakers => speakers.length > 1;

  /// Where the archive lives. Pinned to one release, so the file behind this
  /// name cannot change without the checksum in this file changing with it.
  String get url =>
      'https://github.com/arm00pv/asvab-coach/releases/download/voices-v1/$id.tar.gz';

  String get sizeLabel => bytes <= 0
      ? 'unknown size'
      : '${(bytes / (1024 * 1024)).toStringAsFixed(0)} MB';
}

/// The packs the app knows about. Adding one is a line here plus a line in the
/// Kotlin engine's kind switch if it needs a new model family.
abstract final class VoiceCatalogue {
  static const List<VoicePack> packs = <VoicePack>[
    VoicePack(
      id: 'en-kokoro',
      language: 'en',
      label: 'English',
      engine: 'Kokoro 82M',
      bytes: 94210357,
      sha256:
          'fa22b6754cfd024b7258461b257e723c6f6eddbb183bde9ec8ea6539517f55fa',
      // Kokoro's eleven English voices, in the model's own sid order. The
      // names are the model's; the first letters separate American (a) from
      // British (b) and female (f) from male (m), which is not something to ask
      // a candidate to decode, so they are shown as names.
      speakers: <String>[
        'Heart',
        'Bella',
        'Nicole',
        'Sarah',
        'Sky',
        'Adam',
        'Michael',
        'Emma',
        'Isabella',
        'George',
        'Lewis',
      ],
    ),
    VoicePack(
      id: 'es-piper',
      language: 'es',
      label: 'Spanish',
      engine: 'Piper VITS',
      bytes: 14121495,
      sha256:
          'b48cfc9f67b49bbbcb3560a8df8f296d35d781ef10f444e44c9280d3eb0dc629',
    ),
    VoicePack(
      id: 'it-piper',
      language: 'it',
      label: 'Italian',
      engine: 'Piper VITS',
      bytes: 14060490,
      sha256:
          'aa4fd85179cbf439f961b73845b51fdbf313520c265a3b5ab317d16dbc824ab2',
    ),
  ];

  static VoicePack? forLanguage(String language) {
    final wanted = language.toLowerCase();
    for (final pack in packs) {
      if (pack.language == wanted) return pack;
    }
    return null;
  }

  static VoicePack? byId(String id) {
    for (final pack in packs) {
      if (pack.id == id) return pack;
    }
    return null;
  }
}

/// The downloaded voices.
///
/// sherpa-onnx reads the text and synthesises the audio on the phone, with the
/// pack the candidate downloaded once. No network at all after that, which is
/// the same bargain as the tutor's model - and the reason this exists: the
/// engine Android ships keeps its small, robotic voices on the device.
class NeuralVoice extends ChangeNotifier {
  NeuralVoice();

  static const MethodChannel _methods = MethodChannel('asvabcoach/voice');
  static const EventChannel _events = EventChannel('asvabcoach/voice_events');

  bool _initialised = false;
  bool _supported = false;
  bool _speaking = false;
  String? _speakingId;
  String? _error;
  String? _downloading;
  StreamSubscription<dynamic>? _subscription;
  Completer<void>? _finished;

  final Map<String, bool> _installed = <String, bool>{};
  final Map<String, int> _onDisk = <String, int>{};
  final Map<String, double> _progress = <String, double>{};

  /// True when this build carries the neural engine (arm64).
  bool get supported => _supported;

  bool get speaking => _speaking;

  String? get playingId => _speakingId;

  String? get error => _error;

  /// The pack being downloaded, or null.
  String? get downloading => _downloading;

  bool isInstalled(String id) => _installed[id] ?? false;

  /// Whether a downloaded voice can read [language] right now.
  bool canSpeak(String language) {
    final pack = VoiceCatalogue.forLanguage(language);
    return pack != null && isInstalled(pack.id);
  }

  /// How much of the pack is on disk, for the row that shows "141 MB".
  int bytesOnDisk(String id) => _onDisk[id] ?? 0;

  /// Download progress in the range 0..1 for the pack in the given id.
  double progressOf(String id) => _progress[id] ?? 0;

  Future<void> initialise() async {
    if (_initialised) return;
    _initialised = true;
    if (kIsWeb) return;
    try {
      _subscription = _events.receiveBroadcastStream().listen(
        _onEvent,
        onError: (Object error) {
          debugPrint('ASVAB coach: voice events failed: $error');
          _downloading = null;
          _speaking = false;
          _finished?.complete();
          _finished = null;
          notifyListeners();
        },
      );
    } catch (error) {
      debugPrint('ASVAB coach: no voice events on this platform: $error');
    }
    await refresh();
  }

  Future<void> refresh() async {
    if (kIsWeb) return;
    try {
      final map = await _methods.invokeMapMethod<Object?, Object?>(
        'status',
        <String, Object>{
          'ids': [for (final p in VoiceCatalogue.packs) p.id],
        },
      );
      if (map == null) return;
      _supported = map['supported'] == true;
      // The platform says why the engine would not open, which is the difference
      // between "this phone is not arm64" and a library that failed to load.
      final why = map['error'];
      if (!_supported && why is String && why.isNotEmpty) _error = why;
      final packs = map['packs'];
      if (packs is Map) {
        for (final entry in packs.entries) {
          final id = entry.key.toString();
          final value = entry.value;
          if (value is! Map) continue;
          _installed[id] = value['installed'] == true;
          _onDisk[id] = (value['bytes'] as num?)?.toInt() ?? 0;
        }
      }
      if (_supported) _error = null;
      notifyListeners();
    } on MissingPluginException {
      _supported = false;
      notifyListeners();
    } catch (error) {
      debugPrint('ASVAB coach: voice status failed: $error');
    }
  }

  /// Starts the download of [pack] and returns immediately: progress arrives as
  /// events so the row can move.
  Future<void> install(VoicePack pack) async {
    if (_downloading != null) return;
    _error = null;
    _downloading = pack.id;
    _progress[pack.id] = 0;
    notifyListeners();
    try {
      await _methods.invokeMethod<void>('install', <String, Object>{
        'id': pack.id,
        'url': pack.url,
        'bytes': pack.bytes,
        'sha256': pack.sha256,
      });
    } catch (error) {
      _downloading = null;
      _error = 'The voice download could not be started.';
      debugPrint('ASVAB coach: voice install failed: $error');
      notifyListeners();
    }
  }

  Future<void> cancel() async {
    try {
      await _methods.invokeMethod<void>('cancelInstall');
    } catch (error) {
      debugPrint('ASVAB coach: voice install cancel failed: $error');
    }
  }

  Future<void> remove(String id) async {
    try {
      await _methods.invokeMethod<void>('delete', <String, Object>{'id': id});
    } catch (error) {
      debugPrint('ASVAB coach: voice delete failed: $error');
    }
    _installed[id] = false;
    _onDisk[id] = 0;
    notifyListeners();
  }

  /// Reads [text] in [language] with the downloaded voice.
  ///
  /// Returns null once it has finished speaking, or a sentence to show instead
  /// when there is no pack for that language.
  Future<String?> speak(
    String language,
    String text, {
    double speed = 1.0,
    int speaker = 0,
  }) async {
    final pack = VoiceCatalogue.forLanguage(language);
    if (pack == null || !isInstalled(pack.id)) {
      return 'No downloaded voice for that language yet.';
    }
    final chunks = chunksOf(text);
    if (chunks.isEmpty) return null;
    if (_speaking) await stop();
    final gate = Completer<void>();
    _finished = gate;
    _error = null;
    _speaking = true;
    _speakingId = pack.id;
    notifyListeners();
    try {
      await _methods.invokeMethod<void>('speak', <String, Object>{
        'id': pack.id,
        // Sent as pieces, not as one paragraph: the engine speaks each one as
        // soon as it is made, so the first sentence is heard while the rest is
        // still being synthesised.
        'chunks': chunks,
        // A single-voice pack has only speaker 0. Sending the Kokoro voice the
        // candidate picked to a Piper model is how a voice goes silent.
        'speaker': pack.hasSpeakers ? speaker : 0,
        'speed': speed,
      });
    } catch (error) {
      _speaking = false;
      _speakingId = null;
      _finished = null;
      _error = 'The downloaded voice could not speak.';
      debugPrint('ASVAB coach: voice speak failed: $error');
      notifyListeners();
      return _error;
    }
    await gate.future;
    return null;
  }

  Future<void> stop() async {
    if (!_speaking) return;
    try {
      await _methods.invokeMethod<void>('stop');
    } catch (error) {
      debugPrint('ASVAB coach: voice stop failed: $error');
    }
    _speaking = false;
    _speakingId = null;
    _finished?.complete();
    _finished = null;
    notifyListeners();
  }

  /// Splits text into pieces the engine can speak one after another.
  ///
  /// A paragraph generated in one call is silent for as long as it takes to
  /// synthesise all of it - about four seconds for three seconds of speech on a
  /// Pixel. Sentences are the natural unit: the voice sounds the same on each,
  /// and the first one can be playing while the rest is still being computed.
  ///
  /// Nothing is dropped: joining the pieces gives back the text, and a piece
  /// longer than [maxChars] is broken at a word boundary so one long sentence
  /// cannot hold the first sound hostage.
  static List<String> chunksOf(String text, {int maxChars = 160}) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return const <String>[];
    final sentences = <String>[];
    final buffer = StringBuffer();
    for (var i = 0; i < trimmed.length; i++) {
      final character = trimmed[i];
      buffer.write(character);
      final endsSentence =
          character == '.' ||
          character == '!' ||
          character == '?' ||
          character == ';' ||
          character == '\n';
      final followedBySpace =
          i + 1 >= trimmed.length || trimmed[i + 1].trim().isEmpty;
      // Four words is enough for a voice to settle into a rhythm; splitting
      // after "Yes." sounds worse than saying both halves together.
      if (endsSentence && followedBySpace && buffer.length >= 40) {
        sentences.add(buffer.toString().trim());
        buffer.clear();
      }
    }
    if (buffer.isNotEmpty) sentences.add(buffer.toString().trim());

    // Merge the short ones forward so a run of small sentences is not a run of
    // small gaps between the audio.
    final merged = <String>[];
    var pending = '';
    for (final sentence in sentences) {
      pending = pending.isEmpty ? sentence : '$pending $sentence';
      if (pending.length >= 40) {
        merged.add(pending);
        pending = '';
      }
    }
    if (pending.isNotEmpty) {
      if (merged.isEmpty) {
        merged.add(pending);
      } else {
        merged[merged.length - 1] = '${merged.last} $pending';
      }
    }

    final out = <String>[];
    for (final piece in merged) {
      out.addAll(_splitLong(piece, maxChars));
    }
    return out.where((String piece) => piece.trim().isNotEmpty).toList();
  }

  static List<String> _splitLong(String piece, int maxChars) {
    if (piece.length <= maxChars) return <String>[piece];
    final out = <String>[];
    var rest = piece;
    while (rest.length > maxChars) {
      var cut = rest.lastIndexOf(' ', maxChars);
      if (cut <= 0) cut = maxChars;
      out.add(rest.substring(0, cut).trim());
      rest = rest.substring(cut).trim();
    }
    if (rest.isNotEmpty) out.add(rest);
    return out;
  }

  void _onEvent(dynamic raw) {
    if (raw is! Map) return;
    final type = raw['type'];
    final id = (raw['id'] as String?) ?? '';
    switch (type) {
      case 'download':
        final received = (raw['received'] as num?)?.toInt() ?? 0;
        final total = (raw['total'] as num?)?.toInt() ?? 0;
        _downloading = id;
        if (total > 0) _progress[id] = (received / total).clamp(0.0, 1.0);
        notifyListeners();
      case 'installed':
        _downloading = null;
        _progress.remove(id);
        _installed[id] = true;
        _error = null;
        notifyListeners();
        refresh();
      case 'error':
        _downloading = null;
        _progress.remove(id);
        _error = (raw['message'] as String?) ?? 'The downloaded voice failed.';
        // An engine that could not speak still has to release the caller, or the
        // button spins until the app is closed.
        _speaking = false;
        _speakingId = null;
        notifyListeners();
        _finished?.complete();
        _finished = null;
      case 'started':
        _speaking = true;
        _speakingId = id;
        notifyListeners();
      case 'finished':
        _speaking = false;
        _speakingId = null;
        notifyListeners();
        _finished?.complete();
        _finished = null;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _finished?.complete();
    super.dispose();
  }
}
