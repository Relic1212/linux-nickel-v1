{
  lib,
  drvs,
  kdl | lib.CargoPackage = {
    singleSource = {
      # uri = "https://github.com/kdl-org/kdl-rs/archive/refs/tags/kdl-lsp-v6.3.3.tar.gz",
      # sha256sum = "4ea3b21e1bad83ec6bb15cbd82f32b484e7dad47569ac9e5181fc2e6ceaf7eee",

      # uri = "https://github.com/kdl-org/kdl-rs/archive/refs/tags/v6.5.0.tar.gz",
      # sha256sum = "0915571a054e14384d1699a3241eac73d4edf21f0244fcbd8b56486e415c0225",

      uri = "https://github.com/kdl-org/kdl-rs/archive/refs/tags/kdl-lsp-v6.5.0.tar.gz",
      sha256sum = "b4bf38d341ed6e4e1f662aa11bf5de2e15acb8581ad58f2569b31e681366e4de"
    },

    crates =
      lib.functions.filterCrates (
        import "kdl-crates.json"
      ),
    extraCargoFlags = [
      "-p kdl-lsp"
    ]
  }
}
