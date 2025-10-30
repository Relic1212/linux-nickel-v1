{
  lib,
  drvs,
  swaytreesave | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/fabienjuif/swaytreesave/archive/refs/tags/v0.4.0.tar.gz",
      sha256sum = "2b31fcbf97bea73d197a8f233a8cfbd872c5daa1856cbc51b642d9ac57b75f3b"
    },
    enableSccache = false,
    crates = lib.functions.filterCrates (import "swaytreesave-crates.json"),
  }
}
