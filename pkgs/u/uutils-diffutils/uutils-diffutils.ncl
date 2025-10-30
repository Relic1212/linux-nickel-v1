{
  lib,
  drvs,
  uutilsDiffutils | lib.CargoPackage =
    let j = import "./uutils-diffutils-crates.json"
    in
    let _crates = lib.functions.filterCrates j
    in
    {
      singleSource = {
        # uri = "https://github.com/uutils/diffutils/archive/refs/tags/v0.4.2.tar.gz",
        # sha256sum = "3be767b5417fb5358d6a979603628c9a926367c700c45335e888b605d9d16ef4",
        uri = "https://github.com/uutils/diffutils/archive/b193ea0c43c4b89a6a08c6a9a33a27449e6feddd.tar.gz",
        sha256sum = "127cea9229128a21034f3d54ec9a2814b3d469c91747f6c0fba74c1e9209fe69",
      },
      crates = _crates,
    }
}
