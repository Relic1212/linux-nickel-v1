let 
drvUtils=import "drv.ncl"
in

let 
pkgs={
musl-stage-0= import "../pkgs/musl/musl-stage-0.ncl",

# musl = import "../pkgs/musl/musl.ncl",
llvmStage0 = import "../pkgs/llvm/llvm-stage-0.ncl",
llvmBaselibsStage0 = import "../pkgs/llvm/llvm-baselibs-stage-0.ncl",
linuxHeadersStage0=import "../pkgs/linux-headers/linux-headers-stage-0.ncl",
compilerRtStage0=import "../pkgs/compiler-rt/compiler-rt-stage-0.ncl",
binutilsStage0=(import "../pkgs/binutils/binutils.ncl").binutilsStage0,
libsspNonsharedStage0=(import "../pkgs/libssp-nonshared/libssp-nonshared.ncl").libsspNonsharedStage0,

busyboxStage0=(import "../pkgs/busybox/busybox-stage-0.ncl"),
gnumakeStage1=(import "../pkgs/gnumake/gnumake.ncl").gnumakeStage1,

pythonStage1=(import "../pkgs/python/python.ncl").pythonStage1,


}
in 


let drvs =
    #drvUtils.pkgToFullDrv pkgs.musl ,
    #drvUtils.pkgToFullDrv pkgs.libcxx ,
    (drvUtils.toDrvsByhash pkgs.musl-stage-0)
    # &(drvUtils.toDrvsByhash pkgs.musl )
    &
    (drvUtils.toDrvsByhash pkgs.llvmStage0) 
    &(drvUtils.toDrvsByhash pkgs.linuxHeadersStage0) 
    &(drvUtils.toDrvsByhash pkgs.compilerRtStage0)
    &(drvUtils.toDrvsByhash pkgs.binutilsStage0)
    &(drvUtils.toDrvsByhash pkgs.llvmBaselibsStage0)
    &(drvUtils.toDrvsByhash pkgs.libsspNonsharedStage0)
    &(drvUtils.toDrvsByhash pkgs.busyboxStage0)
    &(drvUtils.toDrvsByhash pkgs.gnumakeStage1)
    &(drvUtils.toDrvsByhash pkgs.pythonStage1)




   # ( std.record.map_values drvUtils.toDrvsByhash pkgs)


in 
let pkgsArr=(std.record.values pkgs )@[
    (import "../pkgs/cmake/cmake.ncl").cmakeStage1,
    (import "../pkgs/m4/m4.ncl").m4Stage1,
    (import "../pkgs/flex/flex.ncl").flexStage1,
    (import "../pkgs/bison/bison.ncl").bisonStage1,
    #(import "../pkgs/llvm/llvm.ncl").llvmStage1,
    (import "../pkgs/llvm/llvm-stage-1.ncl"),

   # (import "../pkgs/ninja/ninja.ncl").ninjaStage1,



]
in
let 
drvs2=std.record.merge_all (std.array.map (drvUtils.toDrvsByhash) pkgsArr)
in
drvs2
