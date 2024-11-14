{
  lib,
  drvs,
  uutils | lib.CargoPackage
    = {
      sourceInputs = [
        {
          src = {
            uri = "https://github.com/uutils/coreutils/archive/refs/tags/0.0.27.tar.gz",
            sha256sum = "3076543a373c8e727018bd547cc74133f4a6538849e4990388f2bbea9a9aff6b"
          }
        }
      ],

      separateBuildDir = false,

      buildPhase = [
        "cargo build --offline"
      ]
    }
}