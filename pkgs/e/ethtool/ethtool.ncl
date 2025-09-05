{
  lib,
  drvs,
  ethtool | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://mirrors.edge.kernel.org/pub/software/network/ethtool/ethtool-6.15.tar.xz",
      sha256sum = "9477c365114d910120aaec5336a1d16196c833d8486f7c6da67bedef57880ade"
    },
    biDrvs = [
      drvs.linuxHeaders,
      drvs.pkgconf,
      drvs.libmnl,
    ]
  }
}
