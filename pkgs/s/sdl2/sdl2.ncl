{
  lib,
  drvs,
  sdl2 | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/libsdl-org/SDL/archive/refs/tags/release-2.32.10.tar.gz",
      sha256sum = "03f9d7c191a837525c9cda6406af2f2e48be02b5e7eb03d949cc9f1e9ca41c8b"
    },

    cmakeExtraArgsRecord = {
      "-DSDL_X11" = false,
      "-DSDL_DEPS_SHARED" = false,
      "-DSDL_VULKAN" = false,
      "-DSDL_RPATH" = false,
    },

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.expat,
      drvs.jsonC,
      drvs.pcre2,
      drvs.mesa2,
      drvs.spirvTools,
      drvs.wayland,
      #drvs.waylandProtocols_1_41,
      drvs.waylandProtocols,
      drvs.libelf,
      drvs.libpciaccess,
      drvs.libdrm,
      drvs.libxkbcommon,
      drvs.pixman,
      drvs.eudev,
      # drvs.libudevZero,
      drvs.libdisplayinfo,
      drvs.libinput,
      drvs.libffi,
      drvs.libevdev,
      drvs.mtdev,
      drvs.pango,
      drvs.fribidi,
      drvs.cairo,
      drvs.libpng,
      drvs.freetype,
      drvs.fontconfig,
      drvs.zlibNg,
      drvs.harfbuzz,
      drvs.glib,
      drvs.hwdata,
      drvs.linuxHeaders,

      # For optional features
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
      # drvs.basu,
      drvs.lcms,
      drvs.scdoc,
    ],
    propagatedBuildInputs = [
      drvs.seatd,
    ]
  }
}
