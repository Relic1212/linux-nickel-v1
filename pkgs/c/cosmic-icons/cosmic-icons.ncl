{
  lib,
  drvs,
  _cosmicSrcs,

  cosmicIcons | lib.Package = {
    # singleSource = {
    #   uri = "https://github.com/pop-os/cosmic-icons/archive/refs/tags/epoch-1.0.0.tar.gz",
    #   sha256sum = "7336228a063795d59c8b5b90aa78527034f624446b556196ce2ff68d8018b3ae"
    # },
    singleSource = _cosmicSrcs."cosmic-icons",
    separateBuildDir = false,
    installPhase = [
      # see https://gitlab.archlinux.org/archlinux/packaging/packages/cosmic-icon-theme/-/blob/main/PKGBUILD?ref_type=heads
      "just rootdir=$DEST install"
    ],
    biDrvs = [
      drvs.just
    ]
  }
}
