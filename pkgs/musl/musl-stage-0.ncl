let muslBase=import "./musl-base.ncl"
in 
let muslStageZero=muslBase&{buildInputs=[], buildInChroot=false,name|priority 1="musl-stage-0"}
in 
muslStageZero