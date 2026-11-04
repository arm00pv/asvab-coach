# Voices: what speaks, and what could

Two questions came back from the phone: *why does Settings show only English?*
and *can the voice be less robotic?* This records the honest answer to the first
and the measured options for the second.

## Why the guide lists one language

There are two independent reasons, and only one of them is about the phone.

1. **The guide is written in English.** Every spoken script in
   `lib/engines/narration.dart` is an authored English text
   (`writtenLanguages = ['en']`), and the voice picker offers only voices for
   languages the guide can actually say. Handing Spanish words to an English
   voice, or English words to a Spanish one, produces noise rather than an
   explanation - so the row was deliberately short.
2. **Google ships one language at a time.** The Pixel reported 52 English voices
   and the voice file for other languages is a separate download in Android's own
   settings. So even the tutor's Spanish answer had no Spanish voice to read it
   until one is installed.

What was missing was not the feature but the sentence explaining it. Settings now
says how many English voices there are, names any other languages the phone has
and why the guide does not offer them, and carries an **Install or change
voices** button that opens Android's text-to-speech settings through a new
`openVoiceSettings` call on the speech channel. Tests:
`test/spoken_guide_settings_test.dart`.

The tutor is a separate case and already speaks the language it answers in
(`SpeechService.speakIn`, see [AI_TUTOR.md](AI_TUTOR.md)).

## Why it sounds robotic, and what could replace it

The guide uses the engine that is already on the phone. That engine is free,
offline and instant, but the voices it keeps *on the device* are the small ones:
Google's local voices are optimised for size, and the natural-sounding ones are
either marked as needing a connection or come from a newer engine. The app
already sorts local-first and then by the engine's own quality rating, so it is
picking the best of what is installed - the ceiling is the engine, not the app.

Free, offline, well-rated options that run inside an Android app, with the
licences and the sizes that matter for a download:

