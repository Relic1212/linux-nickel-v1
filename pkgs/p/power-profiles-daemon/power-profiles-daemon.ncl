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
  upower,

  powerProfilesDaemon | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/upower/power-profiles-daemon/-/archive/0.23/power-profiles-daemon-0.23.tar.gz",
      sha256sum = "ccf6e00093dc5300be48d66d439540bb6239460b602bbd85001c937860de2e5f"
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
        upower,
      ],
    extraMesonArgs = [
      "-Dsystemdsystemunitdir=no",
    ]
  }
}
