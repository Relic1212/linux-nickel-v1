{
  lib,
  drvs,
  oksh | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/ibara/oksh/archive/refs/tags/oksh-7.9.tar.gz",
      sha256sum = "1dc923da1a2bd52d4035e2ae0463d8fed353339d6e692ff747926d2125346f2e",
    },
    separateBuildDir = false,
    pDrvs = [
      drvs.ncurses,
    ],
  }
}
