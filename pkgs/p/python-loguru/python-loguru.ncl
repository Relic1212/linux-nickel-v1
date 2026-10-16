{
  lib,
  drvs,
  pythonLoguru | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/Delgan/loguru/archive/refs/tags/0.7.3.tar.gz",
      sha256sum = "1cad8860aa0ecf9567125381e4430046526246e075224350a6a624addac05f5e",
    },

    biDrvs = [
      drvs.pythonFlitCore312,
    ]
  }
}
