{
  lib,
  drvs,
  libcss | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/netsurf-browser/libcss/archive/refs/tags/release/0.9.2.tar.gz",
      sha256sum = "eea107218f4ec53911bbeca9c3eb897f2636c129db299a68ff52c01e73decb22",
    },

    extraEnv = {
      BUILD_CC = ["clang", "--static"],
    },

    extraMakeArgs = [
      "INSTALL=\"install\"",
    ],

    extraMakeInstallArgs =
      extraMakeArgs
      @ [
        "PREFIX=/usr",
      ],
    preConfigurePhase = [
      #   "pwd",
      #   "echo 'now building'",
      "unset BUILDDIR", # variable used by makefile
    ],
    biDrvs = [
      drvs.perl,
      drvs.pkgconfMeson,
    ],
    pDrvs = [
      # drvs.netsurfBuildsystem,
      drvs.libwapcaplet,
      drvs.libparserutils,
    ],
  }
}
