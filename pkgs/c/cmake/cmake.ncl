let misc = import "cmake-base.ncl"
in
{
  drvs,
  lib,
  # base for non-bootstrap
  _cmakeCmakeBase #| lib.CmakePackage
  = {
    singleSource = misc.cmakeSingleSource,
    cmakeArgs =
      lib.CmakePackage.cmakeArgs
      @ misc.cmakeCmakeArgs
      @ [
        "-G Ninja",
        "-DCMake_ENABLE_DEBUGGER_BOOL=OFF",
        "-DBUILD_TESTING:BOOL=OFF",
        "-DCMAKE_RUN_LONG_TESTS:BOOL=OFF",
        "-DCPACK_BINARY_STGZ:BOOL=OFF",
        "-DCPACK_BINARY_TGZ:BOOL=OFF",
        "-DCPACK_BINARY_TZ:BOOL=OFF",
        "-DCPACK_SOURCE_TBZ2:BOOL=OFF",
        "-DCPACK_SOURCE_TGZ:BOOL=OFF",
        "-DCPACK_SOURCE_TXZ:BOOL=OFF",
        "-DCPACK_SOURCE_TZ:BOOL=OFF",
        "-DCMAKE_C_FLAGS_RELEASE:STRING=\"-O0 -DNDEBUG\"",
        "-DCMAKE_CXX_FLAGS_RELEASE:STRING=\"-O0 -DNDEBUG\"",
      ],

    # buildPhase=[
    #   "ninja bin/cmake"
    # ],
    # installPhase = [
    #   "install -d -m0755 ${DEST}/usr/bin",
    #   "install -m0755 bin/cmake ${DEST}/usr/bin",

    # ]
  },
  # 2

  cmakeStage2 | lib.CmakePackage =
    _cmakeCmakeBase
    & {
      stage = 2,

      biDrvs = [
        drvs.busyboxStage1,
        drvs.llvmStage1,
        drvs.muslStage2,
        drvs.samuraiStage2,
        drvs.cmakeStage1,
        drvs.ccacheBin,
        drvs.linuxHeadersStage2,
      ]
    },

  cmakeStage3 | lib.CmakePackage =
    _cmakeCmakeBase
    & {
      stage = -1,

      utilsProviders = [],
      baseBuildinputPackages = [],
      biDrvs = [
        drvs.busyboxStage2,
        drvs.llvmStage2,
        drvs.muslStage3,
        drvs.samuraiStage3,
        drvs.cmakeStage2,
        drvs.ccacheBin,
        drvs.linuxHeadersStage3,
      ]
    },

  # final

  cmake | lib.CmakePackage =
    _cmakeCmakeBase
    & {
      stage = -1,

      utilsProviders = [],
      baseBuildinputPackages = [],
      biDrvs = [
        drvs.busyboxStage3,
        drvs.llvmStage3,
        drvs.musl,
        drvs.samurai,
        drvs.cmakeStage3,
        drvs.ccacheBin,
        drvs.linuxHeaders,
      ]
    },
}
