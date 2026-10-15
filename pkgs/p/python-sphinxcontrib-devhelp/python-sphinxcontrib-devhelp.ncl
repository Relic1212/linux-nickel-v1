{
  lib,
  drvs,
  pythonSphinxcontribDevhelp | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/sphinx-doc/sphinxcontrib-devhelp/archive/refs/tags/2.0.0.tar.gz",
      sha256sum = "e650ce2bde1204477df2f428757e14aa85735bd6a40517645eba55730262b8e8",
    },

    biDrvs = [
      drvs.pythonFlitCore312,
    ],
  }
}
