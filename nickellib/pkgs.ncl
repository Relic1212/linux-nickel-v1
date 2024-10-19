let 
drvUtils=import "drv.ncl"
in

let 
pkgs={
musl-stage-0= import "../pkgs/musl/musl-stage-0.ncl",

musl = import "../pkgs/musl/musl.ncl",
libcxx = import "../pkgs/llvm/libcxx.ncl"
}
in 


let drvs =
    #drvUtils.pkgToFullDrv pkgs.musl ,
    #drvUtils.pkgToFullDrv pkgs.libcxx ,
    (drvUtils.toDrvsByhash pkgs.musl-stage-0)
    &(drvUtils.toDrvsByhash pkgs.musl )
    &(drvUtils.toDrvsByhash pkgs.libcxx) 


in 
drvs
