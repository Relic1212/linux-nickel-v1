{
  lib,
  drvs,
  libwapcaplet | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/netsurf-browser/libwapcaplet/archive/c7c128d3eb3223b216c974471f82e9337fbcf4ba.tar.gz",
      sha256sum = "e1e1f6cca38ea6e6b62f87b579227bad564e235ac027f0328aa1fee7661c11e1",
    },
    buildEnv = {
      # CC = ["clang", "--verbose"],
    },
    extraEnv = {
      BUILD_CC = ["clang"],
    },
    extraMakeArgs = [
      # "CC=\"${CC}\"",
      # "BUILD_CC=\"${CC} --verbose\"",
      "INSTALL=\"install\"",
    ],

    extraMakeInstallArgs =
      extraMakeArgs
      @ [
        "PREFIX=/usr",
      ],
    pDrvs = [
      drvs.netsurfBuildsystem,
    ],
  }
}
