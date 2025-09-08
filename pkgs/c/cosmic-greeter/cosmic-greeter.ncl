{
  lib,
  drvs,
  _CargoFetcher,
  cosmicGreeterSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = {
        uri = "https://github.com/pop-os/cosmic-greeter/archive/refs/tags/epoch-1.0.0-alpha.7.tar.gz",
        sha256sum = "dfb1ce08f0fb4c1047f1a3e011e8428bfe45b150dbaf848e1f29abee183a2c4d"
      },
      outputSha256sum = "696309af4c34285b91f19906360f40310ef0f2ceceefbb15d0847c1f79a5c1df"
    },
}
& {
  lib,
  drvs,
  cosmicGreeter | lib.CargoPackage = {

    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    preConfigurePhase = [
      "export CARGO_HOME=${SRC}/.cargo",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      # m%"sed -i 's@"pulse",@@g' ${SRC}/vendor/cosmic-settings-subscriptions/Cargo.toml"%,
      # m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard/Cargo.toml"%,
      # m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      # m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      # m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/accesskit_winit/Cargo.toml"%,
      # m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/iced_winit/Cargo.toml"%,
      # m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      # m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer/Cargo.toml"%,

      # m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen/Cargo.toml"%,

      # m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys/Cargo.toml"%,
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen/Cargo.toml"%,
      m%"sed -i 's@"clang-sys\/runtime"@"clang-sys\/static"@g' ${SRC}/vendor/bindgen/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/accesskit_winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/iced_winit/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@\["dlopen"\]@\[\]@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer/Cargo.toml"%,
      # m%"sed -i 's@default-features@#default-features@g' ${SRC}/vendor/pam-sys/Cargo.toml"%,
      m%"sed -i 's@default-features = false@default-features = false\nfeatures = \[ \"static\" \]@g' ${SRC}/vendor/pam-sys/Cargo.toml"%,

      # m%"sed -i 's@\[\"libloading\"\]@false@g' ${SRC}/vendor/clang-sys/Cargo.toml"%,
    ],
    extraEnv = {
      # cosmic-epoch alpha
      VERGEN_GIT_COMMIT_DATE = "9e13a3e47a41296e815ecffef086746dd6bb44bc",
      VERGEN_GIT_SHA = "'Sat Apr 26 13:09:25 2025 +0530'",
      EXTRA_RUSTFLAGS = ["-C link-arg=-lcap"],
    },
    patches = [
      {
        sha256sum = "ae7010ae3fd4b4603789a9cb58e5fd40bea31b728bed9fd112c581c039d39527",
        file = "cosmic-osd-xkb.patch",
      }
    ],
    release,

    target,
    cargoFlags,

    extraCargoFlags = [
      "--verbose",
    ],
    buildPhase = [
      # "just build-release %{std.string.join " " cargoFlags }",     
      "just build-release --offline --target x86_64-unknown-linux-musl --verbose",
      "echo 'Done building'",
    ],

    installPhase =
      let d = if release then "release" else "debug" in
      [
        # "just --set bin-src \"target/%{target}/%{d}/cosmic-greeter\" rootdir=$DEST install",
        "CARGO_TARGET_DIR=\"target/%{target}/\" just rootdir=$DEST install",
      ],

    postInstallPhase = [
      "cargo tree --target=x86_64-unknown-linux-musl -e features > features_manifest.txt",
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
      @ utilsProviders,
    llvmProvider = drvs.llvmFull,

    biDrvs = [
      drvs.git,
      drvs.just,
      drvs.cosmicGreeterSources,
      drvs.alsaLibs,
      drvs.atSpi2Core,
      drvs.bluez,
      drvs.cairo,
      drvs.cairoGobjectEmpty,
      drvs.dbus,
      drvs.eudev,
      drvs.expat,
      drvs.fdkAac,
      drvs.ffmpeg,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.glib,
      drvs.gperf,
      drvs.gtk3,
      drvs.harfbuzz,
      drvs.hwdata,
      drvs.jansson,
      drvs.jsonC,
      drvs.kmod,
      drvs.ldacbt,
      drvs.libdisplayinfo,
      drvs.libdlEgl,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxy,
      drvs.libevdev,
      drvs.libffi,
      drvs.libfreeaptx,
      drvs.libinput,
      drvs.libjpegTurbo,
      drvs.libopus,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libsndfile,
      drvs.libusb,
      drvs.libxkbcommon,
      drvs.libyaml,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.lua,
      drvs.m4,
      drvs.mesaExp,
      drvs.mtdev,
      drvs.ncurses,
      drvs.openssl,
      drvs.pango,
      drvs.pcre2,
      drvs.pixman,
      drvs.readline,
      drvs.sbc,
      drvs.seatd,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.utilLinux,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.xz,
      drvs.zlibNg,
      drvs.zstd,
      drvs.pipewire,
      drvs.dinit,
      drvs.libstdcppCompat,
      drvs.libpamFinal,
      drvs.libcap,
    ],
  },
}
