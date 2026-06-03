{
  lib,
  drvs,
  cargoVendorFilter | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/coreos/cargo-vendor-filterer/archive/refs/tags/v0.5.18.tar.gz",
      sha256sum = "43da7839e028b2e94db623ab301d9602dae4d8f7fe35c10c2f485624797b8b71",
    },
    crates = lib.functions.filterCrates (import "cargo-vendor-filter-crates.json"),
  }
}
