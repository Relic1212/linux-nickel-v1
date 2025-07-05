{
  lib,
  drvs,
  libdisplayinfo | lib.MesonPackage = {
    name = "libdisplayinfo",
    singleSource = {
      uri = "https://gitlab.freedesktop.org/emersion/libdisplay-info/-/archive/0.2.0/libdisplay-info-0.2.0.tar.gz",
      sha256sum = "f7331fcaf5527251b84c8fb84238d06cd2f458422ce950c80e86c72927aa8c2b",
    },
    biDrvs = [
      drvs.hwdata,
    ]
  }
}
