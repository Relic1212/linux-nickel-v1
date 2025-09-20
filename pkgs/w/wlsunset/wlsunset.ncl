{
  lib,
  drvs,
  wlsunset | lib.MesonPackage = {
    singleSource = {
      uri = "https://git.sr.ht/~kennylevinsen/wlsunset/archive/0.4.0.tar.gz",
      sha256sum = "a86ffb1793fe622802ec25795b69df864715986ecc175f7734e739c9e264ed72"
    },
    biDrvs = [
      #   drvs.tllist,
      #   drvs.fcft,
      drvs.zlibNg,
      #   drvs.gperf,
      #   drvs.pixman,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.expat,
      drvs.linuxHeaders,
      drvs.scdoc,
    ],
  }
}
