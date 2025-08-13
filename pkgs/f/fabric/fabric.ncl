{
  lib,
  drvs,
  fabric | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/Fabric-Development/fabric/archive/3ce7523c34f53fda615f8c425ff9de22e1d812cc.tar.gz",
      sha256sum = "46c4c86bbb0573f4c60eebed0a7dd2028595f9d5136c189139de3169f2287289"
    }
  }
}
