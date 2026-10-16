{
  lib,
  drvs,
  pythonPuccinialin | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/konstin/puccinialin/archive/refs/tags/v0.1.14.tar.gz",
      sha256sum = "f7f0ce6746df15d023c620b3ebd33c521ac9061ec7d109fd70552e0701f3193d",
    },
    biDrvs = [
      drvs.pythonFlitCore312,
    ],
  }
}
