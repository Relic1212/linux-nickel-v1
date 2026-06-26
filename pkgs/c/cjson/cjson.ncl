{
  lib,
  drvs,
  cjson | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/DaveGamble/cJSON/archive/refs/tags/v1.7.19.tar.gz",
      sha256sum = "7fa616e3046edfa7a28a32d5f9eacfd23f92900fe1f8ccd988c1662f30454562",
    },
    cmakeExtraArgsRecord = {
      "-DCMAKE_POLICY_VERSION_MINIMUM" = "3.5",
      "-DENABLE_CJSON_TEST" = false,
    },
    preConfigurePhase = [
      m%"sed -i 's|-std=c89|-std=c99|g' ${SRC}/CMakeLists.txt"%,
    ]
  }
}
