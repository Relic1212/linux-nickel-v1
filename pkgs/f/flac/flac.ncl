{
  lib,
  drvs,
  flac | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/xiph/flac/archive/refs/tags/1.5.0.tar.gz",
      sha256sum = "aea54ed186ad07a34750399cb27fc216a2b62d0ffcd6dc2e3064a3518c3146f8",
    },
    cmakeExtraArgsRecord = {
      "-DINSTALL_MANPAGES" = false,
    },
    pDrvs = [
      drvs.libogg,
    ],
  }
}
