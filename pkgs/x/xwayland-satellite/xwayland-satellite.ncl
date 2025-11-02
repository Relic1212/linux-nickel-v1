{
  lib,
  drvs,
  xwaylandSatellite | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/Supreeeme/xwayland-satellite/archive/refs/tags/v0.7.tar.gz",
      sha256sum = "466fc8d44b45f446a581549ab4e55ce65aa32e090e98638dde79f9da9faf89a0"
    },
    crates = lib.functions.filterCrates (import "crates.json"),
    configurePhase = [
      m%"sed -i 's/\("files":{\)[^}]*/\1/' ${SRC}/vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys-*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen-*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/xcb-util-cursor-sys-*/Cargo.toml"%,
    ],

    buildEnv = {
      EXTRA_LDFLAGS = ["(pkg-config --libs --static xcb-cursor xcb-renderutil)"]
    },
    extraEnv = {
      PKGCONFIG = "\"pkg-config --static\"",
      EXTRA_RUSTFLAGS =
        std.array.map (fun a => "-C link-arg=%{a}") (std.string.split " " "-lxcb-cursor -lxcb -lXau -lxcb-render -lxcb -lXau -lxcb-render-util -lxcb -lXau -lxcb-render -lxcb -lXau -lxcb-image -lxcb -lXau -lxcb-shm -lxcb -lXau -lxcb-util"),
    },

    options = {
      glx | default = false,
    },

    llvmProvider = drvs.llvmFull,

    biDrvs =
      [
        #drvs.cairo,
        drvs.atSpi2Core,
        drvs.cairoXlib,
        drvs.expat,
        drvs.fontconfig,
        drvs.freetype,
        drvs.fribidi,
        drvs.gdkPixbufFull,
        drvs.glibDynamic,
        drvs.gobjectDynamic,
        drvs.gperf,
        drvs.harfbuzz,
        drvs.hwdata,
        drvs.libdrm,
        drvs.libelf,
        drvs.libepoxyX11,
        drvs.libffi,
        drvs.libfontenc,
        drvs.libjpegTurbo,
        drvs.libpciaccess,
        drvs.libpng,
        drvs.libx11,
        drvs.libxau,
        drvs.libxcb,
        drvs.libxcursor,
        drvs.libxcvt,
        drvs.libxfixes,
        drvs.libxfont2,
        drvs.libxkbcommon,
        drvs.libxkbfile,
        drvs.libxrender,
        drvs.libxshmfence,
        drvs.linuxHeaders,
        drvs.llvmConfigStatic,
        # drvs.mesa2,
        drvs.ncurses,
        drvs.openssl,
        drvs.pango,
        drvs.pcre2,
        drvs.pixman,
        drvs.readline,
        drvs.spirvLlvmTranslator,
        drvs.spirvTools,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.xcbProto,
        drvs.xcbRenderutil,
        drvs.xcbUtilWm,
        drvs.xorgMacros,
        drvs.xorgproto,
        drvs.xtrans,
        drvs.xwayland,
        drvs.zlibNg,
        drvs.isoCodes,
        drvs.libxext,
        drvs.libxf86vm,
        drvs.libxrandr,
        drvs.libxi,
        drvs.dbus,
        drvs.xcbUtilCursor,
        drvs.xcbUtilImage,
        drvs.xcbUtil,
        drvs.libstdcppCompat,
      ]
      @ (
        if options.glx then
          [
            drvs.xcbUtilErrors,
            drvs.mesaGlx,
          ]
        else
          [
            drvs.mesa2,
          ]
      ),
  }
}
& {
  lib,
  drvs,
  xcbUtilCursor | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.5.tar.xz",
      sha256sum = "0caf99b0d60970f81ce41c7ba694e5eaaf833227bb2cbcdb2f6dc9666a663c57"
    },
    biDrvs = [
      drvs.libxcursor,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
      drvs.zlibNg,
      drvs.xcbRenderutil,
      drvs.xcbUtilWm,
      drvs.pkgconf,
      drvs.m4,
      drvs.bison,
      drvs.xcbUtilImage,
      drvs.xcbUtil,
    ]
  }
}
