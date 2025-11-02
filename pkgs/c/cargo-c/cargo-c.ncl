{
  lib,
  drvs,
  cargoC | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.16.tar.gz",
      sha256sum = "c0ebb3175393da5b55c3cd83ba1ae9d42d32e2aece6ceff1424239ffb68eb3e3",
    },
    nonCrateSourceInputs = [
      {
        src = singleSource
      },
      {
        src = {
          uri = "https://github.com/lu-zero/cargo-c/releases/download/v0.10.16/Cargo.lock",
          sha256sum = "5b4201d68d52bd9cbf928d48ae9274131c604fe7b21149841fd07cc78a50b36e"
        }
      },
    ],

    crates = lib.functions.filterCrates (import "cargo-c-crates.json"),

    extraEnv = {
      OPENSSL_NO_VENDOR = "1",
      LIBGIT2_NO_VENDOR = "1",
    },
    biDrvs = [
      drvs.libgit2,
      drvs.openssl,
      drvs.zlibNg,
    ]
  }
}
