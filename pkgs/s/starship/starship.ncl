{
  lib,
  drvs,
  starship | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/starship/starship/archive/refs/tags/v1.23.0.tar.gz",
      sha256sum = "be3ba025a64bd808899dce256e1511145b55cc5eefc5fca82bf5537cd8e09c72"
    },
    crates = (lib.functions.filterCrates (import "starship-crates.json"))
  }
}
