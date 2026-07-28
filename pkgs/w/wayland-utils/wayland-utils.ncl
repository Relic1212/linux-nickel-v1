{
  lib,
  drvs,
  waylandUtils | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/wayland/wayland-utils/-/archive/1.3.0/wayland-utils-1.3.0.tar.bz2",
      sha256sum = "898ceff3007b11aaec5b13844ac673b99ee186b2706b9b2ab41ba6be8c29ad06",
    },

    biDrvs = [
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libdrm,
    ]
  }
}
