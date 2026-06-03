{
  lib,
  drvs,
  regreet | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/rharish101/ReGreet/archive/refs/tags/0.4.0.tar.gz",
      sha256sum = "dd11f6dc82a929ac51a51750b3268028fe5aa46e5fe1d1cbd11b43ad57b3006a",
    },

    crates = lib.functions.filterCrates (import "regreet-crates.json"),
    llvmProvider = drvs.llvmFull,
    neverInclude = [
      drvs.harfbuzz,
    ],
    pDrvs = [
      drvs.gtk4,
    ]
  }
}
