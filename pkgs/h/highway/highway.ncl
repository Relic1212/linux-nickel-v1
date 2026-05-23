{
  lib,
  drvs,
  highway | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/google/highway/archive/refs/tags/1.4.0.tar.gz",
      sha256sum = "e72241ac9524bb653ae52ced768b508045d4438726a303f10181a38f764a453c"
    },
    cmakeExtraArgsRecord = {
      "-DHWY_SYSTEM_GTEST" = true,
      "-DHWY_ENABLE_EXAMPLES" = false,
      "-DHWY_ENABLE_TESTS" = false,
    },
    biDrvs = [
      drvs.googletest,
      drvs.linuxHeaders,
    ]
  }
}
