{
  lib,
  drvs,
  lsof | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/lsof-org/lsof/archive/refs/tags/4.99.5.tar.gz",
      sha256sum = "3c591556c665196e0aada5982ff43c75e248187bad78bb1368d8fb9c1c527e6e"
    },
    biDrvs = [
      drvs.mandoc,
      drvs.linuxHeaders,
    ]
  }
}
