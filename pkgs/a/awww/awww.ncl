{
  lib,
  drvs,
  awww | lib.CargoPackage = {
    singleSource = {
      uri = "https://codeberg.org/LGFae/awww/archive/v0.12.1.tar.gz",
      sha256sum = "5e31092d5170b90ec614f76bad0739b729923a57979d2dfed3673cf0d8db2dee",
    },
    crates = lib.functions.filterCrates (import "awww-crates.json"),
    preInstallPhase = [
      "./doc/gen.sh",
    ],
    postInstallPhase = [
      "install -dm0755 ${DEST}/usr/share/fish/completions",
      "install -m0755 completions/awww.fish ${DEST}/usr/share/fish/completions",
      "install -dm0755 ${DEST}/usr/share/man",
      "cp -r doc/generated ${DEST}/usr/share/man/man1",
    ],
    biDrvs = [
      drvs.lz4,
      drvs.waylandProtocols,
      drvs.wayland,
      drvs.scdoc,
    ]
  }
}
