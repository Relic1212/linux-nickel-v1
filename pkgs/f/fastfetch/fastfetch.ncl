{
  lib,
  drvs,
  fastfetch | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.62.1.tar.gz",
      sha256sum = "8c4833e55b8b445a32c7cb7570007b5e10a9ee4cee74a494004ba61e88b12b26",
    },
    biDrvs = [
      drvs.linuxHeaders,
    ],
  }
}
