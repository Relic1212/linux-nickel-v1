let muslBase=import "./musl-base.ncl"
in 
let musl=muslBase&{buildInputs=[]}
in 
musl