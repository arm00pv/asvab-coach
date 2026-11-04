# v1.9.0 - voices that sound like people

The spoken guide and the tutor can now use a voice that was trained to sound
like a person, running on the phone with no network at all.

* **Downloaded voices.** Settings has a *Downloaded voices* card: English
  (Kokoro 82M, 90 MB), Spanish (Piper VITS, 13 MB) and Italian (Piper VITS,
  13 MB). Each is downloaded once, checked against a pinned size and SHA-256,
  and unpacked into the app's own storage. After that it needs no connection,
  no account and no server - the same bargain as the tutor's model.
* **Used everywhere, with no second switch.** A pack that is installed becomes
  the voice for its language: the speaker beside every screen title reads the
  guide with it, the tutor's answer is read with it, and the *Hear it* button on
  each row lets you try one before you keep it. The speed control still applies.
* **The engine is in the app.** sherpa-onnx (Apache-2.0) with onnxruntime,
  arm64 only - 9.5 MB more in the APK, and a stub on other ABIs, exactly like
  the tutor. Nothing is fetched at run time except the voice you chose.
* **Licences checked, in the release notes.** Kokoro-82M is Apache-2.0. The
  Spanish voice is CC0. The Italian voice's training set is CC0. Each archive
  carries its model card or licence, and [docs/VOICE-PACKS.md](docs/VOICE-PACKS.md)
  has the exact bytes and digests.
* **The system voice stays.** A phone that does not download anything behaves
  exactly as it did in 1.8.1, and Settings still has *Install or change voices*
  for Android's own voices.

The APK is 38.8 MB (was 29.3 MB); the voices themselves are never inside it.

Nothing about scoring, the job catalogue or the question bank changed.
