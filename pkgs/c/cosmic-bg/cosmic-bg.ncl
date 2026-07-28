{
  lib,
  drvs,
  _CargoFetcher,
  _cosmicSrcs,
  _cosmicSrcs,

  cosmicBgSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = _cosmicSrcs."cosmic-bg",

      outputSha256sum = (import "src.sha256sum" as 'Text), # "0ff1275ce810d127c2d73cb10d13063173252aa97c0867bc4900c5e9be81791f"
    },
}
& {
  lib,
  drvs,
  cosmicBg | lib.CargoPackage = {

    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    preConfigurePhase = [
      "export CARGO_HOME=${SRC}/.cargo",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard/Cargo.toml"%,
    ],

    utilsProviders,
    baseBuildinputPackages =
      [
        drvs.rust,
        drvs.muslBoth,
        drvs.pkgconf,
        llvmProvider,
        drvs.clangCc,
      ]
      @ (if enableSccache then [drvs.sccache] else [])
      @ utilsProviders,
    llvmProvider = drvs.llvmFull,

    enableSccache = true,
    biDrvs = [
      drvs.cosmicBgSources,
    ],
    pDrvs = [
      drvs.libxkbcommon,
      drvs.dav1d,
    ],
  },
}
