{
  lib,
  drvs,
  gdkPixbuf | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://gitlab.gnome.org/GNOME/gdk-pixbuf/-/archive/2.42.12/gdk-pixbuf-2.42.12.tar.gz",
        sha256sum = "d41966831b3d291fcdfe31f683bea4b3f03241d591ddbe550b5db873af3da364",
      },
      biDrvs = [
        drvs.glib,
        drvs.pcre2,
        drvs.libffi,
        drvs.zlibNg
      ],
      extraMesonArgs = [
        "-Dgio_sniffing=false",
        "-Dinstalled_tests=false",
        "-Dtests=false",
        "-Dman=false",
        "-Dintrospection=disabled",
        "-Dgtk_doc=false",
        "-Dbuiltin_loaders=png,jpeg,gif",
        "-Djpeg=disabled",
        "-Dpng=disabled",
      ]
    }
}
