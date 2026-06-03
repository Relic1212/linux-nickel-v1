{
  lib,
  drvs,
  lemurs | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/coastalwhite/lemurs/archive/22091b22d9269c8153c1fa8e79be2dcb68eaf6ba.tar.gz",
      sha256sum = "3db67a9aec0ad82dbbb3e25487a3db46b423aaf3e472390a4e14dd743cd5cf67",
    },
    crates = lib.functions.filterCrates (import "lemurs-crates.json"),

    extraEnv.EXTRA_RUSTFLAGS = ["-C link-arg=-lcap"],

    pDrvs = [
      drvs.libpamFinal,
      drvs.libcap,
    ]
  }
}
