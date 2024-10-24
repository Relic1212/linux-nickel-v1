let lib = import "../../nickellib/lib.ncl"
in

let bisonBase = import "bison-base.ncl" in

{
  # 1
  muslStage1,
  gnumakeStage1,
  ccacheBin,
  m4Stage1,
  busyboxStage0,
  llvmStage0,
  bisonStage1 =
    bisonBase
    & {
      stage=1,
      buildInputs =
        lib.biMap [
          muslStage1,
          gnumakeStage1,
          ccacheBin,
          m4Stage1,
          busyboxStage0,
          llvmStage0
        ]
    },

# 2
     muslStage2,
  gnumakeStage2,
  ccacheBin,
  m4Stage2,
  busyboxStage1,
  llvmStage1,
  bisonStage2 =
    bisonBase
    & {
      stage=2,
      buildInputs =
        lib.biMap [
          muslStage2,
          gnumakeStage2,
          ccacheBin,
          m4Stage2,
          busyboxStage1,
          llvmStage1,
        ]
    },

# final

     musl,
  gnumake,
  ccacheBin,
  m4,
  busyboxStage2,
  llvmStage2,
  bison =
    bisonBase
    & {
      stage=-1,
      buildInputs =
        lib.biMap [
          musl,
          gnumake,
          ccacheBin,
          m4,
          busyboxStage2,
          llvmStage2,
        ]
    }



}
