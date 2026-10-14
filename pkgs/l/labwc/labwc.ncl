{
  lib,
  drvs,
  labwc | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/labwc/labwc/archive/refs/tags/0.20.2.tar.gz",
      sha256sum = "fae023b6fe022f7057556707a17cdb2d98e0138c5dffaedaa1dade975699f9e8",
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

      # # For optional features
      # drvs.gdkPixbufFull,
      # drvs.libjpegTurbo,
      # # drvs.basu,
      # drvs.lcms,
      drvs.scdoc,
      # drvs.wlroots19,
      # drvs.libxml2,
      # drvs.libsfdo,
    ],
    pDrvs = [
      drvs.wlroots20,
      drvs.libxml2,
      # drvs.glib,
      # drvs.cairo,
      drvs.pango,
      drvs.libsfdo,
    ]
  }
}
