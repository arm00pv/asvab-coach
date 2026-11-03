// The bridge between the app and llama.cpp.
//
// It exposes exactly four things - load, generate, cancel, free - because that
// is all the tutor needs and every extra entry point is another way for a
// candidate's memory to leak on a device we cannot debug afterwards.
//
// Generation streams: every token is handed back to Kotlin as it is sampled, so
// the first sentence is on screen while the rest is still being computed.
#include <jni.h>

#include <android/log.h>
#include <atomic>
#include <cstring>
#include <string>
#include <vector>

#include "ggml-backend.h"
#include "llama.h"

#define LOG_TAG "AsvabLlm"
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)

namespace {

// llama.cpp logs to stderr, which Android throws away. Without this the only
// thing a phone can tell you about a failed load is that it failed.
void log_to_android(enum ggml_log_level level, const char * text, void * /*user*/) {
    if (text == nullptr) return;
    int priority = ANDROID_LOG_DEBUG;
    if (level == GGML_LOG_LEVEL_ERROR) priority = ANDROID_LOG_ERROR;
    else if (level == GGML_LOG_LEVEL_WARN) priority = ANDROID_LOG_WARN;
    __android_log_write(priority, LOG_TAG, text);
}

struct Engine {
    llama_model * model = nullptr;
    llama_context * ctx = nullptr;
    const llama_vocab * vocab = nullptr;
    std::atomic<bool> cancel{false};
    int n_ctx = 0;
};

bool g_backend_ready = false;

Engine * as_engine(jlong handle) {
    return reinterpret_cast<Engine *>(static_cast<intptr_t>(handle));
}

std::string jstring_to_std(JNIEnv * env, jstring value) {
    if (value == nullptr) return std::string();
    const char * chars = env->GetStringUTFChars(value, nullptr);
    std::string out(chars == nullptr ? "" : chars);
    if (chars != nullptr) env->ReleaseStringUTFChars(value, chars);
    return out;
}

// The model writes "<|im_end|>" at the end of its turn and that is not part of
// an answer. Cutting it here keeps it out of a candidate's screen and out of the
// speech guide that reads the answer aloud.
bool has_stop_marker(const std::string & text, size_t & cut_at) {
    static const char * markers[] = {"<|im_end|>", "<|endoftext|>", "<|im_start|>"};
    for (const char * marker : markers) {
        const size_t at = text.find(marker);
        if (at != std::string::npos) {
            cut_at = at;
            return true;
        }
    }
    return false;
}

}  // namespace

extern "C" JNIEXPORT jboolean JNICALL
Java_com_arm00pv_asvabcoach_llm_NativeLlm_probe(
        JNIEnv * env, jobject, jstring jlib_dir) {
    if (!g_backend_ready) {
        llama_log_set(log_to_android, nullptr);
        llama_backend_init();
        // The CPU kernels ship as their own libraries in this build, and
        // llama.cpp will not touch a model until one is registered. The
        // libraries live in the app's native library directory, which is the
        // only place the loader can find them on Android.
        const std::string dir = jstring_to_std(env, jlib_dir);
        if (!dir.empty()) {
            ggml_backend_load_all_from_path(dir.c_str());
        } else {
            ggml_backend_load_all();
        }
        LOGI("backend registry: %d", static_cast<int>(ggml_backend_reg_count()));
        g_backend_ready = true;
    }
    return ggml_backend_reg_count() > 0 ? JNI_TRUE : JNI_FALSE;
}

extern "C" JNIEXPORT jlong JNICALL
Java_com_arm00pv_asvabcoach_llm_NativeLlm_load(
        JNIEnv * env, jobject, jstring jpath, jint n_ctx, jint n_threads) {
    if (!g_backend_ready) {
        llama_log_set(log_to_android, nullptr);
        llama_backend_init();
        ggml_backend_load_all();
        g_backend_ready = true;
    }

    const std::string path = jstring_to_std(env, jpath);
    if (path.empty()) return 0;

    llama_model_params mparams = llama_model_default_params();
    mparams.n_gpu_layers = 0;

    llama_model * model = llama_model_load_from_file(path.c_str(), mparams);
    if (model == nullptr) {
        LOGE("could not load the model at %s", path.c_str());
        return 0;
    }

    llama_context_params cparams = llama_context_default_params();
    cparams.n_ctx = static_cast<uint32_t>(n_ctx);
    cparams.n_batch = 512;
    cparams.n_ubatch = 512;
    cparams.n_threads = n_threads;
    cparams.n_threads_batch = n_threads;
    cparams.no_perf = true;

    llama_context * ctx = llama_init_from_model(model, cparams);
    if (ctx == nullptr) {
        LOGE("could not create a context");
        llama_model_free(model);
        return 0;
    }

    auto * engine = new Engine();
    engine->model = model;
    engine->ctx = ctx;
    engine->vocab = llama_model_get_vocab(model);
    engine->n_ctx = n_ctx;
    LOGI("model loaded, n_ctx=%d threads=%d", n_ctx, n_threads);
    return static_cast<jlong>(reinterpret_cast<intptr_t>(engine));
}

