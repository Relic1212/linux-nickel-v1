{
  lib,
  drvs,
  niriSidebar | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/Vigintillionn/niri-sidebar/archive/refs/tags/v0.2.0.tar.gz",
      sha256sum = "74292d30a4d86e647c7891051085ff64062b0db4aeaf9fd6b655b882619f4e9a",
    },
    enableSccache = false,

    crates = lib.functions.filterCrates (import "niri-sidebar-crates.json"),
  }
}
