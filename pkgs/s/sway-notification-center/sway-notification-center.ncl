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
      drvs.pango_1_56,
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
  blueprintCompiler | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/blueprint-compiler/-/archive/0.18.0/blueprint-compiler-0.18.0.tar.gz",
      sha256sum = "51aa472ecd7bd4b32b8baa7ae6768b19810793d4a2a1aba39c5b31b0170cb258"
    }
  }
}
& {
  lib,
  drvs,
  granite7 | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/elementary/granite/archive/refs/tags/7.6.0.tar.gz",
      sha256sum = "4b4e4f7f86eb3f55116faec42ebd87e04c3e424d82715ecd967ed39540dca5ef"
    },

    llvmProvider = drvs.llvmFull,
    # pythonProvider = drvs.pythonDynamic,

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
      drvs.glib,
      #   drvs.muslShared,
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
      drvs.sassc,
      drvs.blueprintCompiler,
      drvs.gtk4LayerShell,
      drvs.jsonGlib,
      drvs.appstream,
      drvs.curl,
      drvs.openssl,
      drvs.libadwaita,
      drvs.libpsl,
      drvs.libyaml,
      drvs.libxml2,
      drvs.libxmlb,
      drvs.libgee,
      drvs.gettext,
    ],

    extraMesonArgs = [
      "-Dintrospection=false",
      "-Ddemo=false",
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
