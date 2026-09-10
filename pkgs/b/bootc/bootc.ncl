{
  lib,
  drvs,
  bootc | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/bootc-dev/bootc/archive/refs/tags/v1.16.11.tar.gz",
      sha256sum = "94efd51df637c1b00500fc8bcd87eae45b16c0a11dafaa640373b7d64eaa7e66",
    },

    sourceInputs = [
      {
        src = singleSource,
      },
      {
        src = {
          uri = "https://github.com/bootc-dev/bootc/releases/download/v1.16.11/bootc-1.16.11-vendor.tar.zstd",
          sha256sum = "ca63783cee1c54230020b20c5500cd83d0c533714fd099801907ac25099e511b",
        },
        dest = "vendor"
      }
    ],
    extraEnv = {
      OPENSSL_NO_VENDOR = "1",

      EXTRA_RUSTFLAGS = [
        m%"$(for l in $(pkg-config --libs --static ostree-1);do printf " -C link-arg=$l ";done)"%,
      ],
    },
    preConfigurePhase = [
      lib.functions.writeFile
        ".cargo/config.toml"
        m%"[source.crates-io]
replace-with = "vendored-sources"

[source."git+https://github.com/bootc-dev/bcvk?rev=13d860c2a916d0f4cdcc5a817af0042b9cafee86"]
git = "https://github.com/bootc-dev/bcvk"
rev = "13d860c2a916d0f4cdcc5a817af0042b9cafee86"
replace-with = "vendored-sources"

[source."git+https://github.com/composefs/composefs-rs?tag=v0.9.0"]
git = "https://github.com/composefs/composefs-rs"
tag = "v0.9.0"
replace-with = "vendored-sources"

[source.vendored-sources]
directory = "vendor"
"%,
      "export CARGO_HOME=${SRC}/.cargo",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen/Cargo.toml"%,
      m%"sed -i 's@VHOST_VSOCK_SET_GUEST_CID,@VHOST_VSOCK_SET_GUEST_CID.try_into().unwrap(),@g' ${SRC}/vendor/bcvk-qemu/src/qemu.rs"%,
      m%"sed -i 's@_MAGIC @_MAGIC as u64@g' ${SRC}/crates/lib/src/*.rs"%,
      "cargo tree --target=x86_64-unknown-linux-musl -e features",
    ],
    # installPhase = [
    #   "make PREFIX=/usr DESTDIR=${DEST} install",
    # ],

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.gnutar & { priority = 1 },
      # drvs.zstd,
      # drvs.gnumake,
      drvs.musl,
      drvs.llvmConfigStatic,
      drvs.libstdcppCompat,
      drvs.linuxHeaders,
    ],
    pDrvs = [
      # drvs.openssl,
      # drvs.zlibNg,
      # drvs.glib,
      drvs.ostree,
      drvs.selinux,
      drvs.ncurses,
    ],
  }
}
