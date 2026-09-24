{
  lib,
  drvs,
  libparserutils | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/netsurf-browser/libparserutils/archive/6b0cbf086ca8eb8fe74b69f0c9ecf274eb2397ca.tar.gz",
      sha256sum = "ac424f77b80ec3806ba8bf10cdab982e7e2e96e825be849e2a704edfc286a193",
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
      drvs.perl,
    ],
    pDrvs = [
      drvs.netsurfBuildsystem,
    ],
  }
}
