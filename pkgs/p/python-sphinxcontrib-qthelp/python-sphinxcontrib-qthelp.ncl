{
  lib,
  drvs,
  pythonSphinxcontribQthelp | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/sphinx-doc/sphinxcontrib-qthelp/archive/refs/tags/2.0.0.tar.gz",
      sha256sum = "8bbb0bc76ad38fc552a73292740b55bdf9ea2ab3d5111ebd58e47cd6225855b2",
    },

    biDrvs = [
      drvs.pythonFlitCore312,
    ],
  }
}
