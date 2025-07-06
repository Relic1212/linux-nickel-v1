{
  lib,
  linuxHeaders,

  mtdev | lib.AutotoolsPackage = {
    name = "mtdev",
    singleSource = {
      uri = "https://bitmath.se/org/code/mtdev/mtdev-1.1.7.tar.gz",
      sha256sum = "a55bd02a9af4dd266c0042ec608744fff3a017577614c057da09f1f4566ea32c"
    },
    biDrvs =
      lib.biMap [
        linuxHeaders,
      ]
  }
}
