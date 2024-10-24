let lib = import "../../nickellib/lib.ncl" in
let muslBase = import "./musl-base.ncl"
in

{
  busyboxStage0,
  llvmStage0,
  gnumakeStage1,
  ccacheBin,
  muslStage0,
  muslStage1 =
    muslBase
    & {
      stage = 1,

      buildInputs =
        lib.biMap [
          busyboxStage0,
          llvmStage0,
          gnumakeStage1,
          ccacheBin,
          muslStage0
        ]
    },

  busyboxStage1,
  llvmStage1,
  gnumakeStage2,
  ccacheBin,
  muslStage2=    muslBase
    & {
      stage = 2,

      buildInputs =
        lib.biMap [
          busyboxStage1,
          llvmStage1,
          gnumakeStage2,
          ccacheBin,
          muslStage1
        ]
    },

}
