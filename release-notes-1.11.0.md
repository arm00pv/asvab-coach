# v1.11.0 - a voice that admits when it is silent

Reported from the phone: *"the new voices I cannot hear them"*. The honest answer
is that the app could not tell the difference between speaking and failing, and
that is fixed here.

* **No more silent success.** The engine could return nothing to say and the app
  treated it as a finished utterance: silence, no fallback, no message. It now
  - checks the media volume first and says so if it is at zero,
  - measures the peak of every generated chunk and reports a silent pack,
  - checks every write to the audio device instead of assuming it worked,
  - lets the audio buffer drain, so the last word of a sentence is not cut off,
  - sends single-voice packs speaker 0 (sending the Kokoro voice you picked to a
    Piper model is another way to get silence),
  - and if the downloaded voice cannot speak, **falls back to the phone's own
    voice and puts the reason on the screen**.
* **Empty answers are failures, not quiet successes.** A model that ends its turn
  without writing anything used to leave the sheet spinning for ever; it now says
  so and offers *Try again*, and the *preparing* state appears the moment a load
  starts rather than a second later.

What was checked on the phone: the downloaded voices do play - the audio system
reports the app's own track started and mapped to a device, the generated samples
peak at 0.96, and both the English and Spanish packs synthesise
(`chunk 1/1: 59538 samples`, `peak=0.96`). If they cannot be heard after this
release, the app will now say why.

**Not in this release:** the tutor on each lesson. It is written, prompted,
tested and wired, but on the test phone the lesson sheet came up empty and I could
not yet prove it end to end, so it is held back rather than shipped broken. Every
question in Review still has it, as before.

Nothing about scoring, the job catalogue or the question bank changed.
