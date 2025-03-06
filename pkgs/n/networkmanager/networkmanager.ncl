{
  lib,
  drvs,
  networkmanager | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/archive/1.48.12/NetworkManager-1.48.12.tar.gz",
      sha256sum = "d041000b20e172fe4d93b7a12913422b58e8873fb9693c597938198313cc438c"
    },
    biDrvs = [
      drvs.iwd,
      drvs.dbus,
      drvs.perl,
      drvs.openssl,
      drvs.ncurses,
      drvs.readline,
      drvs.libxml2,
      drvs.libxslt,
      drvs.utilLinux,
      drvs.eudev,
      drvs.libndp,
      drvs.glib,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.openresolv,
      drvs.ppp,
      drvs.libpsl,
      drvs.curl,
      drvs.newt,
      drvs.slang,
      drvs.linuxHeaders,
    ],
    extraMesonArgs = [
      "-Dtests=no",
      "-Dsession_tracking=no",
      "-Dpolkit=false",
      "-Dintrospection=false",
      "-Dsystemd_journal=false",
      "-Dsystemdsystemunitdir=no",
      "-Dselinux=false",
      "-Dlibaudit=no",
      "-Dcrypto=null",
      "-Dmodem_manager=false",
      "-Dovs=false",
    ]
  }
}
