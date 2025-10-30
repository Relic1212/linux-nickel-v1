{
  lib,
  drvs,
  niriSessionManager | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/MTeaHead/niri-session-manager/archive/2d9ae35bb654ad0cdc5f646e5fee446bf3af083c.tar.gz",
      sha256sum = "3ba876e22b0a9408a31ef2d2b8c16b4af427c4c660e82ea0a5f234f8e3ce98bc"
    },
    enableSccache = false,
    crates = lib.functions.filterCrates (import "./niri-session-manager-crates.json"),
  }
}
