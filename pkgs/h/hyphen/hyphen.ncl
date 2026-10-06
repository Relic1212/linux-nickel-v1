{
  lib,
  drvs,
  hyphen | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/hunspell/hyphen/archive/refs/tags/v2.8.9.tar.gz",
      sha256sum = "d6fc75d8500094903b119a45667fed91fe665e5f6f106029a4d3b4e26f3d8d6f",
    }
  }
}
