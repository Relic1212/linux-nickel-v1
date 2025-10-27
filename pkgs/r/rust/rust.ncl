{
  lib,
  drvs,
  rust | lib.AutotoolsPackage =
    let tgt = "x86_64-unknown-linux-musl" in
    {
      # symlinkBuldInputs = true,

      sourceInputs = [
        {
          src = {
            # uri = "https://static.rust-lang.org/dist/rustc-1.85.1-src.tar.xz",
            # sha256sum = "b1fbf809efe9f036939401e142631c201a53bcf43ec1696bd9f5290ba236a266",

            uri = "https://static.rust-lang.org/dist/rustc-1.89.0-src.tar.xz",
            sha256sum = "0b9d55610d8270e06c44f459d1e2b7918a5e673809c592abed9b9c600e33d95a",
          },
        },
        {
          dest = "local",
          src = {
            # uri = "https://static.rust-lang.org/dist/rust-std-1.84.0-x86_64-unknown-linux-musl.tar.xz",
            # sha256sum = "5f976818603468384bd78fde6c4e12f2b0a996d55f4985a33a68b5af54974ac0",

            # uri = "https://static.rust-lang.org/dist/rust-std-1.85.0-x86_64-unknown-linux-musl.tar.xz",
            # sha256sum = "27cebed8bafcb07c1c61a3dfc548efc3c032720d953375391896b664f8fe06f5",

            uri = "https://static.rust-lang.org/dist/rust-std-1.88.0-x86_64-unknown-linux-musl.tar.xz",
            sha256sum = "0c42b63c18a6343851e0f27aeb5cff73146c86fc95bc4e2bf51b726c4311249e",
          }
        },
        {
          dest = "local1",
          src = {
            # uri = "https://static.rust-lang.org/dist/rustc-1.84.0-x86_64-unknown-linux-musl.tar.xz",
            # sha256sum = "bb96af675e34195588ab322ddaeabadd8bf4da08869aef3c91b7e7bbaf9a74b1",

            # uri = "https://static.rust-lang.org/dist/rustc-1.85.0-x86_64-unknown-linux-musl.tar.xz",
            # sha256sum = "229735169a7dfdd460cc36e3a7f44729555d7de10af88494b77a93ce767d86c3",

            uri = "https://static.rust-lang.org/dist/rustc-1.88.0-x86_64-unknown-linux-musl.tar.xz",
            sha256sum = "58c2003a5e1c3f03e0b3b59677866d212b19d2d74473f63e52f60244fc062a76",
          }
        },
        {
          dest = "local2",
          src = {
            # uri = "https://static.rust-lang.org/dist/cargo-1.84.0-x86_64-unknown-linux-musl.tar.xz",
            # sha256sum = "0356fa019a7ee60fe6eec2f94c7d68e01b1a7710437bb6cf3422b42c2870d822",

            # uri = "https://static.rust-lang.org/dist/cargo-1.85.0-x86_64-unknown-linux-musl.tar.xz",
            # sha256sum = "097bf46bb15bf8af3e33f7720fd14d6d02bbbf7dddcef926b773a52535c2c8a3",

            uri = "https://static.rust-lang.org/dist/cargo-1.88.0-x86_64-unknown-linux-musl.tar.xz",
            sha256sum = "a00f8caf4f22b5e8f5492b70fc9e16fbf5c2f19ab655f79ede3d2d1ba11531c4",
          }
        },
      ],
      # patches = [
      #   {
      #     sha256sum = "e96ebfd7e040e480d893c3e5ddd0a13e4f403fd1a9794700a70b84820fec0621",
      #     file = "fc32dd49cb70c4b113353c7a060a875f30b9af04.patch"
      #   }
      # ],
      separateBuildDir = false,
      isStatic = false,
      isLlvm = false,

      # buildEnv = {
      #   # _isStatic=false,
      #   EXTRA_CFLAGS = ["-no-pie", "-fno-pie", "-fPIC"],
      #   EXTRA_CXXFLAGS = ["-no-pie", "-fno-pie", "-fPIC"],
      #   EXTRA_LDFLAGS = ["-no-pie", "-fno-pie", "-fPIC"],
      # },

      buildEnv | force =
        # (std.record.map (fun k v => let v2 =(
        #   if std.is_string v then null
        #   else if std.is_array v then null
        #   else v) in v2 ) (lib.AutotoolsPackage.buildEnv)) &
        {
          _isLlvm | force = false,
          _isStatic | force = false,
          #LDFLAGS = ["-static", "--static"],
          #CFLAGS = ["-static", "--static"],
          #CXXFLAGS = ["-static", "--static"],
          # LDFLAGS = ["-static-libgcc"],
          # CFLAGS = ["-static-libgcc"],
          # CXXFLAGS = ["-static-libgcc"],
        },

      unpackPhase = [
        m%"
        rust_src=$(find  /tmp/workdir/packed -name rustc-1.*-src.tar.xz)
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

        #   m%"
        # sed -i \
        #   's@\[lib\]@#\[lib\]@g'\
        #   ${SRC}/compiler/rustc_driver/Cargo.toml
        # "%,
        #   m%"
        # sed -i \
        #   's@crate-type@#crate-type@g'\
        #   ${SRC}/compiler/rustc_driver/Cargo.toml
        # "%,
        #   m%"
        # sed -i \
        #   's@"-static-pie"@"-static"@g'\
        #   ${SRC}/compiler/rustc_codegen_ssa/src/back/linker.rs
        # "%,
        "export OPENSSL_NO_VENDOR=1",
        "export RUST_BACKTRACE=1",

        # m%"sed -i 's|\[package\]|cargo-features = \["edition2024"\]\n\[package\]|g' ${SRC}/src/bootstrap/Cargo.toml"%,
      ],

      buildPhase = [
        "echo 'running b'",
        "./x.py build  --jobs $(nproc)",
        # "echo 'running b 1'",
        # m%"
        # RUSTC_SYSROOT=/tmp/workdir/src/build/tmp/rust/src/build/x86_64-unknown-linux-musl/stage0-sysroot/ \
        # ./x.py build --keep-stage 0 --stage 1 --jobs $(nproc)
        # "%,
        # "echo 'running b 2'",
        # m%"
        # RUSTC_SYSROOT=/tmp/workdir/src/build/tmp/rust/src/build/x86_64-unknown-linux-musl/stage1-sysroot/ \
        # ./x.py build --keep-stage 1 --stage 2 --jobs $(nproc)
        # "%,
        "echo 'b done'",
      ],

      installPhase = [
        "DESTDIR=${DEST} ./x.py install",
      ],

      biDrvs = [
        drvs.pythonFull,
        # drvs.rsync,
        drvs.pkgconf,
        drvs.muslShared,
        (drvs.clangCc & { priority = 1 }),
        drvs.llvmFullPic,
        drvs.libgccSymlinks,
        drvs.zlibNgPic,
        drvs.opensslPic,
        drvs.gcc,

        # drvs.gccSymlink,
        #(drvs.binutils & { priority = 1 }),
        # drvs.libemptyGcc,
        # drvs.libempty,
        (drvs.llvmConfigStatic & { priority = 1 }),
        (drvs.gnutar & { priority = 1 }),
      ],
      configureFlags =
        let lto = "off"
        # lto = "on"
        in

        [
          "--enable-verbose-configure",
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
          "--set=\"rust.lto=%{lto}\"",
          "--set=\"rust.lld=false\"",
          "--target=%{tgt}",
          "--host=%{tgt}",
          "--build=%{tgt}",
          "--set=\"target.%{tgt}.llvm-config=/usr/bin/llvm-config\"",
          "--set=\"target.%{tgt}.llvm-libunwind=system\"",
          "--set=\"target.%{tgt}.musl-root=/usr\"",
          "--set=\"target.%{tgt}.crt-static=false\"",
        ],
    },
}
& (import "mrust.ncl")
& {
  lib,
  gccSymlink | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "cd ${DEST}/usr/bin",
      "ln -s gcc cc",
      "ln -s g++ c++",
    ]
  }
}
& (import "CargoPackage.ncl")
