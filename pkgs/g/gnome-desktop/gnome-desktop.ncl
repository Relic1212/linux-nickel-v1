{
    lib,
    drvs,
    gnomeDesktop | lib.MesonPackage = {
        singleSource = {
            uri = "https://download.gnome.org/sources//gnome-desktop/44/gnome-desktop-44.1.tar.xz",
            sha256sum = "ae7ca55dc9e08914999741523a17d29ce223915626bd2462a120bf96f47a79ab"
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

        drvs.eudev,

          drvs.kmod,
          drvs.xz,
          drvs.openssl,
          drvs.zstd,
          drvs.utilLinux,

          drvs.gsettingsDesktopSchemas,
                    drvs.xkeyboardConfig,
                    drvs.isoCodes,
                    drvs.libseccomp,

      ],
      extraMesonArgs = [
        "-Dbuild_gtk4=false",
        "-Ddesktop_docs=false",
        "-Ddebug_tools=false",
        "-Dintrospection=false",

      ]
    }
}

&
{
    lib,
    drvs,
    gsettingsDesktopSchemas | lib.MesonPackage = {
        singleSource = {
            uri = "https://download.gnome.org/sources/gsettings-desktop-schemas/47/gsettings-desktop-schemas-47.1.tar.xz",
            sha256sum = "a60204d9c9c0a1b264d6d0d134a38340ba5fc6076a34b84da945d8bfcc7a2815"
        },
        biDrvs = [
            drvs.glib,
                drvs.pcre2,
        drvs.libffi,
        drvs.zlibNg,
        ],
        extraMesonArgs=[
            "-Dintrospection=false"
        ]
    }
}

& {

    lib,
    drvs,
    isoCodes | lib.AutotoolsPackage = {
        singleSource = {
            uri = "https://salsa.debian.org/iso-codes-team/iso-codes/-/archive/v4.17.0/iso-codes-v4.17.0.tar.gz",
            sha256sum = "dd5ca13db77ec6dd1cc25f5c0184290a870ec1fed245d8e39a04ff34f59076c3"
        },
        biDrvs = [
            drvs.pythonFull,
            drvs.libtool,
            drvs.gettext,
        ]
    }
}