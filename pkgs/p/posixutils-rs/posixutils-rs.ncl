{
  lib,
  drvs,
  posixutilsRs | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/rustcoreutils/posixutils-rs/archive/refs/tags/v0.7.0.tar.gz",
      sha256sum = "bfbbbf11fd863f51e51479366fcf60f24e7b6ec26d2b54b6f7f73986f7a3dbf6",
    },

    crates = lib.functions.filterCrates (import "posixutils-rs-crates.json"),

    extraFiles = [
      # https://github.com/rust-lang/libc/commit/33d6a5909ca822e8f5a0ebb0d302761cdd0dd184
      {
        sha256sum = "579c96debdc346ab1503a55679e27b61051ee0e942e0c2c39e4a3b5f6d1263d6",
        file = "libc.patch",
      }
    ],

    configurePhase = [
      "(cd ${SRC}/vendor/libc-0.2.178 && patch -p1 < /tmp/workdir/files/libc.patch)",
    ],

    rustProvider = drvs.rustWFmt,
  }
}
