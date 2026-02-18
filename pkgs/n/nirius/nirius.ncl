{
  lib,
  drvs,
  nirius | lib.CargoPackage = {
    singleSource = {
      uri = "https://git.sr.ht/~tsdh/nirius/archive/nirius-0.7.0.tar.gz",
      sha256sum = "c78ad43f1588ad8b81be8b76578235bf876e44235d76f540d6a0c8b7f246d8a2"
    },
    crates = lib.functions.filterCrates (import "nirius-crates.json"),
  }
}
