{

  lib,
  drvs,
  glaze | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/stephenberry/glaze/archive/refs/tags/v7.0.2.tar.gz",
      sha256sum = "febbec555648b310c2a1975ca750939cd00c4801dede8362fcf84cab7b3ae46f"
    },

    cmakeExtraArgsRecord = {
      "-DBUILD_TESTING" = false,
      "-Dglaze_DEVELOPER_MODE" = false,
    }
  }
}
