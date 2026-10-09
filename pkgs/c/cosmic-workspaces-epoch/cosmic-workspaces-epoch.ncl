{
  lib,
  drvs,
  _CargoFetcher,
  _cosmicSrcs,
  cosmicWorkspacesEpochSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = _cosmicSrcs."cosmic-workspaces-epoch",

      outputSha256sum = (import "src.sha256sum" as 'Text),
    },
}
& {
  lib,
  drvs,
  cosmicWorkspacesEpoch | lib.CargoPackage = {

    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    preConfigurePhase = [
      "export CARGO_HOME=${SRC}/.cargo",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      # m%"sed -i 's@"pulse",@@g' ${SRC}/vendor/cosmic-settings-subscriptions/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard/Cargo.toml"%,
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
    # patches = [
    #   {
    #     sha256sum = "ae7010ae3fd4b4603789a9cb58e5fd40bea31b728bed9fd112c581c039d39527",
    #     file = "cosmic-osd-xkb.patch",
    #   },
    # ],

    extraEnv = {
      # https://github.com/NixOS/nixpkgs/pull/264517#issuecomment-1817817060
      EXTRA_RUSTFLAGS = [
        "-C link-arg=-Wl,--push-state,--no-as-needed",
        "-C link-arg=-lc++",
        "-C link-arg=/tmp/workdir/src/dlopen.o",
        "-C link-arg=$(clang --print-file-name=libclang_rt.builtins-x86_64.a)",
        m%"$(for l in $(pkg-config --libs --static libinput egl xkbcommon);do printf " -C link-arg=$l ";done)"%,
        "-C link-arg=-Wl,--pop-state",
      ],
    },

    # release = false,

    cargoFlags,
    target,
    release,

    buildPhase = [
      "make ARGS+=\"%{std.string.join " " cargoFlags}\"",
    ],
    installPhase =
      let d = if release then "release" else "debug" in
      [
        "make TARGET=%{target}/%{d} DESTDIR=$DEST install",
      ],

    postInstallPhase = [
      "cargo tree --target=x86_64-unknown-linux-musl -e features",
    ],

    llvmProvider = drvs.llvmFull,
    muslProvider = drvs.muslBothRenamedDl,

    biDrvs = [
      drvs.gnumake,
      drvs.cosmicWorkspacesEpochSources,
      drvs.libstdcppCompat,
    ],
    pDrvs = [
      drvs.libinput,
      drvs.libxkbcommon,
      drvs.mesa2,
    ],
  },
}
