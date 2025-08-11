{
  lib,
  drvs,
  btop | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/aristocratos/btop/archive/refs/tags/v1.4.4.tar.gz",
      sha256sum = "98d464041015c888c7b48de14ece5ebc6e410bc00ca7bb7c5a8010fe781f1dd8"
    },
    biDrvs = [
      drvs.linuxHeaders,
    ]
  }
}
