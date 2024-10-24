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
      stage=1,
      buildInputs =
        lib.biMap [
          busyboxStage0,
          llvmStage0,
          muslStage1,
          gnumakeStage1,
          ccacheBin,
        ]
    }
}
