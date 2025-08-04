{
  lib,
  drvs,
  thunar | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.xfce.org/xfce/thunar/-/archive/50da48b64fd4a7958c503270f91111d46fafa598/thunar-50da48b64fd4a7958c503270f91111d46fafa598.tar.gz",
      sha256sum = "3181330c01435bd0baa9a76729d6a8b8ccdc3126686c28fac6c166834950877e"
    },
    extraMesonArgs = [
      "-Dintrospection=false",
      "-Dvisibility=false",
      "-Dx11=disabled",
      "-Dthunar-apr=disabled",
      "-Dthunar-sbr=disabled",
      "-Dgexiv2=disabled",
      "-Dthunar-tpa=disabled",
      "-Dthunar-uca=disabled",
      "-Dthunar-wallpaper=disabled",
    ],

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
      #drvs.cairo,
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
      # drvs.gtk3,
      drvs.libxfce4util,
      drvs.xconf,
      drvs.gettext,
      drvs.libxfce4ui,
      drvs.xfce4DevTools,
      drvs.libxslt,
      drvs.gtk3,
    ],

    preConfigurePhase = [
      m%"sed -i "s@subdir('docs')@@g" ${SRC}/meson.build"%,
      m%"sed -i "s@subdir('examples' / 'tex-open-terminal')@@g" ${SRC}/meson.build"%,
    ],
    patches = [
      {
        # https://github.com/gentoo-mirror/sorrow/blob/4778c989219f5da1477aff82d2c5213b37de890e/xfce-base/thunar/files/thunar-4.19.4-no-x-workaround.patch#L5
        file = "0001-no-x.patch",
        sha256sum = "5b8e4a83420b8f98d47330954b80519e607275b8fe57ac25f13b1af4edd579a5"
      }
    ]
  }
}
& {
  lib,
  drvs,
  libxfce4ui | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.xfce.org/xfce/libxfce4ui/-/archive/libxfce4ui-4.21.2/libxfce4ui-libxfce4ui-4.21.2.tar.gz",
      sha256sum = "646d4383b9520953719a7c4af0976fe3431ccfc5f1441605467c93356ace902e"
    },
    extraMesonArgs = [
      "-Dintrospection=false",
      "-Dvisibility=false",
      "-Dx11=disabled",
      "-Dkeyboard-library=true",
      "-Dwayland=enabled",
      "-Dglade=disabled",
      "-Dgudev=disabled",
      "-Depoxy=disabled",
      "-Dlibgtop=disabled",
    ],

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
      #drvs.cairo,
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
      drvs.libxfce4util,

      #   drvs.libgtop,
      drvs.xconf,
      drvs.gettext,
    ],
  }
}
& {
  lib,
  drvs,
  libxfce4util | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.xfce.org/xfce/libxfce4util/-/archive/libxfce4util-4.20.1/libxfce4util-libxfce4util-4.20.1.tar.gz",
      sha256sum = "998e6ede1b908a34b2f91defcdcc9e7103e7d2628b7830698d65409743ccec72"
    },
    extraMesonArgs = [
      "-Dintrospection=false",
      "-Dvisibility=false",
      "-Dvala=disabled",
    ],

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
      #drvs.cairo,
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
    ],
  }
}
& {
  lib,
  drvs,
  xconf | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.xfce.org/xfce/xfconf/-/archive/xfconf-4.21.0/xfconf-xfconf-4.21.0.tar.gz",
      sha256sum = "14e1ae3ad07cd33cad7be295467bd035480b776ffc24248de8c50c63bd2e5c64"
    },

    llvmProvider = drvs.llvmFull,

    extraMesonArgs = [
      "-Dgsettings-backend=false",
      "-Dtests=false",
      "-Dvisibility=false",
      "-Dintrospection=false",
    ],

    # separateBuildDir = false,

    biDrvs = [

      #drvs.cairo,
      drvs.atSpi2Core,
      drvs.cairoGobject,
      drvs.expat,
      drvs.freetype,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.glibDynamic,
      drvs.gobjectDynamic,
      drvs.gperf,
      drvs.gtk3,
      drvs.harfbuzz,
      drvs.hwdata,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxy,
      drvs.libffi,
      drvs.libgtop,
      drvs.libjpegTurbo,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libxfce4util,
      drvs.libxkbcommon,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.mesa2,
      drvs.muslShared,
      drvs.ncurses,
      drvs.pango,
      drvs.pcre2,
      drvs.pixman,
      drvs.pythonSetuptools,
      drvs.readline,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.zlibNg,
      drvs.fontconfig,
    ],
  }
}
& {
  lib,
  drvs,
  xfce4DevTools | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://archive.xfce.org/src/xfce/xfce4-dev-tools/4.21/xfce4-dev-tools-4.21.0.tar.bz2",
      sha256sum = "36059f48bbb196645f6514ab5a356e55cdd9bc917edcaf6afd86adfc28d7a358"
    },

    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.pkgconf,
      drvs.libxslt,
      drvs.libxml2,
      drvs.meson,
      drvs.pythonFull,
      drvs.samurai,
    ],
  }
}
& {

  lib,
  drvs,

  docbookFIle | lib.Package = {
    singleSource = {
      uri = "http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl",
      sha256sum = "06cfa9a2549c408abb6c0f699cba5e94e81e5235f934a68f03d43f88263cb19f"
    },
    installPhase = [
      "install -d -m0755 ${DEST}/usr/share/docbook-file",
      "install -m0755 /tmp/workdir/packed/docbook.xsl ${DEST}/usr/share/docbook-file",
    ]
  }
}
