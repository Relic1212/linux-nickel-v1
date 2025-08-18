{
  lib,
  drvs,
  hyprlandAutonameWorkspaces | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/hyprland-community/hyprland-autoname-workspaces/archive/refs/tags/1.1.16.tar.gz",
      sha256sum = "aadfef505b8cbedc1769a6412e1e0dd8bd9c3a0d37dddcebed97479de01b21b7"
    },

    crates = (lib.functions.filterCrates (import "hyprland-autoname-workspaces-crates.json")),
    biDrvs = []
  }
}
