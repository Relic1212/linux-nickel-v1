{
  lib,
  drvs,

  freerdp | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/FreeRDP/FreeRDP/archive/refs/tags/3.20.0.tar.gz",
      sha256sum = "7aef7cb22398ecdff0dd83071cbd17d20881751750b3879982af75b28042fd0d"
    }
  }
}
