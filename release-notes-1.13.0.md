# v1.13.0 - a Spanish voice that sounds like home

## Two Spanish voices, and the candidate picks

The app had one Spanish voice, and it was Castilian. That voice says "grathias"
where a Mexican speaker says "gracias", and most Spanish speakers a
National Guard candidate meets - and most of the Guard's own - say the second.
A tutor that answers in the wrong accent is not wrong about the maths; it is
just not theirs to learn in.

`es-mx-piper` is the Mexican voice: Piper VITS `es_MX-ald-medium` int8,
14.2 MB, trained on public-domain (Unlicense) Mexican Spanish, and it phonemises
with Latin American Spanish (`es-419`), not Castilian. It appears in Settings
beside the Castilian voice:

* download either one, or both;
* the row for the voice in use says **In use**, and the other offers **Use this
  voice** - one tap, remembered across launches;
* **Hear it** always previews the row you tapped, even when another voice is the
  chosen one;
* if the chosen voice is removed, the other one for that language takes over
  instead of leaving the tutor silent.

Nothing is replaced and nothing is downloaded for the candidate: the Castilian
voice stays exactly where it was.

## How it is stored

One pack id in the speech settings, resolved against the language at the moment
it is used - so choosing the Mexican voice for Spanish cannot make it the voice
for English or Italian. A pack id for a language that is not being spoken is
ignored rather than trusted.

## Checks

* The catalogue offers both accents and resolves the choice; the chosen pack is
  the one asked to speak; a chosen pack that was removed falls back to the other.
* The pack is verified the same way as the rest: size and SHA-256
  (`8b5cfb86…6884d47`, 14,171,852 bytes) before it is unpacked.
* 772 tests, audit and CI green, and the pack archive checked against the
  uploaded asset (size and digest). The APK is built and waiting for the phone
  to be plugged back in before this release is published - the download and the
  extraction on hardware are the two things no test on this laptop can prove.
