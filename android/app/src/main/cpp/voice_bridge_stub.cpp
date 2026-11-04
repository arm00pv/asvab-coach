// The same five entry points for every ABI that does not ship the neural voice
// engine - 32-bit phones and x86_64 emulators - so one multi-ABI APK still
// installs everywhere and the app reports the engine as unavailable.
#include <jni.h>

extern "C" JNIEXPORT jlong JNICALL
Java_com_arm00pv_asvabcoach_voice_NativeVoice_create(
        JNIEnv *, jobject, jint, jstring, jstring, jstring, jstring, jint) {
    return 0;
}

extern "C" JNIEXPORT jint JNICALL
Java_com_arm00pv_asvabcoach_voice_NativeVoice_sampleRate(
        JNIEnv *, jobject, jlong) {
    return 0;
}

extern "C" JNIEXPORT jfloatArray JNICALL
Java_com_arm00pv_asvabcoach_voice_NativeVoice_generate(
        JNIEnv *, jobject, jlong, jstring, jint, jfloat) {
    return nullptr;
}

extern "C" JNIEXPORT void JNICALL
Java_com_arm00pv_asvabcoach_voice_NativeVoice_free(JNIEnv *, jobject, jlong) {}
