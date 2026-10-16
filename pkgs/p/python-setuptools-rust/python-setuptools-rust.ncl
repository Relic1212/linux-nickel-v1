{
  lib,
  drvs,
  pythonSetuptoolsRust | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/PyO3/setuptools-rust/archive/refs/tags/v1.13.0.tar.gz",
      sha256sum = "7e502b9069fc35804e0a9b249a65ba90679dcd1abd51d397163d8376cad0667d",
    }
  }
}
