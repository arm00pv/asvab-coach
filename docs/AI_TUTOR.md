# The spoken guide and the AI tutor

Two different things, often confused, and the whole design follows from keeping
them apart:

* **the spoken guide** - a speaker beside every screen's title that reads that
  screen's explanation out loud, in a language the candidate chooses. The words
  are written into the app; the voice belongs to the phone. It ships.
* **the tutor** - a model that can be *asked* things, look at the screen, and
  answer in a language its author never wrote. That is what LFM3-Omni is for. It
  does not ship yet, and this page says exactly why and what it would take.

## What the guide does today

`lib/engines/narration.dart` holds one authored script per screen. Every
screen builds its own script from the same numbers it displays - the same
`StudySchedule`, the same `attemptSupportsAggregate` verdict, the same whole-day
count - so the voice cannot say something the screen is not showing. A test
(`test/narration_test.dart`) refuses a script that is empty, has a stray `${`,
runs longer than a minute and a half, shouts, or uses an abbreviation it never
expanded.

`lib/core/speech.dart` owns the guide: which voice, how fast, whether a screen
reads itself. Two engines sit under it, behind one interface:

| platform | engine | notes |
| --- | --- | --- |
| Android | `TextToSpeech` via the `asvabcoach/speech` channel | the device's own voices, offline, no download |
| web | `window.speechSynthesis` via `dart:js_interop` | the browser's voices, no download |

Nothing is recorded, nothing is uploaded, and the app needs no new permission.
The `INTERNET` permission is still used for exactly one thing: the update check.

### Why language choice is a list of written languages, not of installed voices

A phone that can pronounce Spanish will happily read an English sentence with
Spanish sounds. That is noise, not an explanation. What a screen says has to
exist in the language before any voice can speak it, so the language sheet
offers voices only for the languages in `writtenLanguages` - English, today.
The machinery is per-language data; adding a language is writing and reviewing a
script set, not writing code. Machine-translated ASVAB instruction shipped
without a native speaker reading it would be worse than no translation at all.

## What the tutor would be

Liquid AI's **LFM3-Omni-2B** is a single end-to-end model that takes text,
images, video and audio in, and puts out text, speech, or interleaved text and
speech - one model in place of a speech recogniser, a vision model, a language
model and a speech synthesiser. Facts taken from the model documentation and
the published weights on 7 November 2026:

| property | value |
| --- | --- |
| parameters | 2.17 B (non-reasoning) |
| context | 32 K tokens |
| input | text, images, video (with or without sound), audio |
| output | text, speech, or both, at 24 kHz |
| text languages | 16, including English, Spanish, French, Hindi, Portuguese, Russian, Vietnamese |
| speech languages | 19, including English (US and UK), Spanish, French, Arabic, Japanese, Chinese, Portuguese - **Hindi is text-only** |
| voices | female and male per language |
| licence | LFM Open License v1.0: free to use, commercial use restricted above $10 M annual revenue |

Sources:
* <https://docs.liquid.ai/lfm/models/lfm3-omni-2b>
* <https://huggingface.co/LiquidAI/LFM3-Omni-2B>
* <https://huggingface.co/LiquidAI/LFM3-Omni-2B-GGUF>
* <https://www.liquid.ai/blog/lfm3>

### What it would cost to carry

Measured from the published GGUF repository, not estimated:

| file | size |
| --- | --- |
| `LFM3-Omni-2B-Q4_K_M.gguf` | 1 048.7 MB |
| `mmproj-LFM3-Omni-2B-Q4_K_M.gguf` | 278.1 MB |
| **total download** | **about 1.33 GB** |

That is roughly 23 times the entire APK (56.9 MB). It cannot go inside the
build: Play Protect, storage, and the Play Store's own limits would all be
against it. It would be a download the candidate chooses, on Wi-Fi, resumable,
verified by size and SHA-256 exactly the way the updater already verifies a
release.

### Runtime

llama.cpp has merged the model family - the model itself (`ggml-org/llama.cpp#31257`),
video input (`#31283`) and quantising the audio codec decoder (`#31386`) - so a
phone-side runtime is no longer research, it is packaging: a native library in
the APK, a Kotlin bridge, and a download manager. The browser build is out: a
2.17 B model in WASM is not a serious option for a study app on a school laptop.

### What it would add that the guide cannot

1. **Language.** Explanation in the candidate's own language, translated, not
   just pronounced - Hindi as text, Spanish or Arabic as speech.
