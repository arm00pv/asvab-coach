# v1.12.0 - turn the volume up where the voice is silent

## The button the last two releases were missing

v1.11.2 made the app say why a downloaded voice could not be heard - most often
the phone's media stream sitting at zero. Saying it was necessary and not enough:
the candidate was told to leave the sheet and find the side button on a phone
they were using for something else.

Now the screen that reports the problem offers the fix. When the voice cannot be
heard because the media volume is at zero, the tutor sheet and the settings page
both show **Turn the volume up**. It raises the media stream a third of the way
of its own range - never lower than where the candidate already had it - puts
Android's own volume panel on screen so the change is visible and adjustable,
and then reads the answer again without asking for a second tap.

The same action appears beside the settings warning, and in the "Hear it" snack
bar when a downloaded pack is the voice that could not be heard.

## How it is built

`asvabcoach/speech` gains `turnUpVolume`, which reads `STREAM_MUSIC` through
`AudioManager`, sets it with `FLAG_SHOW_UI` and returns where it ended up. The
Dart side calls it through the same [SpeechBackend] seam as every other speech call,
so the screens never learn whether a channel, a browser or a test is behind it.
The button only appears when the last failure is recognised as a volume failure,
which is a match on the engine's own sentence - `test/native_contract_test.dart`
now reads `VoiceTts.kt` and fails if either the wording or the method name drifts
from what Dart looks for.

## Checks

* 769 tests, audit clean, CI green.
* New: the app can raise the volume and knows where it ended up; the engine's
  sentence is recognised and nothing else is; the Kotlin method name, the Dart
  channel call and the message all agree (contract test).
* Shipped over the installed v1.11.2 and driven on the phone: the lesson tutor
  still answers (79 tokens, 17.6 s) and the downloaded voice still speaks the
  answer.
