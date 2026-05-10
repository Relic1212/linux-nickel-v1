{
  lib,
  drvs,
  spidermonkey | lib.Package = {
    singleSource = {
      uri = "https://archive.mozilla.org/pub/firefox/releases/140.10.1esr/source/firefox-140.10.1esr.source.tar.xz",
      sha256sum = "4e75c0c3e2c5530de9364de388272bf81b2b32209d98fa4a7eb50d268a17a5bb",
    },
    unpackPhase = [
      "tar xf /tmp/workdir/packed/%{singleSource.sha256sum}/firefox-*.source.tar.xz -C /tmp/workdir/src",
    ],
    separateBuildDir = false,
    buildPhase = [
      "mkdir home",
      "export HOME=$(pwd)/home",
      "cd firefox-*",
      "./mach build",
    ],
    biDrvs = [
      drvs.pythonDynamicCurses,
      drvs.muslShared,
    ],
  }
}
