{
  lib,
  drvs,
  pythonHatchVcs | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/ofek/hatch-vcs/archive/refs/tags/v0.5.0.tar.gz",
      sha256sum = "a74465d21bb60eef75f01b3c189b73181f152a5eef2b26bd95de039e224953a7",
    },
    biDrvs = [
      drvs.pythonHatchling,
      drvs.pythonPathspec,
      drvs.pythonPluggy,
      drvs.pythonPackaging242,
      drvs.pythonImportlibMetadate,
      drvs.pythonTroveClassifiers,
    ],
  }
}