2. **Questions.** "Why is the answer 12 and not 18?" answered about the item on
   screen, in the candidate's words, instead of a fixed script.
3. **Reading the screen.** The picture is the input: the app can pass what is
   drawn rather than describing it twice.

### What it would not be allowed to do

The honesty rules that govern every other number in this app apply unchanged:

* it may not state a score, a percentile or a line score of its own - those come
  from `ScoringEngine` or not at all;
* it may not state a job requirement the pamphlet does not print - those come
  from `MosRepository` with their transcription date;
* it may not claim to be an official ASVAB, and neither may the build that ships
  it;
* anything it says about a lesson must be checkable against that lesson, which is
  why the tutor's answers would be shown beside the written explanation rather
  than in place of it.

## Where it would live

A new `TutorEngine` beside `SpeechService`, with the same contract shape:
`available()`, `ask(screen, question)`, `stop()`. With no model installed it reports
unavailable and the speaker button keeps working exactly as it does now - the
guide is the floor, not a fallback.

The settings page already reserves the space: *Settings - AI tutor - not in this
build*, with the download size and the platform limit printed rather than an
empty switch.

## Decision record

* **1 Nov 2026** - evaluated the model itself: 16 real bank items, three
  languages, marked against the app's own key. It solved the questions and
  explained the method well, got the option letter wrong in more than half, and
  translated numbers faithfully while inventing Spanish vocabulary. Record, with
  quotes and timings: [AI_EVAL.md](AI_EVAL.md). Consequence: the tutor will
  re-explain from the app's key and never name the answer.
* **7 Nov 2026 (earlier decision)** - shipped the spoken guide (authored scripts,
  device voices, eleven screens, auto-read on screen activation). Deferred
  LFM3-Omni to a separate download because 1.33 GB cannot ship inside an APK and
  cannot run in the browser build.

## The tutor, running on the phone (1 November 2026)

The model is in the app. Not a link, not a server: llama.cpp built for Android
arm64, LFM3-Omni-2B Q4 downloaded once and loaded into the phone's own memory.

**What ships.** `android/app/src/main/cpp/llm_bridge.cpp` is a JNI bridge over
the llama.cpp C API with four entry points - load, generate, cancel, free - and
generation streams: every token is handed back to Kotlin as it is sampled, so
the first sentence is on screen while the rest is still being computed.
`LlmTutor.kt` owns the download, the verify and the model file;
`lib/core/tutor.dart` is the Dart side; `lib/widgets/tutor_sheet.dart` is the
button a candidate presses under an answer in Review.

**The APK** is 29.2 MiB (30,655,560 bytes). Eleven of those megabytes are the
llama.cpp libraries, stripped from a 75 MB release tarball: `libllama.so`,
`libggml.so`, `libggml-base.so` and six `libggml-cpu-android_*` kernels, arm64
only. The model is not in it: that is a 1.02 GB download, checked against a
pinned length and SHA-256 before it is allowed to load.

It is also smaller than the 54.6 MiB of v1.7.1, which looks like a contradiction
until you open both archives. v1.7.1 stored its native libraries uncompressed -
`lib/x86_64/libflutter.so` was 13,051,040 bytes on disk and 13,051,040 bytes in
the zip - while this build sets `useLegacyPackaging = true`, which stores them
deflated (2.3 MB) and has Android extract them at install. That flag is not a
size trick: it is what makes them visible to `ggml_backend_load_all_from_path`,
which cannot enumerate libraries mapped out of the APK. The size saving is a
side effect.

**Four defects found only on hardware**, each fixed:

* *the load found no backends.* This llama.cpp ships its CPU kernels as separate
  libraries that have to be registered; `ggml_backend_load_all()` searched the
  app process's paths and found nothing. The bridge now calls
  `ggml_backend_load_all_from_path()` with the app's native library directory,
  passed down from Kotlin.
* *the libraries were not there to load.* Android packs `.so` files inside the
  APK and maps them from the archive, which the backend loader cannot enumerate.
  `useLegacyPackaging = true` extracts them at install time.
* *the loader's own log went nowhere.* llama.cpp writes to stderr, which Android
  discards, so a failed load said only "failed". It now routes through
  `llama_log_set` into logcat under `AsvabLlm`, which is how the two defects
  above were found at all.
* *llama.h moved under us.* `use_mmap` and `use_mlock` no longer exist on
  `llama_model_params` in this version, and the ggml headers had to be fetched
  beside `llama.h`.

