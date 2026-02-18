{
  lib,
  drvs,
  niriNsticky | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/lonerOrz/nsticky/archive/3c6f14ee94c9208cce8505a51a16e8116dd7e79c.tar.gz",
      sha256sum = "4d29d9f69a56a8e330246884953d08e5ee20a8b4db6772d3b7546d6e0bcebeed"
    },
    crates = lib.functions.filterCrates (import "niri-nsticky-crates.json")
  }
}
