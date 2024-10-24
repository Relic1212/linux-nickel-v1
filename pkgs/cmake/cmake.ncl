let
 lib = import "../../nickellib/lib.ncl" 
 in
let 
misc = import "cmake-base.ncl" 
in
let
 cmakeCmakeBase |lib.CmakePackage={
    baseName="cmake",
    sourceInputs=misc.cmakeBase.sourceInputs,
    cmakeArgs=lib.CmakePackage.cmakeArgs @ misc.cmakeCmakeArgs @[
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
in {
    # 2
     busyboxStage1,
  llvmStage1,
  muslStage2,
  cmakeStage1,
  samuraiStage2,
  ccacheBin,
  linuxHeadersStage2,
  cmakeStage2 =
    cmakeCmakeBase
    & {
        stage=2,
      buildInputs =
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

    # final 

     busyboxStage2,
  llvmStage2,
  musl,
  samurai,
  ccacheBin,
  linuxHeaders,
  cmake =
    cmakeCmakeBase
    & {
        stage=-1,
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