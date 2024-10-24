let lib = import "../../nickellib/lib.ncl"
in
let flexBase = import "flex-base.ncl" in

{
  llvmStage0,
  muslStage1,
  gnumakeStage1,
  ccacheBin,
  m4Stage1,
  busyboxStage0,
  flexStage1 =
    flexBase
    & {
      stage=1,
      buildInputs =
        lib.biMap [
          llvmStage0,
          muslStage1,
          gnumakeStage1,
          ccacheBin,
          m4Stage1,
          busyboxStage0,
        ]
    },

#2
  llvmStage1,
  muslStage2,
  gnumakeStage2,
  m4Stage2,
  busyboxStage1,
  flexStage2 =
    flexBase
    & {
      stage=2,
      buildInputs =
        lib.biMap [
          llvmStage1,
          muslStage2,
          gnumakeStage2,
          ccacheBin,
          m4Stage2,
          busyboxStage1,
        ]
    },
    #final 
     llvmStage2,
  musl,
  gnumake,
  m4,
  busyboxStage2,
  flex =
    flexBase
    & {
      stage=-1,
      buildInputs =
        lib.biMap [
          llvmStage2,
          musl,
          gnumake,
          ccacheBin,
          m4,
          busyboxStage2,
        ]
    }
}
