{
  lib,
  drvs,
  cbindgen | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/mozilla/cbindgen/archive/refs/tags/0.29.2.tar.gz",
      sha256sum = "e2e8b044662804ef55c075ffca03da1d69c443d4749590cb29f03e8588ba49d1",
    },
    crates = lib.functions.filterCrates (import "cbindgen-crates.json"),
  }
}
