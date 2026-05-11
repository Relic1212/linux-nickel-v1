(
  import "./llvm-base.ncl"
)
& {
  drvs,
  lib,
  _llvmBase,
  # base if stage!=0
  _llvmBaseTarget | lib.CmakePackage =
    let b2 = (_llvmBase & { isLlvm = true }) in
    b2
    & {
      baseName = "llvm",
      cmakeArgsPrepend = ["-G Ninja"],
      cmakeArgsRecord = {
        "-DLLVM_TOOL_LLVM_DRIVER_BUILD" = true,
        "-DLLVM_ENABLE_RUNTIMES" = "'libcxx;libcxxabi;compiler-rt;libunwind'",
        "-DLLVM_ENABLE_PROJECTS" = "'lld;clang'",
        "-DLLVM_PARALLEL_LINK_JOBS" = "2", #  "$(nproc)",
        "-DLLVM_PARALLEL_COMPILE_JOBS" = "$(nproc)",
      },
      # installPhase | priority 1
      #   =
      #     b2.installPhase
      #     @ [
      #       "cd ${DEST}/usr/bin",
      #       "ln -s clang cc",
      #       "ln -s clang++ c++",
      #       "ln -s clang-cpp cpp",
      #       # "ln -s llvm-readobj llvm-readelf",
      #       "cp /tmp/workdir/build/bin/llvm-config ${DEST}/usr/bin",
      #     ]
      pkgconfProvider | priority -1 = drvs.pkgconf,
    },

  _llvmBaseTargetStage1 | lib.CmakePackage = {
    baseName = "llvm",
    cmakeArgsPrepend = ["-G Ninja"],
    cmakeArgsRecord =
      {
        "-DLLVM_TOOL_LLVM_DRIVER_BUILD" = true,
        "-DLLVM_ENABLE_RUNTIMES" = "'libcxx;libcxxabi;compiler-rt;libunwind'",
        "-DLLVM_ENABLE_PROJECTS" = "'lld;clang'",
        "-DLLVM_PARALLEL_LINK_JOBS" = "2", #  "$(nproc)",
        "-DLLVM_PARALLEL_COMPILE_JOBS" = "$(nproc)",
      }
      & _llvmBase.cmakeArgsRecord,
    sourceInputs = _llvmBase.sourceInputs,
    installPhase = _llvmBase.installPhase,
    buildPhase = _llvmBase.buildPhase,
    extraCmakeArgs = _llvmBase.extraCmakeArgs,
    preConfigurePhase = _llvmBase.preConfigurePhase,
    cmakeDir = _llvmBase.cmakeDir,
    # installPhase | priority 1
    #   =
    #     b2.installPhase
    #     @ [
    #       "cd ${DEST}/usr/bin",
    #       "ln -s clang cc",
    #       "ln -s clang++ c++",
    #       "ln -s clang-cpp cpp",
    #       # "ln -s llvm-readobj llvm-readelf",
    #       "cp /tmp/workdir/build/bin/llvm-config ${DEST}/usr/bin",
    #     ]
  },

  # 1

  llvmStage1 =
    # (std.record.remove "buildEnv" _llvmBaseTarget)
    # _llvmBaseTargetStage1
    _llvmBaseTarget
    & {
      stage = 1,
      isLlvm | force = false,

      buildEnv | lib.BuildEnv = {
        _isLlvm | force = false,

        LLVM_CFLAGS | force = [],
        LLVM_CXXFLAGS | force = [],

        STAGE_CPPFLAGS | force = [
          "-I/usr/include",
          # "--sysroot=/usr/x86_64-linux-musl",
        ],
        STAGE_CFLAGS | force = [
          "-I/usr/include",
          # "--sysroot=/usr/x86_64-linux-musl",
        ],
        STAGE_CXXFLAGS | force = [
          "-I/usr/include",
          # "--sysroot=/usr/x86_64-linux-musl",
        ],
      },
      buildInputs = [
        drvs.bootstrapStage0,
        drvs.bootstrapSymlinks,
        drvs.busyboxBootstrapStage0,
        drvs.samuraiStage1,
        drvs.ccacheBin,
        drvs.linuxHeadersStage1,
        drvs.cmakeStage1,
        drvs.pythonStage1,
        drvs.muslStage1,
      ],
      cmakeArgsRecord = {
        "-DLLVM_ENABLE_LLD:BOOL" | force = "OFF",
      },
    },

  # 2

  llvmStage2 =
    _llvmBaseTarget
    & {
      stage = 2,
      buildInputs = [
        drvs.busyboxStage1,
        drvs.llvmStage1,
        drvs.muslStage2,
        drvs.samuraiStage2,
        drvs.ccacheBin,
        drvs.linuxHeadersStage2,
        drvs.cmakeStage2,
        drvs.pythonStage2,
      ]
    },

  # final

  llvmStage3 =
    _llvmBaseTarget
    & {
      stage = -1,
      buildInputs = [
        drvs.busyboxStage2,
        drvs.llvmStage2,
        drvs.muslStage3,
        drvs.samuraiStage3,
        drvs.ccacheBin,
        drvs.linuxHeadersStage3,
        drvs.cmakeStage3,
        drvs.pythonStage3,
      ]
    },
  busyboxStage3,
  llvm =
    _llvmBaseTarget
    & {
      stage = -1,
      buildInputs = [
        drvs.busyboxStage3,
        drvs.llvmStage3,
        drvs.musl,
        drvs.samurai,
        drvs.ccacheBin,
        drvs.linuxHeaders,
        drvs.cmake,
        drvs.python,
      ]
    },

  clangCross =
    _llvmBaseTarget
    & {

      cmakeExtraArgsRecord = {
        "-DLLVM_TARGETS_TO_BUILD" | priority 1 = "'AArch64;X86'",
        "-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR:BOOL" | priority 1 = "ON",
        # "-DLLVM_RUNTIME_TARGETS" = "'AArch64;X86'",
        # "-DLLVM_RUNTIME_TARGETS" = "'aarch64-unknown-linux-musl'",
        # "-DLLVM_ENABLE_RUNTIMES"="'libcxx;libcxxabi;compiler-rt;libunwind'",
        # "-DLLVM_ENABLE_RUNTIMES" | priority 1 = "'compiler-rt'",
      },
      # buildEnv = {
      #   LLVM_LDFLAGS = []
      # },
      # cmakeArgs | priority 1 =
      #   (
      #   # lib.functions.replaceArrayElem

      #   # "-DCMAKE_INSTALL_PREFIX=/usr"
      #   #"-DCMAKE_INSTALL_PREFIX=/${TARGET}"
      #   (
      #     lib.functions.replaceArrayElem
      #       "-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR:BOOL=OFF"
      #       "-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR:BOOL=ON"
      #       (
      #         lib.functions.replaceArrayElem
      #           "-DLLVM_TARGETS_TO_BUILD='X86'"
      #           "-DLLVM_TARGETS_TO_BUILD='AArch64;X86'"
      #           llvm.cmakeArgs
      #       )
      #   )
      #   )
      #   @ [
      #     # "-DCOMPILER_RT_BUILD_BUILTINS:BOOL=ON",
      #     # "-DLLVM_RUNTIME_TARGETS='AArch64;X86'",
      #     #  "-DLLVM_RUNTIME_TARGETS='aarch64-unknown-linux-musl'",
      #     # "-DCOMPILER_RT_DEFAULT_TARGET_TRIPLE:STRING=x86_64-unknown-linux-musl",
      #     # "-DLLVM_DEFAULT_TARGET_TRIPLE:STRING=aarch64-unknown-linux-musl",
      #     # "-DCMAKE_SYSROOT="
      #     #    "-DLIBCXX_INSTALL_INCLUDE_TARGET_DIR:STRING=include/c++/v1",
      #     # "-DLIBCXXABI_INSTALL_LIBRARY_DIR:STRING=lib",
      #     # "-DLIBCXX_INSTALL_LIBRARY_DIR:STRING=lib",
      #     # "-DLIBUNWIND_INSTALL_LIBRARY_DIR:STRING=lib",
      #     # "-DCOMPILER_RT_INSTALL_BINARY_DIR:PATH=lib/bin",
      #     # "-DCOMPILER_RT_INSTALL_DATA_DIR:PATH=share",
      #     # "-DCOMPILER_RT_INSTALL_INCLUDE_DIR:PATH=include",
      #     # "-DCOMPILER_RT_INSTALL_LIBRARY_DIR:PATH=lib",
      #   ],

      #       buildPhase = [
      #   "ninja clang lld"
      # ],
      # installPhase | priority 2
      #   = [
      #     "DESTDIR=${DEST} ninja install-clang install-lld"
      #   ],

      buildInputs | priority 1 = [
        drvs.busybox,
        drvs.llvmFull,
        drvs.musl,
        drvs.samurai,
        drvs.ccacheBin,
        drvs.linuxHeaders,
        drvs.cmake,
        drvs.python,
      ],

      buildPhase | priority 1 = [
        "cmake --build ."
      ],
      installPhase | priority 1 = [
        "cmake --install ."
      ],
      postInstallPhase = [
        # "cp /tmp/workdir/build/bin/llvm-config ${DEST}/usr/bin"
      ]
    },

  libcxxAarch64 =
    let majorVersion = "21" in
    _llvmBaseTarget
    & {
      cmakeArgs | priority 2 =
        lib.CmakePackage.cmakeArgs @ extraCmakeArgs,

      extraCmakeArgs | priority 1 = [
        "-Wno-dev",
        "-G Ninja",
        "-DLIBCXX_HAS_MUSL_LIBC:BOOL=ON",
        "-DCMAKE_C_COMPILER_TARGET=\"%{buildEnv.TARGET}\"",
        "-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY",
        "-DCMAKE_SYSROOT=/${TARGET}",
        "-DLLVM_CMAKE_DIR=/tmp/workdir/src/llvm",
        # "-DLLVM_RUNTIME_TARGETS='AArch64'",
        # https://github.com/llvm/llvm-project/issues/57104
        "-DLLVM_RUNTIME_TARGETS='aarch64-unknown-linux-musl'",
        "-DLLVM_ENABLE_PROJECTS='clang'",
        #  "-DLLVM_ENABLE_RUNTIMES=''",
        "-DCMAKE_CROSSCOMPILING=ON",
        "-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR:BOOL=ON",
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
        "-DLIBCXXABI_ENABLE_STATIC_UNWINDER:BOOL=ON",
        "-DLIBCXX_INSTALL_SHARED_LIBRARY:BOOL=OFF",
        "-DLIBUNWIND_ENABLE_SHARED:BOOL=OFF",
        "-DLLVM_DEFAULT_TARGET_TRIPLE:STRING=aarch64-unknown-linux-musl",
        "-DCMAKE_ASM_COMPILER_TARGET=aarch64-unknown-linux-musl",
        "-DLLVM_TARGET_ARCH=Aarch64",
        "-DCOMPILER_RT_BUILD_BUILTINS=ON",
        "-DCOMPILER_RT_BUILD_XRAY=OFF",
        "-DCOMPILER_RT_BUILD_SANITIZERS=OFF",
        "-DCOMPILER_RT_BUILD_MEMPROF=OFF",
        "-DCOMPILER_RT_BUILD_LIBFUZZER=OFF",
        # "-DCOMPILER_RT_HAS_AARCH64_SME:BOOL=OFF",
        "-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON",
        "-DCOMPILER_RT_INCLUDE_TESTS=OFF",
        # "-DCOMPILER_RT_BUILD_PROFILE=OFF",
        #  "-DLIBCXX_INSTALL_INCLUDE_TARGET_DIR:STRING=include/c++/v1",
        # "-DLIBCXXABI_INSTALL_LIBRARY_DIR:STRING=lib",
        # "-DLIBCXX_INSTALL_LIBRARY_DIR:STRING=lib",
        # "-DLIBUNWIND_INSTALL_LIBRARY_DIR:STRING=lib",
        # "-DCOMPILER_RT_INSTALL_BINARY_DIR:PATH=lib/bin",
        # "-DCOMPILER_RT_INSTALL_DATA_DIR:PATH=share",
        # "-DCOMPILER_RT_INSTALL_INCLUDE_DIR:PATH=include",
        # "-DCOMPILER_RT_INSTALL_LIBRARY_DIR:PATH=lib",
        "-DLLVM_ENABLE_LLD=ON",
        "-DLLVM_ENABLE_LIBCXX=ON",
        "-DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON",
        # undefined symbol: typeinfo
        # "-DLIBCXX_ENABLE_EXCEPTIONS:BOOL=OFF",
        # "-DLIBCXX_ENABLE_RTTI:BOOL=OFF",
        "-DLIBCXX_INCLUDE_TESTS:BOOL=OFF",
        "-DCLANG_DEFAULT_UNWINDLIB=libunwind",
        "-DCLANG_DEFAULT_CXX_STDLIB=libc++",
        "-DCLANG_DEFAULT_RTLIB=compiler-rt",
        "-DCLANG_DEFAULT_LINKER=lld",
        "-DLIBCXXABI_USE_COMPILER_RT:BOOL=ON",
        "-DLIBCXX_USE_COMPILER_RT:BOOL=ON",
        "-DLIBUNWIND_USE_COMPILER_RT:BOOL=ON",
        "-DLLVM_CONFIG=/usr/bin/llvm-config",
        "-DLLVM_HOST_TRIPLE:STRING=x86_64-unknown-linux-musl",
        "-DLLVM_VERSION_SUFFIX=''",
        "-DCOMPILER_RT_INSTALL_BINARY_DIR:PATH=lib/clang/%{majorVersion}/bin",
      ],
      configurePhase | priority 100 = [
        "cmake -S ${SRC}/runtimes %{std.string.join " \\\n\t" cmakeArgs}"
      ],

      buildEnv = {
        TARGET = "aarch64-unknown-linux-musl",
        # CROSS_CFLAGS=[ "--sysroot=/${TARGET}"],
        # CROSS_LDFLAGS=[ "--sysroot=/${TARGET}"],
        # CROSS_CXXFLAGS=[ "--sysroot=/${TARGET}"],
        EXTRA_CXXFLAGS = ["-I./include/aarch64-unknown-linux-musl/c++/v1/"],
      },

      buildPhase | priority 1 = [
        "ninja cxxabi cxx compiler-rt"
      ],
      installPhase | priority 2 = [
        "DESTDIR=${DEST} ninja install-cxx install-cxxabi install-unwind install-compiler-rt install-compiler-rt-headers",
        "DESTDIR=/tmp/workdir/out/destdir ninja install-cxx install-cxxabi install-unwind install-compiler-rt install-compiler-rt-headers",
        "install -d m0755 ${DEST}/usr/lib/clang/%{majorVersion}",
        "cp -r ${DEST}/usr/lib ${DEST}/usr/lib/clang/%{majorVersion}/lib || true",
        "install -d m0755 /tmp/workdir/out/destdir/usr/lib/clang/%{majorVersion}",
        "cp -r /tmp/workdir/out/destdir/usr/lib /tmp/workdir/out/destdir/usr/lib/clang/%{majorVersion}/lib || true",
      ],

      buildInputs | priority 1 = [
        drvs.busybox,
        drvs.clangCross,
        drvs.musl,
        drvs.samurai,
        drvs.ccacheBin,
        drvs.linuxHeadersAarch64,
        drvs.cmake,
        drvs.python,
        drvs.muslAarch64,
      ]
    },

  clangAarch64 =
    clangCross
    & {
      # buildEnv |priority 2 = {
      #       TARGET = "aarch64-unknown-linux-musl",
      #       # CROSS_CFLAGS=[ "--sysroot=/${TARGET}"],
      #       # CROSS_LDFLAGS=[ "--sysroot=/${TARGET}"],
      #       # CROSS_CXXFLAGS=[ "--sysroot=/${TARGET}"],
      #     },
      buildEnv,
      buildInputs | priority 3 = [
        drvs.busybox,
        drvs.clangCross,
        drvs.musl,
        drvs.libcxxAarch64,
        drvs.samurai,
        drvs.ccacheBin,
        drvs.linuxHeadersAarch64,
        drvs.linuxHeaders,
        drvs.cmake,
        drvs.python,
        drvs.muslAarch64,
      ],
      cmakeArgs | priority 2 =
        clangCross.cmakeArgs
        @ [
          "-DCMAKE_CROSSCOMPILING=ON",
          "-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR:BOOL=ON",
          "-DLLVM_DEFAULT_TARGET_TRIPLE:STRING=aarch64-unknown-linux-musl",
          #  "-DCMAKE_C_COMPILER_TARGET=\"%{aarch64-unknown-linux-musl}\"",
          "-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY",
          "-DCMAKE_DEFAULT_SYSROOT=/${TARGET}",
          "-DLLVM_RUNTIME_TARGETS='aarch64-unknown-linux-musl'",
          "-DLLVM_DEFAULT_TARGET_TRIPLE:STRING=aarch64-unknown-linux-musl",
          "-DLLVM_ENABLE_RUNTIMES=''",
          "-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR:BOOL=ON",
          "-DLLVM_CONFIG=/usr/bin/llvm-config"
        ]
    },
}
