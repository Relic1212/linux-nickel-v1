{
  lib,
  drvs,
  niri,
  niriTag | lib.CargoPackage = {
    singleSource = {
      uri = "https://git.atagen.co/atagen/niri-tag/archive/0.1.1.tar.gz",
      sha256sum = "a27a517c36c7f2132915bcdfea155ce7f03892ca4d60b86cb0b1e526aab9b477"
    },
    nonCrateSourceInputs = [
      {
        src = singleSource,
      },
      {
        src = (std.array.at 0 niri.sourceInputs).src,
        dest = "niri",
      },
    ],
    extraFiles = [
      {
        file = "Cargo.lock",
        sha256sum = "cd928685fb415980cdf1f070988d7cc1b5a4ff70d75bcc72288827d61f605f7f",
      }
    ],
    enableSccache = false,
    crates = lib.functions.filterCrates (import "niri-tag-crates.json"),
    configurePhase = [
      "cp ../files/Cargo.lock .",
    ],
  }
}
