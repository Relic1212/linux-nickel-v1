{
  lib,
  drvs,
  vala | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://download.gnome.org/sources/vala/0.56/vala-0.56.17.tar.xz"
      },
      biDrvs = [
        drvs.glib,
      ]
    }
}
