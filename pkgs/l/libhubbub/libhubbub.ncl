{
  lib,
  drvs,
  libhubbub | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/netsurf-browser/libhubbub/archive/6651b8cf87a4aa87bcdb2ff024a02659cd3f9402.tar.gz",
      sha256sum = "85115b31bd1348007ddf1b8f5a339e078ab3fc349acc7a91d8caf33e8ee014d9",
    },

    extraEnv = {
      BUILD_CC = ["clang"],
    },
    extraMakeArgs = [
      "INSTALL=\"install\"",
    ],

    extraMakeInstallArgs =
      extraMakeArgs
      @ [
        "PREFIX=/usr",
      ],
    biDrvs = [
      drvs.pkgconfMeson,
      drvs.gperf,
      drvs.perl,
    ],
    pDrvs = [
      # drvs.netsurfBuildsystem,
      # drvs.libwapcaplet,
      drvs.libparserutils,
      # drvs.expat,
    ],
  }
}
