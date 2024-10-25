let lib = import "../../nickellib/lib.ncl"
in
let misc = import "cmake-base.ncl"
in
let cmakeCmakeBase #| lib.CmakePackage
= {
  baseName = "cmake",
  singleSource = misc.cmakeSingleSource,
  cmakeArgs =
    lib.CmakePackage.cmakeArgs
    @ misc.cmakeCmakeArgs
    @ [
      "-G Ninja",
      "-DLLVM_PARALLEL_LINK_JOBS=$(nproc)",
      "-DLLVM_PARALLEL_COMPILE_JOBS=$(nproc)",
      "-DBUILD_TESTING:BOOL=OFF",
      "-DCMAKE_RUN_LONG_TESTS:BOOL=OFF",
      "-DCPACK_BINARY_STGZ:BOOL=OFF",
      "-DCPACK_BINARY_TGZ:BOOL=OFF",
      "-DCPACK_BINARY_TZ:BOOL=OFF",
      "-DCPACK_SOURCE_TBZ2:BOOL=OFF",
      "-DCPACK_SOURCE_TGZ:BOOL=OFF",
      "-DCPACK_SOURCE_TXZ:BOOL=OFF",
      "-DCPACK_SOURCE_TZ:BOOL=OFF",
    ],
}
in
{
  pkgs,
  # 2

  cmakeStage2 | lib.CmakePackage
    =
      cmakeCmakeBase
      & {
        stage = 2,

        buildInputs =
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

  # final

  busyboxStage2,
  llvmStage2,
  musl,
  samurai,
  ccacheBin,
  linuxHeaders,
  cmake | lib.CmakePackage
    =
      cmakeCmakeBase
      & {
        stage = -1,
        buildInputs =
          lib.biMap [
            busyboxStage2,
            llvmStage2,
            musl,
            samurai,
            cmakeStage2,
            ccacheBin,
            linuxHeaders,
          ]
      },
}
