{
  lib,
  drvs,
  gtk4LayerShell | lib.MesonPackage = {
    debug = true,
    singleSource = {

      uri = "https://github.com/wmww/gtk4-layer-shell/archive/refs/tags/v1.3.0.tar.gz",
      sha256sum = "1ebb01ab14e98afd1727f68f64981c37bd23305b1f131f5667c02b94cf593192",
    },
    # patches = [
    #   {
    #     sha256sum = "adecb4a1bca7411305d591ce9dcf24f6dc258b454d72efbfa9b29eab37f7f6a5",
    #     file = "gtk4-layer-shell.patch"
    #   }
    # ],

    extraMesonArgs = [
      "-Dintrospection=false",
      "-Dvapi=false",
      "-Dexamples=true",
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "/tmp/workdir/src/dlopen.o",
        "-lc++",
        "-lc",
        "$(pkg-config --libs --static wayland-client wayland-cursor gtk4 egl glesv2)",
      ]
    },

    preConfigurePhase = [
      "echo '%{import "../../g/gtk4-layer-shell/gtk4_layer_shell_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "echo '%{import "wayland_weak.c" as 'Text}' >> ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      m%"sed -i "s@'stolen-from-libwayland.c',@@g" ${SRC}/src/meson.build"%
      # "mv ${SRC}/src/stolen-from-libwayland.c ${SRC}/stolen",
      # "touch ${SRC}/src/stolen-from-libwayland.c",
    ],

    llvmProvider = drvs.llvmFull,
    pythonProvider = drvs.pythonDynamic,
    muslProvider = drvs.muslBothRenamedDl,

    neverInclude = [
      drvs.wayland,
      drvs.cairo,
      # drvs.glib,
      drvs.harfbuzz,
    ],
    pDrvs = [
      drvs.waylandGtk4LayerShell,
      drvs.gtk4,
    ]
  },
  gtk4LayerShellIntrospection | lib.MesonPackage = {
    singleSource = gtk4LayerShell.singleSource,
    buildEnv.PKG_CONFIG = null,

    buildEnv = {
      _isStatic = false,
      EXTRA_LDFLAGS = [
        "-Wl,--allow-multiple-definition",
      ],
    },

    extraMesonArgs = [
      "-Dintrospection=true",
      "-Dvapi=true",
      "-Dexamples=false",
    ],

    llvmProvider = drvs.llvmFull,
    pythonProvider = drvs.pythonDynamic,

    biDrvs | priority 1 = [
      drvs.muslShared,
      drvs.ldd,
      # drvs.pango, #??
      drvs.atSpi2Core,
      drvs.cairo,
      drvs.cairoGobject,
      drvs.expat,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.gdkPixbufIntrospection,
      #drvs.glibGobject & { priority = -1 },
      #drvs.glibDynamic,
      drvs.glibGobjectDynamic,
      drvs.gobjectDynamicCairo2,
      drvs.gperf,
      drvs.grapheneIntrospection,
      # drvs.gtk4,
      drvs.harfbuzzFull,
      drvs.harfbuzzGobjectDynamic & { priority = -1 },
      drvs.hwdata,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxy,
      drvs.libffi,
      drvs.libjpegTurbo,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libtiff,
      drvs.libxkbcommon,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.mesa2,
      # drvs.muslShared,
      drvs.ncurses,
      drvs.pangoGobject,
      drvs.pcre2,
      drvs.pixman,
      drvs.pythonSetuptools,
      drvs.readline,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.vala,
      drvs.waylandGtk4LayerShell,
      drvs.waylandProtocols,
      drvs.zlibNg,
      drvs.gtk4Introspection,
      # drvs.librsvg,
      drvs.libxml2,
      drvs.sharedMimeInfo,
    ]
  },

  wayland,
  waylandGtk4LayerShell =
    wayland
    & {

      patches = [
        { file = "wayland.patch", sha256sum = "1d20e0b26c948704aee46ad42d15bb11a34a6c6fee9af1932b9af9ba7012fec0" },
      ],
      extraMesonArgs | priority 1 =
        wayland.extraMesonArgs
        @ [
          "-Dtests=false",
        ],
    }
}
