{
  lib,
  drvs,
  _CargoFetcher,
  _cosmicSrcs,
  _cosmicSrcs,

  cosmicFilesSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = _cosmicSrcs."cosmic-files",

      outputSha256sum = (import "src.sha256sum" as 'Text),
    },
}
& {
  lib,
  drvs,
  cosmicFiles | lib.CargoPackage = {

    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    preConfigurePhase = [
      "export CARGO_HOME=${SRC}/.cargo",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard/Cargo.toml"%,

      # m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen/Cargo.toml"%,
      # m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/libspa-sys/Cargo.toml"%,
      # m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/pipewire-sys/Cargo.toml"%,
      # m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys/Cargo.toml"%,
      # m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/accesskit_winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/iced_winit/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@\["dlopen"\]@\[\]@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer/Cargo.toml"%,
      m%"sed -i 's@"softbuffer/wayland-dlopen",@@g' ${SRC}/vendor/iced_tiny_skia/Cargo.toml"%,
      "echo '%{import "../cosmic-term/cosmic_term_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      # "export RUST_LIBC_UNSTABLE_MUSL_V1_2_3=1",
      # "(cd vendor && patch -p1 compio-driver/src/sys/unix_op.rs < /tmp/workdir/files/compio-driver-669.patch)",
      # "(cd vendor && patch -p1 compio-driver/src/sys/iour/op.rs < /tmp/workdir/files/compio-driver-669.patch)",
    ],

    extraEnv = {
      EXTRA_RUSTFLAGS = [
        "-C link-arg=/tmp/workdir/src/dlopen.o",
        "-C link-arg=/usr/lib/libc.a",
        "-lc++",
        "-C link-arg=$(clang --print-file-name=libclang_rt.builtins-x86_64.a)",
        m%"$(for l in $(pkg-config --libs --static xkbcommon egl wayland-client wayland-egl);do printf " -C link-arg=$l ";done)"%,
      ],
    },

    target,
    buildPhase = [
      "just build-release --offline --target x86_64-unknown-linux-musl",
      "echo 'Done building'",
    ],

    installPhase = [
      "export CARGO_TARGET_DIR=\"target/%{target}\"",
      "just rootdir=$DEST install",
    ],

    llvmProvider = drvs.llvmFull,
    muslProvider = drvs.muslBothRenamedDl,

    biDrvs = [
      (drvs.findutils & { priority = 1 }),
      drvs.just,
      drvs.cosmicFilesSources,
      drvs.libstdcppCompat,
    ],
    pDrvs = [
      drvs.glib,
      drvs.libxkbcommon,
      drvs.mesa2,
    ],
  },
}
