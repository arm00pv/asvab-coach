# Build libggml-vulkan.so for Android arm64 at llama.cpp b12032
# Output is dropped into app/src/main/jniLibs/arm64-v8a so the app's existing
# ggml_backend_load_all_from_path() picks it up at runtime.
$ErrorActionPreference = 'Stop'

$ndk    = 'C:\Users\andre\AppData\Local\Android\Sdk\ndk\28.2.13676358'
$sdkVk  = (Get-ChildItem 'C:\VulkanSDK' -Directory | Sort-Object Name -Descending | Select-Object -First 1).FullName
$src    = 'C:\Users\andre\dev\llama-vk'
$build  = 'C:\Users\andre\dev\llama-vk-build-android'
$cmakeDir = 'C:\Users\andre\AppData\Local\Android\Sdk\cmake\3.31.6'
$cmake  = "$cmakeDir\bin\cmake.exe"
$ninja  = "$cmakeDir\bin\ninja.exe"
$vcvars = 'C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvars64.bat'
$glslc  = "$sdkVk\Bin\glslc.exe"
$api    = '24'

foreach ($p in @($cmake, $ninja, $vcvars, $glslc)) {
  if (-not (Test-Path $p)) { throw "missing prerequisite: $p" }
}
"cmake=$cmake"
"ninja=$ninja"
"glslc=$glslc"
"ndk=$ndk"
"vulkan_lib_exists=" + (Test-Path "$ndk\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\lib\aarch64-linux-android\$api\libvulkan.so")

if (Test-Path $build) { Remove-Item -Recurse -Force $build }

$args = @(
  '-S', $src, '-B', $build, '-G', 'Ninja',
  "-DCMAKE_MAKE_PROGRAM=$ninja",
  "-DCMAKE_TOOLCHAIN_FILE=$ndk\build\cmake\android.toolchain.cmake",
  '-DANDROID_ABI=arm64-v8a',
  "-DANDROID_PLATFORM=android-$api",
  '-DCMAKE_BUILD_TYPE=Release',
  '-DBUILD_SHARED_LIBS=ON',
  '-DGGML_BACKEND_DL=ON',
  '-DGGML_VULKAN=ON',
  '-DGGML_OPENMP=OFF',
  '-DGGML_NATIVE=OFF',
  '-DLLAMA_BUILD_EXAMPLES=OFF',
  '-DLLAMA_BUILD_TOOLS=OFF',
  '-DLLAMA_BUILD_TESTS=OFF',
  '-DLLAMA_BUILD_SERVER=OFF',
  '-DLLAMA_CURL=OFF',
  "-DVulkan_INCLUDE_DIR=$ndk\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include",
  "-DVulkan_LIBRARY=$ndk\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\lib\aarch64-linux-android\$api\libvulkan.so",
  "-DVulkan_GLSLC_EXECUTABLE=$glslc"
)

$cmd = '"' + $vcvars + '" >nul && "' + $cmake + '" ' + ($args -join ' ') + ' && "' + $cmake + '" --build "' + $build + '" --target ggml-vulkan -- -j 8'
"=== CONFIGURE + BUILD ==="
cmd.exe /c $cmd 2>&1 | Out-String
"BUILD_RC=" + $LASTEXITCODE

"=== ARTIFACTS ==="
$so = Get-ChildItem $build -Recurse -Filter 'libggml-vulkan.so' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($so) { "FOUND: " + $so.FullName + " (" + [math]::Round($so.Length/1MB,1) + " MB)" } else { "NOT FOUND" }
"BUILD_SCRIPT_END"
