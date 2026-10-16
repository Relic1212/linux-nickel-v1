{
  lib,
  drvs,
  perlPathTiny | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/dagolden/Path-Tiny/archive/refs/tags/release-0.150.tar.gz",
      sha256sum = "cc0a1604ef315e207ac222de904f4bb2b7e0fbf78b704e41362ca640b888e031",
    },
    preConfigurePhase = [
      "perl Makefile.PL LINKTYPE=static"
    ],
    biDrvs = [
      drvs.perl,
    ],
  }
}
