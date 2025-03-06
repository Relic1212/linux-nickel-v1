{
  lib,

  pkgconf | lib.AutotoolsPackage = {
    name = "pkgconf",
    singleSource = {
      uri = "https://distfiles.dereferenced.org/pkgconf/pkgconf-1.1.0.tar.xz",
      sha256sum = "5f1ef65d73a880fa5e7012102a17f7b32010e5e46139aed85851a541ba828a63",
    },
    postInstallPhase = [
      "cd ${DEST}/usr/bin",
      "ln -s pkgconf pkg-config",
    ]
  }
}
