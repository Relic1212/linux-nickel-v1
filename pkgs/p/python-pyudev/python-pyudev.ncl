{
  lib,
  drvs,
  pythonPyudev | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/pyudev/pyudev/archive/refs/tags/v0.24.5.tar.gz",
      sha256sum = "2a5de2783e4b875d663494489aa4d251f10ec8057a70fd574a9ef2dba12edc06",
    },
    biDrvs = [
      # drvs.pythonFull,
      # drvs.pythonBuild,
      # drvs.pythonHooks,
      # drvs.pythonTwine,
      # drvs.pythonPackaging,
      # drvs.pythonRequests,
      # drvs.pythonUrllib3,
      # drvs.pythonIdna,
      # drvs.pythonCertifi,
      # drvs.pythonPoetryCore,
      # drvs.pythonPoetry,
      # drvs.pythonRich,
      # drvs.pythonReadmeRenderer,
      # drvs.docutils,
      # drvs.pythonNh3,
    ],
  }
}
