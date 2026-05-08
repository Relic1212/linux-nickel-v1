{
  lib,
  drvs,
  snowball | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/snowballstem/snowball/archive/refs/tags/v3.0.1.tar.gz",
      sha256sum = "80ac10ce40dc4fcfbfed8d085c457b5613da0e86a73611a3d5527d044a142d60",
    },
    biDrvs = [
      drvs.perl,
    ],
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib",
      "install -dm0755 ${DEST}/usr/bin",
      "install -dm0755 ${DEST}/usr/include",
      "install -m0755 libstemmer.a ${DEST}/usr/lib",
      # https://gitlab.archlinux.org/archlinux/packaging/packages/snowball/-/blob/main/PKGBUILD?ref_type=heads
      "install -m0755 include/libstemmer.h ${DEST}/usr/include",
      "install -m0755 snowball ${DEST}/usr/bin",
      "install -m0755 stemwords ${DEST}/usr/bin",
    ]
  }
}
