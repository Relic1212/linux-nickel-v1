{
  lib,
  drvs,
  kanshi | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/emersion/kanshi/-/archive/v1.8.0/kanshi-v1.8.0.tar.gz",
      sha256sum = "11a4282356415e242e19d4202ff25118add657486396e47370996d39696e3ccc",
    },

    biDrvs = [
      drvs.wayland,
      drvs.linuxHeaders,
      drvs.waylandProtocols,
      drvs.scdoc,
      drvs.expat,
      drvs.libffi,
      drvs.libscfg,
    ],
  }
}
