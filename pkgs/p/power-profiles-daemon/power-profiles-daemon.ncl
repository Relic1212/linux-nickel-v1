{
  lib,
  drvs,
  powerProfilesDaemon | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/upower/power-profiles-daemon/-/archive/0.30/power-profiles-daemon-0.30.tar.gz",
      sha256sum = "90f2c95024861d9f4062abedd514084939224e7a49edd468f001af7260ec8e6c"
    },
    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.libxslt,
      drvs.gudev,
      drvs.eudev,
      drvs.linuxHeaders,
      drvs.upower,
    ],
    extraMesonArgs = [
      "-Dsystemdsystemunitdir=no",
    ]
  }
}
