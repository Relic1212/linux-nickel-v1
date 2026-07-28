{
  lib,
  drvs,
  libgit2 | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/libgit2/libgit2/archive/refs/tags/v1.9.6.tar.gz",
      sha256sum = "a88a42a4ea9bdab7aa8686eead3bf7d9c6dd74529caca16ab22eaa92433d31d9"
    },
    cmakeExtraArgsRecord = {
      "-DUSE_GSSAPI" = false,
      "-DUSE_BUNDLED_ZLIB" = false,
      # "-DBUILD_TESTS" = false,
    },
    biDrvs = [
      drvs.linuxHeaders,
      drvs.pythonFull,
    ],
    pDrvs = [
      drvs.zlibNg,
      drvs.openssl,
    ]
  }
}
