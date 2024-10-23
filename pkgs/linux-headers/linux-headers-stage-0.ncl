let linuxHeadersBase = (import "./linux-headers-base.ncl")
in

let _linuxHeadersStage0 =
  linuxHeadersBase
  & {
    buildInChroot = false,
    name = "linux-headers-stage-0",

    #buildInputs = [
    #      import "../musl/musl-stage-0.ncl"
    #     ]
  }
in
{
  muslStage0,
  linuxHeadersStage0 =
    _linuxHeadersStage0
    & {
      buildInputs = [
        muslStage0
      ]
    }
}
