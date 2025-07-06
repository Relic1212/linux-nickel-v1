{
  lib,

  libjxl | lib.CmakePackage = {
    generator = "Ninja",

    singleSource = {
      uri = "https://github.com/libjxl/libjxl/archive/refs/tags/v0.11.1.tar.gz",
      sha256sum = "1492dfef8dd6c3036446ac3b340005d92ab92f7d48ee3271b5dac1d36945d3d9"
    }
  }
}
