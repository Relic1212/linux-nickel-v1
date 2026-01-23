{
  lib,
  drvs,
  highway | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/google/highway/archive/refs/tags/1.3.0.tar.gz",
      sha256sum = "07b3c1ba2c1096878a85a31a5b9b3757427af963b1141ca904db2f9f4afe0bc2"
    },
    cmakeExtraArgsRecord = {
      "-DHWY_SYSTEM_GTEST" = true
    },
    biDrvs = [
      drvs.googletest,
      drvs.linuxHeaders,
    ]
  }
}
