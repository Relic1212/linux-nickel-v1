{
  lib,
  drvs,
  infyne | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/Inlyne-Project/inlyne/archive/refs/tags/v0.5.0.tar.gz",
      sha256sum = "0473d154469c4f078029c2fdb58dca19b8d415633934773c41930536b54e71e0"
    },

    crates = lib.functions.filterCrates (import "infyne-crates.json"),

    configurePhase = [
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      #   m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen*/Cargo.toml"%,
      #   m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys/Cargo.toml"%,
      # m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit*/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-client-toolkit*/Cargo.toml"%,
    ],

    biDrvs = [
      drvs.expat,
      drvs.libffi,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libxkbcommon,
    ]
  }
}
