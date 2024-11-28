{
  lib,
  drvs,
  atkmm | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://download.gnome.org/sources/atkmm/2.28/atkmm-2.28.4.tar.xz",
        sha256sum = "0a142a8128f83c001efb8014ee463e9a766054ef84686af953135e04d28fdab3"
      },
      biDrvs = [
        drvs.pcre2,
        drvs.libffi,
        drvs.zlibNg,
        drvs.glib,
        drvs."libsigc++2",
        drvs.glibmm,
        drvs.libxml2,
        drvs.dbus,
        drvs.atSpi2Core,
      ]
    }
}
