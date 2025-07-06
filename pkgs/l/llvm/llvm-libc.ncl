{
  lib,
  llvmFull,
  pythonFull,
  linuxHeaders,
  pyyaml,

  llvmLibc | lib.CmakePackage =
    llvmFull
    & {
      configurePhase | priority 10 = [
        m%"
            cmake -B . -S ${SRC}/runtimes \
                -G Ninja \
                -DBUILD_STATIC_LIBS:BOOL=ON \
                -DLLVM_BUILD_STATIC=ON \
                -DCMAKE_LINK_SEARCH_START_STATIC:BOOL=OFF \
                -DCLANG_LINK_CLANG_DYLIB=OFF \
                -DLLVM_BUILD_LLVM_DYLIB=OFF \
                -DCMAKE_INSTALL_PREFIX=/usr \
                -DLLVM_DYLIB_COMPONENTS='' \
                -DLLVM_LINK_LLVM_DYLIB=OFF \
                -DLLVM_ENABLE_SHARED_LIBS=OFF \
                -DCMAKE_C_COMPILER=clang \
                -DCMAKE_CXX_COMPILER=clang++ \
                -DLLVM_ENABLE_RUNTIMES="libc;compiler-rt" \
                -DLLVM_LIBC_FULL_BUILD=ON \
                -DCMAKE_BUILD_TYPE=Release \
                -DLLVM_LIBC_INCLUDE_SCUDO=ON \
                -DCOMPILER_RT_BUILD_SCUDO_STANDALONE_WITH_LLVM_LIBC=ON \
                -DCOMPILER_RT_BUILD_GWP_ASAN=OFF                       \
                -DCOMPILER_RT_SCUDO_STANDALONE_BUILD_SHARED=OFF        \
                -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
                -DLLVM_ENABLE_SPHINX=OFF \
                -DLIBC_INCLUDE_DOCS=ON \
                -DLIBC_CMAKE_VERBOSE_LOGGING=ON \

            "%
      ],
      buildPhase = [
        "ninja libc libm"
      ],
      installPhase = [
        "DESTDIR=${DEST} ninja install-libc"
      ],
      postInstallPhase | priority 2 = [],

      biDrvs | priority 1 =
        lib.biMap [
          pythonFull,
          linuxHeaders,
          pyyaml,
        ],
    }
}
