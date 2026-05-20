{
  lib,
  drvs,
  firejail | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/netblue30/firejail/archive/refs/tags/0.9.80.tar.gz",
      sha256sum = "1397bba6774a6361171c72464ddcdcfbc36d44fa413ecc9a1d56092f8da58825",
    },
    separateBuildDir = false,
    pDrvs = [
      drvs.libseccomp,
      drvs.linuxHeaders,
    ]
  }
}
