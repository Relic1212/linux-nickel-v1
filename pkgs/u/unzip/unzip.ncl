{
  lib,

  unzip | lib.MakePackage = {
    name = "unzip",
    singleSource = {
      uri = "https://dev.alpinelinux.org/archive/unzip/unzip60.tgz",
      sha256sum = "036d96991646d0449ed0aa952e4fbe21b476ce994abc276e49d30e686708bd37"
    },
    buildDir = "${SRC}",
    buildPhase = [
      "cp unix/Makefile .",
      m%"make CC="${CC} -static --static"  CFLAGS="-static --static" LDFLAGS="-static --static -all-static" prefix=/usr -j$(nproc) unzips"%
    ],
    installPhase = [
      m%"make  CC="${CC} -static --static" CFLAGS="-static --static" LDFLAGS="-static --static -all-static" prefix=${DEST}/usr MANDIR=${DEST}/usr/share/man/man1/ install"%,
    ],
  }
}
