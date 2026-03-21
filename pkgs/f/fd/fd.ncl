{
  lib,
  drvs,
  fd | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/sharkdp/fd/archive/refs/tags/v10.4.2.tar.gz",
      sha256sum = "3a7e027af8c8e91c196ac259c703d78cd55c364706ddafbc66d02c326e57a456",
    },
    crates = lib.functions.filterCrates (import "fd-crates.json"),
    # extraEnv = {
    #     "JEMALLOC_OVERRIDE" = "/usr/lib/libjemalloc.a",
    #     EXTRA_RUSTFLAGS = [
    #         "-C link-arg=/usr/lib/libjemalloc.a",
    #     ],
    # },
    biDrvs = [
      # drvs.jemalloc,
      drvs.musl & { priority = 1 },
      drvs.gnumake,
    ]
  }
}
