let lib = import "../../nickellib/lib.ncl"
in
let x = import "./busybox-base.ncl" in
let busyboxTarget = x.busyboxBaseTarget
in

{
  busyboxStage0,
  llvmStage1,
  muslStage1,
  linuxHeadersStage1,
  ccacheBin,
  gnumakeStage1,
  busyboxStage1 =
    busyboxTarget
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
    busyboxTarget
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
    busyboxTarget
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
