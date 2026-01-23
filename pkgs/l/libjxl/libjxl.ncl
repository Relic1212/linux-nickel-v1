{
  lib,
  drvs,
  libjxl | lib.CmakePackage = {
    generator = "Ninja",

    singleSource = {
      uri = "https://github.com/libjxl/libjxl/archive/refs/tags/v0.11.1.tar.gz",
      sha256sum = "1492dfef8dd6c3036446ac3b340005d92ab92f7d48ee3271b5dac1d36945d3d9"
    },
    sourceInputs = [
      {
        src = singleSource
      },
      {
        src = {
          uri = "https://github.com/google/skcms/archive/42030a771244ba67f86b1c1c76a6493f873c5f91.tar.gz",
          sha256sum = "f070f9f7ac770ea2aab977cdc628e087a0eabaae9dd04883a511dfd6e37232b5"
        },
        dest = "third_party/skcms"
      },
      {
        src = {
          uri = "https://github.com/webmproject/sjpeg/archive/e5ab13008bb214deb66d5f3e17ca2f8dbff150bf.tar.gz",
          sha256sum = "35c5ad32fd422d279f394dced490208674284ae2f58221c1dfb981dbbdf695b5"
        },
        dest = "third_party/sjpeg"
      },
    ],
    cmakeExtraArgsRecord = {
      "-DCMAKE_POLICY_VERSION_MINIMUM" = "3.5",
      "-DBUILD_TESTING" = false,
    },
    biDrvs = [
      drvs.googletest,
      drvs.highway,
      drvs.linuxHeaders,
      drvs.brotli,
      drvs.zlibNg,
      drvs.libjpegTurboStatic,
      drvs.libpng,
    ]
  }
}
