{
  lib,
  drvs,
  zxing | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      # uri = "https://github.com/zxing/zxing/archive/refs/tags/zxing-3.5.4.tar.gz",
      # sha256sum = "0eb2f54ad45ee19617dd0fb6ac19e4aa7022d6a6d0a8c95b4e85727bd67ee56c",
      #   uri = "https://github.com/zxing-cpp/zxing-cpp/archive/refs/tags/v3.0.2.tar.gz",
      #   sha256sum = "b063dacf384c7bb93ab2c3eea247cc06b4525330f0efa631907aa3029f7e2144",
      uri = "https://github.com/zxing-cpp/zxing-cpp/archive/refs/tags/v2.3.0.tar.gz",
      sha256sum = "64e4139103fdbc57752698ee15b5f0b0f7af9a0331ecbdc492047e0772c417ba",
    },
    sourceInputs = [
      {
        src = singleSource,
      },
      #   {
      #     src = {
      #       uri = "https://github.com/zint/zint/archive/55541e139e62b9209b71cd9b0ba9010cec28b1d9.tar.gz",
      #       sha256sum = "9f09d2ba0838291188fb9fdea36a864b5e1fdd9c1ff9eb1ac673fa38dbfe69cc"
      #     },
      #     dest = "zint"
      #   },
    ],
    cmakeExtraArgsRecord = {
      "-DZXING_EXAMPLES" = false,
      "-DZXING_EXAMPLES_QT" = false,
      "-DZXING_BLACKBOX_TESTS" = false,
      "-DZXING_UNIT_TESTS" = false,
      "-DZXING_TEST_DOTNET" = false,
      "-DZXING_DEPENDENCIES" = "LOCAL",
      "-DZXING_READERS" = false,
    },
  }
}
