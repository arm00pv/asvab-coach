# Rules that keep the tutor's native boundary intact through R8.
#
# The token callback is called from C++ (llm_bridge.cpp) with GetMethodID and
# CallVoidMethod. R8 cannot see that caller, so without these rules it renames
# the class and the method. The lookup then fails, and because a failed
# GetMethodID leaves a pending NoSuchMethodError, the JVM rethrows it when the
# native frame returns: the app dies with "FATAL EXCEPTION: pool-4-thread-1 ...
# NoSuchMethodError: no non-static method onToken". That is a crash only a
# release build on a real phone shows, which is why it happened here.
#
# The Dart side of this contract is checked by test/native_contract_test.dart.

-keep class com.arm00pv.asvabcoach.llm.LlmTokenSink { *; }

-keepclassmembers class com.arm00pv.asvabcoach.llm.** {
    public void onToken(java.lang.String);
}

# The library is opened by name from the app, and the JNI symbol names in the C
# bridge are derived from these classes. Keeping them costs a few hundred bytes
# and removes a category of release-only failure.
-keepclasseswithmembernames class * {
    native <methods>;
}
