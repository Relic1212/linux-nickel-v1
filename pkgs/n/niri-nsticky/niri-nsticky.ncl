{
  lib,
  drvs,
  niriNsticky | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/lonerOrz/nsticky/archive/339a4fa90fba07de52b2afe24ab24e6d5d47cb5a.tar.gz",
      sha256sum = "6b1e4f37e3cff4367e53fb9634edb9c7b06b46e6aab4ce7a8dc51f8640622de5"
    },
    crates = lib.functions.filterCrates (import "niri-nsticky-crates.json")
  }
}
