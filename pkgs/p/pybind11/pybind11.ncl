{
  lib,
  drvs,
  pybind11 | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/pybind/pybind11/archive/refs/tags/v3.0.0.tar.gz",
      sha256sum = "453b1a3e2b266c3ae9da872411cadb6d693ac18063bd73226d96cfb7015a200c"
    },

    llvmProvider = drvs.llvmFullPic,
    biDrvs = [
      drvs.pythonDynamic,
      drvs.muslShared,
    ],
    isStatic = false,
    buildEnv._isStatic = false,
  }
}
