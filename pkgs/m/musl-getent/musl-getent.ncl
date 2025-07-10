{
  lib,
  musl,
  llvm,
  ccacheBin,

  muslGetent | lib.Package = {
    #name = "musl-getent",
    singleSource = {
      uri = "https://github.com/alpinelinux/aports/raw/c20d637e3370e89a3e903771fd38374fa1654c9e/main/musl/getent.c",
      sha256sum = "002c1a216f6bed0f816ab1cfebde94a0b127193ef410c36b2190599983e015b8",
    },
    buildPhase = [
      m%"
            cd ${SRC}
            ${CC} -static getent.c -o getent
            install -d -m0755 ${DEST}/usr/bin
            install -m0755 getent ${DEST}/usr/bin
            "%
    ],
    biDrvs =
      lib.biMap [
        musl,
        llvm,
        ccacheBin,
      ]
  }
}
