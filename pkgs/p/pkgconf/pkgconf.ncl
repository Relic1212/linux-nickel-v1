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
& {
  lib,
  drvs,
  pkgconf251 =
    let _p | lib.MesonPackage = {
      singleSource = {
        uri = "https://github.com/pkgconf/pkgconf/archive/refs/tags/pkgconf-2.5.1.tar.gz",
        sha256sum = "79721badcad1987dead9c3609eb4877ab9b58821c06bdacb824f2c8897c11f2a"
      },
      postInstallPhase = [
        "cd ${DEST}/usr/bin",
        "ln -s pkgconf pkg-config",
      ]
    }
    in
    _p
    & {
      baseBuildinputPackages = std.array.filter (fun p => p.name != "pkgconf") _p.baseBuildinputPackages
    }
}
