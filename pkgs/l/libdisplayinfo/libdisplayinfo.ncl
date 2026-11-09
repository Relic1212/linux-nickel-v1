{
  lib,
  drvs,
  libdisplayinfo | lib.MesonPackage = {
    name = "libdisplayinfo",
    singleSource = {
      # uri = "https://gitlab.freedesktop.org/emersion/libdisplay-info/-/archive/0.2.0/libdisplay-info-0.2.0.tar.gz",
      # sha256sum = "f7331fcaf5527251b84c8fb84238d06cd2f458422ce950c80e86c72927aa8c2b",
      uri = "https://gitlab.freedesktop.org/emersion/libdisplay-info/-/archive/0.4.0/libdisplay-info-0.4.0.tar.bz2",
      sha256sum = "5b88699ca21dceb10ab8fb1b41d1cbd9eabeb3b775e11e86ce9d7d6a3158a318",
    },
    biDrvs = [
      drvs.hwdata,
    ]
  }
}
