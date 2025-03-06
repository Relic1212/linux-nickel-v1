{
  lib,
  drvs,
  _spirvTools | lib.CmakePackage
    = {
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
        drvs.spirvHeaders,
      ],
      patches = [
        {
          file = "0001-no-shared.patch",
          sha256sum = "8f08d8582c8da16bd4e80ec3ec475988b3b2ad0f61d68fde74453c151f4ead7d",
        }
      ]
    },

    spirvHeaders2,
    _spirvTools2 | lib.CmakePackage = _spirvTools &{



      sourceInputs  | priority 1 = [
        {
          src =  {
            uri | priority 1= "https://github.com/KhronosGroup/SPIRV-Tools/archive/ce92630396c2fd2d6d04819369116af4fb141a28.zip",
            sha256sum | priority 1= "43b981567354af80570eedbd7858718f7273b3d964101a358a5202b2fae2844d"
          }
          
        },
        {
          dest| priority 1 = "external/spirv-headers",
          src | priority 1=spirvHeaders2.singleSource,
        },
      ],

       biDrvs | priority 1 = [
        drvs.pythonFull,
        drvs.spirvHeaders2,
      ],
    }
}
