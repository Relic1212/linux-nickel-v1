{
  lib,
  drvs,
  iw | lib.MakePackage = {
    singleSource = {
      uri = "https://mirrors.edge.kernel.org/pub/software/network/iw/iw-6.9.tar.xz",
      sha256sum = "3f2db22ad41c675242b98ae3942dbf3112548c60a42ff739210f2de4e98e4894"
    },

    extraMakeInstallArgs = [
      "SBINDIR=/usr/bin"
    ],

    biDrvs = [
      drvs.pkgconf,
      drvs.libnl,
      drvs.linuxHeaders,
    ]
  }
}
