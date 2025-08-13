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
        uri = "https://github.com/uutils/findutils/archive/refs/tags/0.8.0.tar.gz",
        sha256sum = "932f153d256f7a4cf40255a948689bf59a10f14c8804151817ab50fa1b46429a"
      },
      crates = _crates,

      postInstallPhase = [
        "rm ${DEST}/usr/bin/testing-commandline",
      ]
    }
}
