{
  lib,
  drvs,
  pythonDasbus | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/dasbus-project/dasbus/archive/refs/tags/v1.7.tar.gz",
      sha256sum = "442a8df9330d4f55704c92cbed066cf0918378418be89d6fff67721d3cba5590",
    }
  }
}
