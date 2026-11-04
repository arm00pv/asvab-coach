cmake_minimum_required(VERSION 3.22)
project(asvab_llm CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Both bridges link against prebuilt arm64 libraries packaged beside this folder
# rather than rebuilding them: the llama.cpp build is stripped to 8 MB and the
# sherpa-onnx one to 27 MB, and a source build of either would add minutes to
# every CI run.
set(JNI_LIBS ${CMAKE_CURRENT_SOURCE_DIR}/../jniLibs/${ANDROID_ABI})

if(ANDROID_ABI STREQUAL "arm64-v8a")
    add_library(asvab_llm SHARED llm_bridge.cpp)
    target_include_directories(asvab_llm PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)

    add_library(llama SHARED IMPORTED)
    set_target_properties(llama PROPERTIES
        IMPORTED_LOCATION ${JNI_LIBS}/libllama.so)

    # The backend loader lives in ggml, not in llama: the CPU kernels are their
    # own libraries and have to be registered before a model can be mapped.
    add_library(ggml SHARED IMPORTED)
    set_target_properties(ggml PROPERTIES
        IMPORTED_LOCATION ${JNI_LIBS}/libggml.so)

    target_link_libraries(asvab_llm llama ggml log android)

    # The neural voices: sherpa-onnx's C API over onnxruntime.
    add_library(asvab_voice SHARED voice_bridge.cpp)
    target_include_directories(asvab_voice PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)

    add_library(sherpa_capi SHARED IMPORTED)
    set_target_properties(sherpa_capi PROPERTIES
        IMPORTED_LOCATION ${JNI_LIBS}/libsherpa-onnx-c-api.so)

    add_library(onnxruntime SHARED IMPORTED)
    set_target_properties(onnxruntime PROPERTIES
        IMPORTED_LOCATION ${JNI_LIBS}/libonnxruntime.so)

    target_link_libraries(asvab_voice sherpa_capi onnxruntime log android)
else()
    # 32-bit phones and the x86_64 emulator get stubs that report no engine, so
    # the app stays one multi-ABI artefact.
    add_library(asvab_llm SHARED llm_bridge_stub.cpp)
    target_link_libraries(asvab_llm log android)

    add_library(asvab_voice SHARED voice_bridge_stub.cpp)
    target_link_libraries(asvab_voice log android)
endif()
