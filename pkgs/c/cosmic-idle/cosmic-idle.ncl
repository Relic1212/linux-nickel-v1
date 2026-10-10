{
  lib,
  drvs,
  _CargoFetcher,
  _cosmicSrcs,
  _cosmicSrcs,

  cosmicIdleSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = _cosmicSrcs."cosmic-idle",

      outputSha256sum = (import "src.sha256sum" as 'Text), # "57613d4960bc73fd18690fecda6501390e47a259957cf842d12452a70bcc5b52"
    },
}
& {
  lib,
  drvs,
  cosmicIdle | lib.CargoPackage = {

    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    preConfigurePhase = [
      "export CARGO_HOME=${SRC}/.cargo",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard/Cargo.toml"%,
    ],

    extraEnv = {
      EXTRA_RUSTFLAGS = [],
    },
    target,
    # buildPhase = [
    #   "just args=\" --target %{target}\" build-vendored "
    # ],

    installPhase = [
      "export CARGO_TARGET_DIR=\"target/%{target}\"",
      "just rootdir=$DEST install",
    ],

    llvmProvider = drvs.llvmFull,

    biDrvs = [
      (drvs.findutils & { priority = 1 }),
      drvs.just,
      drvs.cosmicIdleSources,
      drvs.libstdcppCompat,
    ],
    pDrvs = [
      drvs.libxkbcommon,
    ],
  },
}
