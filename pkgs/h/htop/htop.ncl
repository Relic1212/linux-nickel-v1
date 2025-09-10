{
  lib,
  drvs,
  htop | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/htop-dev/htop/releases/download/3.4.1/htop-3.4.1.tar.xz",
      sha256sum = "904f7d4580fc11cffc7e0f06895a4789e0c1c054435752c151e812fead9f6220"
    },
    biDrvs = [
      drvs.ncurses,
      drvs.libcap,
      drvs.libnl,
      drvs.lmSensors,
      drvs.pkgconf,
      drvs.linuxHeaders,
    ]
  }
}
