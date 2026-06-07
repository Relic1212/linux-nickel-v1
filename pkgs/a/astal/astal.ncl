{
  lib,
  drvs,
  astalIo | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/Aylur/astal/archive/67ddc83e0bdbda6de7f6f15e4fbc5d6b9d2d1b18.tar.gz",
      sha256sum = "fe9ac3e126271de1d871ca0d5992be952835df2d89765181df1180e31cbf0391"
    },

    preConfigurePhase = [
      "export SRC=/tmp/workdir/src/lib/astal/io",
    ],
    # llvmProvider = drvs.llvmFull,
    pythonProvider = drvs.pythonDynamic,

    biDrvs = [
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman,
      # drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.expat,
      drvs.linuxHeaders,
      drvs.ncurses,
      drvs.readline,
      drvs.pcre2,
      # drvs.pango, #??
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.harfbuzzFull,
      drvs.glibGobject,
      drvs.muslShared,
      drvs.hwdata,
      drvs.gobjectDynamic,
      drvs.cairoGobject,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
      # drvs.libepoxy,
      drvs.atSpi2Core,
      # drvs.mesa2,
      # drvs.libelf,
      # drvs.libdrm,
      # drvs.libpciaccess,
      # drvs.llvmConfigStatic,
      # drvs.spirvTools,
      # drvs.spirvLlvmTranslator,
      # drvs.gtk4,
      drvs.valaDoc,
      drvs.pythonSetuptools,
      drvs.libtiff,
      drvs.graphene,
      # drvs.gtk4LayerShell,
      drvs.libadwaita,
    ],
  },
  astalGtk3 | lib.MesonPackage =
    astalGtk4
    & {
      preConfigurePhase | priority 1 = [
        "export SRC=/tmp/workdir/src/lib/astal/gtk3",
      ],

      biDrvs | priority 1 = [
        drvs.fontconfig,
        drvs.freetype,
        drvs.zlibNg,
        drvs.gperf,
        drvs.pixman,
        # drvs.wayland,
        drvs.waylandProtocols,
        drvs.libffi,
        drvs.libxkbcommon,
        drvs.expat,
        drvs.linuxHeaders,
        drvs.ncurses,
        drvs.readline,
        drvs.pcre2,
        # drvs.pango, #??
        drvs.pango,
        drvs.cairo,
        drvs.libpng,
        drvs.harfbuzzFull,
        drvs.glibGobject,
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
        drvs.valaDoc,
        drvs.pythonSetuptools,
        drvs.libtiff,
        drvs.graphene,
        drvs.gtkLayerShell,
        drvs.wayland,
        drvs.libadwaita,

        # drvs.cairoGobject,
        drvs.gdkPixbufIntrospectionDynamic & { priority = -1 },
        drvs.glibGobjectDynamic & { priority = -2 },
        # drvs.gobjectDynamic,
        drvs.gobjectDynamicCairo2 & { priority = -1 },
        drvs.grapheneIntrospection & { priority = -1 },
        drvs.gtk4IntrospectionDynamic & { priority = -1 },
        drvs.gtk4LayerShellIntrospection & { priority = -1 },
        drvs.harfbuzzGobjectDynamic & { priority = -1 },
        drvs.pangoGobject & { priority = -1 },
        drvs.pythonPygobject,
        drvs.libadwaitaIntrospection & { priority = -1 },
        drvs.astalIo,
      ],
    },
  astalGtk4 | lib.MesonPackage = {
    singleSource = astalIo.singleSource,

    buildEnv.EXTRA_LDFLAGS = [
      # "/tmp/workdir/src/dlopen.o",
    ],
    preConfigurePhase = [
      # lib.functions.writeFile "${SRC}/dlopen.c" (import "vala_dlopen.c" as 'Text),
      # "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      "export SRC=/tmp/workdir/src/lib/astal/gtk4",
    ],
    llvmProvider = drvs.llvmFull,
    pythonProvider = drvs.pythonDynamic,
    # muslProvider = drvs.muslBothRenamedDl,

    biDrvs = [
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman,
      # drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.expat,
      drvs.linuxHeaders,
      drvs.ncurses,
      drvs.readline,
      drvs.pcre2,
      # drvs.pango, #??
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.harfbuzzFull,
      drvs.glibGobject,
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
      drvs.valaDoc,
      drvs.pythonSetuptools,
      drvs.libtiff,
      drvs.graphene,
      drvs.gtk4LayerShell,
      drvs.waylandGtk4LayerShell,
      drvs.libadwaita,

      # drvs.cairoGobject,
      drvs.gdkPixbufIntrospectionDynamic & { priority = -1 },
      drvs.glibGobjectDynamic & { priority = -2 },
      # drvs.gobjectDynamic,
      drvs.gobjectDynamicCairo2 & { priority = -1 },
      drvs.grapheneIntrospection & { priority = -1 },
      drvs.gtk4IntrospectionDynamic & { priority = -1 },
      drvs.gtk4LayerShellIntrospection & { priority = -1 },
      drvs.harfbuzzGobjectDynamic & { priority = -1 },
      drvs.pangoGobject & { priority = -1 },
      drvs.pythonPygobject,
      drvs.libadwaitaIntrospection & { priority = -1 },
      drvs.astalIo,
    ],
  },

  astalApps | lib.MesonPackage =
    astalGtk4
    & {

      preConfigurePhase | priority 1 = [
        "export SRC=/tmp/workdir/src/lib/apps",
      ],
      biDrvs | priority 1 =
        astalGtk4.biDrvs
        @ [
          drvs.jsonGlib,
        ]
    },
  astalLib | lib.MesonPackage =
    let
      libs = [
        "apps",
        # "astal",
        "auth",
        "battery",
        "bluetooth",
        # "cava",
        # "gir.py",
        "greet",
        "hyprland",
        "mpris",
        # "network",
        "notifd",
        "powerprofiles",
        "quarrel",
        # "river",
        # "tray",
        "wayland-glib",
        "wireplumber",
        # "wl",
      ],
      args = {
        "auth" = ["-Dintrospection=false", "-Dvapi=false"],
        "wireplumber" = ["-Dintrospection=false", "-Dvapi=false"],
      }
    in
    (
      astalGtk4
      & {

        buildEnv.PKG_CONFIG = null,

        mesonArgs,

        preConfigurePhase | priority 1 = [],
        configurePhase =
          std.array.map
            (fun d =>
              "meson setup %{std.string.join lib.constants.buildFlagSep (mesonArgs @ (std.record.get_or d [] args)) } build-%{d} ${SRC}/lib/%{d}"
            )
            libs,

        buildPhase =
          std.array.map
            (fun d =>
              "meson compile -C build-%{d}"
            )
            libs,

        installPhase =
          std.array.map
            (fun d =>
              "meson install -C build-%{d} --destdir ${DEST}"
            )
            libs,
        biDrvs | priority 1 =
          astalGtk4.biDrvs
          @ [
            drvs.jsonGlib,
            # drvs.libpam,
            # drvs.networkmanager,
            # drvs.utilLinux,
            # drvs.eudev,
            # drvs.gnutls,
            # drvs.libtasn1,
            # drvs.nettleGmp,
          ],
        pDrvs = [
          drvs.pipewire,
        ],
        allowDubplicateBuldInputs = true,
      }
    )
}
& (import "ags.ncl")
