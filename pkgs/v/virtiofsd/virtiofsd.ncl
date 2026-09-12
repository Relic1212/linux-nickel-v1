{
  lib,
  drvs,
  virtiofsd | lib.CargoPackage = {
    singleSource = {
      uri = "https://gitlab.com/virtio-fs/virtiofsd/-/archive/v1.14.0/virtiofsd-v1.14.0.tar.bz2",
      sha256sum = "0646c2cd5a733dd411afb49be8eff7f0a10bb4a286f75b822961e07ea6a654af",
    },
    crates = lib.functions.filterCrates (import "virtiofsd-crates.json"),

    pDrvs = [
      drvs.libseccomp,
      drvs.libcapNg,
    ]
  }
}
