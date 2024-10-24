let lib = import "../../nickellib/lib.ncl"
in

let { gnumakeSourceInput } = (import "gnumake-base.ncl")
in

let _gnumake | lib.AutotoolsPackage
  = {
    baseName = "gnumake",

    sourceInputs = [
      gnumakeSourceInput
    ],
  }
  in
{
  busyboxStage1,
  llvmStage1,
  muslStage1,
  gnumakeStage1,
  ccacheBin,
  gnumakeStage2 =
    _gnumake
    & {
      stage = 2,
      buildInputs =
        lib.biMap [
          busyboxStage1,
          llvmStage1,
          muslStage1,
          gnumakeStage1,
          ccacheBin,
        ]
    }
}
