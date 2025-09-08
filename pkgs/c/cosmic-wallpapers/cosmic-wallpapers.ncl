{
  lib,
  drvs,
  cosmicWallpapers | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/pop-os/cosmic-wallpapers/archive/refs/tags/epoch-1.0.0-alpha.7.tar.gz",
      sha256sum = "66146d0aad154f67d011f8a3b5ed756027ba552974c7a3e63becd76a345d713a"
    },
    extraMakeArgs = [
      "prefix=/usr"
    ],
    extraMakeInstallArgs = extraMakeArgs @ ["PREFIX=/usr"]
  }
}
