{
  lib,
  drvs,
  mdevd | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://skarnet.org/software/mdevd/mdevd-0.1.6.5.tar.gz",
      sha256sum = "d5c86420c81b2e4720b41e4f48f727cd5d9a17f4e6317115d21c32099e72a628",
    },
    separateBuildDir = false,
    biDrvs =
      [
        drvs.skalibs,
        drvs.linuxHeaders,
      ],
  }
}
