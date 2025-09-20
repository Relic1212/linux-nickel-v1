{
  lib,
  drvs,
  xremap | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/xremap/xremap/archive/refs/tags/v0.10.18.tar.gz",
      sha256sum = "0979745a022fb1aea5c43dc4c12cefb548ccbf80d03d54c353d1d1ffecc5e101"
    },
    extraCargoFlags = [
      "--features niri"
    ],
    crates = lib.functions.filterCrates (import "xremap-crates.json"),
  }
}
