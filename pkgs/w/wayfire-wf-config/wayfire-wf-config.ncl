{
  lib,
  drvs,
  wayfireWfConfig | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/WayfireWM/wf-config/archive/add9ba7a47492d4f86482b0a308d9054a825637e.tar.gz",
      sha256sum = "e7ab33a3731bcb310277b317abad2581b7ac0a9d8ed880d815ccb1ddd94c917e"
    },

    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
    },

    biDrvs = [
      drvs.linuxHeaders,
    ],

    pDrvs = [
      drvs.glmWf,
      drvs.libevdev,
      drvs.libxml2,
    ],
  }
}
