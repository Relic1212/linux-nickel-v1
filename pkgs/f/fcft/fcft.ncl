{
  lib,
  drvs,
  fcft | lib.MesonPackage = {
    singleSource = {
      uri = "https://codeberg.org/dnkl/fcft/releases/download/3.3.1/fcft-3.3.1.tar.gz",
      sha256sum = "480faa4ad86f7a4af3e21d4993c81d5e57f429e7b553d0103cd68f3fa340fe53"
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