| Component | Licence | Size | Notes |
| --- | --- | --- | --- |
| [sherpa-onnx](https://github.com/k2-fsa/sherpa-onnx) | Apache-2.0 | Android shared libs, all ABIs, 45 MB compressed | Offline TTS/ASR engine on onnxruntime, C/C++/Java/Kotlin/**Dart** bindings, official Flutter package `sherpa_onnx` and arm64/armv7/x86_64 prebuilt libraries. Same integration shape as the llama.cpp bridge: packaged `.so` plus a JNI call. |
| [Kokoro-82M](https://github.com/hexgrad/kokoro) | Apache-2.0 weights | `kokoro-int8-en-v0_19` 103 MB; multi-lang v1.1 int8 147 MB | 82 M parameters, "comparable quality to larger models", 24 kHz. sherpa-onnx support is **Chinese + English only** today, so it would replace the English guide voice only. |
| Piper/VITS voices | model cards vary (mostly CC-BY-4.0) | `en_US-lessac-high-int8` 35 MB, `es_ES-davefx-medium-int8` 21 MB, `it_IT-paola-medium-int8` 21 MB | The voices sherpa-onnx was built around. Spanish and Italian are covered properly here; quality is a clear step above the on-device Google voices, below Kokoro. |
| [piper1-gpl](https://github.com/OHF-Voice/piper1-gpl) | GPL-3.0 | - | The successor to rhasspy/piper. GPL code in an APK is a licensing decision, not a technical one; sherpa-onnx avoids it. |
| Kokoro via `kokoro-onnx` | Apache-2.0 | - | Python-first; on Android it would mean shipping onnxruntime and the G2P stack by hand. sherpa-onnx already does that work. |

**Recommendation.** Ship sherpa-onnx arm64-only (a stub for other ABIs, exactly
like llama.cpp) and let the voice pack be a one-time download with a pinned size
and SHA-256, the same contract the model already has:

| Pack | Download | What it buys |
| --- | --- | --- |
| English | Kokoro int8, 103 MB | The guide reads like a person; this is the voice the candidate hears on every screen |
| Spanish | Piper `es_ES-davefx-medium-int8`, 21 MB | The tutor's Spanish answers read in Spanish |
| Italian | Piper `it_IT-paola-medium-int8`, 21 MB | The same for Italian |

## What shipped, and what it cost

v1.9.0 carries it: sherpa-onnx 1.13.8, arm64 only, with the packs as one-off
downloads and the system engine kept as the fallback.

| | Measured |
| --- | --- |
| APK | 29.3 MB to 38.8 MB (+9.5 MB: libonnxruntime 22.2 MB and libsherpa-onnx-c-api 4.5 MB, arm64, stored compressed) |
| English | Kokoro 82 M int8, 94,210,357-byte download, speaks at 24 kHz |
| Spanish | Piper `es_ES-davefx-medium` int8, 14,121,495 bytes, 22.05 kHz |
| Italian | Piper `it_IT-paola-medium` int8, 14,060,490 bytes, 22.05 kHz |
| Extraction | gzip and tar are done in Kotlin (no native extractor, no extra dependency) |

Three decisions that came out of building it:

1. **Not the Flutter package.** `sherpa_onnx` on pub.dev pulls seven per-platform
   packages and its own prebuilt libraries; the app already has a working pattern
   for a vendored arm64 `.so` and a JNI bridge, so the C API is called directly.
   No new dependency, no fetch at build time, and the libraries stay under
   `jniLibs` where the tutor's already live.
2. **Pin 1.13.8, not 2.x.** sherpa-onnx 2.0 removed espeak-ng and piper-phonemize
   from the library, which would mean shipping a phonemizer of our own. 1.13.8
   still has it, so a pack only carries its model, tokens and a trimmed
   `espeak-ng-data` (1.1 MB instead of 18 MB: the en/es/it dictionaries only).
3. **Trim the espeak data.** Upstream packs carry 113 language dictionaries in
   every voice. Trimming is what makes a Spanish pack 13 MB instead of 31 MB.

Licences were checked before shipping, not after: Kokoro-82M's weights are
Apache-2.0; the Spanish voice's dataset is CC0; the Italian voice's dataset card
is CC0. Each archive carries its licence or model card. Details and digests in
[VOICE-PACKS.md](VOICE-PACKS.md).

The alternative with no size cost at all is still there and still shipped: point
the candidate at Android's own voice settings and let them install Google's
better voices.

## Still open

1. **The browser build has no neural voice.** sherpa-onnx does have a WASM
   target, but adding a 30 MB model fetch to the web build is a separate
   decision, and the web build is the one that runs on a phone that just opened a
   link.
2. **The browser build.** Decided against for now: a 30 MB model fetch in the
   web build is a different product decision.

## Done since: streaming and voices (v1.10.0)

Both of the open items from v1.9.0 are closed.

**Streaming.** The engine used to synthesise a whole paragraph before playing a
single word - about four seconds of silence on a Pixel for three and a half
seconds of speech. The text is now split at sentence boundaries
(`NeuralVoice.chunksOf`: nothing dropped, long sentences broken at a word
boundary, short ones said together) and each piece is generated and played in
turn. Measured on the phone: the Settings script is nine chunks, and chunk 1
starts in about a second while chunk 2 is still being made - "chunk 1/9: 76638
samples", "chunk 2/9: 71322 samples" 3.4 s later, exactly as the first finishes.

**Eleven English voices.** Kokoro's `sid` 0-10 are now offered as chips (Heart,
Bella, Nicole, Sarah, Sky, Adam, Michael, Emma, Isabella, George, Lewis), stored
in the speech settings beside the reading speed, and passed through to the
engine - verified on the phone as `chunk 1/1: 89144 samples, sid=1`.

The Italian pack was the one voice not tested on hardware in v1.9.0; it is now:
`pack it-piper loaded: kind=0, 22050 Hz`, 58,368 samples.
## Done since: the reason a voice said nothing (v1.11.2)

v1.11.0 gave the native side a voice: it measures what it wrote, refuses to call
silence a success, and reports the reason - "The media volume on this phone is at
zero, so the voice cannot be heard", "The downloaded voice produced silence",
"The downloaded voice could not be opened". On the phone that reason reached the
Dart side and stopped there. `NeuralVoice.speak()` waited for the engine's
completion gate and then returned `null` whichever way the utterance had gone,
so:

* the caller was told "spoken, no problem" about a failure;
* `SpeechService` therefore did not fall back to the phone's voice, and the
  candidate heard nothing at all;
* the sheet and the settings page had nothing to show, because there was nothing
  to show.

That was the whole of "I cannot hear the downloaded voices". The fix is three
lines of intent in three places: `speak()` returns `_error` after the gate,
`SpeechService` treats a non-null reason as a failure (so the system voice reads
the words), and the tutor sheet shows `problem ?? speech.lastError` - the settings
page already drew `lastError`.

The cause reproduced on the test phone was the media stream at zero while the app
was open. A speech utterance is a media stream, so nothing is audible, and the
app now says so instead of offering a button that appears to do nothing.

Two tests pin it in `test/neural_voice_test.dart`: the engine's error message is
returned from `speak()`, and a pack that cannot be heard still reads through the
phone's voice while the screen keeps the reason.
