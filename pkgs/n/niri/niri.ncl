{
  lib,
  drvs,
  niri | lib.CargoPackage = {
    buildEnv = {
      EXTRA_LDFLAGS = ["-lc++"],
    },
    extraEnv = {
      # https://github.com/NixOS/nixpkgs/pull/264517#issuecomment-1817817060
      EXTRA_RUSTFLAGS = [
        "-C link-arg=-Wl,--push-state,--no-as-needed",
        "-C link-arg=-lEGL",
        "-C link-arg=-lwayland-client",
        "-C link-arg=-Wl,--pop-state",
        "-C link-arg=-lc++",

        # pkg-config --libs --static libinput
        "-C link-arg=-linput",
        "-C link-arg=-lm",
        "-C link-arg=-ludev",
        "-C link-arg=-pthread",
        "-C link-arg=-levdev",
        "-C link-arg=-lrt",
        "-C link-arg=-lmtdev",
      ],
    },
    extraCargoFlags = [
      "--no-default-features",
      # "--verbose",
    ],
    nonCrateSourceInputs = [
      {
        src = {
          uri = "https://github.com/YaLTeR/niri/archive/refs/tags/v25.05.1.tar.gz",
          sha256sum = "2df192fa85adbb0eabcfddbd8aa812c3d3329a582a7e62212ea9fcddafa79b00",
        }
      },
      {
        dest = "vendor",
        src = {
          uri = "https://github.com/YaLTeR/niri/releases/download/v25.05.1/niri-25.05.1-vendored-dependencies.tar.xz",
          sha256sum = "4c2b2b3fc8340c02f3ba2581b50847f1d9e0fab986bebf53aaf045fa54b9a3c2"
        }
      },
    ],
    # crates = {
    # xkbcommon_rs=_xkbcommon_rs,
    # },
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.expat,
      drvs.jsonC,
      drvs.pcre2,
      drvs.mesa2,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libelf,
      drvs.libpciaccess,
      drvs.libdrm,
      drvs.libxkbcommon,
      drvs.pixman,
      # drvs.eudev,
      drvs.libudevZero,
      drvs.seatd,
      drvs.libdisplayinfo,
      drvs.libinput,
      drvs.libffi,
      drvs.libevdev,
      drvs.mtdev,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.freetype,
      drvs.fontconfig,
      drvs.zlibNg,
      drvs.harfbuzz,
      drvs.glib,
      drvs.hwdata,
      drvs.linuxHeaders,
      drvs.cairoGobjectEmpty,
    ],

    patches = [
      {
        sha256sum = "22aa848609c9ce793c080fe5b0ecaac790b7bf2bbc92c4d51796c6493de5bce6",
        file = "niri.patch",
      }
    ],

    unpackPhase = [
      "(cd /tmp/workdir/src; tar -xf $(find /tmp/workdir/packed -name 'v*.tar.gz') --strip-components=1)",
      "mkdir /tmp/workdir/src/vendor -p",
      "(cd /tmp/workdir/src/vendor; tar -xf $(find /tmp/workdir/packed -name 'niri-*-vendored-dependencies.tar.xz') --strip-components=1)",
    ],

    configurePhase = [

      # checksum removal from Alpine
      #m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      #m%"sed -i 's@"x11",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      m%"
            echo "
            [source.crates-io]
            replace-with = \"vendored-sources\"
            
            [source.\"git+https://github.com/Smithay/smithay.git\"]
            git = \"https://github.com/Smithay/smithay.git\"
            replace-with = \"vendored-sources\"

            [source.\"git+https://gitlab.freedesktop.org/pipewire/pipewire-rs.git\"]
            git = \"https://gitlab.freedesktop.org/pipewire/pipewire-rs.git\"
            replace-with = \"vendored-sources\"


            [source.vendored-sources]
            directory = \"vendor\"

            " > ${SRC}/.cargo/config.toml
            "%,
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/smithay/.cargo-checksum.json"%,
      # sct
      # m%"
      # sed -i \
      #   's@"xkbcommon",@@g' \
      #   ${SRC}/vendor/smithay-client-toolkit/Cargo.toml
      # "%, # echo "
      # [target.'cfg(all(unix))'.dependencies.xkbcommon]
      # version = \"0.8.0\"

      # " >> ${SRC}/vendor/winit/Cargo.toml
      # "%,

      # winit checksum
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/winit/.cargo-checksum.json"%,
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/smithay-client-toolkit/.cargo-checksum.json"%,
      # "rm -rf vendor/x11-dl",
    ],

    release = false,
  },
  cairoGobjectEmpty | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/usr/lib/pkgconfig",
      "cd ${DEST}/usr/lib/pkgconfig",
      "ln -s cairo.pc cairo-gobject.pc",
    ]
  }
}
# & (import "libdl-egl.ncl")
