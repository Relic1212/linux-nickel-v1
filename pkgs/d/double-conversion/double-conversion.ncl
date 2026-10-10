{
  lib,
  drvs,
  doubleConversion | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/google/double-conversion/archive/refs/tags/v3.4.0.tar.gz",
      sha256sum = "42fd4d980ea86426e457b24bdfa835a6f5ad9517ddb01cdb42b99ab9c8dd5dc9",
    }
  }
}
