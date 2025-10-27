{
  lib,
  drvs,
  sccache | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/mozilla/sccache/archive/refs/tags/v0.11.0.tar.gz",
      sha256sum = "eed7ba2b55f91511481df75e238307ac95885064fe734e0aab945654244ecec8"
    },
    enableSccache = false,
    crates = lib.functions.filterCrates (import "sccache-crates.json"),
    biDrvs = [
      drvs.openssl,
    ]
  }
}
