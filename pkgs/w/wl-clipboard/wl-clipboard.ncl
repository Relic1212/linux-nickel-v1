{
  lib,
  drvs,
  wlClipboard | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/bugaevc/wl-clipboard/archive/refs/tags/v2.2.1.tar.gz",
      sha256sum = "6eb8081207fb5581d1d82c4bcd9587205a31a3d47bea3ebeb7f41aa1143783eb"
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
    ],
  }
}
