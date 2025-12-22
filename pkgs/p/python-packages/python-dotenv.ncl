{
  lib,
  drvs,
  pythonDotenv | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/theskumar/python-dotenv/archive/refs/tags/v1.2.1.tar.gz",
      sha256sum = "d9eebba53ff89f06bf99f2c87d2abef2b9da0790dc4b082ce1f9c5572f2cb1d0"
    },
    # biDrvs = [
    #     drvs.pythonFull,
    #     drvs.pythonSetuptools80,
    # ]
  }
}
