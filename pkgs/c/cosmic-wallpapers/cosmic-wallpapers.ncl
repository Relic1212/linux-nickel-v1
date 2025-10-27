{
  lib,
  drvs,
  _cosmicSrcSha256sums,
  cosmicWallpapers | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/pop-os/cosmic-wallpapers/archive/refs/tags/epoch-1.0.0-beta.3.tar.gz",
      sha256sum = _cosmicSrcSha256sums."%{uri}",
    },
    extraMakeArgs = [
      "prefix=/usr"
    ],
    extraMakeInstallArgs = extraMakeArgs @ ["PREFIX=/usr"]
  }
}
