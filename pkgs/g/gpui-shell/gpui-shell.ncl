{
  lib,
  drvs,
  _CargoFetcher,
  gpuiShellSources
    | lib.DeterministicFetcher
    =
      _CargoFetcher
      & {
        singleSource = {
          uri = "https://github.com/andre-brandao/gpui-shell/archive/refs/tags/v0.0.7.tar.gz",
          sha256sum = "5ad48c7e064ba834dee6e191665e529d9b3d36f8b782651cc9364bd5bad65493",
        },

        # outputSha256sum = "160ab4c2a3589e1c489f97db76f5663e83d3ab813df033406d5c544b3ecdbfdc",
        # outputSha256sum = "6208d8a5f45ed237368637630b0abb9ffb197cf34b171c2c68d8e3b8eedd8e28",
        outputSha256sum = "6860341ec9863a05e85d682d3854892ef7a71d1f03d6c9fa730476edd41f222e",
        preConfigurePhase = [
          # https://github.com/CapSoftware/scap/issues/185#issuecomment-4565403391
          # "sed -i 's|0.8|0.10.0|g' ${SRC}/crates/services/Cargo.toml",
          # "cargo update -p pipewire --precise 0.10.0",
          # "cargo update -p libspa --precise 0.10.0",
          "sed -i 's|0.8|0.9.2|g' ${SRC}/crates/services/Cargo.toml",
          "cargo update -p pipewire --precise 0.9.2",
          "cargo update -p libspa --precise 0.9.2",
        ]
      },
  gpuiShell | lib.CargoPackage = {
    unpackPhase = [
      "(cd /tmp/workdir/src && tar xf /sources.tar --strip-components=1)"
    ],
    preConfigurePhase = [
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/libspa-sys*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/pipewire-sys*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys*/Cargo.toml"%,
    ],
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.gpuiShellSources,
      drvs.llvmConfigStatic,
    ],
    pDrvs = [
      drvs.pipewire,
      drvs.libstdcppCompat,
    ],
  }
}
