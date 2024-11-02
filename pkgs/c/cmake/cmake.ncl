let misc = import "cmake-base.ncl"
in
{
  pkgs,
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

  cmakeStage2 | lib.CmakePackage
    =
      _cmakeCmakeBase
      & {
        stage = 2,

        biDrvs =
          lib.biMap [
            pkgs.busyboxStage1,
            pkgs.llvmStage1,
            pkgs.muslStage2,
            pkgs.samuraiStage2,
            pkgs.cmakeStage1,
            pkgs.ccacheBin,
            pkgs.linuxHeadersStage2,
          ]
      },

  cmakeStage3 | lib.CmakePackage
    =
      _cmakeCmakeBase
      & {
        stage = -1,

        utilsProviders = [],
        baseBuildinputPackages = [],
        biDrvs =
          lib.biMap [
            pkgs.busyboxStage2,
            pkgs.llvmStage2,
            pkgs.muslStage3,
            pkgs.samuraiStage3,
            pkgs.cmakeStage2,
            pkgs.ccacheBin,
            pkgs.linuxHeadersStage3,
          ]
      },

  # final

  cmake | lib.CmakePackage
    =
      _cmakeCmakeBase
      & {
        stage = -1,

        utilsProviders = [],
        baseBuildinputPackages = [],
        biDrvs =
          lib.biMap [
            pkgs.busyboxStage3,
            pkgs.llvmStage3,
            pkgs.musl,
            pkgs.samurai,
            pkgs.cmakeStage3,
            pkgs.ccacheBin,
            pkgs.linuxHeaders,
          ]
      },
}
