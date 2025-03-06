{
  lib,
  drvs,
  libnl | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.infradead.org/~tgr/libnl/files/libnl-3.2.25.tar.gz",
      sha256sum = "8beb7590674957b931de6b7f81c530b85dc7c1ad8fbda015398bc1e8d1ce8ec5"
    },
    biDrvs = [
      drvs.m4,
      drvs.flex,
      drvs.bison,
      drvs.linuxHeaders,
    ]
  }
}
