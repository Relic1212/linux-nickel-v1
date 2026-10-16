{
  lib,
  drvs,
  fabric | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/Fabric-Development/fabric/archive/refs/tags/v0.0.2.tar.gz",
      sha256sum = "83e521fc68a51c9cbeefbdb1965eec42ceca4033fa5d7aea90db9ae1c4f608dd"
    }
  }
}
