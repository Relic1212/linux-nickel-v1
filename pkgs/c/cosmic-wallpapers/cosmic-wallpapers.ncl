{
  lib,
  drvs,
  _cosmicSrcs,
  cosmicWallpapers | lib.MakePackage = {
    singleSource = _cosmicSrcs."cosmic-wallpapers",

    extraMakeArgs = [
      "prefix=/usr"
    ],
    extraMakeInstallArgs = extraMakeArgs @ ["PREFIX=/usr"]
  }
}
