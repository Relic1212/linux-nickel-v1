{
  lib,
  drvs,
  nload | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/rolandriegel/nload/archive/refs/tags/v0.7.4.tar.gz",
      sha256sum = "a73b3a75356776860fc4c40daebce04c5022f73d39704a12fb0aeb88a751216a",
    },
    separateBuildDir = false,
    pDrvs = [
      drvs.ncurses,
      drvs.ncursesLibformFix,
    ]
  },
  ncursesLibformFix | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib",
      "cd ${DEST}/usr/lib",
      "ln -s libformw.a libform.a"
    ]
  }
}
