# GPU acceleration for the on-device tutor (Vulkan)

Status: **implemented, measured on a Pixel 7 Pro (Mali-G710), and shipped in
v1.13.0**.

## What changed

| File | Change |
|---|---|
| `android/app/src/main/cpp/llm_bridge.cpp` | Offloads all layers when an offloading backend registered; `n_ubatch` 128 on the GPU; retries CPU-only if the GPU load fails; answers `gpu()` for the app |
| `android/app/src/main/cpp/llm_bridge_stub.cpp` | `gpu()` returns 0 on the ABIs that have no engine |
| `android/app/src/main/kotlin/.../llm/LlmTutor.kt` | Reports `gpu` in the status map |
| `lib/core/tutor.dart` | `TutorStatus.gpu`, kept across the `loaded` event |
| `lib/screens/settings_screen.dart` | Says which processor answers, and why |
| `android/app/src/main/jniLibs/arm64-v8a/libggml-vulkan.so` | **New** — the Vulkan backend, built from llama.cpp `b12032` |
| `tools/build_ggml_vulkan_android.ps1` | Reproducible build script for the backend |

`CMakeLists.txt` needed no edit: the bridge calls
`ggml_backend_load_all_from_path(nativeLibraryDir)`, so a backend dropped into
`jniLibs/arm64-v8a` is discovered at runtime with no link-time dependency.

### The bridge change

```cpp
const bool gpu_offload = llama_supports_gpu_offload();
mparams.n_gpu_layers = gpu_offload ? 999 : 0;
cparams.n_ubatch = gpu_offload ? 128 : 512;
```

`llama_supports_gpu_offload()` is asked rather than enumerating ggml devices,
because `ggml_backend_dev_type`/`dev_name` live in `libggml-base.so`, which this
bridge does not link.

A failed GPU load is retried with `n_gpu_layers = 0` so a driver that advertises
Vulkan but cannot host the model never takes the tutor down.

## Measured on the phone

Pixel 7 Pro, LFM3-Omni 2B Q4_K_M, the same lesson prompt, model already in
memory, greedy decoding, timings read off the tutor sheet's own footnote:

| | CPU | Vulkan GPU |
|---|---|---|
| Reading the question (prefill) | **3.9 - 4.2 s** | **6.2 s** (9.1 s on the first question of a process) |
| Writing the answer | **5.9 - 7.0 tokens/s** | **9.6 - 9.7 tokens/s** |
| Answer of 111 tokens, wall clock | ~21 s (4.0 s + 111/6.5) | **~17.8 s** (6.2 s + 111/9.6) |
| Model load into memory | ~2.2 s | ~3.5 s |
| APK | 38.8 MB | 49.1 MB |

What that means in practice: the GPU writes about 45 % faster, and pays for it
with about two more seconds before the first word appears. For the tutor's
120-word answers the two cancel out into a net win of roughly 10-15 % wall
clock - but the *visible* difference is that the answer appears at a steadier
rate once it starts.

### Two things that were measured and not kept

* **Flash attention.** `flash_attn_type = ENABLED` produced identical timings
  (6.2 s read, 9.6 tokens/s), so it is off: one more way the GPU path could
  differ from the CPU path for no gain.
* **`n_ubatch = 512` on the GPU** (the CPU value): 7.3 s to read the question
  versus 6.2 s at 128. Vulkan dispatches a shader per operation instead of
  looping per thread, so a wide batch spends its time in dispatch and memory
  traffic rather than arithmetic; the CPU still gets 512, where a wide batch is
  what makes it fast.

## Build provenance

| Item | Value |
|---|---|
| llama.cpp | `b12032` (commit `dde879b`), matching the prebuilt libs already in `jniLibs` |
| NDK | `28.2.13676358` — the version pinned in `build.gradle.kts` |
| Android platform | `android-28` (Vulkan 1.1 symbols; see portability below) |
| ABI | `arm64-v8a` only |
| Shader compiler | `glslc` from Vulkan SDK 1.4.363.0 |
| Config | `-DBUILD_SHARED_LIBS=ON -DGGML_BACKEND_DL=ON -DGGML_VULKAN=ON -DGGML_OPENMP=OFF` |

Rebuild: `powershell -File tools/build_ggml_vulkan_android.ps1`, then copy
`llama-vk-build-android/bin/libggml-vulkan.so` into `jniLibs/arm64-v8a/`.

## Verified on device

```
ggml_vulkan: Found 1 Vulkan devices:
ggml_vulkan: 0 = Mali-G710 | uma: 1 | fp16: 1 | int dot: 1 | shared memory: 32768 | matrix cores: none
load_backend: loaded Vulkan backend from .../lib/arm64/libggml-vulkan.so
AsvabLlm: backend registry: 2, gpu offload: 1
AsvabLlm: gpu offload: 1, n_gpu_layers=999
AsvabLlm: llama_prepare_model_devices: using device Vulkan0 (Mali-G710) - 11568 MiB free
```

Note `int dot: 1` — integer dot-product is enabled in this build (`glslc` feature
detection found it), which is what quantised matmul wants. The Termux build of
the same backend reported `int dot: 0`.

## What the app says about it

The AI tutor card in Settings now names the processor:

* **Running on this phone's GPU (Vulkan): faster to write, and the CPU stays free.**
* **Running on this phone's CPU. No usable Vulkan GPU was found, so this is the
  same path every phone used before the GPU build.**

## Portability: which phones get the GPU?

Vulkan is the right choice because it is the only GPU API that is universal on
Android and covers every vendor — Mali (Arm), Adreno (Qualcomm), Xclipse
(Samsung/AMD), PowerVR (Imagination). It also degrades cleanly:

| Device | Behaviour |
|---|---|
| Any phone with a working Vulkan driver | backend loads, all layers offloaded |
| Vulkan advertised but model does not fit | bridge retries CPU-only |
| No Vulkan driver / driver rejected at dlopen | `llama_supports_gpu_offload()` is false, `n_gpu_layers` stays 0 — **exactly the old CPU behaviour**, and the settings card says CPU |
| 32-bit or x86_64 | those ABIs build the stub, unaffected |

**One caveat to know:** the backend is linked at `android-28`, the first platform
exposing Vulkan 1.1 (`vkGetPhysicalDeviceFeatures2`). On Android 8.x and older
the `dlopen` fails and the app silently stays on the CPU — no crash, no
user-visible error, just no speed-up, and the card says CPU.

## Cost

| | Before | After |
|---|---|---|
| APK | ~40 MB | **49.1 MB** |
| `libggml-vulkan.so` (installed) | — | **33.5 MB** |

The backend is large because it embeds hundreds of pre-compiled SPIR-V shader
variants. If that matters, the next lever is trimming the shader set or shipping
the backend as a Play Asset Delivery / feature-on-demand module and loading it
only on devices that can use it.

## Verifying on any device

```
adb logcat -s AsvabLlm:V
```

Look for `Found 1 Vulkan devices`, `loaded Vulkan backend`, `gpu offload: 1`, and
the settings card naming the GPU.
