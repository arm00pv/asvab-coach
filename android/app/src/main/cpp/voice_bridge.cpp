// The bridge between the app and sherpa-onnx's offline text-to-speech engine.
//
// sherpa-onnx runs a VITS or Kokoro model on onnxruntime, on the device, with no
// network at all. It exposes four things here - create, sample rate, generate,
// free - and Kotlin does the rest: reading the downloaded pack, and playing the
// samples through AudioTrack.
//
// The engine is built with espeak-ng inside it (v1.13.8, before the 2.0 release
// removed it), so a pack only has to carry its model, its tokens and a trimmed
// espeak-ng-data directory. That is what makes an English and a Spanish voice
// work from the same code path.
#include <jni.h>

#include <android/log.h>
#include <cstring>
#include <exception>
#include <string>

#include "sherpa-onnx/c-api/c-api.h"

#define LOG_TAG "AsvabVoice"
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)

namespace {

std::string to_std(JNIEnv * env, jstring value) {
    if (value == nullptr) return std::string();
    const char * chars = env->GetStringUTFChars(value, nullptr);
    std::string out(chars == nullptr ? "" : chars);
    if (chars != nullptr) env->ReleaseStringUTFChars(value, chars);
    return out;
}

struct Engine {
    const SherpaOnnxOfflineTts * tts = nullptr;
};

Engine * as_engine(jlong handle) {
    return reinterpret_cast<Engine *>(static_cast<intptr_t>(handle));
}

}  // namespace

extern "C" JNIEXPORT jlong JNICALL
Java_com_arm00pv_asvabcoach_voice_NativeVoice_create(
        JNIEnv * env,
        jobject,
        jint kind,
        jstring jmodel,
        jstring jtokens,
        jstring jvoices,
        jstring jdata_dir,
        jint threads) {
    const std::string model = to_std(env, jmodel);
    const std::string tokens = to_std(env, jtokens);
    const std::string voices = to_std(env, jvoices);
    const std::string data_dir = to_std(env, jdata_dir);

    SherpaOnnxOfflineTtsConfig config;
    std::memset(&config, 0, sizeof(config));
    config.model.num_threads = threads > 0 ? threads : 2;
    config.model.provider = "cpu";
    config.model.debug = 0;
    config.max_num_sentences = 2;
    config.silence_scale = 0.2f;

    if (kind == 1) {
        // Kokoro: an 82 M parameter model with one embedding per voice.
        config.model.kokoro.model = model.c_str();
        config.model.kokoro.voices = voices.c_str();
        config.model.kokoro.tokens = tokens.c_str();
        config.model.kokoro.data_dir = data_dir.c_str();
        config.model.kokoro.length_scale = 1.0f;
        config.model.kokoro.lang = "en";
    } else {
        config.model.vits.model = model.c_str();
        config.model.vits.tokens = tokens.c_str();
        config.model.vits.data_dir = data_dir.c_str();
        config.model.vits.noise_scale = 0.667f;
        config.model.vits.noise_scale_w = 0.8f;
        config.model.vits.length_scale = 1.0f;
    }

    try {
        const SherpaOnnxOfflineTts * tts = SherpaOnnxCreateOfflineTts(&config);
        if (tts == nullptr) {
            LOGE("the engine was created for a pack it cannot read");
            return 0;
        }
        auto * engine = new Engine();
        engine->tts = tts;
        LOGI("voice ready: %d Hz", SherpaOnnxOfflineTtsSampleRate(tts));
        return reinterpret_cast<jlong>(engine);
    } catch (const std::exception & error) {
        LOGE("create threw: %s", error.what());
        return 0;
    } catch (...) {
        LOGE("create threw something that is not a std::exception");
        return 0;
    }
}

extern "C" JNIEXPORT jint JNICALL
Java_com_arm00pv_asvabcoach_voice_NativeVoice_sampleRate(
        JNIEnv *, jobject, jlong handle) {
    Engine * engine = as_engine(handle);
    if (engine == nullptr || engine->tts == nullptr) return 0;
    return SherpaOnnxOfflineTtsSampleRate(engine->tts);
}

extern "C" JNIEXPORT jfloatArray JNICALL
Java_com_arm00pv_asvabcoach_voice_NativeVoice_generate(
        JNIEnv * env,
        jobject,
        jlong handle,
        jstring jtext,
        jint speaker_id,
        jfloat speed) {
    Engine * engine = as_engine(handle);
    if (engine == nullptr || engine->tts == nullptr) return nullptr;
    const std::string text = to_std(env, jtext);
    if (text.empty()) return nullptr;

    const SherpaOnnxGeneratedAudio * audio = nullptr;
    try {
        audio = SherpaOnnxOfflineTtsGenerate(
                engine->tts, text.c_str(), speaker_id, speed);
    } catch (const std::exception & error) {
        LOGE("generate threw: %s", error.what());
        return nullptr;
    }
    if (audio == nullptr || audio->n <= 0) {
        LOGE("the engine produced no samples");
        return nullptr;
    }

    jfloatArray out = env->NewFloatArray(audio->n);
    if (out != nullptr) {
        env->SetFloatArrayRegion(out, 0, audio->n, audio->samples);
    }
    SherpaOnnxDestroyOfflineTtsGeneratedAudio(audio);
    return out;
}

extern "C" JNIEXPORT void JNICALL
Java_com_arm00pv_asvabcoach_voice_NativeVoice_free(
        JNIEnv *, jobject, jlong handle) {
    Engine * engine = as_engine(handle);
    if (engine == nullptr) return;
    if (engine->tts != nullptr) SherpaOnnxDestroyOfflineTts(engine->tts);
    delete engine;
}
