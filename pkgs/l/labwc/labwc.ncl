{
  lib,
  drvs,
  labwc | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/labwc/labwc/archive/refs/tags/0.9.3.tar.gz",
      sha256sum = "38d273faa4e021b9f99e1bf1a5f4bf881cc6a592e00c7b3426b37c0a0b67d126",
    },

    buildEnv = {
      EXTRA_CPPFLAGS = [
        "-I/usr/include/libxml2"
      ],
      EXTRA_LDFLAGS = [
        "-lc++",
      ],
    },

    llvmProvider = drvs.llvmFull,
    # buildEnv._isMold = true,
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
      drvs.wlroots19,
      drvs.libxml2,
      drvs.libsfdo,
    ],
    propagatedBuildInputs = [
      drvs.seatd,
    ]
  }
}
