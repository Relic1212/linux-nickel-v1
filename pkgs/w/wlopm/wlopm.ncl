{
  lib,
  drvs,
  wlopm | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~leon_plickat/wlopm/archive/v1.0.0.tar.gz",
      sha256sum = "15f31bbd855131943397dded3a26003f2f5056e4c6a1a93d35ff7697b3f1e439",
    },
    extraMakeArgs = [
      "PREFIX=/usr",
      "LIBS='-lwayland-client -lffi'",
    ],

    extraMakeInstallArgs = [
      "PREFIX=/usr",
    ],
    preInstallPhase = [
      "install -dm0755 ${DEST}/usr/share/bash-completion/completions",
    ],
    pDrvs = [
      drvs.wayland,
    ],
  }
}
