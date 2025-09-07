{
  lib,
  drvs,
  jemalloc | lib.AutomakePackage = {
    singleSource = {

      uri = "https://github.com/jemalloc/jemalloc/archive/1972241cd204c60fb5b66f23c48a117879636161.tar.gz",
      sha256sum = "c4da7c211dd7019e14bd61714eb1367f1e7ce530d6a9d308c40c469654e228f5",
    },

    extraConfigureFlags = [
      "--disable-libdl",
      # "--with-jemalloc-prefix=",
    ],
  }
}
