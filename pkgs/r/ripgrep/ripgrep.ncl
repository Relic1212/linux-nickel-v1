{
  lib,
  drvs,
  ripgrep | lib.CargoPackage
    = {
      singleSource = {
        uri = "https://github.com/BurntSushi/ripgrep/archive/refs/tags/14.1.1.tar.gz",
        sha256sum = "4dad02a2f9c8c3c8d89434e47337aa654cb0e2aa50e806589132f186bf5c2b66"
      },
      crates = lib.functions.filterCrates (import "ripgrep-crates.json"),
      extraEnv = {
        JEMALLOC_SYS_WITH_LG_PAGE = "16",
        PCRE2_SYS_STATIC = "0",
        RUST_BACKTRACE="full",
      },
      buildEnv = {
        EXTRA_CFLAGS = ["-L/usr/lib", "--verbose"],
        EXTRA_CXXFLAGS = ["-L/usr/lib", "--verbose"],
        EXTRA_LDFLAGS = ["-L/usr/lib", "--verbose"],
      },
      biDrvs = [
        drvs.pcre2,
        drvs.musl,
        drvs.gnumake,
      ]
    }
}
