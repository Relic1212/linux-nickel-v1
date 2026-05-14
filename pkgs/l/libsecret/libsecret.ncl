{
  lib,
  drvs,

  libsecret | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/libsecret/0.21/libsecret-0.21.7.tar.xz",
      sha256sum = "6b452e4750590a2b5617adc40026f28d2f4903de15f1250e1d1c40bfd68ed55e"
    },
    extraMesonArgs = [
      "-Dvapi=false",
      "-Dgtk_doc=false",
      "-Dintrospection=false",
    ],

    preConfigurePhase = [
      m%"sed -i "s@subdir('docs')@@g" ${SRC}/meson.build"%,
    ],
    biDrvs = [
      # drvs.libxslt,
    ],
    pDrvs = [
      drvs.gpgme,
      drvs.libgcrypt,
      drvs.openssl,
      drvs.glib,
      drvs.linuxHeaders,
    ]
  }
}
