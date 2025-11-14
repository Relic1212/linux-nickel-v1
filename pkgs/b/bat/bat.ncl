{
  lib,
  drvs,
  bat | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/sharkdp/bat/archive/refs/tags/v0.26.0.tar.gz",
      sha256sum = "ccf3e2b9374792f88797a28ce82451faeae0136037cb8c8b56ba0a6c1a94fd69"
    },
    crates = lib.functions.filterCrates (import "bat-crates.json"),
  }
}
