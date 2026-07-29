{
  lib,
  drvs,
  flutter_rust_bridge | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/fzyzcjy/flutter_rust_bridge/archive/refs/tags/v2.12.0.tar.gz",
      sha256sum = "ac834e9b6171438ec2b40d1a9ee799c4fcadba307212f430681d69723bdf0163",
    },
    crates = lib.functions.filterCrates (import "flutter_rust_bridge-crates.json"),
  }
}
