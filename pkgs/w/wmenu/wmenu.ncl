{
  lib,
  drvs,
  wmenu | lib.MesonPackage = {
    singleSource = {
      uri = "https://codeberg.org/adnano/wmenu/archive/0.1.9.tar.gz",
      sha256sum = "1b457dfdbf8404748a036d8ee4fab1853d5dd28b132531321b7afc78e85bc1cd"
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
