let b = ((import "llvm-base.ncl") & { stage = 0 })
in
let lib = import "../../nickellib/lib.ncl"
in
let _llvmBaselibsStage0 = (
  b
  & {
    stage = 0,
    name | priority 1 = "llvm-baselibs-stage-0",
    cmakeArgs | force
      =
        let cma = (lib.functions.replaceArrayElem "-DLLVM_TARGETS_TO_BUILD='X86'" "-DLLVM_TARGETS_TO_BUILD=\"\"" b.cmakeArgs)
        #   lib.functions.replaceArrayElem
        #     "-DCLANG_BUILD_TOOLS:BOOL=ON"
        #     "-DCLANG_BUILD_TOOLS:BOOL=OFF"
        #     (
        #       lib.functions.replaceArrayElem
        #         "-DLLVM_BUILD_TOOLS:BOOL=ON"
        #         "-DLLVM_BUILD_TOOLS:BOOL=OFF"
        #         (
        #           lib.functions.replaceArrayElem
        #             "-DLLD_BUILD_TOOLS:BOOL=ON"
        #             "-DLLD_BUILD_TOOLS:BOOL=OFF"
        #             b.cmakeArgs
        #         )
        #     )
        in
        (
          cma
          @ [
            "-DCMAKE_ASM_FLAGS_RELEASE:STRING='-O0 -DNDEBUG'",
            "-DCMAKE_C_FLAGS_RELEASE:STRING='-O0 -DNDEBUG'",
            "-DCMAKE_CXX_FLAGS_RELEASE:STRING='-O0 -DNDEBUG'",
            "-DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi;libunwind'",

            # "-DLLVM_ENABLE_RUNTIMES='libunwind'",
            # "-DLLVM_ENABLE_PROJECTS='lld;clang;compiler-rt'",
            # "-DLLVM_ENABLE_PROJECTS='lld;clang'",
            "-DLLVM_ENABLE_PROJECTS='compiler-rt;lld'",
            "-DLIBCXX_INSTALL_INCLUDE_TARGET_DIR:STRING=include/c++/v1",
            "-DLIBCXXABI_INSTALL_LIBRARY_DIR:STRING=lib",
            "-DLIBCXX_INSTALL_LIBRARY_DIR:STRING=lib",
            "-DLIBUNWIND_INSTALL_LIBRARY_DIR:STRING=lib",
            "-DCOMPILER_RT_INSTALL_BINARY_DIR:PATH=lib/bin",
            "-DCOMPILER_RT_INSTALL_DATA_DIR:PATH=share",
            "-DCOMPILER_RT_INSTALL_INCLUDE_DIR:PATH=include",
            "-DCOMPILER_RT_INSTALL_LIBRARY_DIR:PATH=lib",
          ]
        ),

    #   buildInputs=[
    #        (import "../musl/musl-stage-0.ncl"),
    #  (import "../linux-headers/linux-headers-stage-0.ncl") #.linuxHeadersStage0,
    #   ]
  }
)
in
{
  muslStage0,
  linuxHeadersStage0,
  llvmBaselibsStage0 =
    _llvmBaselibsStage0
    & {
      buildInputs = lib.biMap [muslStage0, linuxHeadersStage0]
    }
}
