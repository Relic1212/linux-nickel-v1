{
  lib,
  drvs,
  elinks | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/rkd77/elinks/archive/refs/tags/v0.20.0.tar.gz",
      sha256sum = "7067925d13297ee91dfaf5aa2e0295a3049d0d8ee5da899a7baf1f5150a6d8d4",
    },
    extraMesonArgs = [
      "-Dbacktrace=false",
      "-Dtre=false",
      "-Didn=false",
      "-Dgpm=false",
    ],

    biDrvs = [
      drvs.linuxHeaders,
      drvs.perl,
    ],

    pDrvs = [
      # drvs.zlibNg,
      # drvs.openssl,
      drvs.curl,
      drvs.libcss,
      drvs.libdom,
    ],
  }
}
