{
  lib,
  drvs,
  pythonSphinxcontribWebsupport | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/sphinx-doc/sphinxcontrib-websupport/archive/refs/tags/2.0.0.tar.gz",
      sha256sum = "ec7b8da36e1ccbb46bcb55697229eaae9da7ef771319c7aeeaffde434e9787f3",
    },

    biDrvs = [
      drvs.pythonFlitCore312,
    ],
  }
}
