let lib = import "../../nickellib/lib.ncl"
in

let linuxHeadersBase = (import "./linux-headers-base.ncl")
in

let _linuxHeadersStage0 =
  linuxHeadersBase
  & {
    buildInChroot = false,
    name = "linux-headers-stage-0",
  }
in
{
  muslStage0,
  linuxHeadersStage0 =
    _linuxHeadersStage0
    & {
      buildInputs =
        lib.biMap [
          muslStage0
        ]
    }
}
