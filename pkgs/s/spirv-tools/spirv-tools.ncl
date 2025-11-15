{
  lib,
  drvs,
  _spirvTools | lib.CmakePackage = {
    generator = "Ninja",
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/v2024.2.tar.gz",
          sha256sum = "58c5f4e6961c3d4936f7dbcd7f0b495c830b96972ee731452eaa9ade873f0095",
        }
      },
      {
        dest = "external/spirv-headers",
        src = {
          #    uri="https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/vulkan-sdk-1.3.296.0.tar.gz",
          #             sha256sum="1423d58a1171611d5aba2bf6f8c69c72ef9c38a0aca12c3493e4fda64c9b2dc6",

          uri = "https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/vulkan-sdk-1.3.290.0.tar.gz",
          sha256sum = "1b9ff8a33e07814671dee61fe246c67ccbcfc9be6581f229e251784499700e24",
        }
      },
    ],

    # cmakeExtraArgsRecord={
    #     "-DBUILD_SHARED_LIBS" = 0,
    # },
    biDrvs = [
      drvs.pythonFull,
      drvs.spirvHeaders_1_3_296,
    ],
    # patches = [
    #   {
    #     file = "0001-no-shared.patch",
    #     sha256sum = "8f08d8582c8da16bd4e80ec3ec475988b3b2ad0f61d68fde74453c151f4ead7d",
    #   }
    # ]
  },

  spirvHeaders,
  spirvTools | lib.CmakePackage =
    # _spirvTools
    # & 
    {
      generator = "Ninja",

      sourceInputs | priority 1 = [
        {
          src = {
            # uri | priority 1 = "https://github.com/KhronosGroup/SPIRV-Tools/archive/ce92630396c2fd2d6d04819369116af4fb141a28.zip",
            # sha256sum | priority 1 = "43b981567354af80570eedbd7858718f7273b3d964101a358a5202b2fae2844d",

            # uri = "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/v2025.4.tar.gz",
            # sha256sum = "d256aa82de849bdce4b05060081dadcc9145c2173a056e8531f649f8975e582e",

            uri = "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.4.328.1.tar.gz",
            sha256sum = "d00dc47df7163c2bacd70f090441e8fad96234f0e3b96c54ee9091a49e627adb",
          }
        },
        {
          dest = "external/spirv-headers",
          src =
            # {
            #   uri = "https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/vulkan-sdk-1.4.328.1.tar.gz",
            #   sha256sum = "602364ab7bf404a7f352df7da5c645f1c4558a9c92616f8ee33422b04d5e35b7"
            # }
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
