let misc = import "cmake-base.ncl"
in
{
  busyboxStage1,
  llvmStage1,
  muslStage2,
  samuraiStage2,
  cmakeStage1,
  ccacheBin,
  linuxHeadersStage2,

  lib,
  # base for non-bootstrap
  _cmakeCmakeBase #| lib.CmakePackage
  = {
    baseName = "cmake",
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

      biDrvs =
        lib.biMap [
          busyboxStage1,
          llvmStage1,
          muslStage2,
          samuraiStage2,
          cmakeStage1,
          ccacheBin,
          linuxHeadersStage2,
        ]
    },

  busyboxStage2,
  llvmStage2,
  muslStage3,
  samuraiStage3,
  cmakeStage2,
  ccacheBin,
  linuxHeadersStage3,
  cmakeStage3 | lib.CmakePackage =
    _cmakeCmakeBase
    & {
      stage = -1,

      utilsProviders = [],
      baseBuildinputPackages = [],
      biDrvs =
        lib.biMap [
          busyboxStage2,
          llvmStage2,
          muslStage3,
          samuraiStage3,
          cmakeStage2,
          ccacheBin,
          linuxHeadersStage3,
        ]
    },

  # final
  busyboxStage3,
  llvmStage3,
  musl,
  samurai,
  cmakeStage3,
  ccacheBin,
  linuxHeaders,
  cmake | lib.CmakePackage =
    _cmakeCmakeBase
    & {
      stage = -1,

      utilsProviders = [],
      baseBuildinputPackages = [],
      biDrvs =
        lib.biMap [
          busyboxStage3,
          llvmStage3,
          musl,
          samurai,
          cmakeStage3,
          ccacheBin,
          linuxHeaders,
        ]
    },
}
