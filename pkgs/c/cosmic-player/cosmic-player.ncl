{
  lib,
  drvs,
  _CargoFetcher,
  _cosmicSrcs,
  cosmicPlayerSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = _cosmicSrcs."cosmic-player",

      outputSha256sum = (import "src.sha256sum" as 'Text),
    },
}
& {
  lib,
  drvs,
  cosmicPlayer | lib.CargoPackage = {

    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],

    extraEnv = {
      PKG_CONFIG_PATH = "\"/usr/lib/pkgconfig:/usr/lib/gstreamer-1.0/pkgconfig\"",
      # cosmic-epoch alpha
      VERGEN_GIT_COMMIT_DATE = "9e13a3e47a41296e815ecffef086746dd6bb44bc",
      VERGEN_GIT_SHA = "'Sat Apr 26 13:09:25 2025 +0530'",
      EXTRA_RUSTFLAGS =
        let toArg = (fun s =>
          "-C link-arg=-l%{s}"
        )
        in
        [
          # m%"$(for l in $(pkg-config --libs --static gstreamer-full-1.0);do printf " -C link-arg=$l ";done)"%,
          "-C link-arg=-lgstreamer-full-1.0",
          "-C link-arg=-lgstcodecs-1.0",
          "-C link-arg=-lgstbasecamerabinsrc-1.0",
          (toArg "gsturidownloader-1.0"),
          (toArg "gstadaptivedemux-1.0"),
          "-C link-arg=-lc++",
          m%"$(find /usr/lib/gstreamer-1.0 -type f -name '*.a' | xargs printf "-C link-arg=%s ")"%,
          # m%"$(for l in $(pkg-config --libs --static gstreamer-base-1.0);do printf " -C link-arg=$l ";done)"%,
          # m%"$(for l in $(pkg-config --libs --static gstreamer-1.0);do printf " -C link-arg=$l ";done)"%,
          # m%"$(for l in $(pkg-config --libs --static gstreamer-rtp-1.0);do printf " -C link-arg=$l ";done)"%,
          # m%"$(for l in $(pkg-config --libs --static gstreamer-codecparsers-1.0);do printf " -C link-arg=$l ";done)"%,
          "-C link-arg=/tmp/workdir/src/dlopen.o",
          m%"$(for l in $(pkg-config --libs --static xkbcommon);do printf " -C link-arg=$l ";done)"%,
        ]
        @ (
          std.array.map
            (fun s =>
              m%"$(for l in $(pkg-config --libs --static %{s});do printf " -C link-arg=$l ";done)"%
            )
            [
              "gst-editing-services-1.0",
              "gstreamer-1.0",
              "gstreamer-allocators-1.0",
              "gstreamer-analytics-1.0",
              "gstreamer-app-1.0",
              "gstreamer-audio-1.0",
              "gstreamer-bad-audio-1.0",
              "gstreamer-base-1.0",
              "gstreamer-check-1.0",
              "gstreamer-codecparsers-1.0",
              "gstreamer-controller-1.0",
              "gstreamer-cuda-1.0",
              "gstreamer-fft-1.0",
              "gstreamer-full-1.0",
              "gstreamer-hip-1.0",
              "gstreamer-insertbin-1.0",
              "gstreamer-mpegts-1.0",
              "gstreamer-mse-1.0",
              "gstreamer-net-1.0",
              "gstreamer-pbutils-1.0",
              "gstreamer-photography-1.0",
              "gstreamer-play-1.0",
              "gstreamer-player-1.0",
              "gstreamer-plugins-bad-1.0",
              "gstreamer-plugins-base-1.0",
              "gstreamer-riff-1.0",
              "gstreamer-rtp-1.0",
              "gstreamer-rtsp-1.0",
              "gstreamer-rtsp-server-1.0",
              "gstreamer-sctp-1.0",
              "gstreamer-sdp-1.0",
              "gstreamer-tag-1.0",
              "gstreamer-transcoder-1.0",
              "gstreamer-video-1.0",
              "gstreamer-webrtc-1.0",
            ]
        ),
    },
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
      m%"sed -i 's@"softbuffer/wayland-dlopen",@@g' ${SRC}/vendor/iced_tiny_skia/Cargo.toml"%,
      "echo '%{import "../cosmic-term/cosmic_term_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      "cargo tree --target=x86_64-unknown-linux-musl -e features",
    ],

    target,

    buildPhase = [
      m%"echo RUSTFLAGS=\"${RUSTFLAGS}\""%,
      "just build-release --offline --target x86_64-unknown-linux-musl",
      "echo 'Done building'",
    ],

    installPhase = [
      "export CARGO_TARGET_DIR=\"target/%{target}\"",
      "just rootdir=$DEST install",
    ],

    utilsProviders,
    baseBuildinputPackages =
      [
        drvs.rust,
        drvs.muslBothRenamedDl,
        drvs.pkgconf,
        llvmProvider,
        drvs.clangCc,
      ]
      @ (if enableSccache then [drvs.sccache] else [])
      @ utilsProviders,
    llvmProvider = drvs.llvmFull,

    enableSccache,
    biDrvs = [
      (drvs.findutils & { priority = 1 }),
      drvs.just,
      drvs.cosmicPlayerSources,
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
      drvs.gstreamer,
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
      drvs.libstdcppCompat,
    ],
  },
}
