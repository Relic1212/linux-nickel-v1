{
  lib,
  drvs,
  cabal | lib.Package = {
    singleSource = {
      uri = "https://github.com/haskell/cabal/archive/refs/tags/cabal-install-v3.16.1.0.tar.gz",
      sha256sum = "d06558ebc56e75e713698b00e2079809f846f06f31cd58401309886a2b84390b"
    },
    separateBuildDir = false,
    configurePhase = [
      "cd ${SRC}/bootstrap",
    ]
  }
}
