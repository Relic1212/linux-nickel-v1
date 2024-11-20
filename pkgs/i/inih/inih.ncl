{
  lib,
  drvs,
  inih | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://github.com/benhoyt/inih/archive/refs/tags/r58.tar.gz",
        sha256sum = "e79216260d5dffe809bda840be48ab0eec7737b2bb9f02d2275c1b46344ea7b7"
      }
    }
}
