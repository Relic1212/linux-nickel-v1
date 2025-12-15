{
  lib,
  drvs,
  vulkanHeaders | lib.CmakePackage = {
    debug = true,
    generator = "Ninja",

    singleSource = {
      # uri = "https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/v1.4.318.tar.gz",
      # sha256sum = "24df01da8a5c54ee19dfee92259b7edcf44693875fbf96ccdfec69d6e3eef0bc",

      uri = "https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/v1.4.334.tar.gz",
      sha256sum = "f6b858ed8ff5747a32e7840ba20c565c6477c5c1c171bfc25195ef1730b349cc",
    }
  }
}
