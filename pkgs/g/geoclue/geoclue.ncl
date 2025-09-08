{
  lib,
  drvs,
  geoclue | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/geoclue/geoclue/-/archive/2.8.0/geoclue-2.8.0.tar.bz2",
      sha256sum = "c07aeb35cccf959ec1dc2e8f9a71a9d8bdd643879ef0a8d37926499541da1685"
    },

    extraMesonArgs = [
      "-Dintrospection=false",
      "-Dvapi=false",
      "-Dgtk-doc=false",
      "-D3g-source=false",
      "-Dcdma-source=false",
      "-Dmodem-gps-source=false",
      "-Dwifi-source=true",
      "-Dip-source=true",
      "-Dnmea-source=false",
      "-Dcompass=false",
      "-Ddemo-agent=false",
    ],

    biDrvs = [
      drvs.glib,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.jsonGlib,
      drvs.libpsl,
      drvs.libxml2,
      drvs.sqlite,
      drvs.libsoup3,
      drvs.nghttp2,
      drvs.gettext,
    ]
  }
}
