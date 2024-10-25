let lib = import "../../nickellib/lib.ncl"
in

let m4Base = import "m4-base.ncl" in
{
  busyboxStage0,
  llvmStage0,
  muslStage1,
  gnumakeStage1,
  ccacheBin,
  m4Stage1 =
    m4Base
    & {
      stage = 1,
      buildInputs =
        lib.biMap [
          busyboxStage0,
          llvmStage0,
          muslStage1,
          gnumakeStage1,
          ccacheBin,
        ]
    },

  #2
  busyboxStage1,
  llvmStage1,
  muslStage2,
  gnumakeStage2,
  m4Stage2 =
    m4Base
    & {
      stage = 2,
      buildInputs =
        lib.biMap [
          busyboxStage1,
          llvmStage1,
          muslStage2,
          gnumakeStage2,
          ccacheBin,
        ]
    },

  #final
  busyboxStage2,
  llvmStage2,
  musl,
  gnumake,
  m4 =
    m4Base
    & {
      stage = -1,
      buildInputs =
        lib.biMap [
          busyboxStage2,
          llvmStage2,
          musl,
          gnumake,
          ccacheBin,
        ]
    },
}
