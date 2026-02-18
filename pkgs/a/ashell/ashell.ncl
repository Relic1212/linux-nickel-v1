{
  lib,
  drvs,
  _CargoFetcher,
  ashellSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = {
        uri = "https://github.com/MalpenZibo/ashell/archive/refs/tags/0.7.0.tar.gz",
        sha256sum = "ea73d22b729ec2c4bb6af1cfce4cb597e8c9c6d657776d3d5575d4e3868925b6",
      },
      outputSha256sum = "511df02a6139c57feee4c83c037d74eaaa4732fc586bfb0d768061f27b2fcebd"
    },
  ashell | lib.CargoPackage = {

    buildEnv = {
      EXTRA_LDFLAGS = [
        "/tmp/workdir/src/dlopen.o",
        # "-l:libdl_ashell.a"
      ]
    },

    extraEnv = {
      EXTRA_RUSTFLAGS = [
        "-C link-arg=/tmp/workdir/src/dlopen.o",

        # "-C link-arg=-l:libdl_ashell",
        "-C link-arg=$(clang --print-file-name=libclang_rt.builtins-x86_64.a)",
        m%"$(for l in $(pkg-config --libs --static xkbcommon libpulse);do printf " -C link-arg=$l ";done)"%,
      ],
    },
    preConfigurePhase = [
      "tar xf /sources.tar",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/libspa-sys/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/pipewire-sys/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      ######
      m%"sed -i 's@"x11-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      ######
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/accesskit_winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/iced_winit/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@\["dlopen"\]@\[\]@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer/Cargo.toml"%,
      m%"sed -i 's@libpulse.so.0@libpulse.a@g' ${SRC}/vendor/libpulse-sys*/build.rs"%,
      "echo '%{import "ashell_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      # "ar rcs libdl_ashell.a dlopen.o",
      # "ranlib libdl_ashell.a",

      # (import "add-link.sh" as 'Text),
    ],

    llvmProvider = drvs.llvmFull,
    # muslProvider = drvs.muslAshell & { priority = 1 },
    muslProvider = drvs.muslBothWeakDl & { priority = 1 },

    biDrvs = [
      drvs.ashellSources,
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
      drvs.seatd,
      drvs.elogindWithPolkit,
      drvs.libcap,
      drvs.pulseaudio17,
    ],
  },
  muslBothRenamedDl,
  muslAshell | lib.AutotoolsPackage =
    muslBothRenamedDl
    & {
      postInstallPhase | priority 1 =
        muslBothRenamedDl.postInstallPhase
        @ [
          "mkdir ${SRC}/dl_obj",
          "mv ${DEST}/usr/lib/libc.a ${SRC}/dl_obj",
          "cd ${SRC}/dl_obj",
          # "ar x libc.a",
          # "rm libc.a",
          "echo '%{import "ashell_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
          "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o dlopen_wrapped.lo",
          "ar rcs libc.a *.lo",
          # "ranlib libc.a",
          "install -m0755 libc.a ${DEST}/usr/lib",
        ]
    }
}
