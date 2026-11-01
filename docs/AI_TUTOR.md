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

* **7 Nov 2026** - shipped the spoken guide (authored scripts, device voices,
  eleven screens, auto-read on screen activation). Deferred LFM3-Omni to a
  separate download because 1.33 GB cannot ship inside an APK and cannot run in
  the browser build.
