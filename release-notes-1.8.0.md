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
* **In your language.** English, Espanol or Italiano, chosen in the sheet. The
  checked explanation stays in English; the tutor's own working is translated.
* **Honest about itself.** The first question after opening the app takes a few
  seconds while the model is read into memory, and the sheet says so. The model
  is unloaded after twelve minutes idle so it is not holding a gigabyte of RAM
  on a phone that has gone back to the home screen.
* **Not during the clock.** The tutor is reachable from Review, never from the
  exam runner: a model that answers the question while the timer runs is a way
  to score a mock you did not earn.
* **A smaller app.** 57 MB down to 29 MB, and the model is never in the APK.

The APK still installs on 32-bit phones and on x86_64 emulators: the engine
compiles to a stub there and the tutor reports itself unavailable.

Nothing about scoring, the job catalogue or the question bank changed.
