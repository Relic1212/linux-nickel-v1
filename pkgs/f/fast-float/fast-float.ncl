{
  lib,
  drvs,
  fastFloat | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/fastfloat/fast_float/archive/refs/tags/v8.0.2.tar.gz",
      sha256sum = "e14a33089712b681d74d94e2a11362643bd7d769ae8f7e7caefe955f57f7eacd"
    }
  }
}
