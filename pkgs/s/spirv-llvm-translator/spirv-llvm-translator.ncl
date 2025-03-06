{
  drvs,
  lib,
  spirvLlvmTranslator | lib.CmakePackage = {
    generator = "Ninja",

    biDrvs = [
      drvs.spirvHeaders,
      drvs.spirvTools,
      drvs.llvmFull,
      drvs.llvmConfigStatic,
      drvs.samurai,
    ],
    baseBuildinputPackages = std.array.filter (fun v => v.drvHash != drvs.llvm.drvHash) lib.CmakePackage.baseBuildinputPackages,

    cmakeExtraArgsRecord = {
      "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR" = "${SRC}/SPIRV-Headers",
    },
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v19.1.1.tar.gz",
          sha256sum = "7f6f7a1af0eb40910ddf3a7647d2186c8c5dc5a47945afa935aeec56bacf4336",
        }
      },
      {
        dest = "SPIRV-Headers",
        src = {

          uri = "https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/vulkan-sdk-1.3.290.0.tar.gz",
          sha256sum = "1b9ff8a33e07814671dee61fe246c67ccbcfc9be6581f229e251784499700e24",
        }
      }
    ],
  }
}
