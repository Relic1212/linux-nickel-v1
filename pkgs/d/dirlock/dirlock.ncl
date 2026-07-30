{
  lib,
  drvs,
  dirlock | lib.CargoPackage = {
    singleSource = {
      uri = "https://gitlab.steamos.cloud/holo/dirlock/-/archive/61b5727d4ddea47dd0de7aecff29135337238aaf/dirlock-61b5727d4ddea47dd0de7aecff29135337238aaf.tar.bz2",
      sha256sum = "c8766e6d5b526ea46a66b688730f89303d600d5395b3e5ee532d3688f47c7edc",
    },
    crates = lib.functions.filterCrates (import "dirlock-crates.json"),

    eofPatches = [
      {
        patch = import "dirlock.patch" as 'Text
      },
    ],
    configurePhase = [
      "sed -i 's|cdylib|staticlib|g' ${SRC}/pam-dirlock/Cargo.toml",
      m%"sed -i 's|"systemd"|"elogind"|g' ${SRC}/dirlock/src/systemd.rs"%,
    ],
    pDrvs = [
      drvs.elogindWithPolkit,
    ],
  }
}
