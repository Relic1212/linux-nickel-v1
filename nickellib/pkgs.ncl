let 
drvUtils=import "drv.ncl"
in

let 
pkgs={
musl-stage-0= import "../pkgs/musl/musl-stage-0.ncl",

musl = import "../pkgs/musl/musl.ncl",
libcxx = import "../pkgs/llvm/libcxx.ncl",
llvmStage0 = import "../pkgs/llvm/llvm-stage-0.ncl"
}
in 


let drvs =
    #drvUtils.pkgToFullDrv pkgs.musl ,
    #drvUtils.pkgToFullDrv pkgs.libcxx ,
    (drvUtils.toDrvsByhash pkgs.musl-stage-0)
    &(drvUtils.toDrvsByhash pkgs.musl )
    &(drvUtils.toDrvsByhash pkgs.libcxx) 
    &
    (drvUtils.toDrvsByhash pkgs.llvmStage0) 

   # ( std.record.map_values drvUtils.toDrvsByhash pkgs)


in 
drvs
