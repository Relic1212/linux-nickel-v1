{
  lib,
  drvs,

  avizo | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://github.com/heyjuvi/avizo/archive/refs/tags/1.3.tar.gz",
        sha256sum = "2b1f5817a916e518b0c10c4c94a3678a5054b879eb32c10b5d1425faa6387127"
      },

      llvmProvider = drvs.llvmFull,

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
        drvs.glibDynamic,
        drvs.muslShared,
        drvs.hwdata,
        drvs.gobjectDynamic,
        drvs.cairoGobject,
        drvs.fribidi,
        drvs.gdkPixbufFull,
        drvs.libjpegTurbo,
        drvs.libepoxy,
        drvs.atSpi2Core,
        drvs.mesa2,
        drvs.libelf,
        drvs.libdrm,
        drvs.libpciaccess,
        drvs.llvmConfigStatic,
        drvs.spirvTools,
        drvs.spirvLlvmTranslator,
        drvs."gtk+3",
        drvs.gtkLayerShellFull,

        drvs.vala,
      ],
    }
}
