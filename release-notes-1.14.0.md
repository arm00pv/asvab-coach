# v1.14.0 - the GPU, on your terms

## A switch, because faster is not the same as better

The GPU writes the tutor's answer about 45 % faster - 9.6 tokens/s against
5.9-7.0 on the CPU - and takes about two seconds longer to start, because a
graphics processor reads the question more slowly than the CPU does. For most
candidates that is a net win of 10-15 % end to end. For a phone whose driver is
slow under load, or warm in a pocket, it is not obviously the trade you want.

So the AI tutor card now carries **Use the GPU**:

* it is on by default, and the card still says which processor is answering;
* it only appears on phones where a Vulkan backend actually registered - a
  phone without one keeps the CPU path and never sees the switch;
* the choice is remembered across launches and travels with the load, because
  the model's layers are placed when it is read;
* switching it unloads a model that is already in memory and the next question
  reads it onto the other processor, so the switch can never be a label that
  does not match what is running.

## Why it is a choice rather than a default to the fast one

Measured on the Pixel 7 Pro, the same lesson question, the model already in
memory:

| | CPU | GPU (Vulkan) |
|---|---|---|
| Reading the question | 3.9 - 4.2 s | 6.2 s |
| Writing the answer | 5.9 - 7.0 tokens/s | **9.6 - 9.7 tokens/s** |
| 111-token answer, end to end | ~21 s | **~17.8 s** |

The first token arrives later on the GPU; the writing is steadier and the total
is shorter. A candidate who asks one short question notices the wait; one who
reads a 120-word explanation notices the pace. Both are legitimate, so both are
available.

## Fixed while testing on the phone

Choosing between the two Spanish voices saved the choice and left the row
looking untouched. The section listened to the downloaded packs; the choice
lives on the speech service, so tapping **Use this voice** repainted nothing
and "In use" stayed on the other accent until the page was opened again.

The row that offers the choice now also marks it, at once: the section listens
to both. A widget test drives the tap and checks that "In use" moves to the
row that was chosen.

## Checks

* The switch reaches every layer: Dart setting -> load argument -> Kotlin ->
  `n_gpu_layers` in C++, with a contract test reading all four files.
* A loaded model is unloaded when the choice changes, and the next load carries
  the new value (unit test with a fake platform).
* The JNI call gained an argument (the GPU choice), and that is the one thing a
  host test cannot prove: `integration_test/gpu_load_test.dart` loads the model
  on the CPU and then on the GPU through the same path the app uses, and prints
  the timings. It needs a development install with the model already downloaded.
* The voice row is covered by a widget test that taps **Use this voice** and
  checks that "In use" moves to the chosen accent.
* 778 tests, audit clean, CI green.