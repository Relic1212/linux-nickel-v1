{
  lib,
  drvs,
  fhtCompositor | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/nferhat/fht-compositor/archive/refs/tags/25.10.1.tar.gz",
      sha256sum = "6ed6816a8e003b2d0b1675475bd73f5da14e5c6bd255573f7e7c154acd9adb46"
    },
    nonCrateSourceInputs = [
      {
        src = singleSource,
      },
      {
        src = {
          uri = "https://github.com/nferhat/fht-animation/archive/d64c1efd3461e27e1475ace7bbf125a298cd192c.tar.gz",
          sha256sum = "a30e0c8c099cbc1a53733a0dc9710e30b8c8a2bf65600ce83d18e11a4916bdfc"
        },
        dest = "vendor/fht-animation"
      },
      {
        src = {
          uri = "https://github.com/smithay/Smithay/archive/9ccbd35f51842934f22b5a85ca0e3be1b99b27f2.tar.gz",
          sha256sum = "ebab9f336e3cb79653b82d01e793ec006b46a8709e7407dba7ee07a4b62c87fb",
        },
        dest = "vendor-smithay",
      },
      {
        src = {
          uri = "https://gitlab.freedesktop.org/pipewire/pipewire-rs/-/archive/fd3d8f7861a29c2eeaa4c393402e013578bb36d9/pipewire-rs-fd3d8f7861a29c2eeaa4c393402e013578bb36d9.tar.bz2",
          sha256sum = "54e11f33901c3d81c43330de7cecb8380b4e4626db835fe7bd510524153f6db6"
        },
        dest = "vendor-pipewire-rs",
      },
    ],
    crates = lib.functions.filterCrates (import "./fht-compositor-crates.json"),

    configurePhase = [
      m%"echo '


[source."git+https://github.com/nferhat/fht-animation"]
git = "https://github.com/nferhat/fht-animation"
replace-with = "vendored-sources"

[source."git+https://github.com/smithay/Smithay?rev=9ccbd35f51842934f22b5a85ca0e3be1b99b27f2"]
git = "https://github.com/smithay/Smithay"
rev = "9ccbd35f51842934f22b5a85ca0e3be1b99b27f2"
replace-with = "vendored-sources"

[source."git+https://gitlab.freedesktop.org/pipewire/pipewire-rs.git"]
git = "https://gitlab.freedesktop.org/pipewire/pipewire-rs.git"
replace-with = "vendored-sources"


' >>  ${SRC}/.cargo/config.toml"%,
      "(cd vendor-pipewire-rs && cargo package --exclude-lockfile --no-verify)",
      "(cd vendor-smithay && cargo package --exclude-lockfile --no-verify)",
      "(cd vendor-smithay/smithay-drm-extras && cargo package --exclude-lockfile --no-verify)",
      "cp vendor-*/target/package/*.crate vendor/",
      "(cd vendor/ && for f in $(ls *.crate); do mv ${f} ${f}.tar.gz; tar xf ${f}.tar.gz; done)",
      m%"(cd vendor && for d in $(ls); do if [ -d ${d} ];then if [ ! -e ${d}/.cargo-checksum.json ];then echo '{"files":{},"package":null}' > ${d}/.cargo-checksum.json;fi;fi;done)"%,
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/libspa-sys*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/pipewire-sys*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys*/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit-*/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/smithay-*/Cargo.toml"%,
      m%"sed -i 's@"x11-dlopen",@@g' ${SRC}/vendor/winit-*/Cargo.toml"%,
      m%"sed -i 's@"runtime",@@g' ${SRC}/vendor/rustix*/Cargo.toml"%,
      m%"sed -i 's@"use-libc-auxv",@@g' ${SRC}/vendor/rustix*/Cargo.toml"%,
      "echo '%{import "symbols.c" as 'Text}' > symbols.c",
      "clang -c -O2 symbols.c -o symbols.c.o",
    ],
    buildEnv.EXTRA_LDFLAGS = [
      "-lc++",
      "-lcap",
      # "-ldl_factory",
    ],
    extraEnv.EXTRA_RUSTFLAGS = [
      "-C link-arg=-lc++",
      "-C link-arg=-lcap",
      # "-C link-arg=-ldl_factory",
      "-C link-arg=-linput",
      "-C link-arg=-lm",
      "-C link-arg=-ludev",
      "-C link-arg=-pthread",
      "-C link-arg=-levdev",
      "-C link-arg=-lrt",
      "-C link-arg=-lmtdev",
      "-C link-arg=$(clang --print-file-name=libclang_rt.builtins-x86_64.a)",
      m%"$(for l in $(pkg-config --libs --static egl);do printf " -C link-arg=$l ";done)"%,
      "-C link-arg=/tmp/workdir/src/symbols.c.o",
    ],
    llvmProvider = drvs.llvmFull,
    # muslProvider = drvs.muslDlFactory & { priority = 1 },
    biDrvs = [
      drvs.muslDlFactory & { priority = 1 },
      # drvs.libdlFactory,
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
      # drvs.gtk3,
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
      # drvs.libepoxy,
      drvs.libevdev,
      drvs.libffi,
      # drvs.libfreeaptx,
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
      drvs.mtdev,
      drvs.ncurses,
      drvs.openssl,
      drvs.pango,
      drvs.pcre2,
      drvs.pixman,
      drvs.readline,
      drvs.sbc,
      # drvs.seatd,
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
      drvs.mesaExp,
    ],

    propagatedBuildInputs = [
      drvs.seatd,
    ],
  },
}
