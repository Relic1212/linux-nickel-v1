{
  lib,
  drvs,
  niriTag | lib.CargoPackage = {
    singleSource = {
      uri = "https://git.atagen.co/atagen/niri-tag/archive/0.1.1.tar.gz",
      sha256sum = "a27a517c36c7f2132915bcdfea155ce7f03892ca4d60b86cb0b1e526aab9b477"
    },
    enableSccache = false,
    crates = lib.functions.filterCrates (import "niri-tag-crates.json")
  }
}
