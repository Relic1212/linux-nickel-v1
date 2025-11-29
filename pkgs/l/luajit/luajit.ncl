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
  }
}
