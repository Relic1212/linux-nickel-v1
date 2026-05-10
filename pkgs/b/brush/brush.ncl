{
  lib,
  drvs,
  brush | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/reubeno/brush/archive/refs/tags/brush-shell-v0.4.0.tar.gz",
      sha256sum = "0cce607454972c18bc4a30d2f44a2c91fccf02c458475fda7720370a3dc8a4f0",
    },
    crates = lib.functions.filterCrates (import "brush-crates.json"),
  }
}
