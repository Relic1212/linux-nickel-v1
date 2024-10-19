let 
drvUtils=import "drv.ncl"
in

let 
pkgs={
musl = import "../pkgs/musl/musl.ncl",
libcxx = import "../pkgs/llvm/libcxx.ncl"
}
in 


let drvs =[
    drvUtils.pkgToFullDrv pkgs.musl ,
    drvUtils.pkgToFullDrv pkgs.libcxx ,

]
in 
drvs
