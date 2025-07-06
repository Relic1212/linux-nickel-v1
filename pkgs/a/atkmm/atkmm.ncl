{
  lib,
  pcre2,
  libffi,
  zlibNg,
  glib,
  libsigcpp2,
  glibmm,
  libxml2,
  dbus,
  atSpi2Core,

  atkmm | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/atkmm/2.28/atkmm-2.28.4.tar.xz",
      sha256sum = "0a142a8128f83c001efb8014ee463e9a766054ef84686af953135e04d28fdab3"
    },
    biDrvs =
      lib.biMap [
        pcre2,
        libffi,
        zlibNg,
        glib,
        libsigcpp2,
        glibmm,
        libxml2,
        dbus,
        atSpi2Core,
      ]
  }
}
