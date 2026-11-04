# v1.8.0 - the tutor runs on the phone

The app now carries a language model of its own.

* **A real tutor, on the device.** LFM3-Omni-2B, running through llama.cpp
  inside the app. No server, no account, no key, and no network call after the
  one that fetches the weights - it works in aeroplane mode, which is the whole
  point for someone revising where there is no signal.
* **One download, checked.** Settings offers *AI tutor*, a 1.02 GB download done
  once over Wi-Fi. The file is verified against a pinned size and SHA-256 before
  it is allowed to load, and it is stored in the app's own folder.
* **"Explain another way"**, under every answer in Review. The tutor streams its
  explanation as it writes it, and it is **grounded**: the app's marked answer
  and its authored explanation go into the prompt, so the model teaches the
  answer that has been checked instead of guessing at one. If its own working
  reaches a different option it says so in one line, and the app shows that as a
  warning rather than as an answer.
* **In your language, and out loud.** English, Espanol or Italiano, chosen in
  the sheet. The checked explanation stays in English; the tutor's own working is
  translated - and the speaker beside the title reads that answer aloud with the
  phone's own voice for that language, at the speed you set for the spoken guide.
  When the guide reads screens by itself, a finished answer is read out by
  itself too. If the phone has no Spanish or Italian voice installed, the sheet
  tells you instead of reading Spanish with an English voice.
* **Honest about itself.** The first question after opening the app takes a few
  seconds while the model is read into memory, and the sheet says so. A question
  asked during that wait now waits for it instead of failing. The model is
  unloaded after twelve minutes idle so it is not holding a gigabyte of RAM on a
  phone that has gone back to the home screen.
* **Not during the clock.** The tutor is reachable from Review, never from the
  exam runner: a model that answers the question while the timer runs is a way
  to score a mock you did not earn.
* **Measured, on the phone.** Settings has *Benchmark it*, which runs one fixed
  question and reports the reading and writing speeds separately and how long the
  model took to load - the numbers from your phone, not from somewhere else's. On
  a Pixel 7 Pro a General Science explanation took 35 seconds: 3.9 s to read the
  question, then 156 tokens at 4.6 tokens/s. That is the honest price of a tutor
  with no network, and the sheet says it before you tap.

**Two faults that only a release build on a real phone showed, both fixed:**
a question asked while the model was still loading reached an engine with no
model and the sheet said "The tutor could not start answering"; and the shrinker
renamed the tutor's token callback, which crashed the app mid-answer. Loading is
single-flight now, the callback's name is kept, and both have tests that would
catch a return of either. The detail is in [docs/AI_TUTOR.md](docs/AI_TUTOR.md).

**Smaller download.** 29 MB, against 54.6 MB for v1.7.1. Most of that is not the
app getting smaller: the native libraries are stored compressed in the APK now
and Android unpacks them at install, which is also what the llama.cpp backend
loader needs. The model is never in the APK.

The APK still installs on 32-bit phones and on x86_64 emulators: the engine
compiles to a stub there and the tutor reports itself unavailable.

Nothing about scoring, the job catalogue or the question bank changed.
