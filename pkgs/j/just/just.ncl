{
  lib,
  drvs,
  just | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/casey/just/archive/refs/tags/1.42.4.tar.gz",
      sha256sum = "bd604ff72ecd8d8def79d39997499433e22fbffa03260e3a2c5fe5f84cc37f52"
    },
    crates = (lib.functions.filterCrates (import "just-crates.json")),
  }
}
