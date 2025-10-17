{
  lib,
  drvs,
  impala | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/pythops/impala/archive/refs/tags/v0.3.0.tar.gz",
      sha256sum = "6ebdfbd83f7c3874fd43a1b781a7c08b309a2dc5bef99e1c29c5736b616a0f33"
    },
    crates = lib.functions.filterCrates (import "impala-crates.json"),
  }
}
