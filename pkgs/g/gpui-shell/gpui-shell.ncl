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
          uri = "https://github.com/andre-brandao/gpui-shell/archive/refs/tags/v0.1.3.tar.gz",
          sha256sum = "e08afe337d57ea2dff03f7211496e7f6a3b62b474c493f7fb6854109b5ecb7a1",
        },

        outputSha256sum = "5729159bcc2a0526ca8fe374fab29c402d2245e9b72fb9248b6940161628fa2c",
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
