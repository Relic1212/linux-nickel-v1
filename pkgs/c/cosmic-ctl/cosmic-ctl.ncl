{
  lib,
  drvs,
  _CargoFetcher,
  cosmicCtlSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = {
        uri = "https://github.com/cosmic-utils/cosmic-ctl/archive/refs/tags/v1.5.0.tar.gz",
        sha256sum = "6d0feb0179be9f96e32f2ba60e5c65905eee8b880f6c3254c6833fcb363111c8"
      },
      outputSha256sum = (import "src.sha256sum" as 'Text),
    },
  cosmicCtl | lib.CargoPackage = {
    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    preConfigurePhase = [],
    biDrvs = [
      drvs.cosmicCtlSources,
    ]
  }
}
