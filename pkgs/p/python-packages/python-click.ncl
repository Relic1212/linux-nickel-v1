{
  lib,
  drvs,
  pythonClick | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/pallets/click/archive/refs/tags/8.3.1.tar.gz",
      sha256sum = "df2fb64b9c3f0b5fbf65f1b69dd164cd2d8e7d5d8f6ee3abdafcff7fe2d63719"
    },
    biDrvs = [
      drvs.pythonHatchling,
      drvs.pythonPathspec,
      drvs.pythonPluggy,
      drvs.pythonImportlibMetadate,
      drvs.pythonPackaging242,
      drvs.pythonTroveClassifiers,
      drvs.pythonFlitCore312,
    ]
  }
}
