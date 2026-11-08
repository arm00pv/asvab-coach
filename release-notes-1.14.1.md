# v1.14.1 - the card tells the truth about the GPU

v1.14.0 made the GPU a choice and put the choice on the AI tutor card. Testing
it on the phone found the card's sentence about which processor is answering
was sometimes a guess presented as a reading.

## What the phone drew

The model was already in memory, on the Vulkan device - the log said
`offloaded 25/25 layers to GPU` - and the card said:

> Running on this phone's CPU. No usable Vulkan GPU was found, so this is the
> same path every phone used before the GPU build.

Two things were wrong at once. The app rebuilt its status from the value it had
*before* the load, so the answer "the GPU" never made it to the screen; and the
only way the app could ask where the layers went was the question "can this
phone run the GPU at all", which answers for the phone rather than for the load.

## The fix

The bridge now answers two questions separately:

* `gpu()` - can this phone run the model on the GPU? This is what decides
  whether the **Use the GPU** switch is offered.
* `modelGpu()` - where are the layers of the model in memory? This is what the
  card prints, and it is set by the load: 1 when the layers went to Vulkan, 0
  after the CPU fallback, 0 again when the model is freed.

The `loaded` event carries that answer, so the sentence on screen comes from
the load that produced it rather than from a guess made a moment earlier.

There is a third sentence now, for the case that used to be impossible to
describe: the phone has a GPU, the switch is on, and the driver refused the
allocation, so the load fell back. The card says that, instead of saying the
phone has no GPU.

## Checks

* The contract test watches all five files: bridge, stub, Kotlin, the status
  map and the load event, plus the sentence the card prints.
* A unit test loads with the GPU answer `false` while the phone reports a GPU
  available, and checks the app believes the load.
* 779 tests, audit clean, checked on the Pixel 7 Pro.
