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
}
