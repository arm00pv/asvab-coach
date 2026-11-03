import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// What the device can do right now, as the platform reports it.
class TutorStatus {
  const TutorStatus({
    this.supported = false,
    this.loaded = false,
    this.installed = false,
    this.downloading = false,
    this.abi = 'unknown',
    this.path = '',
    this.bytes = 0,
    this.expectedBytes = 0,
    this.error,
  });

  /// True when the engine library opened and reports itself usable. False on
  /// 32-bit phones, on the web build, and wherever the native library is not
  /// packaged.
  final bool supported;

  /// The model is in memory and answering.
  final bool loaded;

  /// The model file is on the device and the right size.
  final bool installed;

  final bool downloading;
  final String abi;
  final String path;
  final int bytes;
  final int expectedBytes;

  /// Why the engine could not open, when it could not.
  final String? error;

  static const unknown = TutorStatus();

  factory TutorStatus.fromMap(Map<Object?, Object?> map) => TutorStatus(
    supported: map['supported'] == true,
    loaded: map['loaded'] == true,
    installed: map['installed'] == true,
    downloading: map['downloading'] == true,
    abi: (map['abi'] as String?) ?? 'unknown',
    path: (map['path'] as String?) ?? '',
    bytes: (map['bytes'] as num?)?.toInt() ?? 0,
    expectedBytes: (map['expectedBytes'] as num?)?.toInt() ?? 0,
    error: map['error'] as String?,
  );

  /// "1.02 GB", for a settings row.
  String get sizeLabel => expectedBytes <= 0
      ? 'unknown size'
      : '${(expectedBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}

/// The on-device tutor.
///
/// Every byte of this runs on the phone: the model is downloaded once, kept in
/// the app's own files, loaded into memory by llama.cpp and sampled there. No
/// request leaves the device, which is the whole point - a candidate revising
/// on a range with no signal is the candidate this exists for.
class TutorService extends ChangeNotifier {
  TutorService();

  static const _methods = MethodChannel('asvabcoach/llm');
  static const _events = EventChannel('asvabcoach/llm_events');

  /// How long the model is kept in memory after the last question. Holding
  /// 1.9 GB on a phone that has gone back to the home screen is how an app gets
  /// killed by the low-memory killer mid-revision.
  static const idleUnload = Duration(minutes: 12);

  TutorStatus _status = TutorStatus.unknown;
  bool _initialised = false;
  bool _generating = false;
  bool _loading = false;
  Timer? _idle;
  String _answer = '';
  String? _error;
  int? _lastMillis;
  int? _lastTokens;
  int? _lastLoadMillis;
  int _received = 0;
  int _total = 0;
  StreamSubscription<dynamic>? _subscription;
  Completer<String>? _pending;

  TutorStatus get status => _status;
  bool get ready => _initialised;

  /// The engine can run here at all.
  bool get supported => _status.supported;

  /// The model file is here and loaded.
  bool get loaded => _status.loaded;

  /// The model file is here.
  bool get installed => _status.installed;

  /// The tutor can be used right now: installed and supported.
  bool get usable => _status.supported && _status.installed;

  bool get downloading => _status.downloading;
  bool get generating => _generating;

  /// The model is being read into memory right now. The first question after a
  /// cold start takes seconds, and the sheet says so instead of pretending to
  /// think.
  bool get loading => _loading;

  /// The answer being streamed, so a sheet can draw it as it arrives.
  String get answer => _answer;

  /// How long the last answer took, for the sheet's small print.
  int? get lastMillis => _lastMillis;

  /// How many tokens the engine sampled for the last answer.
  int? get lastTokens => _lastTokens;

  /// How long the model took to read into memory, in milliseconds.
  int? get lastLoadMillis => _lastLoadMillis;

  /// Sampling speed of the last answer, or null before there is one.
  double? get tokensPerSecond {
    final millis = _lastMillis;
    final tokens = _lastTokens;
    if (millis == null || tokens == null || millis <= 0 || tokens <= 0) {
      return null;
    }
    return tokens * 1000 / millis;
  }

  String? get error => _error;

  /// Download progress in the range 0..1.
  double get downloadProgress {
    if (_total <= 0) return 0;
    return (_received / _total).clamp(0.0, 1.0);
  }

  Future<void> initialise() async {
    if (_initialised) return;
    _initialised = true;
    if (kIsWeb) return;
    try {
      _subscription = _events.receiveBroadcastStream().listen(_onEvent);
    } catch (error) {
      debugPrint('ASVAB coach: no tutor events on this platform: $error');
    }
    await refresh();
  }

  Future<void> refresh() async {
    if (kIsWeb) return;
    try {
      final map = await _methods.invokeMapMethod<Object?, Object?>('status');
      if (map == null) return;
      _status = TutorStatus.fromMap(map);
      notifyListeners();
    } on MissingPluginException {
      _status = TutorStatus.unknown;
      notifyListeners();
    } catch (error) {
      debugPrint('ASVAB coach: tutor status failed: $error');
    }
  }

