{
  lib,
  drvs,
  lmdb | lib.MakePackage = {
    extraMakeArgs = [
      "-C libraries/liblmdb",
      "CC=\"${CC}\"",
      "prefix=/usr",
    ],
    extraMakeInstallArgs =
      []
      @ extraMakeArgs,
    preConfigurePhase = [
      "sed -i 's@ILIBS	= liblmdb.a liblmdb$(SOEXT)@ILIBS	= liblmdb.a@g' ${SRC}/libraries/liblmdb/Makefile",
    ],
    singleSource = {
      uri = "https://github.com/LMDB/lmdb/archive/refs/tags/LMDB_0.9.35.tar.gz",
      sha256sum = "18b021fd589d30cc08860a9550a30ae51637117451385e9581616da751326632",
    }
  }
}
