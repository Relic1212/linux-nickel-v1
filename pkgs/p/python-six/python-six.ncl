{
  lib,
  drvs,
  pythonSix | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/benjaminp/six/archive/refs/tags/1.17.0.tar.gz",
      sha256sum = "32f3ae8f39a23ff9458d84c90e00cf042e5432ccb61c8991a5e437e7eacd83c6",
    }
  }
}
