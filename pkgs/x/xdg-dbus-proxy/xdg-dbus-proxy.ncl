{
  lib,
  drvs,
  xdgDbusProxy | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/flatpak/xdg-dbus-proxy/archive/refs/tags/0.1.6.tar.gz",
      sha256sum = "ee9c1d665f4e3b025a83d522d478ff7930070f2817fc2cb446db0dca93c990b1"
    },
    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
    ]
  }
}
