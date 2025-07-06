{
  lib,
  pcre2,
  libffi,
  zlibNg,
  glib,

  desktopFileUtils | lib.MesonPackage = {
    singleSource = {
      uri = "https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.28.tar.xz",
      sha256sum = "4401d4e231d842c2de8242395a74a395ca468cd96f5f610d822df33594898a70"
    },
    biDrvs =
      lib.biMap [
        pcre2,
        libffi,
        zlibNg,
        glib,
      ],
  }
}
