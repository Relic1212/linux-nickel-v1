{
  lib,
  drvs,
  xdgDesktopPortalUmbriel | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/noctalia-dev/xdg-desktop-portal-umbriel/archive/56951426eb9931db3f1c57348f226c2427fba4f3.tar.gz",
      sha256sum = "9b06e0b352499dce6a6ed3147998645a0d9959f959c7480da5b6bc0fc41256a8",
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --static --libs egl)",
      ],
    },
    extraMesonArgs = [
      "-Dpicker=enabled",
    ],
    llvmProvider = drvs.llvmFull,
    pDrvs = [
      drvs.sdbusCpp,
      drvs.pipewire,
      # drvs.cairo,
      drvs.gtk4,
      drvs.tomlplusplus,
      drvs.nlohmannJson,
      drvs.libei,
    ],
  }
}
