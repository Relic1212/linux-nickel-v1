{
  lib,
  drvs,
  aml | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/any1/aml/archive/refs/tags/v1.0.0.tar.gz",
      sha256sum = "b2b8f743213af39f40e8bc611147d69e2ea9e010b9b19cb65246582338f28d96",
    }
  }
}
