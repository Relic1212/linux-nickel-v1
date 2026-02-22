{
  lib,
  drvs,
  lxqtThemes | lib.LxqtPackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/lxqt/lxqt-themes/archive/refs/tags/2.3.0.tar.gz",
      sha256sum = "e30dd9e21267c3b0b4e129933a5d2adf48539e4b7ab23a454c3f02ea37860950",
    },
    biDrvs = [
      drvs.lxqtBuildTools,
      drvs.perl,
      drvs.xdgUserDirs,
    ]
  }
}
