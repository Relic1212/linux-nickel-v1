{
  lib,
  drvs,
  libjxl | lib.CmakePackage = {
    generator = "Ninja",

    singleSource = {
      uri = "https://github.com/libjxl/libjxl/archive/refs/tags/v0.11.2.tar.gz",
      sha256sum = "ab38928f7f6248e2a98cc184956021acb927b16a0dee71b4d260dc040a4320ea"
    },
    sourceInputs = [
      {
        src = singleSource
      },
      {
        src = {
          uri = "https://github.com/google/skcms/archive/b2e692629c1fb19342517d7fb61f1cf83d075492.tar.gz",
          sha256sum = "96e274f403135c19ad4e7f9272f03a64c0aa5615591b087457e7fd0a5f14af23"
        },
        dest = "third_party/skcms"
      },
      {
        src = {
          uri = "https://github.com/webmproject/sjpeg/archive/94e0df6d0f8b44228de5be0ff35efb9f946a13c9.tar.gz",
          sha256sum = "ac94917fe745a674eabf1e044f23ec55cd5a548c9869c06ec4b19da14ee0227d"
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
      drvs.linuxHeaders,
      drvs.libjpegTurboStatic,
    ],
    pDrvs = [
      drvs.highway,
      drvs.brotli,
      # drvs.zlibNg,
      drvs.libpng,
    ]
  }
}
