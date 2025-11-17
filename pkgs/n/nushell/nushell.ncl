{
  lib,
  drvs,
  nushell | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/nushell/nushell/archive/refs/tags/0.108.0.tar.gz",
      sha256sum = "5995c211411ad1d5dd7da904b9db238a543958675b9e45f5e84fbdf217499eee"
    },
    crates = lib.functions.filterCrates (import "nushell-crates.json"),
  }
}
