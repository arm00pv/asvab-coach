# v1.13.0 - a Spanish voice that sounds like home, and the GPU

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

## The tutor runs on the GPU

The phone's graphics processor is now used for the on-device tutor, through
Vulkan. The backend ships inside the app, loads itself only where the phone's
driver accepts it, and leaves every other phone on exactly the CPU path it had
before - no setting, no crash, and the Settings card says which one you got.

Measured on a Pixel 7 Pro with the same lesson question:

| | CPU | GPU (Vulkan) |
|---|---|---|
| Reading the question | 3.9 - 4.2 s | 6.2 s |
| Writing the answer | 5.9 - 7.0 tokens/s | **9.6 - 9.7 tokens/s** |
| A 111-token answer, end to end | ~21 s | **~17.8 s** |

The GPU writes about 45 % faster and takes about two seconds longer to start;
for the tutor's answers that is a net 10-15 % quicker, with the words arriving at
a steadier rate. All of it stays on the phone, with no network, like everything
else in the tutor.

Three details worth knowing, all measured rather than assumed:

* the GPU batch is 128 tokens, not the CPU's 512: a wide batch spends its time
  in shader dispatch, and on this phone it cost a second of latency;
* flash attention was tried and dropped - identical timings, one more way the
  GPU path could differ for nothing;
* if a driver advertises Vulkan but cannot host the model, the engine retries on
  the CPU instead of failing, and the Settings card reports the CPU.

`docs/AI_GPU_VULKAN.md` carries the provenance of the backend build, the numbers
above and the portability table (which phones get the GPU, and the Android 8
caveat).

## Checks

* The catalogue offers both accents and resolves the choice; the chosen pack is
  the one asked to speak; a chosen pack that was removed falls back to the other.
* The pack is verified the same way as the rest: size and SHA-256
  (`8b5cfb86…6884d47`, 14,171,852 bytes) before it is unpacked, and it was
  downloaded and heard on the phone: `pack es-mx-piper loaded: kind=0, 22050 Hz`,
  78,592 samples, peak 0.71.
* The GPU path was driven on the phone: `Found 1 Vulkan devices` (Mali-G710),
  `loaded Vulkan backend`, `gpu offload: 1`, layers assigned to `Vulkan0`, and a
  full lesson answer written at 9.6 tokens/s.
* Two voice rows at 2x system text used to squeeze "Spanish (Mexico)" to four
  characters a line; the row is now a name line and a wrapping action line, and
  a widget test pins it.
* 775 tests, audit and CI green.