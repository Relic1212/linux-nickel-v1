{
  lib,
  drvs,
  waycorner | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/AndreasBackx/waycorner/archive/refs/tags/0.2.3.tar.gz",
      sha256sum = "829575b86f21903a97082a290c48ac7025428d1c8bf308f6a851dc54bb8a61b1"
    },

    crates = lib.functions.filterCrates (import "waycorner-crates.json"),

    configurePhase = [
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      #   m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen*/Cargo.toml"%,
      #   m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys/Cargo.toml"%,
      # m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-client-toolkit*/Cargo.toml"%,
    ],

    postInstallPhase = [
      "cargo tree --target=x86_64-unknown-linux-musl -e features",
    ],
    biDrvs = [
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
    ],
  }
}
