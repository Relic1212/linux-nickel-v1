{
  lib,
  drvs,
  llvm,
  libclc | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = llvm.singleSource,
    # singleSource = { uri = "https://gitlab.freedesktop.org/karolherbst/mesa-libclc/-/archive/298976d4ddad1c7e0472647bcb50e1336a1bfd1a/mesa-libclc-298976d4ddad1c7e0472647bcb50e1336a1bfd1a.tar.bz2", sha256sum = "a26ed9992f1ba85a835db51f87e18f959516e8f88a70ab8092214f8d841fbc6b", },
    unpackPhase = llvm.unpackPhase,
    cmakeDir = "${SRC}/libclc",
    cmakeExtraArgsRecord = {
      "-DLLVM_DIR" = "\"$(llvm-config --cmakedir)\"",
      "-DLLVM_CONFIG" = "/usr/bin/llvm-config",
      "-DLLVM_SPIRV" = "/usr/bin/llvm-spirv",
      "-DLIBCLC_TARGETS_TO_BUILD" = "all",
      #"-DLLVM_RUNTIME_TARGETS" = "'amdgcn-amd-amdhsa;default'", #amdgcn-amd-amdhsa-llvm
      #"-DLLVM_TARGETS" = "'amdgcn-amd-amdhsa;default'", #amdgcn-amd-amdhsa-llvm
      # "-DLLVM_DEFAULT_TARGET_TRIPLE" = "x86_64-unknown-linux-musl",
      # "-DLLVM_DEFAULT_TARGET_TRIPLE" = "amdgcn-amd-amdhsa",
      # "-DLLVM_DEFAULT_TARGET_TRIPLE" = "spirv64-amd-amdhsa",
      # "-DLLVM_DEFAULT_TARGET_TRIPLE" = "spirv64-mesa3d-",
      "-DLLVM_DEFAULT_TARGET_TRIPLE" = "spirv64-unknown-unknown",
    },

    postInstallPhase = libclcPkgconfig.postInstallPhase,

    llvmProvider = drvs.llvmFull,

    biDrvs = [
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvHeaders,
      drvs.spirvLlvmTranslator,
    ],
  },
  libclcPkgconfig | lib.Package = {
    # https://github.com/llvm/llvm-project/pull/185654
    postInstallPhase = [
      "install -dm0755 ${DEST}/usr/lib/pkgconfig",
      lib.functions.writeFile "${DEST}/usr/lib/pkgconfig/libclc.pc" (import "libclc.pc" as 'Text),
    ],
  }
}
