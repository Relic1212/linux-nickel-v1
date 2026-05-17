{
  lib,
  drvs,

  spirvHeaders,
  spirvTools | lib.CmakePackage = {
    generator = "Ninja",

    sourceInputs | priority 1 = [
      {
        src = {

          uri = "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.4.350.0.tar.gz",
          sha256sum = "446b288fe76d3f31bbf9a405d62b97020ac0f135edb0ed5dbdf1136c488138f5",
        }
      },
      {
        dest = "external/spirv-headers",
        src =
          spirvHeaders.singleSource,
      },
    ],
    patches = [
      {
        file = "0001-no-shared.patch",
        sha256sum = "0622acd34f987e45dfba87f6d9cd33c4356cb1476a8baa6c63dd8f5e9fe9391b",
      }
    ],
    cmakeExtraArgsRecord = {
      "-DSPIRV_TOOLS_BUILD_STATIC" = true
    },
    # preConfigurePhase = [
    #   m%"sed -i 's|static ${SPIRV_TOOLS}-shared|static|g' ${SRC}/source/CMakeLists.txt"%,
    # ],
    biDrvs | priority 1 = [
      drvs.pythonFull,
      # drvs.spirvHeaders2,
    ],
  },
  spirvToolsDebug =
    spirvTools
    & {
      debug = true,
    },
}
