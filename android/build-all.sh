#!/bin/bash

# Remove old build output dirs
rm -rf build jniLibs tools includes

# Supported ABIs and corresponding cross-file names
ABIS=("arm64-v8a" "armeabi-v7a" "x86" "x86_64")
CROSS_FILE_NAMES=("aarch64-android" "arm-android" "x86-android" "x86_64-android")

# Build for each ABI
for ((i=0; i<${#ABIS[@]}; i++)); do
  abi=${ABIS[i]}
  cross_file_name=${CROSS_FILE_NAMES[i]}
  
  echo "Building for ABI: $abi"

  # Create a build directory for the ABI
  mkdir -p build/$abi
  cd build/$abi

  # Configure the build system
  meson setup ../../.. --cross-file=../../../package/crossfiles/$cross_file_name.meson --buildtype release

  # Build the project
  ninja

  # Go back to the parent directory
  cd ../..

  # Create output jniLibs dir for the ABI
  mkdir -p jniLibs/$abi

  # Copy the output libdav1d.so files to jniLibs dir
  cp -r build/$abi/src/libdav1d.so jniLibs/$abi

  mkdir -p tools/$abi/bin tools/$abi/src

  cp -r build/$abi/tools/dav1d tools/$abi/bin

  cp -r build/$abi/src/libdav1d.so tools/$abi/src

  mkdir -p includes

  cp -r build/$abi/include includes/$abi

done

rm -rf build
