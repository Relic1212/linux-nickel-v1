
let linuxHeadersBase = (import "./linux-headers-base.ncl")
in 

let 
linuxHeadersStage0 = linuxHeadersBase & { buildInChroot = false, name = "linux-headers-stage-0", buildInputs = [
    # pkgs.muslStage0
     import "../musl/musl-stage-0.ncl"
    ] }
in
linuxHeadersStage0