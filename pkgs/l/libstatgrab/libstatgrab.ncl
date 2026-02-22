{
  lib,
  drvs,
  libstatgrab | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/libstatgrab/libstatgrab/archive/refs/tags/LIBSTATGRAB_0_92_1.tar.gz",
      sha256sum = "fb75ba97e6e71f220baf015790e6deb21c77e29e4fbdb3f5de133d7f4564edc8",
    },
    extraConfigureFlags = [
      "--disable-man",
      "--disable-maintainer-mode",
    ],
    biDrvs = [
      drvs.linuxHeaders,
    ]
  }
}
