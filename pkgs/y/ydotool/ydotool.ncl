{
  lib,
  drvs,
  ydotool | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/ReimuNotMoe/ydotool/archive/refs/tags/v1.0.4.tar.gz",
      sha256sum = "ba075a43aa6ead51940e892ecffa4d0b8b40c241e4e2bc4bd9bd26b61fde23bd",
    },

    extraFiles = [
      {
        # https://github.com/ReimuNotMoe/ydotool/issues/25#issuecomment-535842993
        file = "80-uinput.rules",
        sha256sum = "72dab3e5a64f89130d2c2f6b57cc866ebb6a5b4cdc03859a27cbdc7c7ebb9c84"
      },
    ],

    cmakeExtraArgsRecord = {
      "-DCMAKE_POLICY_VERSION_MINIMUM" = "3.5",
    },

    postInstallPhase = [
      "install -dm0755 ${DEST}/usr/lib/udev/rules.d/",
      "install -m0644 /tmp/workdir/files/80-uinput.rules ${DEST}/usr/lib/udev/rules.d/",
    ],

    biDrvs = [
      drvs.linuxHeaders,
      drvs.scdoc,
    ],
  }
}
