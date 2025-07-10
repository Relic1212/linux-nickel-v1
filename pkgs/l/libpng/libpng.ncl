{
  lib,
  zlibNg,

  libpng | lib.AutotoolsPackage = {
    #name = "libpng",
    singleSource = {
      uri = "https://download.sourceforge.net/libpng/libpng-1.6.44.tar.gz",
      sha256sum = "8c25a7792099a0089fa1cc76c94260d0bb3f1ec52b93671b572f8bb61577b732",
    },
    biDrvs =
      lib.biMap [
        zlibNg
      ]
  }
}
