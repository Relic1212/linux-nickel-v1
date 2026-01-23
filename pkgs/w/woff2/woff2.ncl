{
  lib,
  drvs,
  woff2 | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/google/woff2/archive/refs/tags/v1.0.2.tar.gz",
      sha256sum = "add272bb09e6384a4833ffca4896350fdb16e0ca22df68c0384773c67a175594"
    },
    cmakeExtraArgsRecord = {
      "-DCMAKE_POLICY_VERSION_MINIMUM" = "3.5"
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --static --libs libbrotlienc)"
      ]
    },
    biDrvs = [
      drvs.brotli,
    ]
  }
}
