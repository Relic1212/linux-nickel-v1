{
  lib,
  drvs,
  groff | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://mirrors.dotsrc.org/gnu/groff/groff-1.23.0.tar.gz",
      sha256sum = "6b9757f592b7518b4902eb6af7e54570bdccba37a871fddb2d30ae3863511c13"
    },
    biDrvs = [
      drvs.perl,
      drvs.libtool,
      drvs.pkgconf,
      drvs.m4,
      drvs.flex,
    ]
  }
}
