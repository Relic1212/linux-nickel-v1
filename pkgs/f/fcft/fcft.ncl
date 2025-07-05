{
  lib,
  drvs,
  fcft | lib.MesonPackage = {
    singleSource = {
      uri = "https://codeberg.org/dnkl/fcft/releases/download/3.1.8/fcft-3.1.8.tar.gz",
      sha256sum = "028099126692625873410889a1d76cd82d5a71b5e350bd618320e48db15a8636"
    },
    biDrvs = [
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman,
      drvs.tllist,
      drvs.expat,
    ]
  }
}
