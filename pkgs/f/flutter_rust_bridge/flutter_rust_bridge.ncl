{
  lib,
  drvs,
  flutter_rust_bridge | lib.CargoPackage = {
    singleSource = {
      # uri = "https://github.com/fzyzcjy/flutter_rust_bridge/archive/refs/tags/v2.12.0.tar.gz",
      # sha256sum = "ac834e9b6171438ec2b40d1a9ee799c4fcadba307212f430681d69723bdf0163",
      uri = "https://github.com/fzyzcjy/flutter_rust_bridge/archive/refs/tags/v1.80.1.tar.gz",
      sha256sum = "5c1494e79024de228a9f383c8e52e45b042cd0cf24f4b0f47ee4d5448938b336",
    },
    # crates = lib.functions.filterCrates (import "flutter_rust_bridge-crates.json"),
    crates = lib.functions.filterCrates (import "flutter_rust_bridge-1.80.1-crates.json"),

    configurePhase = [
      m%"sed -i 's@"frb_example@#"frb_example@g' ${SRC}/Cargo.toml"%,
    ],
  }
}
