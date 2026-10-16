{
  lib,
  drvs,
  pythonReadmeRenderer | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/pypa/readme_renderer/archive/refs/tags/46.0.tar.gz",
      sha256sum = "719933245e101e70e34e09c7cae80e1596fad36b72ac31ed16baef101f089921",
    }
  }
}
