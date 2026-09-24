{
  lib,
  drvs,
  libdom | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/lightpanda-io/libdom/archive/c7f2d3cd27d6dc853d8f4cc29ac51ef47944c233.tar.gz",
      sha256sum = "ba932cfe635589021f61abbcf3f54cee7059c3e0ac0fde0316b56dd8489ca0d3",
    },
    extraEnv = {
      BUILD_CC = ["clang"],
    },

    extraMakeArgs = [
      "INSTALL=\"install\"",
      #   "COMPONENT_VERSION=\"0.4.1\""
    ],

    extraMakeInstallArgs =
      extraMakeArgs
      @ [
        "PREFIX=/usr",
      ],

    preConfigurePhase = [
      m%"sed -i 's@0.4.1@0.4.2@g' ${SRC}/Makefile"%,
    ],

    biDrvs = [drvs.pkgconfMeson, ],
    pDrvs = [
      # drvs.netsurfBuildsystem,
      drvs.libwapcaplet,
      #   drvs.libparserutils,
      drvs.libhubbub,
      drvs.expat,
    ],
  }
}
