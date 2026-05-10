let s = {
  uri = "https://github.com/servo/servo/archive/refs/tags/v0.1.0.tar.gz",
  sha256sum = "311db5fd67ca035d480a507393c2fd3a28912cd2d3a6b9ea0efc5bac84d81173"
},
in

{
  lib,
  drvs,
  _CargoFetcher,
  servoSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = s,
      outputSha256sum = "e597f68c4e1d9f316e032371b6731e83dc62c4031b35c5464cb76ebd752fb76a"
    },
  servo | lib.CargoPackage = {
    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    preConfigurePhase = [
      "export CARGO_HOME=${SRC}/.cargo",
      "mkdir /tmp/workdir/build/home",
      "export HOME=/tmp/workdir/build/home",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      "sed -i 's|when=link_libstdcxx_statically|when=target_is_windows|g' ${SRC}/vendor/mozjs_sys/mozjs/build/moz.configure/flags.configure",
    ],
    extraCargoFlags = [
      "--verbose",
    ],
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.servoSources,
      drvs.pythonDynamicCurses,
      drvs.musl & { priority = 1 },
      drvs.gnumake,
      drvs.libstdcppCompat,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.expat,
      drvs.fontconfig,
      drvs.bash,
      drvs.llvmConfigStatic,
    ]
  },
  #   servo1 | lib.CargoPackage = {
  #     singleSource = {
  #       uri = "https://github.com/servo/servo/archive/refs/tags/v0.0.3.tar.gz",
  #       sha256sum = "571fc8e1b27431e630aa3d55d4aa4d9ab9741f8b861dcb6da997ceb7ae1c8897"
  #     },

  #     crates = lib.functions.filterCrates (import "servo-crates.json"),

  #     configurePhase = [
  #       m%"echo '[source.crates-io]
  # replace-with = "vendored-sources"

  # [source."git+https://github.com/servo/fontsan"]
  # git = "https://github.com/servo/fontsan"
  # replace-with = "vendored-sources"

  # [source."git+https://github.com/servo/media"]
  # git = "https://github.com/servo/media"
  # replace-with = "vendored-sources"

  # [source."git+https://github.com/servo/mozjs"]
  # git = "https://github.com/servo/mozjs"
  # replace-with = "vendored-sources"

  # [source."git+https://github.com/servo/rust-content-security-policy?branch=servo-csp"]
  # git = "https://github.com/servo/rust-content-security-policy"
  # branch = "servo-csp"
  # replace-with = "vendored-sources"

  # [source."git+https://github.com/servo/stylo?branch=2025-11-01"]
  # git = "https://github.com/servo/stylo"
  # branch = "2025-11-01"
  # replace-with = "vendored-sources"

  # [source."git+https://github.com/servo/webrender?branch=0.68"]
  # git = "https://github.com/servo/webrender"
  # branch = "0.68"
  # replace-with = "vendored-sources"

  # [source.vendored-sources]
  # directory = "vendor"
  # ' > ${SRC}/.cargo/config.toml"%
  #     ]
  #   }
}
