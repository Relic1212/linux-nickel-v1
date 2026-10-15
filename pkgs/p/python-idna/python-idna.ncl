{
  lib,
  drvs,
  pythonIdna | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/kjd/idna/archive/refs/tags/v3.20.tar.gz",
      sha256sum = "3b64b9833de055ddf182017c01761a57a2d9756b3c234ce5cae5007255d7368f",
    },
    biDrvs = [
      drvs.pythonFlitCore312,
    ],
  }
}
