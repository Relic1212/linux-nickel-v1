{
  lib,
  drvs,
  llvmFull,
  llvm,
  llvmBaltos | lib.CmakePackage =
    llvm
    & {
      cmakeArgsRecord = {
        "-DLLVM_TARGETS_TO_BUILD" | force = "'X86'",
        "-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR:BOOL"|force = true,
        # "-DLLVM_DEFAULT_TARGET_TRIPLE:STRING" = "'i686-unknown-baltos'",
      #   "-DLLVM_ENABLE_PROJECTS"|force="'clang;lld'",
      # "-DLLVM_ENABLE_RUNTIMES"|force = "'compiler-rt;libunwind'",

      },
      patches=[{
        sha256sum = "a3ac7ebb77f0142b4cf02af04323f42d5428c3fea9275de301f6ff06cc40b224",
        file =  "baltos-3.patch",

      }]
    }
}

&
{
  lib,
  drvs,
  llvmBaltos,
  llvmBaltos2 | lib.CmakePackage = llvmBaltos & {
        buildInputs | priority 1=
         [
          drvs.busyboxStage3,
          drvs.llvmBaltos,
          drvs.musl,
          drvs.samurai,
          drvs.ccacheBin,
          drvs.linuxHeaders,
          drvs.cmake,
          drvs.python,
        ],

              cmakeArgsRecord = {
         "-DLLVM_DEFAULT_TARGET_TRIPLE:STRING" = "'i686-unknown-baltos'",

              }
    },
  
}