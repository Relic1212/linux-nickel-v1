{
  lib,
  drvs,
  libjpegTurbo | lib.CmakePackage = {
    # buildEnv._isStatic = false,
    # isStatic = false,
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/3.0.4.tar.gz",
      sha256sum = "0270f9496ad6d69e743f1e7b9e3e9398f5b4d606b6a47744df4b73df50f62e38"
    },
    cmakeExtraArgsRecord = {
      "-DENABLE_SHARED" = false,
    },
    biDrvs = [
      drvs.muslShared,
    ]
  }
}
# & {
#   lib,
#   drvs,
#   libjpegTurbo,
#   libjpegTurboStatic | lib.CmakePackage = {
#     generator = "Ninja",
#     singleSource = libjpegTurbo.singleSource,
#     biDrvs = [],
#     cmakeExtraArgsRecord = {
#       "-DENABLE_SHARED" = false,
#     }
#   }
# }
