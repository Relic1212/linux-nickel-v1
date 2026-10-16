{
  lib,
  drvs,
  pythonPygobjectStubs | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/pygobject/pygobject-stubs/archive/refs/tags/v2.19.0.tar.gz",
      sha256sum = "91409f6ed628d2275fcfa8a0a7a521d83889383d28cd51b9a46efa55f2e37576",
    }
  }
}
