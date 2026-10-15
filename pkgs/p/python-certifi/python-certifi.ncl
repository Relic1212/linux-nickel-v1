{
  lib,
  drvs,
  pythonCertifi | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/certifi/python-certifi/archive/refs/tags/2026.07.22.tar.gz",
      sha256sum = "e2ac9fa32eb2dacee4024443d75187a62868f9cc2ea72b15195c8dfa8c6c16ef",
    }
  }
}
