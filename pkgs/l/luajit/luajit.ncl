{
  lib,
  drvs,
  luajit | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/LuaJIT/LuaJIT/archive/refs/tags/v2.1.ROLLING.tar.gz",
      sha256sum = "31d7a4853df4c548bf91c13d3b690d19663d4c06ae952b62606c8225d0b410ad"
    },
    extraMakeArgs = [
      "CC=\"${CC}\"",
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ],
    postInstallPhase = [
      m%"cd ${DEST}/usr/bin"%,
      "ln -s luajit-2.1. luajit",
    ]
  },
  luajitStatic | lib.MakePackage =
    luajit
    & {
      postInstallPhase | priority 1 = [
        "rm -f ${DEST}/usr/lib/*.so",
        "rm -f ${DEST}/usr/lib/*.so.*",
      ]
    }
}
& {
  lib,
  drvs,
  luajitGit | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/LuaJIT/LuaJIT/archive/707c12bf00dafdfd3899b1a6c36435dbbf6c7022.tar.gz",
      sha256sum = "ac2defd1e9b4ab07ac0a52f2403318ffb0d54505b975dff0cfc49a927ab84d90",
    },
    extraMakeArgs = [
      "CC=\"${CC}\"",
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ],
    # postInstallPhase = [
    #   m%"cd ${DEST}/usr/bin"%,
    #   "ln -s luajit-2.1. luajit",
    # ],
  }
}
