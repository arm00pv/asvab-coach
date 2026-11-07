import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// What the device can do right now, as the platform reports it.
class TutorStatus {
  const TutorStatus({
    this.supported = false,
    this.gpu = false,
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

  /// The tutor will run on the phone's GPU rather than its CPU.
  ///
  /// True only when an offloading backend registered (Vulkan, shipped in
  /// jniLibs) and the phone's driver took it. False is not a failure: it is the
  /// CPU path, which is what every phone had before the Vulkan build.
  final bool gpu;

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
    gpu: map['gpu'] == true,
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

  /// Long enough for a 300-token answer at four tokens a second, short enough
  /// that a wedged generation does not leave a spinner on the screen.
  static const generationTimeout = Duration(minutes: 4);

  TutorStatus _status = TutorStatus.unknown;

  /// The one and only startup call, shared by everyone who needs it.
  ///
  /// This was a plain bool, and that was a real bug on a real phone: the app's
  /// tutor object is created lazily, so the sheet's `await initialise()` came
  /// back at once while the first status read was still in flight. The sheet
  /// then asked a service that did not yet know the phone had a model, and
  /// `ask` returned nothing at all - a blank sheet with no error on it.
  Future<void>? _init;
  bool _generating = false;
  bool _loading = false;
  Timer? _idle;
  String _answer = '';
  String? _error;
  int? _lastMillis;
  int? _lastTokens;
  int? _lastLoadMillis;
  int? _lastFirstTokenMillis;
  int _received = 0;
  int _total = 0;
  StreamSubscription<dynamic>? _subscription;
  Completer<String>? _pending;

  /// Held while the model is being read into memory.
  ///
  /// A load is answered by the platform immediately and finished on its own
  /// thread, so awaiting the method call proves nothing. This is completed by
  /// the "loaded" (or "error") event, and it is what makes a tap on "Explain
  /// another way" wait for the warm-up that is already running instead of
  /// asking an engine that has no model yet.
  Completer<void>? _loadGate;

  TutorStatus get status => _status;

  /// True once [initialise] has been called, whether or not it has finished.
  bool get ready => _init != null;

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

  /// How long the last answer spent reading the question before it wrote its
  /// first token. Null when nothing was written.
  int? get lastReadMillis {
    final first = _lastFirstTokenMillis;
    if (first == null || first <= 0) return null;
    return first;
  }

  /// Tokens per second while it was writing, with the question excluded.
  ///
  /// This is the number that decides whether the tutor feels usable, and it is
  /// not [tokensPerSecond]: that one divides by the whole call, most of which is
  /// the model reading a prompt it has not been given before.
  double? get writeTokensPerSecond {
    final millis = _lastMillis;
    final first = _lastFirstTokenMillis;
    final tokens = _lastTokens;
    if (millis == null || tokens == null || first == null) return null;
    final writing = millis - first;
    if (writing <= 0 || tokens <= 0) return null;
    return tokens * 1000 / writing;
  }

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

  /// What to tell a candidate whose phone cannot run the tutor, in the terms
  /// that phone actually needs: a download to make, or a phone that cannot do it.
  String get unavailableMessage {
    if (!_status.supported) {
      return 'The tutor cannot run on this phone or in this build. It needs a '
          '64-bit ARM phone; the web version has no tutor.';
    }
    return 'The tutor model - ${_status.sizeLabel} - is not on this phone yet. '
        'Download it in Settings, under The tutor, then try again.';
  }

  /// Download progress in the range 0..1.
  double get downloadProgress {
    if (_total <= 0) return 0;
    return (_received / _total).clamp(0.0, 1.0);
  }

  /// Reads the phone's status and subscribes to the engine's events.
  ///
  /// Safe to call from anywhere, any number of times: everyone gets the same
  /// future, so a caller that awaits it really has waited for the status read.
  Future<void> initialise() => _init ??= _initialise();

  Future<void> _initialise() async {
    if (kIsWeb) return;
    try {
      _subscription = _events.receiveBroadcastStream().listen(
        _onEvent,
        // A broken channel must not leave a sheet waiting on an event that can
        // never arrive.
        onError: (Object error) {
          debugPrint('ASVAB coach: tutor event channel failed: $error');
          _generating = false;
          _loading = false;
          _error ??= 'The tutor stopped answering. Try again.';
          _pending?.completeError(_error!);
          _pending = null;
          _finishLoad();
          notifyListeners();
        },
      );
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
  ///
  /// Single flight: whoever asks while a load is already running waits for that
  /// one instead of starting another. Two overlapping loads meant a second copy
  /// of a 1.1 GB model on the worker, and asking the engine before the first
  /// finished meant "The tutor could not start answering" on the very first
  /// question after opening Review - the commonest way in to the tutor.
  Future<void> ensureLoaded() async {
    if (!usable || _status.loaded) return;
    final running = _loadGate;
    if (running != null) return running.future;
    final gate = Completer<void>();
    _loadGate = gate;
    // Say "preparing" from the moment the request goes out. The platform's own
    // "loading" event follows, and on a cold start it can be a second late - long
    // enough for a sheet to look like it did nothing at all.
    _loading = true;
    notifyListeners();
    try {
      await _methods.invokeMethod<void>('load');
    } catch (error) {
      _error = 'The tutor could not be loaded.';
      debugPrint('ASVAB coach: tutor load failed: $error');
      notifyListeners();
      _finishLoad();
      return;
    }
    await gate.future.timeout(
      const Duration(seconds: 90),
      onTimeout: () {
        debugPrint('ASVAB coach: the tutor load never reported back');
        _finishLoad();
      },
    );
    if (!_status.loaded && _error == null) {
      _error = 'The tutor did not finish getting ready.';
      notifyListeners();
    }
  }

  /// Closes the load gate exactly once, however the load ended.
  void _finishLoad() {
    final gate = _loadGate;
    _loadGate = null;
    if (gate != null && !gate.isCompleted) gate.complete();
  }

  /// Asks the tutor, streaming [answer] as tokens arrive and resolving with the
  /// whole reply.
  Future<String> ask(String prompt, {int maxTokens = 320}) async {
    // Whatever happens next, the phone's status has to be known first. Asking
    // before the first status read is what produced an empty answer, no error
    // and no spinner - a sheet that looked like it had simply given up.
    await initialise();
    // A tutor that answers nothing and says nothing is the hardest failure to
    // diagnose from a phone; this line is what a bug report can be checked
    // against.
    debugPrint(
      'ASVAB coach: ask (usable=$usable supported=${_status.supported} '
      'installed=${_status.installed} loaded=${_status.loaded} '
      'error=${_status.error})',
    );
    if (!usable) {
      // The candidate may have downloaded the model in Settings since this
      // object last looked, so look again before saying no.
      await refresh();
      if (!usable) {
        _error = unavailableMessage;
        notifyListeners();
        return '';
      }
    }
    await ensureLoaded();
    debugPrint(
      'ASVAB coach: after load (loaded=${_status.loaded} error=$_error)',
    );
    if (!_status.loaded) {
      // Never ask an engine that has no model: the platform answers with an
      // error, and a sheet cannot do anything useful with it.
      _error ??= 'The tutor is still getting ready. Try again in a moment.';
      notifyListeners();
      return '';
    }
    _answer = '';
    _error = null;
    _generating = true;
    _lastMillis = null;
    _lastTokens = null;
    _lastFirstTokenMillis = null;
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
    try {
      // A generation runs for as long as the phone takes, but not forever. If
      // no "done" ever arrives - the engine died, the process was rebuilt under
      // the sheet - the sheet has to stop spinning rather than lie about work
      // that is no longer happening.
      final String text = await completer.future.timeout(generationTimeout);
      // The model sometimes ends its turn before writing anything: the prompt
      // was too long, or it took the last instruction as the whole task. An
      // empty answer is a failure the sheet can act on, not a quiet success.
      if (text.trim().isEmpty && _error == null) {
        _error = 'The tutor had nothing to add. Try again.';
        notifyListeners();
      }
      return text;
    } on TimeoutException {
      _generating = false;
      _pending = null;
      _error = 'The tutor stopped answering. Try again.';
      notifyListeners();
      await cancelGenerate();
      return _answer;
    }
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
          gpu: _status.gpu,
          loaded: true,
          installed: _status.installed,
          abi: _status.abi,
          path: _status.path,
          bytes: _status.bytes,
          expectedBytes: _status.expectedBytes,
        );
        notifyListeners();
        _finishLoad();
      case 'unloaded':
        refresh();
      case 'token':
        _answer = _answer + ((raw['text'] as String?) ?? '');
        notifyListeners();
      case 'done':
        _generating = false;
        _lastMillis = (raw['millis'] as num?)?.toInt();
        _lastTokens = (raw['tokens'] as num?)?.toInt();
        _lastFirstTokenMillis = (raw['firstTokenMillis'] as num?)?.toInt();
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
        _finishLoad();
        _pending?.completeError(_error!);
        _pending = null;
    }
  }

  @override
  void dispose() {
    _idle?.cancel();
    _subscription?.cancel();
    _finishLoad();
    super.dispose();
  }
}
