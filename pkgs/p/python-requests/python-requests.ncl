{
  lib,
  drvs,
  pythonRequests | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/psf/requests/archive/refs/tags/v2.34.2.tar.gz",
      sha256sum = "d3c132d905099fa3468bb5cb273c2bdf5a7a92dce987c93b198820b3a7b57228",
    }
  }
}
