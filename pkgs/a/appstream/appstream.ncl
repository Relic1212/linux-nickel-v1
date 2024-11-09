{
  lib,
  drvs,
  appstream | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://www.freedesktop.org/software/appstream/releases/AppStream-1.0.3.tar.xz",
        sha256sum = "5ab6f6cf644e7875a9508593962e56bb430f4e59ae0bf03be6be7029deb6baa4"
      },

      biDrvs = [
        drvs.glib,
        drvs.pcre2,
        drvs.libffi,
        drvs.zlibNg,
        drvs.curl,
        drvs.openssl,
        drvs.libpsl,
        drvs.libxml2,
        drvs.libyaml,
        drvs.libxmlb,
        drvs.gperf,
        drvs.gettext,
      ],

      extraMesonArgs = [
        "-Dstemming=false",
        "-Dsystemd=false",
        "-Dgir=false",
        "-Dsvg-support=false",
        "-Dzstd-support=false",
        "-Dapidocs=false",
        "-Dinstall-docs=false",
      ]
    }
}
