{
  lib,
  expat | lib.AutotoolsPackage
    = {
      name = "expat",
      singleSource = {
        uri = "https://github.com/libexpat/libexpat/releases/download/R_2_6_3/expat-2.6.3.tar.gz",
        sha256sum = "17aa6cfc5c4c219c09287abfc10bc13f0c06f30bb654b28bfe6f567ca646eb79",
      }
    }
}
