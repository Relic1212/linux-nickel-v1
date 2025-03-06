((import "llvm-base.ncl"))
& {
  lib,
  pkgs,
  _llvmBase,
  llvmBaselibsStage0 = (
    _llvmBase
    & {
      stage = 0,
      name | priority 1 = "llvm-baselibs-stage-0",
      cmakeArgs | force =
        let llvmStage0Cmakeargs = (lib.functions.replaceArrayElem "-DLLVM_TARGETS_TO_BUILD='AArch64;X86'" "-DLLVM_TARGETS_TO_BUILD=\"\"" (lib.functions.replaceArrayElem "-DLLVM_TARGETS_TO_BUILD='X86'" "-DLLVM_TARGETS_TO_BUILD=\"\"" (_llvmBase & { stage = 0 }).cmakeArgs))
        in
        (
          llvmStage0Cmakeargs
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

      buildInputs = lib.biMap [pkgs.muslStage0, pkgs.linuxHeadersStage0]
    }
  ),
}
