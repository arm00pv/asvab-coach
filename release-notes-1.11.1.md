# v1.11.1 - the tutor can explain every lesson, and no more blank sheets

## Every theme a candidate studies can be explained

Each of the 48 reinforcement lessons - one for every skill in the catalogue - now
has **Have the tutor explain this lesson** on it. It asks LFM3-Omni, on this
phone, to retell that lesson in English, Spanish or Italian, in its own words,
using only what the lesson itself says: no invented rules, no invented numbers,
and under 120 words so it stays a second explanation and not a second lesson.

That closes the question of coverage: every theme the app teaches, the tutor can
teach again.

## The blank sheet

On a lesson the sheet opened with its title, its language chips, its small print
and nothing in between. No spinner, no error, no answer - the worst kind of
failure, because nothing on the screen said anything had gone wrong.

The cause was the order things were built in. The tutor object is created when
it is first read, and the first version of its one-time setup was guarded by a
plain "already started" flag. So a sheet that opened and waited for setup came
back at once, while the very first read of the phone's status was still in
flight, and asked a tutor that did not yet know this phone had a model in it.
That tutor answered nothing, and the sheet drew the nothing.

Three changes, each of which alone would have hidden the bug:

* the tutor is created and reads the phone's status at launch, not when a sheet
  opens, so the first question never races the first status read;
* setup is one shared future: whoever waits for it has really waited;
* a question always waits for that read before it is put to the engine, and if
  the phone still cannot run the tutor the sheet says which of the two reasons
  it is - this phone cannot run it, or the model is not downloaded yet - and
  names the place to download it, instead of showing an empty box.

Three tests pin the failures: a question asked before the status read finishes,
setup called twice, and the message shown when the model is missing.

## Plain prose, not asterisks

Asked for a lesson explanation in Spanish, the tutor wrote
`**Idea en palabras sencillas:**` - and the sheet drew the asterisks as words,
while the read-aloud voice said "asterisk asterisk" in the middle of the
sentence. The lesson prompt now asks for plain prose with no markdown and no
asterisks, and the sheet strips what a small model leaks anyway: emphasis
markers, heading hashes, backticks and bullet stars. The answer is what is read
aloud, so the same cleanup is what the candidate hears.

Switching language used to leave the previous answer still being read aloud over
the new one; a new question now stops the old reading first.

## Checks

* 760 tests pass, audit clean (447 questions, per-choice explanations 447 of
  447, 48 lessons).
* The fix was found on the phone, in logcat, not on a host machine: a sheet that
  reported `ask (usable=false supported=false installed=false ...)` while the
  native library was still loading is the signature this release removes.
* Re-checked on the phone after the fix, with a downloaded voice pack on the
  device: the lesson sheet answered in English (79 tokens, 17.5 s) and in
  Spanish (95 tokens, 20.3 s), and both were read aloud by the downloaded voice -
  `pack es-piper loaded`, 4 chunks at 22050 Hz, peak 0.96, straight to the
  speaker; the English Kokoro pack previewed at 24000 Hz, speaker Bella, peak
  0.49.
* One real cause of silence was reproduced and handled: with the phone's media
  volume at zero the voice now says so instead of failing quietly. That check was
  added in v1.11.0 and this release relies on it.