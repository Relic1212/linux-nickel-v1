{
  lib,
  drvs,
  libsysstat | lib.LxqtPackage = {
    singleSource = {
      uri = "https://github.com/lxqt/libsysstat/archive/refs/tags/1.1.0.tar.gz",
      sha256sum = "3be2444ab6ea0042a640e8f3282c7931e2570cd8d41af80ba583a14d8088b84b",
    },
    preConfigurePhase = [
      m%"sed -i 's|SHARED|STATIC|g' ${SRC}/CMakeLists.txt"%
    ],
    biDrvs = [
      drvs.lxqtBuildTools,
    ],
  }
}
