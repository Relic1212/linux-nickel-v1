{
  lib,
  drvs,

  kickoff | lib.CargoPackage
    =
      let j = import "kickoff-crates.json"
      in
      let _crates = lib.functions.filterCrates j
      in
      {
        singleSource = {
          uri = "https://github.com/j0ru/kickoff/archive/refs/tags/v0.7.4.tar.gz",
          sha256sum = "754e487c8d8b6f457ae8c9364572bf5e62c61526ecd8377d6d70b0b74645604b"
        },
        crates = _crates,
        biDrvs = [
          drvs.fontconfig,
          drvs.freetype,
          drvs.zlibNg,
          drvs.gperf,
          drvs.pixman,
          drvs.wayland,
          drvs.waylandProtocols,
          drvs.libffi,
          drvs.libxkbcommon,
          drvs.expat,
          drvs.linuxHeaders,
        ],
      }
}
