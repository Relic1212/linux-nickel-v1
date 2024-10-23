let muslBase = import "./musl-base.ncl"
in
let _muslStage0 = muslBase & { buildInputs = [], buildInChroot = false, name | priority 1 = "musl-stage-0" }
in
{
  muslStage0 = _muslStage0
}
