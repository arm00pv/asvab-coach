// The same four entry points on architectures the model does not ship for.
//
// The app runs on 32-bit phones and on an x86_64 emulator; saying "no engine"
// is honest, while a missing symbol would crash the app on launch. Flutter
// still packages this library so the Android build stays multi-ABI.
#include <jni.h>

extern "C" JNIEXPORT jboolean JNICALL
Java_com_arm00pv_asvabcoach_llm_NativeLlm_probe(JNIEnv *, jobject, jstring) {
    return JNI_FALSE;
}

extern "C" JNIEXPORT jlong JNICALL
Java_com_arm00pv_asvabcoach_llm_NativeLlm_load(
        JNIEnv *, jobject, jstring, jint, jint) { return 0; }

extern "C" JNIEXPORT jstring JNICALL
Java_com_arm00pv_asvabcoach_llm_NativeLlm_generate(
        JNIEnv * env, jobject, jlong, jstring, jint, jfloat, jint, jfloat, jobject) {
    return env->NewStringUTF("");
}

extern "C" JNIEXPORT void JNICALL
Java_com_arm00pv_asvabcoach_llm_NativeLlm_cancel(JNIEnv *, jobject, jlong) {}

extern "C" JNIEXPORT void JNICALL
Java_com_arm00pv_asvabcoach_llm_NativeLlm_free(JNIEnv *, jobject, jlong) {}
