{
  lib,
  drvs,
  selinuxSetools | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/SELinuxProject/setools/archive/refs/tags/4.7.1.tar.gz",
      sha256sum = "13a39cdccae7fc8454c41e5bf619514d84d7113ffcdcd0cf6ea7ef867a74937e",
    },
    buildEnv.CC = "cc",
    pythonProvider = drvs.pythonDynamic,
    neverInclude = [
      drvs.pythonSetuptools,
    ],
    biDrvs = [
      drvs.llvm,
      drvs.pythonCython,
      drvs.musl,
      drvs.muslShared,
      drvs.pythonSetuptools80,
      drvs.linuxHeaders,
      drvs.selinuxCc,
    ],
    pDrvs = [
      drvs.selinux,
    ],
  }
}
