{
  lib,
  drvs,
  pythonImagesize | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/shibukawa/imagesize_py/archive/refs/tags/2.0.1.tar.gz",
      sha256sum = "0fdd765d9768fb0b5d3005a925e7a76b0a5a965b3c4a3228226cbe99c3f24c31",
    }
  }
}
