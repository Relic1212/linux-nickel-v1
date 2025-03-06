{
  lib,
  drvs,
  gtk4 | lib.MesonPackage = {
    singleSource = {
      # uri = "https://gitlab.gnome.org/GNOME/gtk/-/archive/3.24.43/gtk-3.24.43.tar.gz",
      # sha256sum = "ab197f76719fc875067671247533f8e5bd2bc090568ec17317de410d06397b7f"

      uri = "https://download.gnome.org/sources/gtk/4.16/gtk-4.16.12.tar.xz",
      sha256sum = "ef31bdbd6f082c4401634a20c850b0050c9bf252ef1e079764ee95a2a0c4c95a",
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
      drvs.libtiff,
      drvs.graphene,
      drvs.harfbuzzFull,
    ],

    extraMesonArgs = [
      "-Dwayland-backend=true",
      "-Dx11-backend=false",
      "-Dmedia-gstreamer=disabled",
      "-Dvulkan=disabled",
      "-Df16c=disabled",
      "-Dintrospection=disabled",
      "-Dbuild-demos=false",
      "-Dbuild-testsuite=false",
      "-Dbuild-examples=false",
      "-Dbuild-tests=false",

      # "-Dgtk_doc=false",
    ],
    preConfigurePhase = [
      "sed -i 's@shared_library@library@g' ${SRC}/gtk/meson.build"
    ]
  }
}
