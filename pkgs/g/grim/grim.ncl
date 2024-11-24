{
  lib,
  drvs,
  grim | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://git.sr.ht/~emersion/grim/refs/download/v1.4.1/grim-1.4.1.tar.gz",
        sha256sum = "93dbbc6608ae541a209c82d7e3cf1035d93844b99d2e40592d0b355f088d9ac5"
      },

      biDrvs = [
        drvs.libpng,
        drvs.fontconfig,
        drvs.freetype,
        drvs.zlibNg,
        drvs.gperf,
        drvs.pixman,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.libffi,
        drvs.libxkbcommon,
        drvs.expat,
        drvs.linuxHeaders,
        drvs.scdoc,
      ]
    }
}
