{
  lib,
  drvs,
  lxqtMenuData | lib.LxqtPackage = {
    singleSource = {
      uri = "https://github.com/lxqt/lxqt-menu-data/archive/refs/tags/2.3.0.tar.gz",
      sha256sum = "397f810674e3d55fe46312272289820518d4dbe1b3e475e1e1196b4f1a332f7e",
    },

    biDrvs = [
      drvs.acl,
      drvs.attr,
      drvs.duktape,
      drvs.elogindWithPolkit,
      drvs.kwindowsystem,
      drvs.libcap,
      drvs.libpamFinalUdev,
      drvs.libqtxdg,
      drvs.libx11,
      drvs.libxau,
      drvs.libxcb,
      drvs.libxext,
      drvs.libxfixes,
      drvs.libxrender,
      drvs.libxss,
      drvs.lxqtBuildTools,
      drvs.plasmaWaylandProtocols,
      drvs.polkit,
      drvs.polkitQt6,
      drvs.xcbProto,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.liblxqt,
      drvs.perl,
    ],
  }
}
