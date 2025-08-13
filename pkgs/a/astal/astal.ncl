{
  lib,
  drvs,
  astalIo | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/Aylur/astal/archive/2c5eb54f39e1710c6e2c80915a240978beb3269a.tar.gz",
      sha256sum = "964b819379d5ac18d54a728526e59ee95f24e07e3f79de4efdb945cc059b1d93"
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
      # drvs.pango, #??
      drvs.pango_1_56,
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
      drvs.gtk4LayerShell,
      drvs.libadwaita,
    ],

    preConfigurePhase = [
      "export SRC=/tmp/workdir/src/lib/astal/gtk4",
    ]
  }
}
