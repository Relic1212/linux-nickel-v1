{
  lib,
  drvs,
  pythonSphinxcontribSerializinghtml | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/sphinx-doc/sphinxcontrib-serializinghtml/archive/refs/tags/2.0.0.tar.gz",
      sha256sum = "f418c9f2e93c2e732c5232b570c95e73b6b5c8dd54190f3645e96fb565ea272f",
    },

    biDrvs = [
      drvs.pythonFlitCore312,
    ],
  }
}
