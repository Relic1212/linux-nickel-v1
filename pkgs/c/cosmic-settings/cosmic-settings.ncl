{
  lib,
  drvs,
  _CargoFetcher,
  cosmicSettingsSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = {
        uri = "https://github.com/pop-os/cosmic-settings/archive/refs/tags/epoch-1.0.0-alpha.7.tar.gz",
        sha256sum = "95e632d20cf802fe293014dd9707e65bd7d6ab9e7459957f40b01c928908e34a"
      },
      outputSha256sum = "4f25a13405a019d470e37910fb9710110076c0df7ef1d331d6e224efbe413ead"
    },
}
& {
  lib,
  drvs,
  cosmicSettings | lib.CargoPackage = {

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
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/accesskit_winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/iced_winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer/Cargo.toml"%,
      m%"sed -i 's@libpulse.so.0@libpulse.a@g' ${SRC}/vendor/libpulse-sys/Cargo.toml"%,
    ],

    extraEnv = {
      EXTRA_RUSTFLAGS =
        [
          "-C link-arg=-rtlib=compiler-rt",
          "-C link-arg=-lpulse",
          "-C link-arg=-L/usr/lib/pulseaudio",
          "-C link-arg=-lpulsecommon-17.0",
          "-C link-arg=-lc++",
          "-C link-arg=-L/usr/lib/clang/20/lib/linux",
          "-C link-arg=-lclang_rt.builtins-x86_64",
        ]
        @ (
          std.array.map
            (fun a => "-C link-arg=%{a}")
            (
              std.string.split
                " "
                "-lpipewire-0.3 -ldl -lm -L/usr/lib/spa-0.2/libcamera -lspa-libcamera -L/usr/lib/spa-0.2/bluez5 -lspa-codec-bluez5-ldac -lspa-codec-bluez5-aac -lspa-codec-bluez5-opus -lspa-codec-bluez5-faststream -lspa-codec-bluez5-sbc -lspa-bluez5 -L/usr/lib/spa-0.2/v4l2 -lspa-v4l2 -L/usr/lib/spa-0.2/audiomixer -lspa-audiomixer -L/usr/lib/spa-0.2/aec -lspa-aec-null -L/usr/lib/spa-0.2/audioconvert -lspa-audioconvert -L/usr/lib/spa-0.2/support -lspa-support -L/usr/lib/spa-0.2/alsa -lspa-alsa -lasound -lpthread -lrt -ludev -ldbus-1 -lsbc -lbluetooth -lgio-2.0 -lgobject-2.0 -lffi -lgmodule-2.0 -lglib-2.0 -lpcre2-8 -lz -lusb-1.0 -lopus -lm -lfdk-aac -lldacBT_enc -lm -lldacBT_abr -lldacBT_enc -lcamera -lcamera-base -pthread -lcrypto -ldl -pthread -ludev -lyaml -lssl -ldl -pthread -lcrypto -ldl -pthread"
            )
        )
    },
    target,
    # buildPhase = [
    #   "just args=\" --target %{target}\" build-vendored "
    # ],

    release = false,

    installPhase =
      let d = if release then "release" else "debug" in
      [
        # "export CARGO_TARGET_DIR=\"target/%{target}\"",
        "just --set bin-src \"target/%{target}/%{d}/cosmic-settings\" rootdir=$DEST install",
      ],

    patches = [
      #   {
      #     sha256sum = "e40264ed9187c4c202bdf521537f5828e97e01d51b57ce2c48d4dd96965929fb",
      #     file =  "cosmic-settings-no-pulse.patch"
      #   }
      {
        sha256sum = "ae7010ae3fd4b4603789a9cb58e5fd40bea31b728bed9fd112c581c039d39527",
        file = "cosmic-osd-xkb.patch",
      }
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
      (drvs.findutils & { priority = 1 }),
      drvs.pulseaudio17,
      drvs.just,
      drvs.cosmicSettingsSources,
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
      drvs.pipewire2,
      drvs.dinit,
      drvs.libstdcppCompat,
    ],
  },
}
