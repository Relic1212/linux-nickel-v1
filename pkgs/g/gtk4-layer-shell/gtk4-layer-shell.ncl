{
  lib,
  drvs,
  gtk4LayerShell | lib.MesonPackage = {
    debug = true,
    singleSource = {

      uri = "https://github.com/wmww/gtk4-layer-shell/archive/refs/tags/v1.3.0.tar.gz",
      sha256sum = "1ebb01ab14e98afd1727f68f64981c37bd23305b1f131f5667c02b94cf593192",
    },
    patches = [
      {
        sha256sum = "adecb4a1bca7411305d591ce9dcf24f6dc258b454d72efbfa9b29eab37f7f6a5",
        file = "gtk4-layer-shell.patch"
      }
    ],

    llvmProvider = drvs.llvmFull,
    pythonProvider = drvs.pythonDynamic,

    biDrvs = [
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman,
      drvs.waylandGtk4LayerShell,
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
    ],
    postInstallPhase =
      #   (let symbols = [
      #     "wl_proxy_destroy",
      #     "wl_proxy_add_dispatcher",
      #     "wl_proxy_marshal_array_constructor",
      #     "wl_proxy_marshal_array_flags",
      #     "wl_proxy_marshal_array_constructor_versioned",
      #     "wl_proxy_marshal_flags",
      #     "wl_proxy_marshal",
      #     "wl_proxy_marshal_constructor",
      #     "wl_proxy_marshal_constructor_versioned",
      #     "wl_proxy_marshal_array",
      #   ]
      #   in
      #   std.array.map (fun x => "objcopy -W " ++ x ++ " ${DEST}/usr/lib/libgtk4-layer-shell.a") symbols) @
      [
        "llvm-ar dv ${DEST}/usr/lib/libgtk4-layer-shell.a stolen-from-libwayland.c.o",
      ]
  },

  wayland,
  waylandGtk4LayerShell =
    wayland
    & {
      postInstallPhase | priority 1 =
        wayland.postInstallPhase
        @ (
          let symbols = [
            "wl_proxy_destroy",
            # "wl_proxy_add_dispatcher",
            # "wl_proxy_marshal_array_constructor",
            "wl_proxy_marshal_array_flags",
            # "wl_proxy_marshal_array_constructor_versioned",
            # "wl_proxy_marshal_flags",
            # "wl_proxy_marshal",
            # "wl_proxy_marshal_constructor",
            # "wl_proxy_marshal_constructor_versioned",
            # "wl_proxy_marshal_array",
          ]
          in
          std.array.map (fun x => "objcopy --redefine-sym %{x}=real_%{x} ${DEST}/usr/lib/libwayland-client.a") symbols
        )
    }
}
