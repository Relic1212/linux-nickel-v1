{
  lib,
  drvs,
  gtk4LayerShell | lib.MesonPackage = {
    singleSource = {
      #uri = "https://github.com/wmww/gtk4-layer-shell/archive/refs/tags/v1.1.0.tar.gz",
      #sha256sum = "98284281260a5eef5b4f63a55f16c4bf6a788a1020a6db037ecb0f71fa336988",

      uri = "https://github.com/wmww/gtk4-layer-shell/archive/refs/tags/v1.0.4.tar.gz",
      sha256sum = "7fe327dc3740e4b6f5edfd855e23f84b1ac1ec6854b731047b95df7feb46498b",
    },
    patches = [
      #   {
      #   sha256sum = "d65454203199aebffce1543277e9823e2c96ac3e0fa854a938afce76104bf493",
      #   file = "dups.patch",
      # },
      # {
      #  file = "73.patch",
      #  sha256sum = "a5b33f14111b12bba1641e27ae77f2f9435cfb4aac820ebac54b9d260ec4020d",
      # }
    ],

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
    ],
    extraMesonArgs = [
      "-Dintrospection=false",
      "-Dvapi=false",
    ],
    postInstallPhase =
      let symbols = [
        "wl_proxy_destroy",
        "wl_proxy_add_dispatcher",
        "wl_proxy_marshal_array_constructor",
        "wl_proxy_marshal_array_flags",
        "wl_proxy_marshal_array_constructor_versioned",
        "wl_proxy_marshal_flags",
        "wl_proxy_marshal",
        "wl_proxy_marshal_constructor",
        "wl_proxy_marshal_constructor_versioned",
        "wl_proxy_marshal_array",
      ]
      in
      std.array.map (fun x => "objcopy -W " ++ x ++ " ${DEST}/usr/lib/libgtk4-layer-shell.a") symbols,
  }
}
