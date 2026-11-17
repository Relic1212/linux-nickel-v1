{
  lib,
  drvs,
  htop | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/htop-dev/htop/archive/refs/tags/3.5.3.tar.gz",
      sha256sum = "edf25ee020a5263ffbef9eef5a8c14392bf74e78b3d5c8bc64d9343dd9a82605"
    },
    biDrvs = [
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.ncurses,
      drvs.libcap,
      drvs.libnl,
      drvs.lmSensors,
    ]
  }
}
