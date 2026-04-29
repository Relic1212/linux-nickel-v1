{
  lib,
  drvs,
  clapboard | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/bjesus/clapboard/archive/refs/tags/v1.1.1.tar.gz",
      sha256sum = "e7a0bfdc6cfd7d9ddf83ed5f58db1ef84ab62d28bda949f01dc65a57a26b7b5a",
    },
    crates = lib.functions.filterCrates (import "clapboard-crates.json")
  }
}
