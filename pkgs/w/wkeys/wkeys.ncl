{
  lib,
  drvs,

  _CargoFetcher,
  wkeysSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = {
        uri = "https://github.com/ptazithos/wkeys/archive/13ceae730f2433f3ac398224dafa539ae55d3f54.tar.gz",
        sha256sum = "b6f432f87ff8391b244cdc64b2ae1e6e23643483c2587ef603bbe0de1aaa66ac",
      },

      outputSha256sum = "460eb9196d982d024d3975de6b8ff22ed7a9a2036c59d521dc2050bf0aa8bdc1",
    },
  wkeys | lib.CargoPackage = {

    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    extraEnv = {
      STATIC_RUSTFLAGS = [
        "-C target-feature=+crt-static",
        "-C link-self-contained=no",
        "-C link-arg=-static",
        "-C link-arg=--static"
      ],
      EXTRA_RUSTFLAGS = [
        "-C link-arg=/tmp/workdir/src/dlopen.o",
        "-C link-arg=-lc++",
        m%"$(for l in $(pkg-config --libs --static gtk4-layer-shell-0 egl);do printf " -C link-arg=$l ";done)"%,
      ],
    },
    preConfigurePhase = [
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/accesskit_winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/iced_winit/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@\["dlopen"\]@\[\]@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer/Cargo.toml"%,
      m%"sed -i 's@"softbuffer/wayland-dlopen",@@g' ${SRC}/vendor/iced_tiny_skia/Cargo.toml"%,
      "echo '%{import "../../g/gtk4-layer-shell/gtk4_layer_shell_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      "cargo tree --target=x86_64-unknown-linux-musl -e features",
    ],

    llvmProvider = drvs.llvmFull,
    muslProvider = drvs.muslBothRenamedDl,
    biDrvs = [
      drvs.atSpi2Core,
      drvs.cairoGobject,
      drvs.expat,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.glib,
      drvs.gobjectDynamic,
      drvs.gperf,
      drvs.graphene,
      drvs.gtk4,
      drvs.harfbuzzFull,
      drvs.hwdata,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxy,
      drvs.libffi,
      drvs.libjpegTurbo,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libtiff,
      drvs.libxkbcommon,
      drvs.libxml2,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.mesa2,
      drvs.ncurses,
      drvs.pango,
      drvs.pcre2,
      drvs.pixman,
      drvs.readline,
      drvs.sharedMimeInfo,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.waylandGtk4LayerShell,
      drvs.gtk4LayerShell,
      drvs.waylandProtocols,
      drvs.wkeysSources,
      drvs.zlibNg,
    ]
  }
}
