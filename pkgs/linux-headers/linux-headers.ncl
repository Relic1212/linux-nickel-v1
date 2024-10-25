let lib = import "../../nickellib/lib.ncl"
in
let linuxHeadersBase = (import "./linux-headers-base.ncl")
in

{

  busyboxStage0,
  llvmStage0,
  muslStage1,
  gnumakeStage1,
  ccacheBin,
  m4Stage1,
  flexStage1,
  bisonStage1,
  linuxHeadersStage1 =
    linuxHeadersBase
    & {
      stage = 1,
      buildInputs =
        lib.biMap [
          busyboxStage0,
          llvmStage0,
          muslStage1,
          gnumakeStage1,
          ccacheBin,
          m4Stage1,
          flexStage1,
          bisonStage1,
        ]
    },

  busyboxStage1,
  llvmStage1,
  muslStage2,
  gnumakeStage2,
  m4Stage2,
  flexStage2,
  bisonStage2,
  linuxHeadersStage2 =
    linuxHeadersBase
    & {
      stage = 2,
      buildInputs =
        lib.biMap [
          busyboxStage1,
          llvmStage1,
          muslStage2,
          gnumakeStage2,
          ccacheBin,
          m4Stage2,
          flexStage2,
          bisonStage2,
        ]
    },

  #final
  busyboxStage2,
  llvmStage2,
  musl,
  gnumake,
  m4,
  flex,
  bison,
  linuxHeaders =
    linuxHeadersBase
    & {
      stage = -1,
      buildInputs =
        lib.biMap [
          busyboxStage2,
          llvmStage2,
          musl,
          gnumake,
          ccacheBin,
          m4,
          flex,
          bison,
        ]
    },
}
