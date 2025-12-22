{
  lib,
  drvs,
  pythonColorama | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/tartley/colorama/archive/refs/tags/0.4.6.tar.gz",
      sha256sum = "2d0543c3970840160b32656ab83d43b7f3533208c2c5f3ee5b839940d00af0bd"
    },
    biDrvs = [
      drvs.pythonHatchling,
      drvs.pythonPathspec,
      drvs.pythonPluggy,
      drvs.pythonImportlibMetadate,
      drvs.pythonPackaging242,
      drvs.pythonTroveClassifiers,
    ]
  }
}
