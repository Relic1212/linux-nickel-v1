{
  lib,
  drvs,
  hyprlandPlugins | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/hyprwm/hyprland-plugins/archive/refs/tags/v0.52.0.tar.gz",
      sha256sum = "5101bf5b4fa5048f186e613c1e11c309fa3f8c14d68cf94c01a08a7745746c97"
    },

    options = {
      glx = false,
      plugins = [
        "borders-plus-plus",
        # "csgo-vulkan-fix",
        "hyprbars",
        "hyprexpo",
        "hyprfocus",
        "hyprscrolling",
        # "hyprtrails",
        # "hyprwinwrap",
        "xtra-dispatchers",
      ]
    },

    preConfigurePhase =
      [
        #   m%"
        #   echo "
        #   project('hyprland-plugins', 'cpp',
        #   version: '0.1',
        #   default_options: ['buildtype=release'],
        #   )
        #   subdir('hyprexpo')
        #   " > ${SRC}/meson.build
        #   "%,
        "for f in $(find ${SRC} -name meson.build); do sed -i 's@shared_module@library@g' ${f};done",
      ]
      @ (
        std.array.map
          (fun s => "sed -i 's|#define private public||g' ${SRC}/%{s}"
          )
          [
            "xtra-dispatchers/main.cpp",
            "hyprwinwrap/main.cpp",
            "hyprfocus/main.cpp",
            "hyprexpo/overview.cpp",
            "hyprscrolling/main.cpp",
            "hyprbars/barDeco.hpp",
          ]
      )
      @ [
        # "export SRC=\"/tmp/workdir/src/hyprexpo\"",
      ],
    mesonArgs,
    configurePhase =
      std.array.flatten (
        std.array.map
          (fun p =>
            [
              "mkdir ${BUILDDIR}/%{p}",
              "(cd ${SRC}/%{p} && meson setup %{std.string.join lib.constants.buildFlagSep mesonArgs} ../../build/%{p})"
            ]
          )
          options.plugins
      ),

    buildPhase =
      std.array.flatten (
        std.array.map
          (fun p =>
            [
              "(cd ${SRC}/%{p} && meson compile -C ../../build/%{p})"
            ]
          )
          options.plugins
      ),

    installPhase =
      std.array.flatten (
        std.array.map
          (fun p =>
            [
              "(cd %{p} && meson install --destdir ${DEST})"
            ]
          )
          options.plugins
      ),
    llvmProvider = drvs.llvmFull,

    biDrvs =
      [
        drvs.expat,
        drvs.jsonC,
        drvs.pcre2,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.libelf,
        drvs.libpciaccess,
        drvs.libdrm,
        drvs.libxkbcommon,
        drvs.pixman,
        drvs.eudev,
        drvs.seatd,
        drvs.libdisplayinfo,
        drvs.libinput,
        drvs.libffi,
        drvs.libevdev,
        drvs.mtdev,
        drvs.pango,
        drvs.cairo,
        drvs.libpng,
        drvs.freetype,
        drvs.fontconfig,
        drvs.zlibNg,
        drvs.harfbuzz,
        drvs.glib,
        drvs.hwdata,
        drvs.linuxHeaders,
        drvs.hyprwaylandScanner,
        drvs.hyprUtils,
        drvs.hyprlang,
        drvs.hyprcursor,
        #  drvs.cmake,
        drvs.tomlplusplus,
        drvs.utilLinux,
        ###############################################################
        drvs.hyprlandProtocols,
        drvs.udis86,
        drvs.hyprgraphics,
        drvs.re2,
        drvs.abseilCpp,
        ###############################################################
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
        ###################################################
        drvs.git,
        drvs.libzip,
        drvs.spirvTools,
        drvs.glaze,
        drvs.cmake,
        drvs.fribidi,
      ]
      @ (
        if options.glx then
          [
            drvs.aquamarineGlx,
            drvs.mesaGlx,
            drvs.hyprlandX11,
          ]
        else
          [
            drvs.aquamarine,
            drvs.mesa2,
            drvs.hyprland,
          ]
      ),
  }
}
