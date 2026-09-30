{
  lib,
  drvs,
  libheif | lib.CmakePackage = {
    singleSource = {
      uri = "https://github.com/strukturag/libheif/archive/refs/tags/v1.23.5.tar.gz",
      sha256sum = "3be49950c75d3fd9318ba775e8253248dd9e08c61ea955fca81b6b89c02d6b2b",
    },
    generator = "Ninja",
  }
}
