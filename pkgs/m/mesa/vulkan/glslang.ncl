{
  lib,
  drvs,
  glslang | lib.CmakePackage = {
    # debug = true,
    generator = "Ninja",
    singleSource = {
      # uri = "https://github.com/KhronosGroup/glslang/archive/refs/tags/15.4.0.tar.gz",
      # sha256sum = "b16c78e7604b9be9f546ee35ad8b6db6f39bbbbfb19e8d038b6fe2ea5bba4ff4",
      uri = "https://github.com/KhronosGroup/glslang/archive/refs/tags/16.0.0.tar.gz",
      sha256sum = "172385478520335147d3b03a1587424af0935398184095f24beab128a254ecc7",
    },
    cmakeExtraArgsRecord = {
      # "-DBUILD_EXTERNAL" = false,
      "-DALLOW_EXTERNAL_SPIRV_TOOLS" = true
    },
    biDrvs = [
      drvs.googletest,
      drvs.pythonFull,
      drvs.bison,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
    ]
  },
  glslangDebug =
    glslang
    & {
      debug = true,
    },
  # spirvTools_glslang | lib.CmakePackage = {
  #   debug = true,
  #   generator = "Ninja",
  #   sourceInputs = [
  #     {
  #       src = {
  #         uri = "https://github.com/KhronosGroup/SPIRV-Tools/archive/33e02568181e3312f49a3cf33df470bf96ef293a.tar.gz",
  #         sha256sum = "44d1005880c583fc00a0fb41c839214c68214b000ea8dcb54d352732fee600ff",
  #       }
  #     },
  #     {
  #       dest = "external/spirv-headers",
  #       src = {

  #         uri = "https://github.com/KhronosGroup/SPIRV-Headers/archive/2a611a970fdbc41ac2e3e328802aed9985352dca.tar.gz",
  #         sha256sum = "c2225a49c3d7efa5c4f4ce4a6b42081e6ea3daca376f3353d9d7c2722d77a28a",
  #       }
  #     },
  #   ],

  #   cmakeExtraArgsRecord = {
  #     "-DSPIRV_TOOLS_BUILD_STATIC" = true
  #   },

  #   biDrvs = [
  #     drvs.pythonFull,
  #   ],

  #   patches = [
  #     # {
  #     #   file = "0001-no-shared.patch",
  #     #   sha256sum = "8f08d8582c8da16bd4e80ec3ec475988b3b2ad0f61d68fde74453c151f4ead7d",
  #     # }
  #     {
  #       sha256sum = "50d23b899d39519d0d28b4310c2858f8ac5ca3698e0a1cd5af38b595a24a66a4",
  #       file = "mesa-glslang-spirv.patch"
  #     }
  #   ]
  # },
}
