{
  lib,
  drvs,
  nodejs | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/nodejs/node/archive/refs/tags/v25.9.0.tar.gz",
      sha256sum = "4c64065e0cc91802fb052835d93ce56134dbce483717cb8ce6c48dd1f67657c6",
    },
    separateBuildDir = false,
    configureFlags = [
      "--prefix=/usr",
      "--fully-static",
      "--without-lief",
      "--without-intl",
      "--without-sqlite",
      "--use_clang",
    ],
    biDrvs = [
      drvs.pythonInteractive,
      drvs.linuxHeaders,
      drvs.libemptyAtomic,
      drvs.libempty,
    ]
  }
}
