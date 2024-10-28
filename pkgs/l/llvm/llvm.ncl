(
  import "./llvm-base.ncl"
)
& {
  pkgs,
  lib,
  _llvmBase,
  # base if stage!=0
  _llvmBaseTarget | lib.CmakePackage
    =
      let b2 = (_llvmBase & { isLlvm = true }) in
      b2
      & {
        baseName = "llvm",
        cmakeArgs | priority -9
          =
            (_llvmBase.cmakeArgs)
            @ [
              "-DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi;compiler-rt;libunwind'",
              "-DLLVM_ENABLE_PROJECTS='lld;clang'",
              "-G Ninja",
              "-DLLVM_PARALLEL_LINK_JOBS=$(nproc)",
              "-DLLVM_PARALLEL_COMPILE_JOBS=$(nproc)",
            ],
        installPhase | priority 1
          =
            b2.installPhase
            @ [
              "cd ${DEST}/usr/bin",
              "ln -s clang cc",
              "ln -s clang++ c++",
              "ln -s clang-cpp cpp",
            ]
      },

  # 1

  llvmStage1 =
    _llvmBaseTarget
    & {
      stage = 1,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage0,
          pkgs.llvmStage0,
          pkgs.muslStage1,
          pkgs.samuraiStage1,
          pkgs.ccacheBin,
          pkgs.linuxHeadersStage1,
          pkgs.cmakeStage1,
          pkgs.pythonStage1,
        ]
    },

  # 2

  llvmStage2 =
    _llvmBaseTarget
    & {
      stage = 2,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage1,
          pkgs.llvmStage1,
          pkgs.muslStage2,
          pkgs.samuraiStage2,
          pkgs.ccacheBin,
          pkgs.linuxHeadersStage2,
          pkgs.cmakeStage2,
          pkgs.pythonStage2,
        ]
    },

  # final

  llvm =
    _llvmBaseTarget
    & {
      stage = -1,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage2,
          pkgs.llvmStage2,
          pkgs.musl,
          pkgs.samurai,
          pkgs.ccacheBin,
          pkgs.linuxHeaders,
          pkgs.cmake,
          pkgs.python,
        ]
    },

  clangCross =
    _llvmBaseTarget
    & {
      cmakeArgs | priority 1
        =
          (
          # lib.functions.replaceArrayElem

          # "-DCMAKE_INSTALL_PREFIX=/usr"
          #"-DCMAKE_INSTALL_PREFIX=/${TARGET}"
          (
          # lib.functions.replaceArrayElem
          #   "-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR:BOOL=OFF"
          #   "-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR:BOOL=ON"
          (
            lib.functions.replaceArrayElem
              "-DLLVM_TARGETS_TO_BUILD='X86'"
              "-DLLVM_TARGETS_TO_BUILD='AArch64;X86'"
              llvm.cmakeArgs
          )
          )
          )
          @ [
            # "-DCOMPILER_RT_BUILD_BUILTINS:BOOL=ON",
            # "-DLLVM_RUNTIME_TARGETS='AArch64;X86'",
            #  "-DLLVM_RUNTIME_TARGETS='aarch64-unknown-linux-musl'",
            # "-DCOMPILER_RT_DEFAULT_TARGET_TRIPLE:STRING=x86_64-unknown-linux-musl",
            # "-DLLVM_DEFAULT_TARGET_TRIPLE:STRING=aarch64-unknown-linux-musl",
            # "-DCMAKE_SYSROOT="
          ],

      #       buildPhase = [
      #   "ninja clang lld"
      # ],
      # installPhase | priority 2
      #   = [
      #     "DESTDIR=${DEST} ninja install-clang install-lld"
      #   ],

      buildInputs | priority 1
        =
          lib.biMap [
            pkgs.busybox,
            pkgs.llvm,
            pkgs.musl,
            pkgs.samurai,
            pkgs.ccacheBin,
            pkgs.linuxHeaders,
            pkgs.cmake,
            pkgs.python,
          ]
    },

  libcxxAarch64 =
    _llvmBaseTarget
    & {
      cmakeArgs | priority 2
        =
          lib.CmakePackage.cmakeArgs @ extraCmakeArgs,

      extraCmakeArgs = [
        "-Wno-dev",
        "-G Ninja",
        "-DLIBCXX_HAS_MUSL_LIBC:BOOL=ON",
        "-DCMAKE_C_COMPILER_TARGET=\"%{buildEnv.TARGET}\"",
        "-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY",
        "-DCMAKE_SYSROOT=/${TARGET}",
        "-DLLVM_CMAKE_DIR=/tmp/workdir/src/llvm",
        "-DLLVM_RUNTIME_TARGETS='AArch64'",
        # https://github.com/llvm/llvm-project/issues/57104
        "-DLLVM_RUNTIME_TARGETS='aarch64-unknown-linux-musl'",
        #  "-DLLVM_ENABLE_PROJECTS='compiler-rt'",
        #  "-DLLVM_ENABLE_RUNTIMES=''",
        "-DCMAKE_CROSSCOMPILING=ON",
        "-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR:BOOL=OFF",
        "-DLLVM_INCLUDE_BENCHMARKS=OFF",
        "-DLIBUNWIND_ENABLE_CROSS_UNWINDING=ON",
        "-DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON",
        "-DLIBCXXABI_INCLUDE_TESTS=OFF",
        "-DLIBCXXABI_LIBCXX_INCLUDES=${SRC}/libcxx/include",
        "-DLIBCXX_CXX_ABI=libcxxabi",
        "-DLIBCXX_CXX_ABI_INCLUDE_PATHS=${SRC}/libcxxabi/include",
        "-DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi;compiler-rt;libunwind'",
        "-DLIBCXXABI_ENABLE_SHARED:BOOL=OFF",
        "-DLIBCXX_ENABLE_SHARED:BOOL=OFF",
        "-DLIBCXXABI_INSTALL_SHARED_LIBRARY:BOOL=OFF",
        "-DLIBCXXABI_ENABLE_SHARED:BOOL=OFF",
        "-DLIBCXXABI_ENABLE_STATIC_UNWINDER:BOOL=ON",
        "-DLIBCXX_ENABLE_SHARED:BOOL=OFF",
        "-DLIBCXX_INSTALL_SHARED_LIBRARY:BOOL=OFF",
        "-DLIBUNWIND_ENABLE_SHARED:BOOL=OFF",
      ],
      configurePhase | priority 100
        = [
          "cmake -S ${SRC}/runtimes %{std.string.join " \\\n\t" cmakeArgs}"
        ],

      buildEnv = {
        TARGET = "aarch64-unknown-linux-musl",
        # CROSS_CFLAGS=[ "--sysroot=/${TARGET}"],
        # CROSS_LDFLAGS=[ "--sysroot=/${TARGET}"],
        # CROSS_CXXFLAGS=[ "--sysroot=/${TARGET}"],
      },

      buildPhase = [
        "ninja cxxabi cxx"
      ],
      installPhase | priority 2
        = [
          "DESTDIR=${DEST} ninja install-cxx install-cxxabi install-unwind"
        ],

      buildInputs | priority 1
        =
          lib.biMap [
            pkgs.busybox,
            pkgs.clangCross,
            pkgs.musl,
            pkgs.samurai,
            pkgs.ccacheBin,
            pkgs.linuxHeadersAarch64,
            pkgs.cmake,
            pkgs.python,
            pkgs.muslAarch64,
          ]
    },

  compilerRtAarch64 =
    _llvmBaseTarget
    & {
      cmakeArgs | priority 2
        =
          lib.CmakePackage.cmakeArgs @ extraCmakeArgs,

      extraCmakeArgs = [
        "-Wno-dev",
        "-G Ninja",
        "-DCMAKE_CROSSCOMPILING=ON",
        "-DCOMPILER_RT_BUILD_BUILTINS=ON",
        "-DCOMPILER_RT_BUILD_SANITIZERS=OFF",
        "-DCOMPILER_RT_BUILD_XRAY=OFF",
        "-DCOMPILER_RT_BUILD_LIBFUZZER=OFF",
        "-DCOMPILER_RT_BUILD_PROFILE=OFF",
        "-DCMAKE_C_COMPILER_TARGET=\"%{buildEnv.TARGET}\"",
        "-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON",
        "-DCOMPILER_RT_INCLUDE_TESTS=OFF",
        "-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY",
        "-DCMAKE_SYSROOT=/${TARGET}",
        "-DLLVM_CMAKE_DIR=/tmp/workdir/src/llvm",
        #  "-DLLVM_RUNTIME_TARGETS='AArch64'",
        # https://github.com/llvm/llvm-project/issues/57104
        #  "-DLLVM_RUNTIME_TARGETS=aarch64-unknown-linux-musl",
        "-DLLVM_ENABLE_PROJECTS='compiler-rt'",
        #  "-DLLVM_ENABLE_RUNTIMES=''",
        "-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR:BOOL=OFF",
        "-DCOMPILER_RT_BUILD_XRAY=OFF",
        "-DCOMPILER_RT_BUILD_SANITIZERS=OFF",
        "-DCOMPILER_RT_BUILD_MEMPROF=OFF",
        "-DCOMPILER_RT_BUILD_LIBFUZZER=OFF",
        "-DLIBUNWIND_ENABLE_CROSS_UNWINDING=ON",
        "-DCOMPILER_RT_HAS_AARCH64_SME:BOOL=OFF",
      ],
      configurePhase | priority 100
        = [
          "cmake ${SRC}/llvm %{std.string.join " \\\n\t" cmakeArgs}"
        ],

      buildEnv = {
        TARGET = "aarch64-unknown-linux-musl",
        CROSS_CFLAGS=[ "--sysroot=/${TARGET}"],
        CROSS_LDFLAGS=[ "--sysroot=/${TARGET}"],
        CROSS_CXXFLAGS=[ "--sysroot=/${TARGET}"],
      },

      buildPhase = [
        "ninja compiler-rt"
      ],
      installPhase | priority 2
        = [
          "DESTDIR=${DEST} ninja install-compiler-rt install-compiler-rt-headers",
          "DESTDIR=/tmp/workdir/out/dest ninja install-compiler-rt install-compiler-rt-headers",
        ],

      buildInputs | priority 1
        =
          lib.biMap [
            pkgs.busybox,
            pkgs.clangCross,
            pkgs.musl,
            pkgs.samurai,
            pkgs.ccacheBin,
            pkgs.linuxHeadersAarch64,
            pkgs.cmake,
            pkgs.python,
            pkgs.muslAarch64,
            pkgs.libcxxAarch64,
          ]
    },

  # llvmAarch64 =
  #   _llvmBaseTarget
  #   & {
  #     cmakeArgs | priority 1
  #       =
  #         lib.functions.replaceArrayElem
  #           "-DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi;compiler-rt;libunwind'"
  #           "-DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi;libunwind'"
  #           (
  #             lib.functions.replaceArrayElem
  #               "-DLLVM_ENABLE_PROJECTS='lld;clang'"
  #               "-DLLVM_ENABLE_PROJECTS='clang'"
  #               (
  #                 lib.functions.replaceArrayElem
  #                   "-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR:BOOL=OFF"
  #                   "-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR:BOOL=ON"
  #                   (
  #                     lib.functions.replaceArrayElem
  #                       "-DLLVM_TARGETS_TO_BUILD='X86'"
  #                       "-DLLVM_TARGETS_TO_BUILD='AArch64'"
  #                       llvm.cmakeArgs
  #                   )
  #               )
  #           )
  #         @ [
  #           "-DCOMPILER_RT_BUILD_BUILTINS:BOOL=ON",
  #           # "-DLLVM_RUNTIME_TARGETS='AArch64;X86'",
  #           "-DLLVM_RUNTIME_TARGETS='aarch64-unknown-linux-musl'",
  #           # "-DCOMPILER_RT_DEFAULT_TARGET_TRIPLE:STRING=x86_64-unknown-linux-musl",
  #           # "-DLLVM_DEFAULT_TARGET_TRIPLE:STRING=aarch64-unknown-linux-musl",
  #           "-DCMAKE_SYSROOT=${TARGET}",
  #           "-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY",
  #         ],
  #     buildEnv = {
  #       TARGET = "aarch64-unknown-linux-musl",
  #       CROSS_CFLAGS = ["--sysroot=/${TARGET}"],
  #       CROSS_LDFLAGS = ["--sysroot=/${TARGET}"],
  #       CROSS_CXXFLAGS = ["--sysroot=/${TARGET}"],
  #     },

  #     buildPhase = [
  #       "ninja runtimes"
  #     ],
  #     installPhase | priority 2
  #       = [
  #         "DESTDIR=${DEST} ninja install-runtimes"
  #       ],

  #     buildInputs | priority 1
  #       =
  #         lib.biMap [
  #           pkgs.busybox,
  #           pkgs.clangCross,
  #           pkgs.musl,
  #           pkgs.samurai,
  #           pkgs.ccacheBin,
  #           pkgs.linuxHeaders,
  #           pkgs.cmake,
  #           pkgs.python,
  #           pkgs.muslAarch64,
  #         ]
  #   }
}
