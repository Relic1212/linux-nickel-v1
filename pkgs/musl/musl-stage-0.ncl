let muslBase=import "./musl-base.ncl"
in 
let muslStageZero=muslBase&{buildInputs=[], buildInChroot=false}
in 
muslStageZero