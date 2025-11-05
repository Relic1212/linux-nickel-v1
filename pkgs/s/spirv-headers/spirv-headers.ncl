{
  lib,
  drvs,
  spirvHeaders_1_3_296 | lib.CmakePackage = {
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
  spirvHeaders | lib.CmakePackage = {
    generator = "Ninja",

    singleSource = {
      uri = "https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/vulkan-sdk-1.4.328.1.tar.gz",
      sha256sum = "602364ab7bf404a7f352df7da5c645f1c4558a9c92616f8ee33422b04d5e35b7"
    }
  }
}
& {
  lib,
  drvs,
  spirvHeaders3 | lib.CmakePackage = {
    generator = "Ninja",

    singleSource = {
      uri | priority 1 = "https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/vulkan-sdk-1.4.309.0.tar.gz",

      sha256sum | priority 1 = "a96f8b4f2dfb18f7432e5c523e220ab0075372a9509e0c25fbff21c76af0de7c",
    }
  }
}
