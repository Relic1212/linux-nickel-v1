{
  lib,
  drvs,
  cbindgen | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/mozilla/cbindgen/archive/refs/tags/0.29.4.tar.gz",
      sha256sum = "9b5757e915cf8be523d3aca282b9b5651bafa112e14bf1ba488562ba282807d6",
    },
    crates = lib.functions.filterCrates (import "cbindgen-crates.json"),
  }
}
