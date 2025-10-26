{
  lib,
  drvs,
  ryzenAdj | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/FlyGoat/RyzenAdj/archive/refs/tags/v0.17.0.tar.gz",
      sha256sum = "848ac9d86ff65d30f5e2c8600aac2613f0f10003b0d6f0e516a54761d7345d44"
    },
    biDrvs = [
      drvs.pciutils,
    ]
  }
}
