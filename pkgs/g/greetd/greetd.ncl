{
  lib,
  drvs,
  greetd | lib.CargoPackage = {
    singleSource = {
      uri = "https://git.sr.ht/~kennylevinsen/greetd/archive/0.10.3.tar.gz",
      sha256sum = "ee5cb70e0add4ca9c9fe57e47581ab0002d44c07743fb5492469f3b570db640b"
    },

    crates = lib.functions.filterCrates (import "greetd-crates.json"),
    extraEnv.EXTRA_RUSTFLAGS = ["-C link-arg=-lcap"],
    preInstallPhase = [
      "cd man",
      "make PREFIX=/usr",
      "cd .."
    ],
    postInstallPhase = [
      "install -dm0755 ${DEST}/etc/greetd",
      "install -m0755 config.toml ${DEST}/etc/greetd",
      "cd man",
      "make PREFIX=/usr DESTDIR=${DEST} install",
      "cd .."
    ],
    biDrvs = [
      drvs.libpamFinal,
      drvs.libcap,
      drvs.scdoc,
      drvs.gnumake,
    ]
  }
}
