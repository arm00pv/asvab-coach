# v1.8.1 - voices, and what to do about them

Two questions from the phone, and one honest answer each.

* **"Why does Settings show only English?"** Because the guide's scripts are
  written in English, and the voice picker only offers voices for languages the
  guide can actually speak - English words read with Spanish sounds are noise,
  not an explanation. The card now says so: how many English voices are
  installed, which other languages the phone has, and why they are not offered.
  The tutor is unaffected: it answers in English, Spanish or Italian and is read
  in the language it answered in.
* **"Can the voice be less robotic?"** Not with the engine the app uses: it speaks
  whatever the phone has, and Android keeps the small voices on the device.
  Settings now has **Install or change voices**, which opens Android's own
  text-to-speech settings - that is where Google's better voices and other
  languages are installed, and it costs nothing.
  [docs/VOICES.md](docs/VOICES.md) records the free offline engine and voices
  worth bundling next (sherpa-onnx + Kokoro-82M + Piper voices), with licences,
  measured download sizes and what it would add to the APK.

Nothing about scoring, the job catalogue or the question bank changed.
