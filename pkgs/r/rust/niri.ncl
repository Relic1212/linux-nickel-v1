{
  lib,
  drvs,
  niri | lib.CargoPackage
    = {
      buildEnv = {
        EXTRA_LDFLAGS = ["-lc++"],
      },
      extraEnv = {
        RUSTFLAGS = ["-C target-feature=+crt-static -C link-self-contained=yes -C link-arg=-lc++ -C link-arg=-levdev -C link-arg=-lmtdev -C link-arg=-static -C link-arg=--static"],
      },
      sourceInputs = [
        {
          src = {
            uri = "https://github.com/YaLTeR/niri/archive/refs/tags/v0.1.10.tar.gz",
            sha256sum = "2a6e6c21b05c14498eb84e58853c0a4c9d96d4215b8aec53388e89266fccca1b",
          }
        },
        {
          dest = "vendor",
          src = {
            uri = "https://github.com/YaLTeR/niri/releases/download/v0.1.10/niri-0.1.10-vendored-dependencies.tar.xz",
            sha256sum = "2246443925ad4e7e730e2c556ebf3ac86f0f302dc626bce1193fa84deaded8b8"
          }
        }
      ],
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
        "(cd /tmp/workdir/src; tar -xf $(find /tmp/workdir/packed -name v0.1.10.tar.gz) --strip-components=1)",
        "mkdir /tmp/workdir/src/vendor -p",
        "(cd /tmp/workdir/src/vendor; tar -xf $(find /tmp/workdir/packed -name niri-0.1.10-vendored-dependencies.tar.xz) --strip-components=1)",
      ],

      preConfigurePhase = [
        "mkdir -p /tmp/home",
        "export HOME=/tmp/home",
        "mkdir -p ${HOME}/.cargo",
        "ln -s $(realpath vendor) ${HOME}/vendor",
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

                " > ${HOME}/.cargo/config.toml
                "%,
        "cp -r ${HOME}/.cargo .",
        "CARGO_HOME=$(realpath .cargo)",
        "export CARGO_HOME",
        "RUST_BACKTRACE=full",

        # checksum removal from Alpine
        m%"
            sed -i \
                's@"wayland-dlopen",@@g' \
                ${SRC}/vendor/winit/Cargo.toml
            "%,
        m%"
            sed -i \
                's@"x11",@@g' \
                ${SRC}/vendor/winit/Cargo.toml
            "%,

        # m%"
        # sed -i \
        #     's@wayland-dlopen@#wayland-dlopen@g' \
        #     ${SRC}/vendor/winit/Cargo.toml
        # "%,
        # "rm -r ${SRC}/vendor/winit/wayland-backend/dlopen",
        m%"
            sed -i \
                's@"0.4.2"@"0.8.0"@g' \
                ${SRC}/vendor/winit/Cargo.toml
            "%,
        m%"
            sed -i \
                's@xkbcommon-dl@xkbcommon@g' \
                ${SRC}/vendor/winit/Cargo.toml
            "%,
        m%"
            sed -i \
                's@xkbcommon_dl@xkbcommon@g' \
                ${SRC}/vendor/winit/src/platform_impl/linux/common/xkb/compose.rs
            "%,
        m%"
        	sed -i 's/\("files":{\)[^}]*/\1/' vendor/winit/.cargo-checksum.json
            "%,
        m%"
            sed -i \
                's@"wayland-dlopen",@@g' \
                ${SRC}/vendor/smithay/Cargo.toml
            "%,
        m%"
            sed -i \
                's@"x11",@@g' \
                ${SRC}/vendor/smithay/Cargo.toml
            "%,
        m%"
        	sed -i 's/\("files":{\)[^}]*/\1/' vendor/smithay/.cargo-checksum.json
            "%,
        # sct
        m%"
            sed -i \
                's@"xkbcommon",@@g' \
                ${SRC}/vendor/smithay-client-toolkit/Cargo.toml
            "%,
        m%"
        	sed -i 's/\("files":{\)[^}]*/\1/' vendor/smithay-client-toolkit/.cargo-checksum.json
            "%,
        "rm -rf vendor/x11-dl",
        # "rm -rf vendor/smithay-client-toolkit",

        # "rm -rf vendor/xkbcommon-dl",
      ],

      # always pass target? https://github.com/rust-lang/rust/issues/78210
      buildPhase = [
        "cargo build --target x86_64-unknown-linux-musl --offline --no-default-features"
      ],
      installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 target/x86_64-unknown-linux-musl/debug/niri ${DEST}/usr/bin",
      ]
    },
  cairoGobjectEmpty | lib.Package
    = {
      installPhase = [
        "install -d -m0755 ${DEST}/usr/lib/pkgconfig",
        "cd ${DEST}/usr/lib/pkgconfig",
        "ln -s cairo.pc cairo-gobject.pc",
      ]
    }
}
& {
  drvs,
  lib,
  cairo,
  cairo2 =
    cairo
    & {
      extraMesonArgs | priority 1
        =
          cairo.extraMesonArgs
          @ [
            "-Dglib=enabled",
          ],
      biDrvs | priority 1
        =
          cairo.biDrvs
          @ [
            drvs.glib,
          ]
    }
}
