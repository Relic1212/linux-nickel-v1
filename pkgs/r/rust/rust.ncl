{
  lib,
  drvs,
  rust | lib.AutotoolsPackage =
    let tgt = "x86_64-unknown-linux-musl", p190 = true in
    {
      # 

      sourceInputs = [
        {
          src =
            if (!p190) then
              {

                uri = "https://static.rust-lang.org/dist/rustc-1.89.0-src.tar.xz",
                sha256sum = "0b9d55610d8270e06c44f459d1e2b7918a5e673809c592abed9b9c600e33d95a",
              }
            else
              {

                uri | priority 1 = "https://static.rust-lang.org/dist/rustc-1.91.1-src.tar.xz",
                sha256sum | priority 1 = "66401bb815e236cc6b2aacbbe23b61b286c1fe27a67902e7c0222cfe77b3dbab",
              },
        },
        {
          dest = "local",
          src =
            if (!p190) then
              {

                uri = "https://static.rust-lang.org/dist/rust-std-1.88.0-x86_64-unknown-linux-musl.tar.xz",
                sha256sum = "0c42b63c18a6343851e0f27aeb5cff73146c86fc95bc4e2bf51b726c4311249e",
              }
            else
              {

                uri = "https://static.rust-lang.org/dist/rust-std-1.90.0-x86_64-unknown-linux-musl.tar.xz",
                sha256sum = "38490d575786f4688e83b357baeb022d8dde0ace2cb8c1357e060c76644fc56a",
              }
        },
        {
          dest = "local1",
          src =
            if (!p190) then
              {

                uri = "https://static.rust-lang.org/dist/rustc-1.88.0-x86_64-unknown-linux-musl.tar.xz",
                sha256sum = "58c2003a5e1c3f03e0b3b59677866d212b19d2d74473f63e52f60244fc062a76",
              }
            else
              {

                uri = "https://static.rust-lang.org/dist/rustc-1.90.0-x86_64-unknown-linux-musl.tar.xz",
                sha256sum = "993cb26cee9525b1553d82b8fc2b6ddffd50a0a561cd896e3daa3a9f8ae65949",
              }
        },
        {
          dest = "local2",
          src =
            if (!p190) then
              {

                uri = "https://static.rust-lang.org/dist/cargo-1.88.0-x86_64-unknown-linux-musl.tar.xz",
                sha256sum = "a00f8caf4f22b5e8f5492b70fc9e16fbf5c2f19ab655f79ede3d2d1ba11531c4",
              }
            else
              {
                uri = "https://static.rust-lang.org/dist/cargo-1.90.0-x86_64-unknown-linux-musl.tar.xz",
                sha256sum = "dddd1ee3da59440d5aa4d149ebb5fbbe0d7252dd94e171d5f2b071d7354f9b3a",
              }
        },
      ],

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

      biDrvs =
        [
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
          drvs.llvmConfigStatic & { priority = 1 },
          drvs.gnutar & { priority = 1 },
        ]
        @ (if p190 then [drvs.xz & { priority = 1 }] else []),
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
