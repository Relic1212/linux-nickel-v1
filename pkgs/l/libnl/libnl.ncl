{
  lib,
  drvs,
  libnl | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/thom311/libnl/archive/refs/tags/libnl3_11_0.tar.gz",
      sha256sum = "871d8f9f05b86dab080988bb994748384c1416a5d03de1f9f5e811f265094b04"
    },
    biDrvs = [
      # drvs.m4,
      drvs.flex,
      drvs.bison,
      drvs.linuxHeaders,
    ]
  }
}
