{
  lib,
  drvs,
  qtshadertools | lib.QtPackage = {
    generator = "Ninja",

    llvmProvider = drvs.llvmFull,

    pDrvs = [
      drvs.qtbaseVulkan,
    ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static fontconfig)",
      ]
    },
    cmakeExtraArgsRecord = {
      "-DQT_DEBUG_FIND_PACKAGE" = "ON",
    },
  }
}
