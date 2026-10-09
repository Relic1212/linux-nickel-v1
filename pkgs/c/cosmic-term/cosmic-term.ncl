{
  lib,
  drvs,
  _CargoFetcher,
  _cosmicSrcs,
  cosmicTermSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = _cosmicSrcs."cosmic-term",

      outputSha256sum = (import "src.sha256sum" as 'Text),
    },
}
& {
  lib,
  drvs,
  cosmicTerm | lib.CargoPackage = {

    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    preConfigurePhase = [
      "export CARGO_HOME=${SRC}/.cargo",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/accesskit_winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/iced_winit/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@\["dlopen"\]@\[\]@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer/Cargo.toml"%,
      m%"sed -i 's@"softbuffer/wayland-dlopen",@@g' ${SRC}/vendor/iced_tiny_skia/Cargo.toml"%,
      #
      # m%"sed -i 's@"dynamic"@@g' ${SRC}/vendor/wgpu-hal/Cargo.toml"%, # DynamicInstance
      #
      "echo '%{import "../cosmic-term/cosmic_term_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
    ],

    extraEnv = {
      EXTRA_RUSTFLAGS = [
        "-C link-arg=/tmp/workdir/src/dlopen.o",
        "-C link-arg=-lc++",
        "-C link-arg=$(clang --print-file-name=libclang_rt.builtins-x86_64.a)",
        m%"$(for l in $(pkg-config --libs --static xkbcommon egl wayland-client wayland-egl);do printf " -C link-arg=$l ";done)"%,
      ],
    },

    target,
    # buildPhase = [
    #   "just args=\" --target %{target}\" build-vendored "
    # ],

    installPhase = [
      "export CARGO_TARGET_DIR=\"target/%{target}\"",
      "just rootdir=$DEST install",
    ],

    postInstallPhase = [
      "cargo tree --target=x86_64-unknown-linux-musl -e features",
    ],

    llvmProvider = drvs.llvmFull,
    muslProvider = drvs.muslBothRenamedDl,

    biDrvs = [
      (drvs.findutils & { priority = 1 }), # xargs -d
      drvs.just,
      drvs.cosmicTermSources,
      drvs.libstdcppCompat,
    ],

    pDrvs = [
      drvs.mesa2,
      drvs.libxkbcommon,
    ],
  },
}
