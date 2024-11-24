{
  lib,
  drvs,
  slurp | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://github.com/emersion/slurp/releases/download/v1.5.0/slurp-1.5.0.tar.gz",
        sha256sum = "eeb282b2adc8db5614b852596340b69da6f3954cf6cfbdc4392da509c934208a"
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
