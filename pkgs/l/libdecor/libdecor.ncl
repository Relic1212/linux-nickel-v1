{
  lib,
  drvs,
  libdecor | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/libdecor/libdecor/-/releases/0.2.3/downloads/libdecor-0.2.3.tar.xz",
      sha256sum = "66ab953da968eb2c24c27a8641fdb00d3a6e64c3cf8780c67c14e3202698b39c"
    },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++"
      ],
    },

    options = {
      glx | default = true,
    },

    extraMesonArgs = [
      "-Dgtk=enabled",
      "-Ddbus=enabled",
      "-Ddemo=false",
    ],
    preConfigurePhase = [
      # m%"sed -i "s@subdir('plugins')@@g" ${SRC}/src/meson.build"%,
      m%"sed -i "s@shared_library@library@g" ${SRC}/src/meson.build"%,
      m%"sed -i "s@shared_module@library@g" ${SRC}/src/plugins/gtk/meson.build"%,
      m%"sed -i "s@shared_module@library@g" ${SRC}/src/plugins/dummy/meson.build"%,
      m%"sed -i "s@shared_module@library@g" ${SRC}/src/plugins/cairo/meson.build"%,
    ],

    biDrvs =
      [
        drvs.libelf,
        drvs.libdrm,
        drvs.zlibNg,
        drvs.pythonMako,
        drvs.pythonPackaging,
        drvs.pythonMarkupsafe,
        drvs.libpciaccess,
        drvs.libffi,
        drvs.bison,
        drvs.flex,
        drvs.linuxHeaders,
        drvs.m4,
        drvs.git,
        drvs.pyyaml,
        drvs.llvmFull,
        drvs.llvmConfigStatic,
        drvs.spirvTools,
        drvs.spirvLlvmTranslator,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.dbus,
        drvs.pixman,
        drvs.freetype,
        drvs.fontconfig,
        drvs.libpng,
        drvs.expat,
        drvs.cairo,
        drvs.glib,
        drvs.pcre2,
        drvs.harfbuzz,
        drvs.pango,
        drvs.gperf,
        drvs.libxkbcommon,
        drvs.ncurses,
        drvs.glibDynamic,
        # drvs.muslShared,
        drvs.hwdata,
        drvs.gobjectDynamic,
        drvs.cairoGobject,
        drvs.fribidi,
        drvs.gdkPixbufFull,
        drvs.libjpegTurbo,
        drvs.libepoxy,
        drvs.atSpi2Core,
        drvs.gtk3,
      ]
      @ (
        if options.glx then
          [
            drvs.mesaGlx,
            drvs.libxcursor,
            drvs.xorgMacros,
            drvs.xorgproto,
            drvs.xtrans,
            drvs.libxcb,
            drvs.xcbProto,
            drvs.libxau,
            drvs.libx11,
            drvs.libxrender,
            drvs.libxfixes,
            drvs.xcbRenderutil,
            drvs.libxfont2,
            drvs.libfontenc,
            drvs.libxcvt,
            drvs.libxshmfence,
            drvs.xwayland,
            drvs.libxkbfile,
            drvs.openssl,
            drvs.xcbUtilWm,
            drvs.xcbUtilErrors,
            drvs.libxext,
            drvs.libxf86vm,
            drvs.libxrandr,
          ]
        else
          [
            drvs.mesa2,
          ]
      ),
  }
}
