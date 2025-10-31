{
  lib,
  drvs,
  posixutilsRs | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/rustcoreutils/posixutils-rs/archive/0982172e356b6ff27ac0ee679b6af5780d5e8da6.tar.gz",
      sha256sum = "1de8f2a953c9ae3270bf220c5a61b3a91dc30d799dd3008dbdf8e46c2c86bee9",
    },
    nonCrateSourceInputs = [
      { src = singleSource },
      {
        src = {
          uri = "https://github.com/rust-lang/libc/commit/33d6a5909ca822e8f5a0ebb0d302761cdd0dd184.patch",
          sha256sum = "f06e00e61f8478eb5ca946456d5b61f5e1ffb9e8f93c1ca6262e3542c4acfbb8"
        }
      }
    ],
    crates = lib.functions.filterCrates (import "posixutils-rs-crates.json"),

    configurePhase = [
      # https://reviews.llvm.org/D63785
      m%"sed -i 's|__key|__ipc_perm_key|g' ${SRC}/sys/ipcs.rs"%,
      "(cd ${SRC}/vendor/libc-0.2.171 && patch -p1 < ${SRC}/33d6a5909ca822e8f5a0ebb0d302761cdd0dd184.patch)",
    ],

    rustProvider = drvs.rustWFmt,
  }
}
