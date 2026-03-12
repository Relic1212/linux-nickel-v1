{
  lib,
  drvs,
  inlyne | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/Inlyne-Project/inlyne/archive/refs/tags/v0.5.0.tar.gz",
      sha256sum = "0473d154469c4f078029c2fdb58dca19b8d415633934773c41930536b54e71e0"
    },

    crates = lib.functions.filterCrates (import "inlyne-crates.json"),

    extraEnv = {
      EXTRA_RUSTFLAGS = [
        "-C link-arg=/tmp/workdir/src/dlopen.o",
      ],
    },

    configurePhase = [
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      #   m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen*/Cargo.toml"%,
      #   m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys/Cargo.toml"%,
      # m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit*/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-client-toolkit*/Cargo.toml"%,
      "echo '%{import "dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
    ],
    muslProvider = drvs.muslBothRenamedDl,
    biDrvs = [
      drvs.expat,
      drvs.libffi,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libxkbcommon,
    ]
  }
}
