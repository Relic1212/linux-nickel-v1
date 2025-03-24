{
  lib,
  drvs,
  llvmFull,
  llvmExp | lib.CmakePackage =
    llvmFull
    & {
      cmakeArgsRecord = {
        "-DLLVM_TARGETS_TO_BUILD" | force = "'X86;AArch64;AMDGPU;ARM'",
        "-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR" = true,
        "-DLLVM_DEFAULT_TARGET_TRIPLE:STRING" = "'i686-unknown-none-elf'",
      },
    }
}
