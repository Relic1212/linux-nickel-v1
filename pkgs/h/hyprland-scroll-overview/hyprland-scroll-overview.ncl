{
  lib,
  drvs,
  hyprlandScrollOverview | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/yayuuu/hyprland-scroll-overview/archive/ef2ca3ff4c660e1231868b439e1feeb89d68c4a1.tar.gz",
      sha256sum = "7587a0d1b84d6c21ebee7f0cdfcf46962a61a7507f51b77b1e287df9f60fb174",
    },
    eofPatches = [
      {
        patch = import "fix.patch" as 'Text
      },
    ],
    buildEnv = {
      EXTRA_CXXFLAGS = ["-Wno-c++11-narrowing", ]
    },
    options = {
      glx = false,
    },

    llvmProvider = drvs.llvmFull,

    biDrvs =
      [
        drvs.glslang,
        drvs.lua,
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
        drvs.hyprutils,
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
        # drvs.cmake,
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
