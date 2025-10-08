{
  lib,
  drvs,
  _CargoFetcher,
  _cosmicSrcSha256sums,
  cosmicOsdSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = {
        uri = "https://github.com/pop-os/cosmic-osd/archive/refs/tags/epoch-1.0.0-beta.1.tar.gz",
        sha256sum = _cosmicSrcSha256sums."%{uri}", #"e6c4a8b7b66d945bda585a0414098f78af7533057b6a1534ee3e01ed70be5556"
      },
      outputSha256sum = (import "src.sha256sum" as 'Text), # "fcc1e357b29109836a37a23a0f33f3c8e2c86226d62e5dc16dd175748dd4d462"
    },
}
& {
  lib,
  drvs,
  cosmicOsd | lib.CargoPackage = {

    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xvf /sources.tar",
    ],
    preConfigurePhase = [
      "export CARGO_HOME=${SRC}/.cargo",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"pulse",@@g' ${SRC}/vendor/cosmic-settings-subscriptions/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/libspa-sys/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/pipewire-sys/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/accesskit_winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/iced_winit/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@\["dlopen"\]@\[\]@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer/Cargo.toml"%,
      m%"sed -i 's@libpulse.so.0@libpulse.a@g' ${SRC}/vendor/libpulse-sys/Cargo.toml"%,
    ],

    patches = [
      # {
      #   sha256sum = "812e14176752c9b3c39ebcbd4fb12b0694b684ce6dce98da3ade97023a287a2a",
      #   file = "cosmic-osd-no-pulse.patch"
      # },
      {
        sha256sum = "ae7010ae3fd4b4603789a9cb58e5fd40bea31b728bed9fd112c581c039d39527",
        file = "cosmic-osd-xkb.patch",
      }
    ],

    # release = false,

    cargoFlags,
    target,

    buildPhase = [
      "make ARGS+=\"%{std.string.join " " cargoFlags}\"",
    ],
    installPhase = [
      "make TARGET=%{target}/release DESTDIR=$DEST install",
    ],

    postInstallPhase = [
      "cargo tree --target=x86_64-unknown-linux-musl -e features > features_manifest.txt",
    ],

    extraEnv.EXTRA_RUSTFLAGS = [
      "-C link-arg=-L/usr/lib/pulseaudio",
      "-C link-arg=-lpulsecommon-17.0",
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
      drvs.gnumake,
      drvs.cosmicOsdSources,
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
      drvs.libcamera,
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
      drvs.elogindWithPolkit,
      drvs.libcap,
      drvs.pulseaudio17,
    ],
  },
}
