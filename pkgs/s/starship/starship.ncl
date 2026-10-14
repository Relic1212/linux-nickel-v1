{
  lib,
  drvs,
  starship | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/starship/starship/archive/refs/tags/v1.26.0.tar.gz",
      sha256sum = "8c95e8a6c596b29ac192104eae00dd991e8c8fd66083fd2b34d6b223a5803a59"
    },
    crates = (lib.functions.filterCrates (import "starship-crates.json"))
  }
}
