{
  lib,
  busybox,
  pythonSetuptools,
  pythonFull,

  meson | lib.SetuptoolPackage = {
    name = "meson",
    singleSource = {
      uri = "https://github.com/mesonbuild/meson/releases/download/1.5.2/meson-1.5.2.tar.gz",
      sha256sum = "f955e09ab0d71ef180ae85df65991d58ed8430323de7d77a37e11c9ea630910b",
    },
    buildInputs =
      lib.biMap [
        busybox,
        pythonSetuptools,
        pythonFull,
      ]
  }
}
