{
  lib,
  drvs,
  libwebp | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/webmproject/libwebp/archive/refs/tags/v1.5.0.tar.gz",
      sha256sum = "668c9aba45565e24c27e17f7aaf7060a399f7f31dba6c97a044e1feacb930f37"
    }
  }
}
