{
  lib,
  drvs,
  _CargoFetcher,
  _cosmicSrcs,
  cosmicSettingsSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = _cosmicSrcs."cosmic-settings",

      outputSha256sum = (import "src.sha256sum" as 'Text), # "4f25a13405a019d470e37910fb9710110076c0df7ef1d331d6e224efbe413ead"
    },
}
& {
  lib,
  drvs,
  distro,
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
      m%"sed -i 's@\["dlopen"\]@\[\]@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/accesskit_winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/iced_winit/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer/Cargo.toml"%,
      #
      m%"sed -i 's@"softbuffer/wayland-dlopen",@@g' ${SRC}/vendor/iced_tiny_skia/Cargo.toml"%,
      # "echo '%{import "../cosmic-osk/cosmic_osk_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "echo '%{import "../cosmic-term/cosmic_term_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
    ],

    extraEnv = {
      EXTRA_RUSTFLAGS =
        [
          "-C link-arg=-rtlib=compiler-rt",
          # "-C link-arg=-lpulse",
          # "-C link-arg=-L/usr/lib/pulseaudio",
          # "-C link-arg=-lpulsecommon-17.0",
          "-C link-arg=-lc++",
          "-C link-arg=-L/usr/lib/clang/21/lib/linux",
          "-C link-arg=-lclang_rt.builtins-x86_64",

          #
          "-C link-arg=/tmp/workdir/src/dlopen.o",
          # m%"$(for l in $(pkg-config --libs --static xkbcommon);do printf " -C link-arg=$l ";done)"%,
          m%"$(for l in $(pkg-config --libs --static xkbcommon egl wayland-client wayland-egl);do printf " -C link-arg=$l ";done)"%,
        ]
        @ (if distro.pam then ["-C link-arg=-lcap"] else [])
        @ (
          std.array.map
            (fun a => "-C link-arg=%{a}")
            (
              std.string.split
                " "
                "-lpipewire-0.3 -ldl -lm -L/usr/lib/spa-0.2/bluez5 -lspa-codec-bluez5-ldac -lspa-codec-bluez5-aac -lspa-codec-bluez5-opus -lspa-codec-bluez5-faststream -lspa-codec-bluez5-sbc -lspa-bluez5 -L/usr/lib/spa-0.2/v4l2 -lspa-v4l2 -L/usr/lib/spa-0.2/audiomixer -lspa-audiomixer -L/usr/lib/spa-0.2/aec -lspa-aec-null -L/usr/lib/spa-0.2/audioconvert -lspa-audioconvert -L/usr/lib/spa-0.2/support -lspa-support -L/usr/lib/spa-0.2/alsa -lspa-alsa -lasound -lpthread -lrt -ludev -ldbus-1 -lsbc -lbluetooth -lgio-2.0 -lgobject-2.0 -lffi -lgmodule-2.0 -lglib-2.0 -lpcre2-8 -lz -lusb-1.0 -lopus -lm -lfdk-aac -lldacBT_enc -lm -lldacBT_abr -lldacBT_enc -pthread -lcrypto -ldl -pthread -ludev -lyaml -lssl -ldl -pthread -lcrypto -ldl -pthread"
            )
        )
    },
    target,
    # buildPhase = [
    #   "just args=\" --target %{target}\" build-vendored "
    # ],

    release,

    installPhase =
      let d = if release then "release" else "debug" in
      [
        "export CARGO_TARGET_DIR=\"target/%{target}\"",
        # "just --set bin-src \"target/%{target}/%{d}/cosmic-settings\" rootdir=$DEST install",
        "just rootdir=$DEST install",
      ],

    postInstallPhase = [
      "cargo tree --target=x86_64-unknown-linux-musl -e features",
    ],

    patches = [
      #   {
      #     sha256sum = "e40264ed9187c4c202bdf521537f5828e97e01d51b57ce2c48d4dd96965929fb",
      #     file =  "cosmic-settings-no-pulse.patch"
      #   },
      # {
      #   sha256sum = "ae7010ae3fd4b4603789a9cb58e5fd40bea31b728bed9fd112c581c039d39527",
      #   file = "cosmic-osd-xkb.patch",
      # },
    ],

    utilsProviders,
    baseBuildinputPackages =
      [
        drvs.rust,
        drvs.muslBothWeakDl,
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
      drvs.pipewire, # needed
      drvs.elogindWithPolkit,
      drvs.libcap,
      drvs.libstdcppCompat,
    ],
  },
}
