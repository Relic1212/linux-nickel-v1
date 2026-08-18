{
  lib,
  drvs,
  wayscriber | lib.CargoPackage = {
    singleSource = {
      # uri = "https://github.com/devmobasa/wayscriber/archive/refs/tags/v0.9.24.tar.gz",
      # sha256sum = "67615fb0764683ca119bb301c505f7f7c6dadedee38f76438dc41a73fdc8bbaa",

      uri = "https://github.com/devmobasa/wayscriber/archive/refs/tags/v0.9.21.tar.gz",
      sha256sum = "ed314451c0ea5b0eb700419c5aa55d5e51d6930a8baea773ec847fb9a31a4332",
    },
    # crates = lib.functions.filterCrates (import "wayscriber-crates.json"),
    crates = lib.functions.filterCrates (import "wayscriber-9.21-crates.json"),
    extraCargoFlags = [
      "--no-default-features",
    ],
    # configurePhase=[
    #   m%"sed -i 's@= control_len@= control_len as u32@g' src/process_broker/transport.rs"%,
    #   m%"sed -i 's@usize@u32@g' src/process_broker/transport.rs"%,
    # ],
    neverInclude = [
      drvs.wayland,
      drvs.cairo,
      # drvs.glib,
      drvs.harfbuzz,
    ],
    pDrvs = [
      drvs.gtk4LayerShell,
    ],
  }
}
