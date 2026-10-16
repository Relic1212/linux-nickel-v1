{
  lib,
  drvs,
  pythonRich | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/Textualize/rich/archive/refs/tags/v15.0.0.tar.gz",
      sha256sum = "5e79a8738b4e4e552291253c69e32c695de38f24400b137b119d54385234526a",
    },
    biDrvs = [
      drvs.pythonPoetryCore,
      drvs.pythonPoetry,
    ]
  }
}
