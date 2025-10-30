{
  lib,
  drvs,
  nirius | lib.CargoPackage = {
    singleSource = {
      uri = "https://git.sr.ht/~tsdh/nirius/archive/nirius-0.5.4.tar.gz",
      sha256sum = "3a017f249d2f75005f5ebc7e1f8afb4ad187fee1d4d93ad85e5b5f5a7a8b32ff"
    },
    crates = lib.functions.filterCrates (import "nirius-crates.json"),
  }
}
