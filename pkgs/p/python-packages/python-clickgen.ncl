{
  lib,
  drvs,
  pythonClickgen | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/ful1e5/clickgen/archive/refs/tags/v2.2.5.tar.gz",
      sha256sum = "e76f55eacd66db11d004d2f1a33f42b12d4823d6653e8a288277b045911d51d9"
    }
  }
}
