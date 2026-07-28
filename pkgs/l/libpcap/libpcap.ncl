{
  lib,
  drvs,
  libpcap | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/the-tcpdump-group/libpcap/archive/refs/tags/libpcap-1.10.6.tar.gz",
      sha256sum = "fcaeefbbca8d99249c8f271f3218f77cdbfd7718cc141f5edd16e90575e6bbed",
    },
    biDrvs = [
      drvs.linuxHeaders,
      drvs.flex,
      drvs.m4,
      drvs.bison,
    ],
  }
}
