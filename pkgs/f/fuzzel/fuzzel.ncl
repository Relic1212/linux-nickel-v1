{
  lib,
  drvs,
  fuzzel | lib.MesonPackage = {
    singleSource = {
      uri = "https://codeberg.org/dnkl/fuzzel/archive/1.13.1.tar.gz",
      sha256sum = "17e8f01753469573965a2a37b5745d03e6f6e7bda9d675cd2bc4644abb42d818"
    },
    biDrvs = [
      drvs.tllist,
      drvs.fcft,
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman046,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.expat,
      drvs.linuxHeaders,
      drvs.scdoc,
      drvs.ncurses,
      drvs.utf8proc,
      drvs.libpng,
    ],
  }
}
