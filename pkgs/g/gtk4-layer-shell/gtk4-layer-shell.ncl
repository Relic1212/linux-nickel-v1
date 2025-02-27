
{
  lib,
  drvs,
  gtk4LayerShell | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://github.com/wmww/gtk4-layer-shell/archive/refs/tags/v1.1.0.tar.gz",
        sha256sum = "98284281260a5eef5b4f63a55f16c4bf6a788a1020a6db037ecb0f71fa336988"
      },

      llvmProvider = drvs.llvmFull,
      pythonProvider = drvs.pythonDynamic,

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
        drvs.harfbuzzFull,
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
        drvs.gtk4,
        drvs.vala,
        drvs.pythonSetuptools,
      
      
        drvs.libtiff,
        drvs.graphene,
      ],
      extraMesonArgs = [
        "-Dintrospection=false",
        "-Dvapi=false",

      ]
    }
}
