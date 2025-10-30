{
  lib,
  drvs,
  nirinit | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/amaanq/nirinit/archive/refs/tags/v0.1.3.tar.gz",
      sha256sum = "2bed1bb1e123ef1cb724bc1b070f89216cb5ae8fec04864cfa437f8a9894fcf1"
    },
    enableSccache = false,
    crates = lib.functions.filterCrates (import "nirinit-crates.json")
  }
}
