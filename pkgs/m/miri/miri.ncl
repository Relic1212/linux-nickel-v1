{
  lib,
  drvs,
  miri | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/MintyDoggo/miri/archive/refs/tags/v0.0.2.tar.gz",
      sha256sum = "cc9e43f01b3ebc4efcccbc19bca1621cd8b58d22d2b03b320e4b0a5c3954f744",
    },

    crates = lib.functions.filterCrates (import "miri-crates.json"),
  }
}
