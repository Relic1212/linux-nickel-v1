{
  lib,
  drvs,
  cosmicCtl | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/cosmic-utils/cosmic-ctl/archive/refs/tags/v1.5.0.tar.gz",
      sha256sum = "6d0feb0179be9f96e32f2ba60e5c65905eee8b880f6c3254c6833fcb363111c8"
    },
    crates = lib.functions.filterCrates (import "cosmic-ctl-crates.json"),
    nonCrateSourceInputs = [
      {
        src = {
          uri = "https://github.com/jackpot51/rust-atomicwrites/archive/043ab4859d53ffd3d55334685303d8df39c9f768.tar.gz",
          sha256sum = "95ce4266b50ce6470ba74a5a9ce718bbfba45bf5ab43786db05be1682f6f0db1",
        },
        dest = "vendor/atomicwrites"
      }
    ]
  }
}
