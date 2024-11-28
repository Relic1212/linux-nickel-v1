{
  lib,
  drvs,
  glibmm | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://download.gnome.org/sources/glibmm/2.66/glibmm-2.66.7.tar.xz",
        sha256sum = "fe02c1e5f5825940d82b56b6ec31a12c06c05c1583cfe62f934d0763e1e542b3"
      },
      biDrvs = [
        drvs.pcre2,
        drvs.libffi,
        drvs.zlibNg,
        drvs.glib,
        drvs."libsigc++2",
      ]
    }
}