extern "C" JNIEXPORT jstring JNICALL
Java_com_arm00pv_asvabcoach_llm_NativeLlm_generate(
        JNIEnv * env,
        jobject,
        jlong handle,
        jstring jprompt,
        jint max_tokens,
        jfloat temp,
        jint top_k,
        jfloat top_p,
        jobject sink) {
    Engine * engine = as_engine(handle);
    if (engine == nullptr) return env->NewStringUTF("");

    engine->cancel = false;
    const std::string prompt = jstring_to_std(env, jprompt);

    // Tokenize. A negative return is how llama.cpp says "you gave me no room".
    const int32_t needed = -llama_tokenize(
            engine->vocab, prompt.c_str(), static_cast<int32_t>(prompt.size()),
            nullptr, 0, false, true);
    if (needed <= 0) {
        LOGE("tokenize failed");
        return env->NewStringUTF("");
    }
    std::vector<llama_token> tokens(static_cast<size_t>(needed));
    const int32_t got = llama_tokenize(
            engine->vocab, prompt.c_str(), static_cast<int32_t>(prompt.size()),
            tokens.data(), needed, false, true);
    if (got <= 0) {
        LOGE("tokenize returned %d", got);
        return env->NewStringUTF("");
    }
    tokens.resize(static_cast<size_t>(got));

    // Each question starts from a clean slate; without this the previous
    // answer's keys stay resident and the next one is answered in its shadow.
    llama_memory_clear(llama_get_memory(engine->ctx), true);

    const int32_t n_batch = 512;
    for (int32_t i = 0; i < got; i += n_batch) {
        const int32_t chunk = (i + n_batch <= got) ? n_batch : (got - i);
        llama_batch batch = llama_batch_get_one(tokens.data() + i, chunk);
        if (llama_decode(engine->ctx, batch) != 0) {
            LOGE("prompt decode failed at %d", i);
            return env->NewStringUTF("");
        }
    }

    llama_sampler_chain_params sparams = llama_sampler_chain_default_params();
    llama_sampler * sampler = llama_sampler_chain_init(sparams);
    if (temp <= 0.0f) {
        llama_sampler_chain_add(sampler, llama_sampler_init_greedy());
    } else {
        llama_sampler_chain_add(sampler, llama_sampler_init_top_k(top_k));
        llama_sampler_chain_add(sampler, llama_sampler_init_top_p(top_p, 1));
        llama_sampler_chain_add(sampler, llama_sampler_init_temp(temp));
        llama_sampler_chain_add(sampler, llama_sampler_init_dist(LLAMA_DEFAULT_SEED));
    }

    jclass sink_class = sink == nullptr ? nullptr : env->GetObjectClass(sink);
    jmethodID on_token = sink_class == nullptr
            ? nullptr
            : env->GetMethodID(sink_class, "onToken", "(Ljava/lang/String;)V");
    if (env->ExceptionCheck()) {
        // A failed GetMethodID leaves a pending exception, and the JVM rethrows
        // it as soon as this frame returns - the whole app goes down for a
        // renamed callback. Clear it and answer without streaming: the complete
        // text is still returned to the caller.
        env->ExceptionClear();
        LOGE("token sink has no onToken(String); answering without streaming");
        on_token = nullptr;
    }
    if (on_token == nullptr && sink != nullptr) {
        LOGE("streaming disabled for this generation");
    }

    std::string out;
    out.reserve(2048);

    for (int32_t produced = 0; produced < max_tokens; ++produced) {
        if (engine->cancel.load()) break;

        const llama_token id = llama_sampler_sample(sampler, engine->ctx, -1);
        if (llama_vocab_is_eog(engine->vocab, id)) break;
        llama_sampler_accept(sampler, id);

        char piece[256];
        const int32_t n_piece = llama_token_to_piece(
                engine->vocab, id, piece, sizeof(piece), 0, true);
        if (n_piece > 0) {
            const std::string text(piece, static_cast<size_t>(n_piece));
            out += text;

            size_t cut_at = 0;
            if (has_stop_marker(out, cut_at)) {
                out.resize(cut_at);
                break;
            }

            if (on_token != nullptr) {
                jstring js = env->NewStringUTF(text.c_str());
                env->CallVoidMethod(sink, on_token, js);
                env->DeleteLocalRef(js);
                if (env->ExceptionCheck()) {
                    env->ExceptionClear();
                }
            }
        }

        llama_batch next = llama_batch_get_one(
                const_cast<llama_token *>(&id), 1);
        if (llama_decode(engine->ctx, next) != 0) {
            LOGE("decode failed during generation");
            break;
        }
    }

    llama_sampler_free(sampler);
    return env->NewStringUTF(out.c_str());
}

extern "C" JNIEXPORT void JNICALL
Java_com_arm00pv_asvabcoach_llm_NativeLlm_cancel(JNIEnv *, jobject, jlong handle) {
    Engine * engine = as_engine(handle);
    if (engine != nullptr) engine->cancel = true;
}

extern "C" JNIEXPORT void JNICALL
Java_com_arm00pv_asvabcoach_llm_NativeLlm_free(JNIEnv *, jobject, jlong handle) {
    Engine * engine = as_engine(handle);
    if (engine == nullptr) return;
    if (engine->ctx != nullptr) llama_free(engine->ctx);
    if (engine->model != nullptr) llama_model_free(engine->model);
    delete engine;
}
