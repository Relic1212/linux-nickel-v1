{
  lib,
  drvs,
  pythonPoetryCore | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/python-poetry/poetry-core/archive/refs/tags/2.5.0.tar.gz",
      sha256sum = "e5a6fa94749ba460c56898d2b9649e3779b9f20f225d75be2fdff0ec43a3449d",
    }
  }
}
