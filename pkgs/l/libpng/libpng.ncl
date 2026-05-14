{
  lib,
  drvs,
  libpng | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://download.sourceforge.net/libpng/libpng-1.6.44.tar.gz",
      sha256sum = "8c25a7792099a0089fa1cc76c94260d0bb3f1ec52b93671b572f8bb61577b732",
    },
    pDrvs = [
      drvs.zlibNg
    ]
  },
  libpngApng | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/pnggroup/libpng/archive/0f07f70aa55e4771d00b0f8a238dca992fbb60e4.tar.gz",
      sha256sum = "474ed0109a37311a770fcb1167ce59187bfecec6786c5ed4a0495021a6e7a8fa"
    },
    cmakeExtraArgsRecord = {
      "-DPNG_SHARED" = false,
    },

    biDrvs = [
      drvs.zlibNg
    ]
  },
  libpngPic =
    libpng
    & {
      buildEnv._isPic = true,
      biDrvs | priority 1 = [drvs.zlibNgPic]
    }
}
