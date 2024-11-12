{
  lib,
  drvs,
  rust | lib.AutotoolsPackage
    =
      let tgt = "x86_64-unknown-linux-musl" in
      {
        sourceInputs = [
          {
            src = {
              uri = "https://static.rust-lang.org/dist/rustc-1.82.0-src.tar.xz",
              sha256sum = "1276a0bb8fa12288ba6fa96597d28b40e74c44257c051d3bc02c2b049bb38210",
            },
          },
          {
            dest = "local",
            src = {
              uri = "https://static.rust-lang.org/dist/rust-std-1.81.0-x86_64-unknown-linux-musl.tar.xz",
              sha256sum = "3f2e47fff9320888993139fbd98f4bb44faf9355b25904f36a24a9808ff80240",
            }
          },
          {
            dest = "local1",
            src = {
              uri = "https://static.rust-lang.org/dist/rustc-1.81.0-x86_64-unknown-linux-musl.tar.xz",
              sha256sum = "02c29b1e17105bb286c36d4f9b28ca21feacb4a98848db103af796411cff1ec5",
            }
          },
          {
            dest = "local2",
            src = {
              uri = "https://static.rust-lang.org/dist/cargo-1.81.0-x86_64-unknown-linux-musl.tar.xz",
              sha256sum = "ece99ea9b81e283bcaa3333ec01f6776d2a0840f956a4e7e5199fc3761354e36",
            }
          },
        ],
        separateBuildDir = false,
        #isStatic=false,
        buildEnv = {
          # _isStatic=false,
          EXTRA_CFLAGS = ["-no-pie", "-fno-pie", "-fPIC"],
          EXTRA_CXXFLAGS = ["-no-pie", "-fno-pie", "-fPIC"],
          EXTRA_LDFLAGS = ["-no-pie", "-fno-pie", "-fPIC"],
        },

        unpackPhase = [
          m%"
        rust_src=$(find  /tmp/workdir/packed -name rustc-1.82.0-src.tar.xz)
        (cd /tmp/workdir/src; tar -xf $rust_src --strip-components=1)

        "%,
          "mkdir -p /tmp/workdir/build/root",
          m%"

        for s in $(find  /tmp/workdir/packed -name "*x86_64-unknown-linux-musl.tar.xz"); do
          (cd /tmp/workdir/build/root; tar -xf $s --strip-components=2)
        done
        "%,
        ],

        preConfigurePhase = [
          #   "mkdir root",
          #   "rsync -avz ${SRC}/local/rust-std-x86_64-unknown-linux-musl/ /tmp/workdir/build/root/",
          #   "rsync -avz ${SRC}/local1/rustc/ /tmp/workdir/build/root/",

          #   "rsync -avz ${SRC}/local2/cargo/ /tmp/workdir/build/root/",
          "export LD_LIBRARY_PATH=\"/tmp/workdir/build/root/lib:/usr/lib:/lib\"",

          # "mount -t proc proc /proc",
          m%"
        sed -i \
          's@\[lib\]@#\[lib\]@g'\
          ${SRC}/compiler/rustc_driver/Cargo.toml
        "%,
          m%"
        sed -i \
          's@crate-type@#crate-type@g'\
          ${SRC}/compiler/rustc_driver/Cargo.toml
        "%,
          m%"
        sed -i \
          's@"-static-pie"@"-static"@g'\
          ${SRC}/compiler/rustc_codegen_ssa/src/back/linker.rs
        "%,
          "export RUST_BACKTRACE=1",
        ],

        buildPhase = [
          "echo 'running b 0'",
          "./x.py build --stage 0 --jobs $(nproc)",
          "echo 'running b 1'",
          m%"
          RUSTC_SYSROOT=/tmp/workdir/src/build/tmp/rust/src/build/x86_64-unknown-linux-musl/stage0-sysroot/ \
          ./x.py build --keep-stage 0 --stage 1 --jobs $(nproc)
          "%,
          "echo 'running b 2'",
          m%"
          RUSTC_SYSROOT=/tmp/workdir/src/build/tmp/rust/src/build/x86_64-unknown-linux-musl/stage1-sysroot/ \
          ./x.py build --keep-stage 1 --stage 2 --jobs $(nproc)
          "%,
          "echo 'b done'",
          "./x.py install",
        ],
        # llvmProvider=drvs.llvmPic,
        llvmProvider = drvs.llvmFull,

        biDrvs = [
          drvs.pythonFull,
          drvs.rsync,
          drvs.muslShared,
          drvs.gcc,
          drvs.clangCc,
          drvs.libgccSymlinks,
          # drvs.libemptyGcc,
          # drvs.libempty,
          (drvs.llvmConfigStatic & { priority = 1 }),
          (drvs.gnutar & { priority = 1 }),
        ],
        configureFlags = [
          "--prefix=/usr",
          "--disable-docs",
          "--enable-extended",
          "--release-channel=\"stable\"",
          "--enable-local-rust",
          "--local-rust-root=/tmp/workdir/build/root",
          "--enable-vendor",
          "--enable-locked-deps",
          "--disable-codegen-tests",
          "--enable-cargo-native-static",
          "--tools=\"cargo,src\"",
          "--set=\"rust.codegen-tests=false\"",
          "--set=\"rust.musl-root=/usr\"",
          "--set=\"rust.rpath=false\"",
          # "--set=\"llvm-libunwind=in-tree\"",
          "--set=\"rust.lto=off\"",
          "--target=%{tgt}",
          "--host=%{tgt}",
          "--build=%{tgt}",
          "--set=\"target.%{tgt}.llvm-config=/usr/bin/llvm-config\"",
          "--set=\"target.%{tgt}.musl-root=/usr\"",
          # "--set=\"target.%{tgt}.crt-static=true\"",
        ],
      },
}
& (import "mrust.ncl")
& {
  lib,
  drvs,
  gnutar | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://ftp.gnu.org/gnu/tar/tar-1.35.tar.xz",
        sha256sum = "4d62ff37342ec7aed748535323930c7cf94acf71c3591882b26a7ea50f3edc16",
      },
      extraEnv = {
        FORCE_UNSAFE_CONFIGURE = "1",
      },
      biDrvs = [
        drvs.xz,
        drvs.bzip2,
        drvs.zlibNg,
        drvs.lz4,
        drvs.pkgconf,
        drvs.zstd,
      ]
    }
}
