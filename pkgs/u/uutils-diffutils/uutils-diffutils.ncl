{
  lib,
  drvs,
  uutilsDiffutils | lib.CargoPackage
    =
      let j = import "./uutils-diffutils-crates.json"
      in
      let _crates = lib.functions.filterCrates j
      in
      {
        singleSource = {
          uri = "https://github.com/uutils/diffutils/archive/refs/tags/v0.4.2.tar.gz",
          sha256sum = "3be767b5417fb5358d6a979603628c9a926367c700c45335e888b605d9d16ef4"
        },
        crates = _crates,
      }
}
