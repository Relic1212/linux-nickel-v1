let lib = import "../../nickellib/lib.ncl"
in
let llvmBase = import "./llvm-base.ncl"
in
let llvmBaseTarget | lib.CmakePackage
  =
    let b2 = (llvmBase & { isLlvm = true }) in
    b2
    & {
      baseName = "llvm",
      cmakeArgs | priority -9
        =
          (llvmBase.cmakeArgs)
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
    }
  in

{
  busyboxStage0,
  llvmStage0,
  muslStage1,
  gnumakeStage1,
  samuraiStage1,
  ccacheBin,
  linuxHeadersStage1,
  cmakeStage1,
  pythonStage1,
  llvmStage1 =
    llvmBaseTarget
    & {
      stage = 1,
      buildInputs =
        lib.biMap [
          busyboxStage0,
          llvmStage0,
          muslStage1,
          samuraiStage1,
          ccacheBin,
          linuxHeadersStage1,
          cmakeStage1,
          pythonStage1,
        ]
    },

  # 2
  busyboxStage1,
  llvmStage1,
  muslStage2,
  gnumakeStage2,
  samuraiStage2,
  linuxHeadersStage2,
  cmakeStage2,
  pythonStage2,
  llvmStage2 =
    llvmBaseTarget
    & {
      stage = 2,
      buildInputs =
        lib.biMap [
          busyboxStage1,
          llvmStage1,
          muslStage2,
          samuraiStage2,
          ccacheBin,
          linuxHeadersStage2,
          cmakeStage2,
          pythonStage2,
        ]
    },

  # final
  busyboxStage2,
  llvmStage2,
  musl,
  gnumake,
  samurai,
  linuxHeaders,
  cmake,
  python,
  llvm =
    llvmBaseTarget
    & {
      stage = -1,
      buildInputs =
        lib.biMap [
          busyboxStage2,
          llvmStage2,
          musl,
          samurai,
          ccacheBin,
          linuxHeaders,
          cmake,
          python,
        ]
    },
}
