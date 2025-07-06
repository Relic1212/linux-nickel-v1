{
  spirvHeaders3,
  spirvTools,
  llvmFull,
  llvmConfigStatic,
  samurai,
  llvm,

  lib,
  spirvLlvmTranslator | lib.CmakePackage = {
    generator = "Ninja",

    biDrvs =
      lib.biMap [
        spirvHeaders3,
        spirvTools,
        llvmFull,
        llvmConfigStatic,
        samurai,
      ],
    baseBuildinputPackages = std.array.filter (fun v => v.name != llvm.name) lib.CmakePackage.baseBuildinputPackages,

    cmakeExtraArgsRecord = {
      # "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR" = "${SRC}/SPIRV-Headers",
      "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR" = "/usr/include/spirv",
    },
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v20.1.0.tar.gz",
          sha256sum = "ffca6b2aa53076ef85a09676ef0079877cce4977d7aa64f5f5b33596c7d1d285",
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
