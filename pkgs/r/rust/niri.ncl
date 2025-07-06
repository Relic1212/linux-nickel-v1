{
  lib,
  expat,
  jsonC,
  pcre2,
  mesa2,
  wayland,
  waylandProtocols,
  libelf,
  libpciaccess,
  libdrm,
  libxkbcommon,
  pixman,
  eudev,
  libudevZero,
  seatd,
  libdisplayinfo,
  libinput,
  libffi,
  libevdev,
  mtdev,
  pango,
  cairo,
  libpng,
  freetype,
  fontconfig,
  zlibNg,
  harfbuzz,
  glib,
  hwdata,
  linuxHeaders,
  cairoGobjectEmpty,
  llvmFull,

  niri | lib.CargoPackage =
    let _xkbcommon_rs = {
      "0.1.0" | lib.Crate = {
        name = "xkbcommon-rs",
        version = "0.1.0",
        sha256sum = "1d02316af6831aee03a1ecc7b887ec1e983f4cc43792b80faade552cd7e710c6",
        sourceInput = {
          dest | priority 1 = ""
        }
      },
    }
    in

    {
      buildEnv = {
        EXTRA_LDFLAGS = ["-lc++"],
      },
      extraEnv = {
        RUSTFLAGS = ["-C target-feature=+crt-static -C link-self-contained=yes -C link-arg=-lc++ -C link-arg=-levdev -C link-arg=-lmtdev -C link-arg=-static -C link-arg=--static"],
      },
      nonCrateSourceInputs = [
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
      crates = {
        # xkbcommon_rs=_xkbcommon_rs,
      },
      llvmProvider = lib.singleBiMap llvmFull,
      biDrvs =
        lib.biMap [
          expat,
          jsonC,
          pcre2,
          mesa2,
          wayland,
          waylandProtocols,
          libelf,
          libpciaccess,
          libdrm,
          libxkbcommon,
          pixman,
          # eudev,
          libudevZero,
          seatd,
          libdisplayinfo,
          libinput,
          libffi,
          libevdev,
          mtdev,
          pango,
          cairo,
          libpng,
          freetype,
          fontconfig,
          zlibNg,
          harfbuzz,
          glib,
          hwdata,
          linuxHeaders,
          cairoGobjectEmpty,
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
        # m%"
        #     sed -i \
        #         's@"0.4.2"@"0.8.0"@g' \
        #         ${SRC}/vendor/winit/Cargo.toml
        #     "%,
        # m%"
        #     sed -i \
        #         's@xkbcommon-dl@xkbcommon@g' \
        #         ${SRC}/vendor/winit/Cargo.toml
        #     "%,
        m%"
        echo "
        [target.'cfg(all(unix))'.dependencies.xkbcommon]
        version = \"0.8.0\"

        " >> ${SRC}/vendor/winit/Cargo.toml
        "%,

        # dl 1 (compose)
        # m%"
        #     sed -i \
        #         's@xkbcommon_dl@xkbcommon::xkb::ffi::compose@g' \
        #         ${SRC}/vendor/winit/src/platform_impl/linux/common/xkb/compose.rs
        #     "%,
        #     m%"
        #     sed -i \
        #         's@, xkb_keysym_t,@,@g' \
        #         ${SRC}/vendor/winit/src/platform_impl/linux/common/xkb/compose.rs
        #     "%,
        #     m%"
        #     sed -i \
        #         's@use smol_str::SmolStr;@use smol_str::SmolStr;\nuse xkbcommon::xkb::ffi::{ xkb_keysym_t, };@g' \
        #         ${SRC}/vendor/winit/src/platform_impl/linux/common/xkb/compose.rs
        #     "%,
        #     # dl 1 (event_processor)

        #     m%"
        #     sed -i \
        #         's@use xkbcommon_dl::xkb_mod_mask_t@use xkbcommon::xkb::ffi::xkb_mod_mask_t@g' \
        #         ${SRC}/vendor/winit/src/platform_impl/linux/x11/event_processor.rs
        #     "%,

        #     # dl 3 (state)
        #     m%"
        #      sed -i \
        #         's@use xkbcommon_dl::@use xkbcommon::xkb::ffi::@g' \
        #         ${SRC}/vendor/winit/src/platform_impl/linux/common/xkb/state.rs

        #     sed -i \
        #         's@self as xkb,@@g' \
        #         ${SRC}/vendor/winit/src/platform_impl/linux/common/xkb/state.rs

        #      sed -i \
        #         's@use smol_str::SmolStr;@use smol_str::SmolStr;\nuse xkbcommon::{ xkb, };@g' \
        #         ${SRC}/vendor/winit/src/platform_impl/linux/common/xkb/state.rs

        #     "%,

        # dl 4 (mod)
        # m%"
        #  sed -i \
        #     's@use xkbcommon_dl::@use xkbcommon::xkb::ffi::@g' \
        #     ${SRC}/vendor/winit/src/platform_impl/linux/common/xkb/mod.rs

        # sed -i \
        #     's@self as xkb,@@g' \
        #     ${SRC}/vendor/winit/src/platform_impl/linux/common/xkb/mod.rs

        #  sed -i \
        #     's@use smol_str::SmolStr;@use smol_str::SmolStr;\nuse xkbcommon::{ xkb, };@g' \
        #     ${SRC}/vendor/winit/src/platform_impl/linux/common/xkb/mod.rs

        # "%,
        # keymap?

        # winit checksum
        m%"
        	sed -i 's/\("files":{\)[^}]*/\1/' vendor/winit/.cargo-checksum.json
            "%,
        # end winit, befin smithay
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

        # unpack xkbcommon_rs to vendor

        # m%"
        # mkdir -p ${SRC}/vendor/xkbcommon_rs
        # mv /tmp/workdir/packed/%{crates.xkbcommon_rs."0.1.0".sha256sum}/download ${SRC}/vendor/xkbcommon_rs/download.tar.gz

        # tar -xf \
        #   ${SRC}/vendor/xkbcommon_rs/download.tar.gz \
        #   -C ${SRC}/vendor/xkbcommon_rs \
        #   --strip-components=1

        # echo '{"package":"'"$(sha256sum ${SRC}/vendor/xkbcommon_rs/download.tar.gz|cut -d ' ' -f1)"'","files":{}}' >  ${SRC}/vendor/xkbcommon_rs/.cargo-checksum.json

        # "%
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
  cairoGobjectEmpty | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/usr/lib/pkgconfig",
      "cd ${DEST}/usr/lib/pkgconfig",
      "ln -s cairo.pc cairo-gobject.pc",
    ]
  }
}
