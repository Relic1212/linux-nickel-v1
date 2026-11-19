{
  lib,
  drvs,
  bindgen | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.72.1.tar.gz",
      sha256sum = "4ffb17061b2d71f19c5062d2e17e64107248f484f9775c0b7d30a16a8238dfd1",
    },
    crates = lib.functions.filterCrates (import "bindgen-crates.json"),
    baseCargoFlags,
    extraCargoFlags = [
      "--no-default-features",
      "--features=logging,prettyplease,static",
    ],
    configurePhase = [
      "cargo tree %{std.string.join " " (baseCargoFlags @ extraCargoFlags)} -e features",
    ],
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.llvmConfigStatic,
      drvs.libffi,
      drvs.ncurses,
      drvs.libstdcppCompat,
      drvs.zlibNg,
      drvs.musl & { priority = 1 },
    ],
  },
  bindgen157 | lib.CargoPackage =
    bindgen
    & {
      singleSource | priority 1 = {

        uri = "https://github.com/rust-lang/rust-bindgen/archive/73c69d681eec90b84ffba4f993b5fb2f19580781.tar.gz",
        sha256sum = "76ebd63a6098889ff9805ba19057b9409748e3848a4135e59a0dff8ad7853397",
      },
      crates | priority 1 = lib.functions.filterCrates (import "bindgen157-crates.json"),
    }
}
