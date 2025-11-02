{
  lib,
  drvs,
  libgit2 | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/libgit2/libgit2/archive/refs/tags/v1.9.1.tar.gz",
      sha256sum = "14cab3014b2b7ad75970ff4548e83615f74d719afe00aa479b4a889c1e13fc00"
    },
    cmakeExtraArgsRecord = {
      "-DUSE_GSSAPI" = false,
      "-DUSE_BUNDLED_ZLIB" = false,
      # "-DBUILD_TESTS" = false,
    },
    biDrvs = [
      drvs.zlibNg,
      drvs.openssl,
      drvs.linuxHeaders,
      drvs.pythonFull,
    ],
  }
}
