{
  lib,
  drvs,
  wayle | lib.CargoPackage =
    let libs =
      std.string.join
        " "
        [
          "libcap",
          "xkbcommon",
          "libpulse",
          "egl",
          "wayland-client",
          "wayland-egl",
          "gtk4-layer-shell-0",
        ]
    in
    {
      singleSource = {
        uri = "https://github.com/wayle-rs/wayle/archive/refs/tags/v0.6.0.tar.gz",
        sha256sum = "1d887b9378d04dcf29057d4c8fb8323341f4f0e7ef094feea8ddbdcbf4dfa72e",
      },

      crates = lib.functions.filterCrates (import "wayle-crates.json"),

      extraEnv = {
        EXTRA_RUSTFLAGS = [
          "-C link-arg=/tmp/workdir/src/dlopen.o",
          "-C link-arg=-lc++",
          m%"$(for l in $(pkg-config --libs --static %{libs});do printf " -C link-arg=$l ";done)"%,
          "-C link-arg=$(clang --print-file-name=libclang_rt.builtins-x86_64.a)",
        ]
      },

      buildEnv = {
        EXTRA_LDFLAGS = [
          "/tmp/workdir/src/dlopen.o",
          "-lc++",
          m%"$(pkg-config --libs --static %{libs})"%,
          "$(clang --print-file-name=libclang_rt.builtins-x86_64.a)",
        ],
      },

      linkSelfContained = "no",

      configurePhase = [
        m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
        m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen*/Cargo.toml"%,
        #   m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/libspa-sys*/Cargo.toml"%,
        #   m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/pipewire-sys*/Cargo.toml"%,
        m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys*/Cargo.toml"%,
        m%"sed -i 's@libpulse.so.0@libpulse.a@g' ${SRC}/vendor/libpulse-sys*/build.rs"%,
        lib.functions.writeFile "${SRC}/dlopen.c" (import "ironbar_dlopen.c" as 'Text),
        "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      ],

      llvmProvider = drvs.llvmFull,

      neverInclude = [
        drvs.harfbuzz,
        drvs.wayland,
      ],

      biDrvs = [
        drvs.muslBothWeakDl,
        drvs.waylandGtk4LayerShell,
        drvs.gtk4LayerShell,
        drvs.fftw,
        drvs.llvmConfigStatic,
        drvs.libstdcppCompat,
        drvs.pulseaudio17,
      ],

      pDrvs = [
        drvs.gtksourceview,
        drvs.pipewire,
      ],
    }
}
