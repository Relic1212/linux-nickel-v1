{
  lib,
  drvs,
  hyprlandPlugins | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/hyprwm/hyprland-plugins/archive/refs/tags/v0.50.0.tar.gz",
      sha256sum = "47286d36385bddc2bbc0190bc0b85955bdd5ddc2eb6c548e90a8f07aada08494"
    },

    preConfigurePhase = [
      #   m%"
      #   echo "
      #   project('hyprland-plugins', 'cpp',
      #   version: '0.1',
      #   default_options: ['buildtype=release'],
      #   )
      #   subdir('hyprexpo')
      #   " > ${SRC}/meson.build
      #   "%,
      "export SRC=\"/tmp/workdir/src/hyprexpo\"",
      "sed -i 's@shared_module@library@g' ${SRC}/meson.build",
    ],
    options = {
      glx = false,
    },
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
