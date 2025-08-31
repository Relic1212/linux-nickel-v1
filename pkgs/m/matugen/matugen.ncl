{
  lib,
  drvs,
  matugen | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/InioX/matugen/archive/refs/tags/v2.4.1.tar.gz",
      sha256sum = "6655bd898c30730cfc9d0e6e6689021afbcb6a24de9df3ac6344c72833b6d9fa"
    },
    crates = lib.functions.filterCrates (import "matugen-crates.json"),
  }
}
