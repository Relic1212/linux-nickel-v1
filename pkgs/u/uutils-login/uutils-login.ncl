{
  lib,

  uutilsLogin | lib.CargoPackage =
    let j = import "./uutils-login-crates.json"
    in
    let _crates = lib.functions.filterCrates j
    in
    {
      singleSource = {
        uri = "https://github.com/uutils/login/archive/dbf4a31c2c044adaaaecc41405b11fd6063a076e.zip",
        sha256sum = "930c8d715e5cddac799383bd061af0f8d72c13afc838326a3d2217548bada5ff"
      },
      crates = _crates,
    }
}
