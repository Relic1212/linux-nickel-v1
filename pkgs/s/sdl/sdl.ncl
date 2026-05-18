{
  lib,
  drvs,
  sdl | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/libsdl-org/SDL/archive/refs/tags/release-3.2.28.tar.gz",
      sha256sum = "5c908f07a93087037d3319bc5d820ba8df14ac98bdbdf24af9084ef460ce01b1"
    },

    cmakeExtraArgsRecord = {
      "-DSDL_X11" = false,
      "-DSDL_DEPS_SHARED" = false,
      "-DSDL_VULKAN" = false,
      "-DSDL_RPATH" = false,
    },

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      # drvs.expat,
      # drvs.jsonC,
      # drvs.pcre2,
      # drvs.mesa2,
      # drvs.spirvTools,
      # drvs.wayland,
      # #drvs.waylandProtocols_1_41,
      # drvs.waylandProtocols,
      # drvs.libelf,
      # drvs.libpciaccess,
      # drvs.libdrm,
      # drvs.pixman,
      # drvs.eudev,
      # # drvs.libudevZero,
      # drvs.libdisplayinfo,
      # drvs.libffi,
      # drvs.libevdev,
      # drvs.mtdev,
      # drvs.pango,
      # drvs.fribidi,
      # drvs.cairo,
      # drvs.libpng,
      # drvs.freetype,
      # drvs.fontconfig,
      # drvs.zlibNg,
      # drvs.harfbuzz,
      # drvs.glib,
      # drvs.hwdata,
      # drvs.linuxHeaders,

      # # For optional features
      # drvs.gdkPixbufFull,
      # drvs.libjpegTurbo,
      # # drvs.basu,
      # drvs.lcms,
      # drvs.scdoc,
    ],
    propagatedBuildInputs = [
      drvs.mesa2,
      drvs.gdkPixbufFull,
      drvs.alsaLibs,
      # drvs.eudev,
      drvs.dbus,
      drvs.libxkbcommon,
      drvs.libinput,
    ]
  }
}
