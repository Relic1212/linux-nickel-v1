{
  lib,
  drvs,
  ironbar | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/JakeStanger/ironbar/archive/4917a8401cc9920b8925bf4892517ace894f814c.tar.gz",
      sha256sum = "4d7a520514731393d97f5fd130e72e5da15f880cab5ec22a15791344985bcc35",
    },
    crates = lib.functions.filterCrates (import "ironbar-crates.json"),
    # linkSelfContained = "no",
    extraEnv = {
      EXTRA_RUSTFLAGS = [
        "-C link-arg=/tmp/workdir/src/dlopen.o",
        # "-C link-arg=-no-pie",
        # "-C relocation-model=static",

        # "-C link-arg=-l:libdl_ashell",
        # "-C link-arg=$(clang --print-file-name=libclang_rt.builtins-x86_64.a)",
        "-C link-arg=-lc++",
        m%"$(for l in $(pkg-config --libs --static xkbcommon libpulse egl wayland-client wayland-egl);do printf " -C link-arg=$l ";done)"%,
      ],
    },
    extraCargoFlags = [
      "--verbose",
    ],
    configurePhase = [
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
      #
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      ######
      ######
      m%"sed -i 's@libpulse.so.0@libpulse.a@g' ${SRC}/vendor/libpulse-sys*/build.rs"%,
      #   m%"sed -i 's@"-Cprefer-dynamic=yes",@#"-Cprefer-dynamic=no",@g'  ${SRC}/vendor/cc-1.2.51/src/flags.rs"%,
      m%"sed -i 's@prefer-dynamic=yes@prefer-dynamic=no@g'  ${SRC}/vendor/cc-1.2.51/src/flags.rs"%,
      #
      "echo '%{import "ironbar_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      m%"
      echo '
      [source.crates-io]
      replace-with = "vendored-sources"
      
      [source.vendored-sources]
      directory = "vendor"
      ' > ${SRC}/.cargo/config.toml
      "%,
      "cargo tree --target=x86_64-unknown-linux-musl -e features",
    ],

    muslProvider = drvs.muslBothRenamedDl,
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.atSpi2Core,
      drvs.cairo,
      drvs.cairoGobject,
      drvs.cairomm_1_16,
      drvs.dbus,
      drvs.expat,
      drvs.eudev,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.glibPatched,
      drvs.glibmm_2_82,
      drvs.gobjectDynamic,
      drvs.gperf,
      drvs.graphene,
      drvs.gtk4,
      drvs.gtk4LayerShell,
      drvs.gtkmm4,
      drvs.harfbuzzFull,
      drvs.hwdata,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxy,
      drvs.libevdev,
      drvs.libffi,
      drvs.libjpegTurboStatic,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libsigcpp,
      drvs.libtiff,
      drvs.libxkbcommon,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.mesaExp,
      drvs.ncurses,
      drvs.pango,
      drvs.pangomm_2_48,
      drvs.pcre2,
      drvs.pixman,
      drvs.readline,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.vala,
      drvs.waylandGtk4LayerShell,
      drvs.waylandProtocols,
      drvs.zlibNg,
      #
      drvs.kmod,
      drvs.xz,
      drvs.openssl,
      drvs.zstd,
      drvs.utilLinux,
      #
      drvs.luajitStatic,
      #
      drvs.libinput,
      drvs.mtdev,
      #
      drvs.alsaLibs,
      drvs.bluez,
      drvs.sbc,
      drvs.ffmpeg,
      drvs.speex,
      drvs.speexdsp,
      drvs.check,
      drvs.pulseaudio17,
    ],
  }
}
