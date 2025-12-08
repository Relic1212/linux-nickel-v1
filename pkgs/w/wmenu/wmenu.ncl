{
  lib,
  drvs,
  wmenu | lib.MesonPackage = {
    singleSource = {
      uri = "https://codeberg.org/adnano/wmenu/archive/0.2.0.tar.gz",
      sha256sum = "4e6aea3f8975fec720f6eb87aad620d5297a8a5a137615e4cf047e95d2b9d308"
    },
    biDrvs = [
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
      drvs.ncurses,
      drvs.readline,
      drvs.pcre2,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.harfbuzz,
      drvs.scdoc,
      drvs.glib,
      drvs.hwdata,
      drvs.fribidi,
    ],
  }
}
