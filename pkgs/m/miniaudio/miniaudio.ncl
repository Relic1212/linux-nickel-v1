{
  lib,
  drvs,
  miniaudio | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/mackron/miniaudio/archive/refs/tags/0.11.25.tar.gz",
      sha256sum = "b900edcffe979816e2560a0580b9b1216d674b4f17fbadeca8f777a7f8ab0274",
    }
  }
}
