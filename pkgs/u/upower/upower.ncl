{
  lib,
  drvs,
  upower | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/upower/upower/-/archive/v1.90.10/upower-v1.90.10.tar.gz",
      sha256sum = "7fcd51bece2526dbee5170feb3ffd1adab5b0cd023575f1fd119d969b73f4b90"
    },
    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.libxslt,
      drvs.gudev,
      drvs.eudev,
      drvs.linuxHeaders,
      drvs.docbookXslNons,
      drvs.polkit,
      drvs.elogindWithPolkit,
      drvs.libcap,
      drvs.gettext,
    ],
    extraMesonArgs = [
      "-Dsystemdsystemunitdir=no",
      "-Dman=true",
      "-Dgtk-doc=false",
      "-Dpolkit=enabled",
    ],
    preConfigurePhase = [
      m%"sed -i 's@shared_library@library@g' ${SRC}/libupower-glib/meson.build"%,
      m%"sed -i "s@http://docbook.sourceforge.net/release/xsl/current@/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2@g" ${SRC}/doc/man/meson.build"%,
    ]
  }
}
& {
  lib,
  drvs,
  gudev | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/libgudev/238/libgudev-238.tar.xz",
      sha256sum = "61266ab1afc9d73dbc60a8b2af73e99d2fdff47d99544d085760e4fa667b5dd1"
    },
    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.libxslt,
      drvs.eudev,
    ],
  }
}
