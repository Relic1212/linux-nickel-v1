{
  lib,
  drvs,
  tealdeer | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/tealdeer-rs/tealdeer/archive/refs/tags/v1.7.3.tar.gz",
      sha256sum = "3e8507cd634290a5befea8949e7518e5837860c452830292ef52033d947e04d1",
    },

    crates = lib.functions.filterCrates (import "tealdeer-crates.json"),

    postInstallPhase = [
      "install -Dm0755 completion/fish_tealdeer ${DEST}/usr/share/fish/completions/tldr.fish",
    ]
  }
}
