let lib = import "../../nickellib/lib.ncl"
in
let constants = import "../../nickellib/constants.ncl"
in
let _llvmBase | lib.CmakePackage
  = {
    baseName = "llvm",
    stage,
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.2/llvm-project-19.1.2.src.tar.xz",
          sha256sum = "3666f01fc52d8a0b0da83e107d74f208f001717824be0b80007f529453aa1e19",
        },
      }
    ],
    isStatic,
    isLlvm,
    enableCcache,

    cmakeArgs | priority -10
      =
        ((lib.CmakePackage).cmakeArgs)
        @ [
          #"-DLLVM_ENABLE_PROJECTS='clang;llvm;lld'",
          "-DLLVM_VERSION_SUFFIX=''",
          #"-DLLVM_TARGETS_TO_BUILD='AMDGPU;X86'",
          "-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=''",
          "-DCLANG_ENABLE_CLANGD=OFF",
          "-DLLVM_ENABLE_EH=OFF",
          "-DLLVM_ENABLE_LIBEDIT=OFF",
          "-DLLDB_ENABLE_LIBEDIT=OFF",
          "-DLLDB_ENABLE_LUA=OFF",
          "-DLLDB_EDITLINE_USE_WCHAR=1",
          "-DLLVM_ENABLE_LIBPFM=OFF",
          "-DLLVM_ENABLE_RTTI=OFF",
          "-DLLVM_USE_SPLIT_DWARF=ON",
          "-DLLVM_ENABLE_TERMINFO=OFF",
          "-DCOMPILER_RT_TERMINFO_LIB=OFF",
          "-DLLVM_LIBDIR_SUFFIX=",
          "-DLLDB_ENABLE_PYTHON=OFF",
          "-DLLVM_INCLUDE_BENCHMARKS=OFF",
          "-DLLDB_ENABLE_CURSES=OFF",
          "-DLLVM_BUILD_TESTS=OFF",
          "-DLLVM_INCLUDE_EXAMPLES=OFF",
          "-DLLVM_INCLUDE_DOCS=OFF",
          "-DLLVM_INCLUDE_TESTS=OFF",
          "-DLLVM_ENABLE_TERMINFO=OFF",
          "-DLLVM_ENABLE_LIBXML2=OFF",
          "-DLLVM_ENABLE_SPHINX=OFF",
          "-DLLVM_ENABLE_ZLIB=OFF",
          "-DLLVM_ENABLE_ZSTD=OFF",
          "-DLLVM_ENABLE_LIBEDIT=OFF",
          "-DLLDB_ENABLE_LIBEDIT=OFF",
          "-DLLDB_BUILD_INTEL_MPX=OFF",
          "-DCLANG_ENABLE_ARCMT=OFF",
          # "-DLLVM_RUNTIMES='libcxx;libcxxabi'",
          "-DCLANG_BUILD_TOOLS=ON",
          "-DCLANG_ENABLE_STATIC_ANALYZER=OFF",
          "-DCLANG_INCLUDE_TESTS=OFF",
          "-DCLANG_ENABLE_HLSL=OFF",
          "-DCLANG_TOOL_C_INDEX_TEST_BUILD=OFF",
          "-Wno-dev",
          "-DLLVM_ENABLE_UNWIND_TABLES=OFF",
          # "-DLLVM_USE_LINKER=lld",
          "-DLLVM_ENABLE_LLD=ON",
          "-DLLVM_ENABLE_LIBCXX=ON",
          "-DCOMPILER_RT_BUILD_GWP_ASAN=OFF",
          "-DCOMPILER_RT_BUILD_SANITIZERS=OFF",
          "-DCOMPILER_RT_SCUDO_STANDALONE_BUILD_SHARED:BOOL=OFF",
          "-DCOMPILER_RT_SANITIZERS_TO_BUILD:STRING=''",
          "-DCOMPILER_RT_BUILD_CTX_PROFILE:BOOL=OFF",
          "-DCOMPILER_RT_BUILD_XRAY=OFF",
          "-DCOMPILER_RT_BUILD_LIBFUZZER=OFF",
          "-DCOMPILER_RT_BUILD_PROFILE=OFF",
          "-DCOMPILER_RT_BUILD_MEMPROF=OFF",
          "-DCLANG_TOOL_APINOTES_TEST_BUILD=OFF",
          "-DCLANG_TOOL_ARCMT_TEST_BUILD:BOOL=OFF",
          "-DCLANG_TOOL_CLANG_CHECK_BUILD=OFF",
          "-DCLANG_TOOL_CLANG_DIFF_BUILD=OFF",
          "-DCLANG_TOOL_CLANG_EXTDEF_MAPPING_BUILD=OFF",
          "-DCLANG_TOOL_CLANG_FORMAT_BUILD:BOOL=OFF",
          "-DCLANG_TOOL_CLANG_FORMAT_VS_BUILD:BOOL=OFF",
          "-DCLANG_TOOL_CLANG_FUZZER_BUILD:BOOL=OFF",
          "-DCLANG_TOOL_CLANG_IMPORT_TEST_BUILD=OFF",
          "-DCLANG_TOOL_CLANG_INSTALLAPI_BUILD=OFF",
          # "-DCLANG_TOOL_CLANG_LINKER_WRAPPER_BUILD=OFF",
          # "-DCLANG_TOOL_CLANG_NVLINK_WRAPPER_BUILD:BOOL=OFF",
          # "-DCLANG_TOOL_CLANG_OFFLOAD_BUNDLER_BUILD:BOOL=OFF",
          # "-DCLANG_TOOL_CLANG_OFFLOAD_PACKAGER_BUILD:BOOL=OFF",
          "-DCLANG_TOOL_CLANG_REFACTOR_BUILD:BOOL=OFF",
          # "-DCLANG_TOOL_CLANG_RENAME_BUILD:BOOL=OFF",
          "-DCLANG_TOOL_CLANG_REPL_BUILD:BOOL=OFF",
          "-DCLANG_TOOL_CLANG_SCAN_DEPS_BUILD:BOOL=OFF",
          # "-DCLANG_TOOL_CLANG_SHLIB_BUILD:BOOL=OFF",
          "-DCLANG_TOOL_C_ARCMT_TEST_BUILD:BOOL=OFF",
          "-DCLANG_TOOL_C_INDEX_TEST_BUILD:BOOL=OFF",
          # "-DCLANG_TOOL_DIAGTOOL_BUILD:BOOL=OFF",
          # "-DCLANG_TOOL_DICTIONARY_BUILD:BOOL=OFF",
          # "-DCLANG_TOOL_DRIVER_BUILD:BOOL=OFF",
          # "-DCLANG_TOOL_HANDLE_CXX_BUILD:BOOL=OFF",
          # "-DCLANG_TOOL_HANDLE_LLVM_BUILD:BOOL=OFF",
          "-DCLANG_TOOL_LIBCLANG_BUILD:BOOL=OFF",
          "-DCLANG_TOOL_NVPTX_ARCH_BUILD:BOOL=OFF",
          "-DCLANG_TOOL_SCAN_BUILD_BUILD:BOOL=OFF",
          "-DCLANG_TOOL_SCAN_BUILD_PY_BUILD:BOOL=OFF",
          "-DCLANG_TOOL_SCAN_VIEW_BUILD:BOOL=OFF",
          "-DLLD_BUILD_TOOLS:BOOL=ON",
          "-DLLVM_BUILD_TOOLS:BOOL=ON",
          "-DLLVM_BUILD_UTILS:BOOL=OFF",
          "-DLLVM_DYLIB_COMPONENTS=''",
          "-DLLVM_ENABLE_BACKTRACES=OFF",
          "-DLLVM_ENABLE_BINDINGS:BOOL=OFF",
          "-DLLVM_ENABLE_CRASH_OVERRIDES:BOOL=OFF",
          "-DLLVM_ENABLE_OCAMLDOC=OFF",
          "-DLLVM_HOST_TRIPLE:STRING=x86_64-unknown-linux-musl",
          # "-DLLVM_INCLUDE_TOOLS:BOOL=OFF",
          "-DLLVM_INCLUDE_UTILS:BOOL=OFF",
          "-DLLVM_TOOL_BUGPOINT_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_BUGPOINT_PASSES_BUILD:BOOL=OFF",
          #"-DLLVM_TOOL_CLANG_BUILD:BOOL=TRUE",
          "-DLLVM_TOOL_DSYMUTIL_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_DXIL_DIS_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_GOLD_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_AS_FUZZER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_CFI_VERIFY_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_COV_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_CVTRES_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_CXXDUMP_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_C_TEST_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_DEBUGINFOD_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_DEBUGINFOD_FIND_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_DEBUGINFO_ANALYZER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_DIFF_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_DIS_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_DIS_FUZZER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_DLANG_DEMANGLE_FUZZER_BUILD:BOOL=OFF",
          # "-DLLVM_TOOL_LLVM_DWARFDUMP_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_DWARFUTIL_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_DWP_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_EXEGESIS_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_EXTRACT_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_GSYMUTIL_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_IFS_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_ISEL_FUZZER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_ITANIUM_DEMANGLE_FUZZER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_JITLINK_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_JITLISTENER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_LIBTOOL_DARWIN_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_LINK_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_LIPO_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_LTO2_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_LTO_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_MCA_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_MC_ASSEMBLE_FUZZER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_MC_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_MC_DISASSEMBLE_FUZZER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_MICROSOFT_DEMANGLE_FUZZER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_ML_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_MODEXTRACT_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_MT_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_OPT_FUZZER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_OPT_REPORT_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_PDBUTIL_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_PROFDATA_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_PROFGEN_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_RC_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_READTAPI_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_REMARKUTIL_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_RTDYLD_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_RUST_DEMANGLE_FUZZER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_SHLIB_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_SIM_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_SIZE_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_SPECIAL_CASE_LIST_FUZZER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_STRESS_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_SYMBOLIZER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_TLI_CHECKER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_UNDNAME_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_XRAY_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_YAML_NUMERIC_PARSER_FUZZER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LLVM_YAML_PARSER_FUZZER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_LTO_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_OBJ2YAML_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_OPT_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_OPT_VIEWER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_REDUCE_CHUNK_LIST_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_REMARKS_SHLIB_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_SANCOV_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_SANSTATS_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_SPIRV_TOOLS_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_VERIFY_USELISTORDER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_VFABI_DEMANGLE_FUZZER_BUILD:BOOL=OFF",
          "-DLLVM_TOOL_XCODE_TOOLCHAIN_BUILD:BOOL=OFF",
          # "-DLLVM_TOOL_YAML2OBJ_BUILD:BOOL=OFF",
          "-DLIBCXX_HAS_MUSL_LIBC:BOOL=ON",
          "-DLLVM_ABI_BREAKING_CHECKS=FORCE_OFF",
          "-DLLVM_INSTALL_BINUTILS_SYMLINKS:BOOL=ON",
          "-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR:BOOL=OFF",
          "-DLLVM_INSTALL_TOOLCHAIN_ONLY:BOOL=ON"
        ]
        @ (
          if isLlvm then
            [
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
            ]
          else
            []
        )
        @ (
          if isStatic then
            [
              "-DLLVM_BUILD_STATIC=OFF",
              "-DLLVM_ENABLE_SHARED_LIBS=OFF",
              "-DLLVM_USE_STATIC_ZSTD=ON",
              "-DCLANG_LINK_CLANG_DYLIB=OFF",
              "-DCMAKE_EXE_LINKER_FLAGS=-static",
              #"-DLIBCLANG_BUILD_STATIC=ON",
              "-DLLVM_ENABLE_PIC=OFF",
              "-DLLVM_BUILD_LLVM_DYLIB=OFF",
              "-DLLVM_LINK_LLVM_DYLIB=OFF",
              "-DLIBCXXABI_ENABLE_SHARED:BOOL=OFF",
              "-DLIBCXX_ENABLE_SHARED:BOOL=OFF",
              "-DLIBCXXABI_INSTALL_SHARED_LIBRARY:BOOL=OFF",
              "-DLIBCXXABI_ENABLE_SHARED:BOOL=OFF",
              "-DLIBCXXABI_ENABLE_STATIC_UNWINDER:BOOL=ON",
              "-DLIBCXX_ENABLE_SHARED:BOOL=OFF",
              "-DLIBCXX_INSTALL_SHARED_LIBRARY:BOOL=OFF",
              "-DLIBUNWIND_ENABLE_SHARED:BOOL=OFF",
            ]
          else
            []
        )
        @ (if enableCcache then ["-DLLVM_CCACHE_BUILD:BOOL=ON"] else [])
        @ [
          "-DLLVM_TARGETS_TO_BUILD='X86'",
          "-DCLANG_TOOL_AMDGPU_ARCH_BUILD=OFF",
        ],

    configurePhase | priority -9
      = [
        "export DESTDIR=/tmp/workdir/out/destdir",
        "cmake ${SRC}/llvm %{std.string.join (constants.buildFlagSep) cmakeArgs}"
      ],
    installPhase | priority -9
      = (
        (lib.CmakePackage).installPhase
        @ [
          "for f in $(find ${DEST}/usr/bin -type f);do\n\tstrip ${f} || echo \"not an elf\"\ndone",
        ]
      ),

    buildEnv = (
      if (stage != 0) then
        lib.CmakePackage.buildEnv
      else
        (
          let llvmBuildenv = (lib.CmakePackage & { isLlvm = true }).buildEnv in
          (
            llvmBuildenv
            & {
              CPPFLAGS = [
                "-I/tmp/workdir/sysroot/usr/include",
                "-idirafter=/tmp/workdir/sysroot/"
              ],
              CFLAGS | priority 1 = (llvmBuildenv.CFLAGS @ CPPFLAGS),
              CXXFLAGS | priority 1 = (llvmBuildenv.CXXFLAGS @ CPPFLAGS),
              LDFLAGS | priority 1 = (llvmBuildenv.LDFLAGS @ ["-L/tmp/workdir/sysroot/usr/lib"]),
            }
          )
        )
    ),
  }
  in
_llvmBase
