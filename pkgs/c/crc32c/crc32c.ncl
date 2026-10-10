{
  lib,
  drvs,
  crc32c | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/google/crc32c/archive/refs/tags/1.1.2.tar.gz",
      sha256sum = "ac07840513072b7fcebda6e821068aa04889018f24e10e46181068fb214d7e56",
    },
    cmakeExtraArgsRecord = {
      "-DCMAKE_POLICY_VERSION_MINIMUM" = "3.5",
      "-DCRC32C_BUILD_BENCHMARKS" = false,
      "-DCRC32C_BUILD_TESTS" = false,
      "-DCRC32C_USE_GLOG" = false,
    },
  }
}
