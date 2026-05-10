{
  lib,
  drvs,
  swayNotificationCenter | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/ErikReider/SwayNotificationCenter/archive/refs/tags/v0.12.1.tar.gz",
      sha256sum = "8a6475bfdd8abf5be1267ede0a233266b3f14311b169047bde599752a3ac981c"
    },

    llvmProvider = drvs.llvmFull,
    pythonProvider = drvs.pythonDynamic,

    biDrvs = [
      # drvs.cairo,
      # drvs.pango, #??
      drvs.appstream,
      drvs.atSpi2Core,
      drvs.blueprintCompiler,
      drvs.cairoGobject,
      drvs.curl,
      drvs.expat,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.glibDynamic,
      drvs.gobjectDynamic,
      drvs.gperf,
      drvs.granite7,
      drvs.graphene,
      drvs.gtk4,
      drvs.gtk4LayerShell,
      drvs.harfbuzzFull,
      drvs.hwdata,
      drvs.jsonGlib,
      drvs.libadwaita,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxy,
      drvs.libffi,
      drvs.libgee,
      drvs.libjpegTurbo,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libpsl,
      drvs.libtiff,
      drvs.libxkbcommon,
      drvs.libxml2,
      drvs.libxmlb,
      drvs.libyaml,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.mesa2,
      drvs.muslShared,
      drvs.ncurses,
      drvs.openssl,
      drvs.pango,
      drvs.pcre2,
      drvs.pixman,
      drvs.pythonSetuptools,
      drvs.readline,
      drvs.sassc,
      drvs.scdoc,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.vala,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.zlibNg,
    ],

    extraMesonArgs = [
      "-Dsystemd-service=false",
      "-Dpulse-audio=false",
    ]
  }
}
& {
  lib,
  drvs,
  libgee | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/libgee/0.20/libgee-0.20.8.tar.xz",
      sha256sum = "189815ac143d89867193b0c52b7dc31f3aa108a15f04d6b5dca2b6adfad0b0ee"
    },
    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.pkgconf,
    ],
  }
}
