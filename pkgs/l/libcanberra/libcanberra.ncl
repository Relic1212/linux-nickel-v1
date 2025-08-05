{
  lib,
  drvs,
  libcanberra | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz",
      sha256sum = "c2b671e67e0c288a69fc33dc1b6f1b534d07882c2aceed37004bf48c601afa72"
    },
    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.vala,
      drvs.libtool,
      drvs.gettext,
      drvs.pkgconf,
      drvs.libogg,
      drvs.libvorbis,
    ],
  }
}