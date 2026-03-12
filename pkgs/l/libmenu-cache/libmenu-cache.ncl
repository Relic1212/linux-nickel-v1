{
  lib,
  drvs,
  libmenuCache | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/lxde/menu-cache/archive/refs/tags/1.1.1.tar.gz",
      sha256sum = "e8af90467df271c3c8700c840ca470ca2915699c6f213c502a87d74608748f08",
    },
    biDrvs = [
      drvs.gtkDoc,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.libfmExtra,
    ],
  }
}
