{
    lib,
    drvs,
    ghc | lib.AutotoolsPackage = {
        singleSource = {
            uri = "https://downloads.haskell.org/~ghc/9.12.2/ghc-9.12.2-src.tar.xz",
            sha256sum = "0e49cd5dde43f348c5716e5de9a5d7a0f8d68d945dc41cf75dfdefe65084f933",
        },
        separateBuildDir=false,
        # preConfigurePhase = [
        #     "cd ${SRC}",
        #     "./boot" ,
            
        #     ],
        buildPhase = [
            "DESTDIR=\"${DEST}\" ./hadrian/build",
        ],
        installPhase = []
    }
}