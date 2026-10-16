{
  lib,
  drvs,
  pythonTwine | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/pypa/twine/archive/refs/tags/7.0.0.tar.gz",
      sha256sum = "c4ce7afa802efb38dffa761bca83c3485ae482f8262c32ded74380c64ab508b5",
    }
  }
}
