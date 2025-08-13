{
  lib,
  drvs,
  aubio | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/aubio/aubio/archive/5461304a598952ffdca78f90cef5b6c82475ec4a.tar.gz",
      sha256sum = "f09c58aa757a1fcfca788995daa2cd4e4c1d74ffaad07b7d5a2f36b67c33dea4"
    },
    buildEnv.EXTRA_LDFLAGS = ["-lc++"],
    buildEnv.EXTRA_CXXFLAGS = ["-lc++"],
    biDrvs = [
      drvs.bash,
      drvs.pythonFull,
    ]
  }
}
