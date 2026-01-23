{
  lib,
  drvs,
  libavif | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.3.0.tar.gz",
      sha256sum = "0a545e953cc049bf5bcf4ee467306a2f113a75110edf59e61248873101cd26c1"
    },
    cmakeExtraArgsRecord = {
      "-DAVIF_LIBYUV" = false
    },
    preConfigurePhase = [
      m%"sed -i 's|BUILD_SHARED_LIBS OR VCPKG_TARGET_TRIPLET|true|g' ${SRC}/CMakeLists.txt"%
    ],
  }
}
