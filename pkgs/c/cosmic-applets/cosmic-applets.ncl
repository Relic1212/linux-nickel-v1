{
  lib,
  drvs,
  _CargoFetcher,
  _cosmicSrcs,
  _cosmicSrcs,
  cosmicAppletsSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = _cosmicSrcs."cosmic-applets",
      outputSha256sum = (import "src.sha256sum" as 'Text),
    },
}
& {
  lib,
  drvs,
  cosmicApplets | lib.CargoPackage = {

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
      #
      m%"sed -i 's@"softbuffer/wayland-dlopen",@@g' ${SRC}/vendor/iced_tiny_skia/Cargo.toml"%,
      "echo '%{import "../cosmic-osk/cosmic_osk_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
    ],

    extraEnv = {
      EXTRA_RUSTFLAGS = [
        "-C link-arg=-lpulse",
        "-C link-arg=-L/usr/lib/pulseaudio",
        "-C link-arg=-lpulsecommon-17.0",
        "-C link-arg=-lc++",
        "-C link-arg=$(clang --print-file-name=libclang_rt.builtins-x86_64.a)",
        "-C link-arg=/tmp/workdir/src/dlopen.o",
        m%"$(for l in $(pkg-config --libs --static xkbcommon);do printf " -C link-arg=$l ";done)"%,
      ]
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
    muslProvider = drvs.muslBothWeakDl,

    ################

    pDrvs = [
      drvs.pipewire,
      drvs.pulseaudio17,
      drvs.libinput,
    ],
    ##################

    biDrvs = [
      (drvs.findutils & { priority = 1 }),
      drvs.just,
      drvs.cosmicAppletsSources,
    ],
  },
}
