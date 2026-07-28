{
  lib,
  drvs,
  iftop | lib.AutotoolsPackage = {
    singleSource = {
      # uri = "https://github.com/soarpenguin/iftop/archive/236f925f2d9c7a488c429c0a241d71e7d13c5b5d.tar.gz",
      # sha256sum = "52267d128f2000145f01e360d29e8acaab15ed5e24803c5af5cbf3ad1e7fc29e",

      uri = "https://pdw.ex-parrot.com/iftop/download/iftop-1.0pre4.tar.gz",
      sha256sum = "f733eeea371a7577f8fe353d86dd88d16f5b2a2e702bd96f5ffb2c197d9b4f97",
    },
    buildEnv = {
      EXTRA_CFLAGS = [
        "-fcommon",
      ],
    },
    separateBuildDir = false,
    enableParallel = false,
    pDrvs = [
      drvs.libpcap,
      drvs.ncurses,
    ],
  }
}
