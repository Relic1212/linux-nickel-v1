{
  lib,
  drvs,
  treeSitter | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.3.tar.gz",
      sha256sum = "7f4a7cf0a2cd217444063fe2a4d800bc9d21ed609badc2ac20c0841d67166550",
    },
    crates = lib.functions.filterCrates (import "tree-sitter-crates.json"),

    patches = [
      { file = "no-shared-lib.patch", sha256sum = "dc5b13f72f95e7d32796f22d71f1e1b66b2d9fc0e8c1d845f561396b79ca808f" },
    ],

    configurePhase = [
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen-*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys-*/Cargo.toml"%,
      "make PREFIX=/usr libtree-sitter.a tree-sitter.pc",
    ],
    postInstallPhase = [
      "make DESTDIR=${DEST} PREFIX=/usr install",
    ],
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.llvmConfigStatic,
      drvs.libffi,
      drvs.ncurses,
      drvs.libstdcppCompat,
      drvs.zlibNg,
      drvs.gnumake,
      drvs.musl & { priority = 1 },
    ]
  }
}
