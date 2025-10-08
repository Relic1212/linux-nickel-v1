{
  lib,
  drvs,
  hdparm | lib.MakePackage = {
    singleSource = {
      uri = "https://sourceforge.net/projects/hdparm/files/hdparm/hdparm-9.65.tar.gz",
      sha256sum = "d14929f910d060932e717e9382425d47c2e7144235a53713d55a94f7de535a4b"
    },

    extraMakeInstallArgs = [
      "sbindir=/usr/bin"
    ],

    biDrvs = [
      drvs.linuxHeaders,
      drvs.pkgconf,
    ]
  }
}
