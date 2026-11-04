# v1.11.2 - the voice that was silent now says why

## The reason a downloaded voice said nothing was being thrown away

v1.11.0 taught the native side to stop playing, measure the samples it had
written, and report a failure instead of reporting silence as success. On the
phone that report reached the Dart side - and stopped there. `NeuralVoice.speak()`
waited for the engine to finish and then returned `null` whatever had happened,
so the caller was told "spoken, no problem" about an utterance that had produced
no sound.

That is the whole of "I cannot hear the downloaded voices": the phone had the
explanation and the app threw it away.

Three things follow from the fix, and all three are now visible:

* the reason comes back from `speak()` as the platform wrote it - "The media
  volume on this phone is at zero, so the voice cannot be heard. Turn it up and
  try again", "The downloaded voice produced silence", "The downloaded voice
  could not be opened";
* the phone's own voice reads the words anyway, so the answer is never lost to a
  downloaded pack that failed;
* the tutor sheet and the settings page both show the reason instead of the
  button appearing to do nothing.

## What was actually wrong on the phone

Reproduced on the test phone: the media stream was at zero while the app was
open. A speech utterance is a media stream, so nothing was audible, and until
this release nothing was said about it either. The check that catches it was
added in v1.11.0 and its message reached the app in v1.11.1; this release is what
makes the app show it.

## A test that only passed in the evening

The plan's own tests built "three days ago" as `DateTime.now().subtract(Duration(days: 3))`.
That is 72 hours, and the day a clock goes back is 25 of them, so the day after a
daylight-saving change the fixture landed on the second day back instead of the
third - the test passed all evening and failed after 23:00. The fixture builds a
calendar day now. The scheduler itself already counted calendar days, which is
why nothing on a phone was wrong.

## Checks

* 765 tests pass, audit clean.
* Two new tests pin the failure: the engine's error message is returned from
  `speak()`, and a downloaded voice that cannot be heard still reads through the
  phone's voice while the screen keeps the reason.
* Verified on the phone: es-piper reading a Spanish lesson explanation (4
  chunks, 22050 Hz, peak 0.96) and the English Kokoro pack previewing at
  24000 Hz, speaker Bella, peak 0.49 - both audible with the media volume up.