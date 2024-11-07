{
  lib,
  drvs,
  flatpak | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://github.com/flatpak/flatpak/archive/refs/heads/main.zip",

        sha256sum = "efa3b11337588af274ed6d22b9b0c681e857782f1c7bc6d4e1ef0e6a9bd54aff",
      },
      biDrvs = [
        drvs.glib,
        drvs.curl,
        drvs.pcre2,
        drvs.libffi,
        drvs.zlibNg,
        drvs.bison,
        drvs.libcap,
        drvs.libarchive,
        drvs.openssl,
        drvs.libpsl,
        drvs.libxml2,
        drvs.fuse,
        drvs.ostree,
        drvs.jsonGlib,
        drvs.libyaml,
        drvs.appstream,
        drvs.libxmlb,
      ],
      extraMesonArgs = [
        "-Dseccomp=disabled",
        "-Dsystem_helper=disabled",
        "-Dtests=false",
        "-Dxauth=disabled",
      ],
    }
}
