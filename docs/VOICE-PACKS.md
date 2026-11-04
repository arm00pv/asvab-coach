# Voice packs

These are the files the app downloads for its neural voices. They are not in the
repository: together they are 122 MB, and the app verifies each one by size and
SHA-256 before using it.

| Pack | Language | Engine | Download | SHA-256 |
| --- | --- | --- | --- | --- |
| `en-kokoro` | English | Kokoro-82M int8 (Apache-2.0) | 94,210,357 bytes | `fa22b6754cfd024b7258461b257e723c6f6eddbb183bde9ec8ea6539517f55fa` |
| `es-piper` | Spanish (Spain) | Piper VITS `es_ES-davefx-medium` int8 (CC0) | 14,121,495 bytes | `b48cfc9f67b49bbbcb3560a8df8f296d35d781ef10f444e44c9280d3eb0dc629` |
| `it-piper` | Italian | Piper VITS `it_IT-paola-medium` int8 (CC0) | 14,060,490 bytes | `aa4fd85179cbf439f961b73845b51fdbf313520c265a3b5ab317d16dbc824ab2` |

Each archive is a gzipped tar containing the model, its tokens (and voices for
Kokoro) and a trimmed espeak-ng-data (1.1 MB: the en/es/it dictionaries and the
shared phoneme data, not the 113-language set the upstream packs carry).

## Reproducing them

1. Download from the upstream tts-models release:
   - https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/kokoro-int8-en-v0_19.tar.bz2
   - https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-piper-es_ES-davefx-medium-int8.tar.bz2
   - https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-piper-it_IT-paola-medium-int8.tar.bz2
2. Unpack, rename the Kokoro model to model.onnx, trim espeak-ng-data to the
   en/es/it dictionaries, and tar the contents flat:
   model.onnx, tokens.txt, [voices.bin], espeak-ng-data/

## Licences

* **Kokoro-82M** - Apache-2.0 weights (hexgrad/Kokoro-82M). Redistribution is
  allowed with the licence; the archive carries its LICENSE file.
* **es_ES-davefx-medium** - CC0 dataset (NabuCasa/voice-datasets), MODEL_CARD
  included in the archive.
* **it_IT-paola-medium** - the training set's card is CC0
  (paolapersico1/Voice-Dataset-Italian), MODEL_CARD included.
* **sherpa-onnx** - Apache-2.0; the prebuilt arm64 libraries are vendored in
  android/app/src/main/jniLibs/arm64-v8a.
