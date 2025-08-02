{
  lib,
  drvs,
  cli11 | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/CLIUtils/CLI11/archive/refs/tags/v2.5.0.tar.gz",
      sha256sum = "17e02b4cddc2fa348e5dbdbb582c59a3486fa2b2433e70a0c3bacb871334fd55"
    },
    biDrvs = [
      # drvs.catch2,,
      drvs.boost,
    ],
    cmakeExtraArgsRecord = {
      "-DCLI11_BUILD_TESTS" = false,
      "-DCLI11_BUILD_DOCS" = false,
      "-DCLI11_BUILD_EXAMPLES" = "no",
    }
  }
}
& {
  lib,
  drvs,
  catch2Cmake | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/catchorg/Catch2/archive/refs/tags/v3.9.0.tar.gz",
      sha256sum = "8061daf97429621bc62096841af02fc40070fad26cd04c93ee0b5a825cedb122"
    }
  }
}
