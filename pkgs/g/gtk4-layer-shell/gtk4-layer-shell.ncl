{
  lib,
  drvs,
  gtk4LayerShell | lib.MesonPackage = {
    singleSource = {
      #uri = "https://github.com/wmww/gtk4-layer-shell/archive/refs/tags/v1.1.0.tar.gz",
      #sha256sum = "98284281260a5eef5b4f63a55f16c4bf6a788a1020a6db037ecb0f71fa336988",

      # uri = "https://github.com/wmww/gtk4-layer-shell/archive/refs/tags/v1.0.4.tar.gz",
      # sha256sum = "7fe327dc3740e4b6f5edfd855e23f84b1ac1ec6854b731047b95df7feb46498b",

      uri = "https://github.com/wmww/gtk4-layer-shell/archive/refs/tags/v1.2.0.tar.gz",
      sha256sum = "4e04711fec80afbcd0a1e6e39c07ae263d2c3400181791b7826f3e5317b33567",
    },
    patches = [
      {
        sha256sum = "9953f2bd6a4ff5043fb5a10953bc2cfce60adb2e02f7a361b4a24603bc66fe87",
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
