{
  lib,
  drvs,
  rustfmt | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/rust-lang/rustfmt/archive/refs/tags/v1.8.0.tar.gz",
      sha256sum = "d23bc8bfba28685fd68cf207dde62d0868ae0e4378d438d58b4b51763e6b92f5"
    },
    crates = lib.functions.filterCrates (import "rustfmt-crates.json")
  }
}
& {
  lib,
  drvs,
  rust,
  rustWFmt | lib.CargoPackage = {
    singleSource = (std.array.at 0 rust.sourceInputs).src,

    crates = lib.functions.filterCrates (import "cargo-crates.json"),

    extraEnv.STATIC_RUSTFLAGS = [],
    cargoFlags = [
      "--release",
      "--offline",
    ],
    configurePhase =
      [
        "head -n11 .cargo/config.toml > .cargo/config.toml.new",
        "mv .cargo/config.toml.new .cargo/config.toml",
        # m%"echo "[source.crates-io]\nreplace-with = \"vendored-sources\"\n" >> .cargo/config.toml"%,
        "export LIBGIT2_NO_VENDOR=1",
        "export OPENSSL_NO_VENDOR=1",
      ]
      @ (
        let configureFlags = (
          let
            lto = "off",
            # lto = "thin",
            tgt = "x86_64-unknown-linux-musl"
            # lto = "on"
          in

          [
            "--enable-verbose-configure",
            "--prefix=/usr",
            "--disable-docs",
            "--enable-extended",
            "--release-channel=\"stable\"",
            "--enable-local-rust",
            "--local-rust-root=/usr",
            "--enable-vendor",
            "--enable-locked-deps",
            "--disable-codegen-tests",
            "--enable-cargo-native-static",
            "--tools=\"cargo,src,rustfmt\"",
            "--set=\"rust.codegen-tests=false\"",
            "--set=\"rust.musl-root=/usr\"",
            "--set=\"rust.rpath=false\"",
            # "--set=\"rust.llvm-config=/usr/bin/llvm-config\"",
            # "--set=\"llvm-libunwind=in-tree\"",
            "--set=\"rust.lto=%{lto}\"",
            "--set=\"rust.lld=false\"",
            "--target=%{tgt}",
            "--host=%{tgt}",
            "--build=%{tgt}",
            "--set=\"target.%{tgt}.llvm-config=/usr/bin/llvm-config\"",
            "--set=\"target.%{tgt}.optimized-compiler-builtins=false\"",
            "--set=\"target.%{tgt}.llvm-libunwind=system\"",
            "--set=\"target.%{tgt}.musl-root=/usr\"",
            "--set=\"target.%{tgt}.crt-static=false\"",
            "--set=\"build.local-rebuild=true\"",
          ]
        )
        in
        [
          "./configure %{ std.string.join " " configureFlags }"
        ]
      ),

    buildPhase = [
      "echo 'running build'",
      "./x.py build  --jobs $(nproc)",
      "echo 'build done'"
    ],

    installPhase = [
      "echo 'running install'",
      "DESTDIR=${DEST} ./x.py install",
      "echo 'install done'"
    ],

    llvmProvider = drvs.llvmFullPic,
    biDrvs = [
      drvs.pythonFull,
      # drvs.rsync,
      # (drvs.clangCc & { priority = 1 }),
      # drvs.libgccSymlinks,
      drvs.zlibNgPic,
      drvs.opensslPic,
      (drvs.musl & { priority = 1 }),

      # drvs.gccSymlink,
      #(drvs.binutils & { priority = 1 }),
      # drvs.libemptyGcc,
      # drvs.libempty,
      (drvs.llvmConfigStatic & { priority = 1 }),
      # (drvs.gnutar & { priority = 1 }),
      drvs.libgit2,
    ],
  }
}
