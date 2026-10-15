{
  lib,
  drvs,
  pythonSphinxcontribHtmlhelp | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/sphinx-doc/sphinxcontrib-htmlhelp/archive/refs/tags/2.1.0.tar.gz",
      sha256sum = "52abf96834748a325d396156e5452a77bef3396e9d62fb22a09c0742fa19f663",
    },
    biDrvs = [
      drvs.pythonFlitCore312,
    ]
  }
}
