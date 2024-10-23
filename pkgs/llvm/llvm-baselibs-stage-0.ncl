let b = import "llvm-base-stage-0.ncl"
in
let lib = import "../../nickellib/lib.ncl"
in
let libs0 = (
  b
  & {
    name | priority 1 = "llvm-baselibs-stage-0",
    cmakeArgs | force
      =
        let cma = b.cmakeArgs
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
  linuxHeadersStage0llvmBaselibsStage0 =
    libs0
    & {
      buildInputs = [muslStage0, linuxHeadersStage0]
    }
}
