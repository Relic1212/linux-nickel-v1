{
  drvs,
  lib,

  zlibNg | lib.CmakePackage = {
    name = "zlib-ng",
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.2.2.tar.gz",
      sha256sum = "fcb41dd59a3f17002aeb1bb21f04696c9b721404890bb945c5ab39d2cb69654c",
    },

    cmakeArgs =
      lib.CmakePackage.cmakeArgs
      @ [
        "-DWITH_GTEST:BOOL=OFF",
        "-DZLIBNG_ENABLE_TESTS:BOOL=OFF",
        "-DZLIB_ENABLE_TESTS:BOOL=OFF",
        "-DZLIB_COMPAT:BOOL=ON",
        "-Wno-dev"
      ],

    pkgconfProvider | priority -1 = drvs.pkgconf,
  },
  zlibNgPic =
    zlibNg
    & {
      name | priority 1 = "zlib-ng-pic",
      preConfigurePhase = [
        "export CFLAGS=\"${CFLAGS} -fPIC\"",
        "export CXXFLAGS=\"${CXXFLAGS} -fPIC\"",
        "export LDFLAGS=\"${LDFLAGS} -fPIC\"",
      ]
    }
}
