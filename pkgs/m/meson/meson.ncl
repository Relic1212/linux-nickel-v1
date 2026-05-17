{
  lib,
  drvs,
  meson | lib.SetuptoolPackage = {
    name = "meson",
    singleSource = {
      # uri = "https://github.com/mesonbuild/meson/releases/download/1.5.2/meson-1.5.2.tar.gz",
      # sha256sum = "f955e09ab0d71ef180ae85df65991d58ed8430323de7d77a37e11c9ea630910b",

      # uri = "https://github.com/mesonbuild/meson/archive/refs/tags/1.8.5.tar.gz",
      # sha256sum = "1cd0b5b013b4208ab450f5aca93b592b707f3fb2afe96b101dc710e6e5a8245c",

      uri = "https://github.com/mesonbuild/meson/archive/refs/tags/1.11.1.tar.gz",
      sha256sum = "1a2219422be4a66ad0e8daed125c2a3d5c963458e289203eae22edf3224f5d3e",
    },
    buildInputs = [
      drvs.busybox,
      drvs.pythonSetuptools,
      drvs.pythonFull,
    ],
    pkgconfProvider = drvs.pkgconf,
  }
}
