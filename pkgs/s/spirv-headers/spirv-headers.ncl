{
  lib,
  drvs,
  spirvHeaders | lib.CmakePackage = {
    generator = "Ninja",

    singleSource = {
      uri = "https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/vulkan-sdk-1.3.296.0.tar.gz",
      sha256sum = "1423d58a1171611d5aba2bf6f8c69c72ef9c38a0aca12c3493e4fda64c9b2dc6",
    }
  }
}
& {
  lib,
  drvs,
  spirvHeaders2 | lib.CmakePackage = {
    generator = "Ninja",

    singleSource = {
      uri | priority 1 = "https://github.com/KhronosGroup/SPIRV-Headers/archive/3f17b2af6784bfa2c5aa5dbb8e0e74a607dd8b3b.zip",
      sha256sum | priority 1 = "366a4a46f0e36293852119ad1cf5b91d72c2920eeb6aee3a3d8f2596e0a70167",
    }
  }
}
