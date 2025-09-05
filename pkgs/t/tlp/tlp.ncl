{
  lib,
  drvs,
  tlp | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/linrunner/TLP/archive/refs/tags/1.8.0.tar.gz",
      sha256sum = "65515f7652064a1be2940c031e045b762924bb1dbd94f5e58e3b765113cf5210"
    },
    extraMakeArgs = [
      "TLP_SBIN=/usr/bin",
    ],
    extraMakeInstallArgs = extraMakeArgs
  }
}
