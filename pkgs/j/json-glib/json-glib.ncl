{
  lib,
  drvs,
  jsonGlib | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://gitlab.gnome.org/GNOME/json-glib/-/archive/1.10.0/json-glib-1.10.0.tar.gz",
        sha256sum = "447890f9de2a04c312871768208f6c8aeec4069392af7605bc77e61165dcb374",
      },
      biDrvs = [
        drvs.glib,
        drvs.pcre2,
        drvs.libffi,
        drvs.zlibNg
      ]
    }
}
