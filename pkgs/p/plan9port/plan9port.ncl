{
  lib,
  drvs,
  plan9port | lib.Package
    = {
      singleSource = {
        uri = "https://github.com/9fans/plan9port/archive/61e362add9e1485bec1ab8261d729016850ec270.zip",
        sha256sum = "b86ed10afe0c469fa4c477527f0a3bcfe79b83c1d14a30b2e9f83d674295e455"
      },
      buildEnv,
      extraEnv = {
        CC9 = buildEnv.CC,
        CC9FLAGS = buildEnv.CFLAGS @ buildEnv.LDFLAGS,
      },

      biDrvs = [
        drvs.musl,
        drvs.llvm,
        drvs.ccacheBin,
        drvs.linuxHeaders,
      ],

      separateBuildDir = false,

      buildPhase = [
        "./INSTALL -b",
        "PLAN9_TARGET=/usr ./INSTALL -c",
      ],
      installPhase = []
    }
}
