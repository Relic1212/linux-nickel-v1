{
  lib,
  drvs,
  pythonNh3 | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/messense/nh3/archive/refs/tags/v0.3.7.tar.gz",
      sha256sum = "fc308c02f7912f45801bdb503652a41db5c8e4eb82767c5c5374de4019706244",
    }
  }
}
