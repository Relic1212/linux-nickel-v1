{
  lib,
  pcre2,
  libffi,
  zlibNg,
  glib,
  libxslt,
  gudev,
  eudev,
  linuxHeaders,

  upower | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/upower/upower/-/archive/v1.90.6/upower-v1.90.6.tar.gz",
      sha256sum = "7e367c2619ca0f26d5bfc085b46bad9657b2774cc3eaffbf310b607df6e21377"
    },
    biDrvs =
      lib.biMap [
        pcre2,
        libffi,
        zlibNg,
        glib,
        libxslt,
        gudev,
        eudev,
        linuxHeaders,
      ],
    extraMesonArgs = [
      "-Dsystemdsystemunitdir=no",
      "-Dman=false",
      "-Dgtk-doc=false",
    ],
    preConfigurePhase = [
      m%"sed -i 's@shared_library@library@g' ${SRC}/libupower-glib/meson.build"%,
    ]
  }
}
& {
  lib,
  pcre2,
  libffi,
  zlibNg,
  glib,
  libxslt,
  eudev,

  gudev | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/libgudev/238/libgudev-238.tar.xz",
      sha256sum = "61266ab1afc9d73dbc60a8b2af73e99d2fdff47d99544d085760e4fa667b5dd1"
    },
    biDrvs =
      lib.biMap [
        pcre2,
        libffi,
        zlibNg,
        glib,
        libxslt,
        eudev,
      ],
  }
}
