{
  lib,
  drvs,
  gtk4 | lib.MesonPackage = {
    singleSource = {
      # uri = "https://download.gnome.org/sources/gtk/4.18/gtk-4.18.6.tar.xz",
      # sha256sum = "e1817c650ddc3261f9a8345b3b22a26a5d80af154630dedc03cc7becefffd0fa",

      # uri = "https://download.gnome.org/sources/gtk/4.21/gtk-4.21.1.tar.xz",
      # sha256sum = "a6a899276ccbb97ff257731d93474de689e9a4f62a63071b5bff4feeae8b895c",
      # uri = "https://download.gnome.org/sources/gtk/4.19/gtk-4.19.4.tar.xz",
      # sha256sum = "9397f0f5135808a52052082318531c5e90a9b5377a280c2d4c439c1328f93070",

      # uri = "https://download.gnome.org/sources/gtk/4.19/gtk-4.19.1.tar.xz",
      # sha256sum = "7e793899bc2a47fdf52b149b9262f5398a2dd1252cfe58536e3dbfb78848d4eb",

      uri = "https://download.gnome.org/sources/gtk/4.22/gtk-4.22.0.tar.xz",
      sha256sum = "ed3932469d3d891df53451f2cd28380af7673f736aa443bb3dda7adb40994f1e",
    },
    llvmProvider = drvs.llvmFull,

    biDrvs =
      [
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
        drvs.glibDynamic,
        drvs.muslShared,
        drvs.hwdata,
        options.gobjectProvider,
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
        drvs.libtiff,
        drvs.graphene,
        drvs.harfbuzzFull,
        drvs.libxml2,
        drvs.sharedMimeInfo,
      ]
      @ (
        if options.introspection then
          [
            drvs.pythonSetuptools,
            drvs.glibGobject & { priority = -1 },
            drvs.gdkPixbufIntrospection & { priority = -1 },
          ]
        else
          []
      ),

    options = {
      introspection | default = false,
      gobjectProvider | default = if introspection then drvs.gobjectDynamicCairo else drvs.gobjectDynamic,
    },

    extraMesonArgs = [
      "-Dwayland-backend=true",
      "-Dx11-backend=false",
      "-Dmedia-gstreamer=disabled",
      "-Dvulkan=disabled",
      "-Df16c=disabled",
      "-Dintrospection=%{ if options.introspection then "enabled" else  "disabled" }",
      "-Dbuild-demos=false",
      "-Dbuild-testsuite=false",
      "-Dbuild-examples=false",
      "-Dbuild-tests=false",

      # "-Dgtk_doc=false",
    ],
    preConfigurePhase = [
      "sed -i 's@shared_library@library@g' ${SRC}/gtk/meson.build"
    ]
  },
  gtk4Introspection =
    gtk4
    & {
      options.introspection = true,
      pythonProvider = drvs.pythonDynamic,
    }
}
