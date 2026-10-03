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
    singleSource = {
      uri = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v23.1.2.tar.gz",
      sha256sum = "b657254b5e0a2dda7914a8cb1eace467f22847d75d877b83829026c1452f827a",
    },
    sourceInputs = [
      {
        src = singleSource,
      },
      # {
      #   dest = "SPIRV-Headers",
      #   src = {

      #     uri = "https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/vulkan-sdk-1.3.290.0.tar.gz",
      #     sha256sum = "1b9ff8a33e07814671dee61fe246c67ccbcfc9be6581f229e251784499700e24",
      #   }
      # }
    ],
  },
  spirvLlvmTranslatorDebug =
    spirvLlvmTranslator
    & {
      debug = true,
    },
}
