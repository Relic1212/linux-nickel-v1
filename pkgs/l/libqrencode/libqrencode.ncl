{
  lib,
  drvs,
  libqrencode | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/fukuchi/libqrencode/archive/refs/tags/v4.1.1.tar.gz",
      sha256sum = "5385bc1b8c2f20f3b91d258bf8ccc8cf62023935df2d2676b5b67049f31a049c"
    },
    biDrvs = [
      drvs.zlibNg,
      drvs.libpng,
    ]
  }
}
