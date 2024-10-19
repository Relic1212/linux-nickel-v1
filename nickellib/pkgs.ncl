let 
drvUtils=import "drv.ncl"
in

let 
musl = import "../pkgs/musl/musl.ncl"
in 
let 
_musl=musl
in
let drvs =[
    drvUtils.pkgToFullDrv _musl
]
in 
drvs
