{
  lib,
  drvs,
  iwmenu | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/e-tho/iwmenu/archive/refs/tags/v0.3.0.tar.gz",
      sha256sum = "9537bf39032a229558e34f7e98700bb0f1924d818aa4bc55ee92c7ddf4bd73b9"
    },
    enableSccache = true,
    crates = lib.functions.filterCrates (import "iwmenu-crates.json"),
  }
}
