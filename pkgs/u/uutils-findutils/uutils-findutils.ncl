{
  lib,
  drvs,
  uutilsFindutils | lib.CargoPackage =
    let j = import "./uutils-findutils-crates.json"
    in
    let _crates = lib.functions.filterCrates j
    in
    {
      singleSource = {
        uri = "https://github.com/uutils/findutils/archive/refs/tags/0.7.0.tar.gz",
        sha256sum = "129c263c6953b5c6aa756666aa9f5e968e04c1d0315d9d8ad9e93ec3d1823bc0"
      },
      crates = _crates,
    }
}
