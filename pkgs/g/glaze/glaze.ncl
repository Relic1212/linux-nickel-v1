{

  lib,
  drvs,
  glaze | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/stephenberry/glaze/archive/refs/tags/v5.5.5.tar.gz",
      sha256sum = "c2ae536d634aa12f49ac7521f169d2891af55b3376648cbb0053daadb78b6ef1"
    },

    cmakeExtraArgsRecord = {
      "-DBUILD_TESTING" = false,
      "-Dglaze_DEVELOPER_MODE" = false,
    }
  }
}
