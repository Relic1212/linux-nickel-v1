{
  lib,
  drvs,
  lxqtWaylandSession | lib.LxqtPackage = {
    singleSource = {
      uri = "https://github.com/lxqt/lxqt-wayland-session/archive/refs/tags/0.3.1.tar.gz",
      sha256sum = "9f83c8e99010824995fed8b87efb9c126d6bab1ae4023cb7c513611b8802ebb1",
    },
    biDrvs = [
      drvs.liblxqt,
      drvs.lxqtBuildTools,
      drvs.qtxdgTools,
      drvs.libqtxdg,
      drvs.kwindowsystem,
      drvs.xdgUserDirs,
      drvs.perl,
    ]
  }
}
