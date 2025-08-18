{
  lib,
  drvs,
  niri | lib.CargoPackage =
    # let _xkbcommon_rs = {
    #   "0.1.0" | lib.Crate = {
    #     name = "xkbcommon-rs",
    #     version = "0.1.0",
    #     sha256sum = "1d02316af6831aee03a1ecc7b887ec1e983f4cc43792b80faade552cd7e710c6",
    #     sourceInput = {
    #       dest | priority 1 = ""
    #     }
    #   },
    # }
    # in

    {
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
        {
          src = {
            uri = "https://github.com/rust-windowing/winit/archive/58402b58cf660e236e825b36287a8fc2abfb1f5d.tar.gz",
            sha256sum = "f53ca2163ab21fe746b4697c18438453b2563e3dc94358a259abd78c047af567",
          },
          dest = "vendor-winit",
        }
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

      unpackPhase = [
        "(cd /tmp/workdir/src; tar -xf $(find /tmp/workdir/packed -name 'v*.tar.gz') --strip-components=1)",
        "mkdir /tmp/workdir/src/vendor -p",
        "(cd /tmp/workdir/src/vendor; tar -xf $(find /tmp/workdir/packed -name 'niri-*-vendored-dependencies.tar.xz') --strip-components=1)",
        "mkdir /tmp/workdir/src/vendor-winit -p",
        "(cd /tmp/workdir/src/vendor-winit; tar -xf $(find /tmp/workdir/packed -name '58402b58cf660e236e825b36287a8fc2abfb1f5d.tar.gz') --strip-components=1)",
      ],

      configurePhase =
        [

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
          m%"sed -i 's@"backend_winit",@@g' ${SRC}/Cargo.toml"%
        ]
        @ [

          #"(cd ${SRC}/vendor/winit-0.30.9 && patch -p1 < /tmp/workdir/patches/513604e0cb15da96e6d3c76b4afc5148b1a8f873.patch)",
        ],

      patches = [
        {

          file = "513604e0cb15da96e6d3c76b4afc5148b1a8f873.patch",
          sha256sum = "ca62a08327c426ae8d16796e8ab6add94d9d9bab9507f4b8d8a7320baad6aff5",
        }
      ],
      patchPhase = [],

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
