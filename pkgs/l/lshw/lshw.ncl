{
  lib,
  drvs,
  lshw | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/lyonel/lshw/archive/refs/tags/B.02.20.tar.gz",
      sha256sum = "6b8346a89fb0f0f1798e66f6a707a881d38b9b3a67256b30fc4628dac09f291a"
    },
    biDrvs = [
      drvs.linuxHeaders,
      drvs.gettext,
      drvs.git,
    ],
    extraMakeArgs = [
      "SBINDIR=/usr/bin"
    ],
    extraMakeInstallArgs = extraMakeArgs
  },

  lshwGui =
    lshw
    & {
      makeTargets = ["gui"]
    }
}
