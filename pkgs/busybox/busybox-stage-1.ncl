(import "busybox-base.ncl")
& {
  lib,
  _busyboxBaseTarget,
  busyboxStage0,
  llvmStage1,
  muslStage1,
  linuxHeadersStage1,
  ccacheBin,
  gnumakeStage1,
  busyboxStage1 =
    _busyboxBaseTarget
    & {
      stage = 1,
      buildInputs =
        lib.biMap [
          busyboxStage0,
          llvmStage1,
          muslStage1,
          linuxHeadersStage1,
          ccacheBin,
          gnumakeStage1
        ]
    },

  llvmStage2,
  muslStage2,
  linuxHeadersStage2,
  ccacheBin,
  gnumakeStage2,
  busyboxStage2 =
    _busyboxBaseTarget
    & {
      stage = 2,
      buildInputs =
        lib.biMap [
          busyboxStage1,
          llvmStage2,
          muslStage2,
          linuxHeadersStage2,
          ccacheBin,
          gnumakeStage2
        ]
    },

  #final
  llvm,
  musl,
  linuxHeaders,
  ccacheBin,
  gnumake,
  busybox =
    _busyboxBaseTarget
    & {
      stage = -1,
      buildInputs =
        lib.biMap [
          busyboxStage2,
          llvm,
          musl,
          linuxHeaders,
          ccacheBin,
          gnumake
        ]
    }
}