**Verified on the Pixel 7 Pro:** the APK installs, the tutor reports itself
usable, the 1.02 GB download completes and verifies on the device, and the model
loads - `model loaded, n_ctx=2048 threads=6` in logcat.

**Not yet verified:** a finished answer and the tokens-per-second on the phone.
The USB connection dropped mid-run and the device has not come back, so the one
number that decides whether this feels like a tutor or a wait is still owed.

## Two release-only defects (3 November 2026)

The phone came back on wireless debugging, so the tutor was driven by hand on a
Pixel 7 Pro, through the real UI, on the real release APK. It did not work. Both
faults were invisible to the analyzer, to the widget tests and to every debug
build, and both were fixed and pinned with a test the same day.

**1. A question asked before the model was in memory.** Opening Review warms the
tutor up. The platform answers a `load` request immediately and reads the 1.1 GB
file on its own thread, so `await` on the method call proves nothing - and the
old `ensureLoaded()` treated that answer as "loaded". A candidate who taps
"Explain another way" during the warm-up - the commonest way in to the tutor -
sent the question to an engine with no model, and the sheet said *"The tutor
could not start answering."* The log named it:
`PlatformException(not_loaded, The tutor has not been loaded.)`.

The fix is single-flight loading. `ensureLoaded()` holds a gate that is completed
by the `loaded` or `error` event, so a second caller waits for the load that is
already running instead of starting another one (two loads meant two copies of
the model on one worker). `ask()` also refuses to call the engine while the model
is absent, and a generation that never reports back now gives up after four
minutes instead of spinning forever. Pinned by
`test/tutor_service_test.dart`, which drives a fake platform channel that
acknowledges `load` and only later sends `loaded`.

**2. R8 renamed the token callback and killed the app.** The bridge finds the
sink with `GetMethodID(sink_class, "onToken", "(Ljava/lang/String;)V")`. R8 cannot
see a caller that lives in C++, so it renamed the anonymous sink class and
removed the method name. `GetMethodID` then failed, which leaves a *pending*
`NoSuchMethodError`; the JVM rethrows it when the native frame returns, and the
process died with

```
FATAL EXCEPTION: pool-4-thread-1
java.lang.NoSuchMethodError: no non-static method "Lw0;.onToken(Ljava/lang/String;)V"
    at com.arm00pv.asvabcoach.llm.NativeLlm.generate(Native Method)
```

The visible symptom was a sheet stuck on "Working it through..." and then the app
gone - no tokens, no error, no crash dialog the candidate could act on.

Three changes, because one would not be enough:

* the sink is a named class, `LlmTokenSink`, and `android/app/proguard-rules.pro`
  keeps it and its `onToken(java.lang.String)` by name, wired in from
  `build.gradle.kts`;
* the C++ side clears a failed lookup instead of leaving the exception pending,
  and answers without streaming rather than taking the process down;
* `test/native_contract_test.dart` reads the Kotlin, C++ and ProGuard sources and
  fails if any of the three drifts, because no Dart test can see this at runtime.

R8's own `mapping.txt` now shows `void onToken(java.lang.String) -> onToken` under
a class that keeps its name, which is the evidence that the fix is in the build
and not just in the source.

## Saying it out loud (3 November 2026)

The tutor was writing in Spanish and reading in English, which is the one thing
a candidate studying in another language cannot use.

The sheet now carries a speaker beside its title. It reads the answer with the
phone's own voice for the language the answer was written in - `es-ES` for a
Spanish answer, `it-IT` for an Italian one - at whatever speed the spoken guide
is set to, and it stops when the sheet closes. If the phone has no voice for
that language the sheet says so in a line rather than reading Spanish with an
English voice: a voice is something the candidate can install, and being told
that is more useful than hearing the answer butchered.

When the guide is set to read screens as they open, a finished answer is read
out by itself. That is the point of the feature: the tutor is used with eyes
busy - driving practice, a walk, a workout - and the speaker the candidate has
already turned on for the studied screens is the one they expect here.

Under it: `SpeechService.speakIn()`, which is `speakText()` with the language
argument the guide does not normally have, and `tests/speech_language_test.dart`
- a fake engine proves the Spanish voice is used for a Spanish answer, that a
missing voice is reported instead of faked, and that the candidate's reading
speed carries over. The text the button reads is the same `TutorPrompt.body()`
the sheet draws, so what is heard and what is on the screen cannot differ.
