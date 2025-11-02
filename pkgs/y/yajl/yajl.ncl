{
  lib,
  drvs,
  yajl | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      # uri = "https://github.com/lloyd/yajl/archive/6bc5219389fd2752631682b0a8368e6d8218a8c5.zip",
      # sha256sum = "ffa9b4c85f97aec59db1060c2414d90ede72fa9e96ee70dac84e0b7a221ee649",     
      uri = "https://github.com/lloyd/yajl/archive/5e3a7856e643b4d6410ddc3f84bc2f38174f2872.tar.gz",
      sha256sum = "1523e0923b22fb9e6256083fb3372f90553646c281829d0b213c9b76dcbe4f67",
    },
    sourceInputs = [
      {
        src = singleSource
      },
      {
        src = {
          uri = "https://github.com/lloyd/yajl/commit/6fe59ca50dfd65bdb3d1c87a27245b2dd1a072f9.patch",
          sha256sum = "d91b16e56a226db616d4ab6ef5c11384c11438dd6f6aad933bba74e92721dd5b",
        }
      }
    ],
    cmakeExtraArgsRecord = {
      "-DCMAKE_POLICY_VERSION_MINIMUM" = "3.5"
    },
    preConfigurePhase = [
      "(cd ${SRC} && patch -p1 < 6fe59ca50dfd65bdb3d1c87a27245b2dd1a072f9.patch)",
      m%"sed -i 's| SHARED | STATIC |g' ${SRC}/src/CMakeLists.txt"%,
    ],
  }
}