  /// Starts the one download, and returns immediately: progress arrives as
  /// events so the settings row can move.
  Future<void> install() async {
    _error = null;
    _received = 0;
    _total = _status.expectedBytes;
    try {
      final map = await _methods.invokeMapMethod<Object?, Object?>('install');
      if (map != null) {
        _status = TutorStatus.fromMap(map);
        notifyListeners();
      }
    } catch (error) {
      _error = 'The download could not be started.';
      debugPrint('ASVAB coach: tutor install failed: $error');
      notifyListeners();
    }
  }

  Future<void> cancelInstall() async {
    try {
      await _methods.invokeMethod<void>('cancelInstall');
      await refresh();
    } catch (error) {
      debugPrint('ASVAB coach: cancel failed: $error');
    }
  }

  Future<void> remove() async {
    try {
      await _methods.invokeMethod<void>('delete');
      await refresh();
    } catch (error) {
      debugPrint('ASVAB coach: could not remove the model: $error');
    }
  }

  /// Starts loading the model before anyone asks, so the first tap on
  /// "Explain another way" is not the one that pays for it.
  Future<void> warmUp() async {
    if (!usable || _status.loaded || _loading) return;
    await ensureLoaded();
  }

  /// Gives the memory back. Called on a timer, and when the model is removed.
  Future<void> unload() async {
    _idle?.cancel();
    _idle = null;
    if (!_status.loaded) return;
    try {
      await _methods.invokeMethod<void>('unload');
    } catch (error) {
      debugPrint('ASVAB coach: could not unload the tutor: $error');
    }
    await refresh();
  }

  void _touch() {
    _idle?.cancel();
    _idle = Timer(idleUnload, () {
      if (!_generating) unload();
    });
  }

  /// Loads the model into memory. The first call after a cold start takes a few
  /// seconds and is reported through [loaded].
  Future<void> ensureLoaded() async {
    if (!usable || _status.loaded) return;
    try {
      await _methods.invokeMethod<void>('load');
    } catch (error) {
      _error = 'The tutor could not be loaded.';
      debugPrint('ASVAB coach: tutor load failed: $error');
      notifyListeners();
    }
  }

  /// Asks the tutor, streaming [answer] as tokens arrive and resolving with the
  /// whole reply.
  Future<String> ask(String prompt, {int maxTokens = 320}) async {
    if (!usable) return '';
    await ensureLoaded();
    _answer = '';
    _error = null;
    _generating = true;
    _lastMillis = null;
    _lastTokens = null;
    _touch();
    notifyListeners();
    final completer = Completer<String>();
    _pending = completer;
    try {
      await _methods.invokeMethod<void>('generate', <String, Object>{
        'prompt': prompt,
        'maxTokens': maxTokens,
        // Greedy, like every measurement in docs/AI_EVAL.md: a tutor that
        // answers a question differently each time cannot be checked.
        'temp': 0.0,
        'topK': 40,
        'topP': 0.95,
      });
    } catch (error) {
      _generating = false;
      _pending = null;
      _error = 'The tutor could not start answering.';
      debugPrint('ASVAB coach: generate failed: $error');
      notifyListeners();
      return '';
    }
    return completer.future;
  }

  Future<void> cancelGenerate() async {
    try {
      await _methods.invokeMethod<void>('cancelGenerate');
    } catch (error) {
      debugPrint('ASVAB coach: cancel generate failed: $error');
    }
  }

  void _onEvent(dynamic raw) {
    if (raw is! Map) return;
    final type = raw['type'];
    switch (type) {
      case 'download':
        _received = (raw['received'] as num?)?.toInt() ?? 0;
        _total = (raw['total'] as num?)?.toInt() ?? _total;
        notifyListeners();
      case 'installed':
        _error = null;
        refresh();
      case 'downloadCancelled':
        _received = 0;
        refresh();
      case 'loading':
        _loading = true;
        notifyListeners();
      case 'loaded':
        _loading = false;
        _lastLoadMillis = (raw['millis'] as num?)?.toInt();
        _status = TutorStatus(
          supported: _status.supported,
          loaded: true,
          installed: _status.installed,
          abi: _status.abi,
          path: _status.path,
          bytes: _status.bytes,
          expectedBytes: _status.expectedBytes,
        );
        notifyListeners();
      case 'unloaded':
        refresh();
      case 'token':
        _answer = _answer + ((raw['text'] as String?) ?? '');
        notifyListeners();
      case 'done':
        _generating = false;
        _lastMillis = (raw['millis'] as num?)?.toInt();
        _lastTokens = (raw['tokens'] as num?)?.toInt();
        final text = (raw['text'] as String?) ?? _answer;
        _answer = text;
        notifyListeners();
        _pending?.complete(text);
        _pending = null;
      case 'error':
        _error = (raw['message'] as String?) ?? 'The tutor failed.';
        _generating = false;
        _loading = false;
        notifyListeners();
        _pending?.completeError(_error!);
        _pending = null;
    }
  }

  @override
  void dispose() {
    _idle?.cancel();
    _subscription?.cancel();
    super.dispose();
  }
}
