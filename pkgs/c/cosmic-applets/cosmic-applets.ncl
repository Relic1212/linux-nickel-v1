{
  lib,
  drvs,
  _CargoFetcher,
  _cosmicSrcSha256sums,
  cosmicAppletsSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = {
        uri = "https://github.com/pop-os/cosmic-applets/archive/refs/tags/epoch-1.0.0-beta.3.tar.gz",
        sha256sum = _cosmicSrcSha256sums."%{uri}", #"6627209f8e85502486a8ee2f19cff83d014a270c384f885299d0e1113e55a51a"
      },
      outputSha256sum = (import "src.sha256sum" as 'Text), # "3a58b8e709a9e19e42de654379701a135dd04fcc338d71cb3a1d16470090a9bf"
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
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/libspa-sys/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/pipewire-sys/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys/Cargo.toml"%,
      # m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/accesskit_winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/iced_winit/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@\["dlopen"\]@\[\]@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer/Cargo.toml"%,
    ],

    patches = [
      {
        sha256sum = "ae7010ae3fd4b4603789a9cb58e5fd40bea31b728bed9fd112c581c039d39527",
        file = "cosmic-osd-xkb.patch",
      }
    ],
    extraEnv = {
      EXTRA_RUSTFLAGS = [
        "-C link-arg=-lpulse",
        "-C link-arg=-L/usr/lib/pulseaudio",
        "-C link-arg=-lpulsecommon-17.0",
        "-C link-arg=-lc++",
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
      (drvs.findutils & { priority = 1 }),
      drvs.pulseaudio17,
      drvs.just,
      drvs.cosmicAppletsSources,
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
    ],
  },
}
