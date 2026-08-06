{
  lib,
  drvs,
  xfce4Terminal | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/xfce-mirror/xfce4-terminal/archive/refs/tags/xfce4-terminal-1.2.0.tar.gz",
      sha256sum = "33eba852002db39aebcaabb9af790bf4d49dfb92785b641048ac9460f5560985",
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++",
      ],
    },
    extraMesonArgs = [
      "-Ddoc=false",
    ],
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.libxslt,
      drvs.gettext,
    ],
    pDrvs = [
      # drvs.mesa2,
      drvs.gtkLayerShell,
      drvs.vte,
      drvs.libxfce4ui,
      drvs.libxfce4util,
      drvs.xconf,
    ],
  }
}
