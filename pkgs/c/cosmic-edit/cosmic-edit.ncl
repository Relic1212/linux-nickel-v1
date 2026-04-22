{
  lib,
  drvs,
  _CargoFetcher,
  _cosmicSrcs,
  _cosmicSrcs,

  cosmicEditSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = _cosmicSrcs."cosmic-edit",

      outputSha256sum = (import "src.sha256sum" as 'Text), # "69e20209a2b8221dbf119bc17f8d575f1505ee5738a99e56313707de83afa9a5"
      # preConfigurePhase = [
      #   "cargo update -p compio-driver --precise 0.11.2",
      # ]
    },
}
& {
  lib,
  drvs,
  cosmicEdit | lib.CargoPackage = {

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
      "echo '%{import "../cosmic-osk/cosmic_osk_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
    ],
    extraEnv = {

      # cosmic-epoch alpha
      VERGEN_GIT_COMMIT_DATE = "9e13a3e47a41296e815ecffef086746dd6bb44bc",
      VERGEN_GIT_SHA = "'Sat Apr 26 13:09:25 2025 +0530'",
      EXTRA_RUSTFLAGS = [
        "-C link-arg=/tmp/workdir/src/dlopen.o",
        m%"$(for l in $(pkg-config --libs --static xkbcommon);do printf " -C link-arg=$l ";done)"%,
      ],
    },

    patches = [
      # {
      #   sha256sum = "ae7010ae3fd4b4603789a9cb58e5fd40bea31b728bed9fd112c581c039d39527",
      #   file = "cosmic-osd-xkb.patch",
      # },
      # {
      #   sha256sum = "a81c62ef7a5d5e0bcefa23b1bf5ed252f3df41dbbe24ba9523aaa38c180bee07",
      #   file = "winit-common-xkb.patch",
      # },
    ],
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

    enableSccache = true,
    biDrvs = [
      (drvs.findutils & { priority = 1 }), # xargs -d
      drvs.just,
      drvs.cosmicEditSources,
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
      drvs.libstdcppCompat,
    ],
  },
}
