{
  drvs,
  lib,
  spirvLlvmTranslator | lib.CmakePackage = {
    generator = "Ninja",

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.spirvHeaders,
      drvs.spirvTools,
      # drvs.llvmFull,
      drvs.llvmConfigStatic,
      # drvs.samurai,
    ],
    # baseBuildinputPackages = std.array.filter (fun v => v.name != drvs.llvm.name) lib.CmakePackage.baseBuildinputPackages,

    cmakeExtraArgsRecord = {
      # "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR" = "${SRC}/SPIRV-Headers",
      "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR" = "/usr/include/spirv",
    },
    sourceInputs = [
      {
        src = {
          # uri = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v20.1.0.tar.gz",
          # sha256sum = "ffca6b2aa53076ef85a09676ef0079877cce4977d7aa64f5f5b33596c7d1d285",

          # uri = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v21.1.1.tar.gz",
          # sha256sum = "dda46febdb060a1d5cc2ceeb9682ccaf33e55ae294fd0793274531b54f07c46b",
          uri = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v21.1.0.tar.gz",
          sha256sum = "4f7019a06c731daebbc18080db338964002493ead4cfb440fef95d120c50a170",
        }
      },
      # {
      #   dest = "SPIRV-Headers",
      #   src = {

      #     uri = "https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/vulkan-sdk-1.3.290.0.tar.gz",
      #     sha256sum = "1b9ff8a33e07814671dee61fe246c67ccbcfc9be6581f229e251784499700e24",
      #   }
      # }
    ],
  }
}
