cmake_minimum_required(VERSION 3.22)
project(asvab_llm CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# llm_bridge links against the packaged llama.cpp libraries beside this folder
# rather than rebuilding them: the prebuilt arm64 build is stripped to 8 MB and
# a full source build would add minutes to every CI run.
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
else()
    # 32-bit phones and the x86_64 emulator get a stub that reports no engine,
    # so the app stays one multi-ABI artefact.
    add_library(asvab_llm SHARED llm_bridge_stub.cpp)
    target_link_libraries(asvab_llm log android)
endif()
