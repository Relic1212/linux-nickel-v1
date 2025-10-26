{
  lib,
  drvs,
  mold | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/rui314/mold/archive/refs/tags/v2.40.4.tar.gz",
      sha256sum = "69414c702ec1084e1fa8ca16da24f167f549e5e11e9ecd5d70a8dcda6f08c249"
    },
    biDrvs = [
      drvs.linuxHeaders
    ]
  }
}
