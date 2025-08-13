{
  lib,
  drvs,
  fdkAac | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/mstorsjo/fdk-aac/archive/refs/tags/v2.0.3.tar.gz",
      sha256sum = "e25671cd96b10bad896aa42ab91a695a9e573395262baed4e4a2ff178d6a3a78"
    }
  }
}
