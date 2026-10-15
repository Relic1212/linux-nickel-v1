{
  lib,
  drvs,
  pythonSphinxcontribApplehelp | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/sphinx-doc/sphinxcontrib-applehelp/archive/refs/tags/2.0.0.tar.gz",
      sha256sum = "953f2b79bf0162715e943fadbb805f614fb879c61f07a44d425961485baf7891",
    },

    biDrvs = [
      drvs.pythonFlitCore312,
    ],
  }
}
