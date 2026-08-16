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
          uri = "https://github.com/andre-brandao/gpui-shell/archive/refs/tags/v0.1.0.tar.gz",
          sha256sum = "1b90af0f3c2d2fdb6a82ffc0287b562b6fcb0a389019c4f1d5dab8ec78b56140",
        },

        # outputSha256sum = "160ab4c2a3589e1c489f97db76f5663e83d3ab813df033406d5c544b3ecdbfdc",
        # outputSha256sum = "6208d8a5f45ed237368637630b0abb9ffb197cf34b171c2c68d8e3b8eedd8e28",
        # outputSha256sum = "6860341ec9863a05e85d682d3854892ef7a71d1f03d6c9fa730476edd41f222e",
        outputSha256sum = "5336b59cbffec37a2e8e2bc5bb53cc523fc5620ac2ede51e846cfa6b159f1c12",
        preConfigurePhase = [
          # https://github.com/CapSoftware/scap/issues/185#issuecomment-4565403391
          # "sed -i 's|0.8|0.10.0|g' ${SRC}/crates/services/Cargo.toml",
          # "cargo update -p pipewire --precise 0.10.0",
          # "cargo update -p libspa --precise 0.10.0",
          #"sed -i 's|0.8|0.9.2|g' ${SRC}/crates/services/Cargo.toml",
          #"cargo update -p pipewire --precise 0.9.2",
          #"cargo update -p libspa --precise 0.9.2",
        ]
      },
  gpuiShell | lib.CargoPackage = {
    unpackPhase = [
      "(cd /tmp/workdir/src && tar xf /sources.tar --strip-components=1)"
    ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "/tmp/workdir/src/dlopen.o",
      ],
    },
    extraEnv = {
      EXTRA_RUSTFLAGS = [
        "-C link-arg=/tmp/workdir/src/dlopen.o",

        # "-C link-arg=-l:libdl_ashell",
        "-C link-arg=$(clang --print-file-name=libclang_rt.builtins-x86_64.a)",
        "-C link-arg=-lc++",
        m%"$(for l in $(pkg-config --libs --static xkbcommon libpulse egl wayland-client wayland-egl);do printf " -C link-arg=$l ";done)"%,
      ],
    },
    preConfigurePhase = [
      "echo '%{import "gpui_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      # "echo '%{import "../../a/ashell/ashell_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/libspa-sys*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/pipewire-sys*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys*/Cargo.toml"%,
      m%"sed -i 's@libpulse.so.0@libpulse.a@g' ${SRC}/vendor/libpulse-sys*/build.rs"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/wgpu-hal/Cargo.toml"%,
      # m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/gpui_linux/Cargo.toml"%,
      "cargo tree --target=x86_64-unknown-linux-musl -e features",
    ],
    llvmProvider = drvs.llvmFull,
    muslProvider = drvs.muslBothWeakDl,
    # muslProvider = drvs.muslBothRenamedDl,
    biDrvs = [
      drvs.gpuiShellSources,
      drvs.llvmConfigStatic,
    ],
    pDrvs = [
      drvs.pipewire,
      drvs.libstdcppCompat,
      drvs.pulseaudio17,
      # drvs.mesa2,
    ],
  }
}
