{
  lib,
  drvs,
  pciutils | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/pciutils/pciutils/archive/refs/tags/v3.13.0.tar.gz",
      sha256sum = "861fc26151a4596f5c3cb6f97d6c75c675051fa014959e26fb871c8c932ebc67"
    },
    extraMakeArgs = [
      "CC=\"${CC}\"",
      "SBINDIR=/usr/bin",
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr",
      "SBINDIR=/usr/bin",
    ],
    makeInstallTargets = [
      "install",
      "install-lib",
    ],
    biDrvs = [
      drvs.linuxHeaders,
    ]
  }
}
