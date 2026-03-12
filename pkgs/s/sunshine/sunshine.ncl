{
  lib,
  drvs,
  sunshine | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/LizardByte/Sunshine/archive/refs/tags/v2025.924.154138.tar.gz",
      sha256sum = "109f68c8c01f50c0df2214790a307b7f2589c2b575d8961d9a5ed3ef42660b54",
    }
  }
}
