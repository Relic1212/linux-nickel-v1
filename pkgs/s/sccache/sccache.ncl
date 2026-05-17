{
  lib,
  drvs,
  sccache | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/mozilla/sccache/archive/refs/tags/v0.15.0.tar.gz",
      sha256sum = "6e69b88f2f88982dc6389f68a6624b35502b5a2760a6a8a07bdb10a250ed98df"
    },
    enableSccache = false,
    crates = lib.functions.filterCrates (import "sccache-crates.json"),
    biDrvs = [
      drvs.openssl,
    ]
  }
}
