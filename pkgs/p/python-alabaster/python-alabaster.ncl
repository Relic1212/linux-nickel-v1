{
  lib,
  drvs,
  pythonAlabaster | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/sphinx-doc/alabaster/archive/refs/tags/1.0.0.tar.gz",
      sha256sum = "10f054e53bb5417658bdf242ed51e0189816423b0908dfffbc7eaa4382459bce",
    },

    biDrvs = [
      drvs.pythonFlitCore312,
    ],
  }
}
