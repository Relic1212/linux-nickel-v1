{
  lib,
  drvs,

  gtkLayerShell | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/wmww/gtk-layer-shell/archive/refs/tags/v0.9.0.tar.gz",
      sha256sum = "3809e5565d9ed02e44bb73787ff218523e8760fef65830afe60ea7322e22da1c"
    },

    llvmProvider = drvs.llvmFull,

    pDrvs = [
      drvs.gtk3,
    ],
    extraMesonArgs = [
      "-Dvapi=false",
      "-Dintrospection=false",
    ]
  }
}
& {
  lib,
  drvs,
  gtkLayerShell,
  gtkLayerShellFull | lib.MesonPackage = {
    singleSource = gtkLayerShell.singleSource,

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
      drvs.gtk3,
      # drvs.vala,
      drvs.pythonSetuptools,
    ],
    extraMesonArgs = [
      "-Dvapi=true",
      "-Dintrospection=false",
    ]
  }
}
