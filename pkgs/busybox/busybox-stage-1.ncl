
let lib = import "../../nickellib/lib.ncl"
in
let x=import "busybox-base.ncl" in 
let busyboxTarget =x.busyboxBaseTarget
in
let 
  _busyboxStage1 |lib.MakePackage= busyboxTarget&{
    stage=1,
    name|priority 1="busybox-stage-1",
    # buildInputs=[
    #   (import "../busybox/busybox-stage-0.ncl"),
    #        (import "../llvm/llvm.ncl").llvmStage1,
    #        (import "../musl/musl-stage-1.ncl"),
    #       # (import "../gnumake/gnumake.ncl").gnumakeStage1,
    #       # (import "../ccache/ccache-bin.ncl"),
    #       # (import "../linux-headers/linux-headers-stage-1.ncl"),

    # ],
   },

   in 
   {
    busyboxStage0,llvmStage1,muslStage1,linuxHeadersStage1,ccacheBin,gnumakeStage1,
   busyboxStage1=_busyboxStage1&{
    buildInputs=lib.biMap[
    busyboxStage0,llvmStage1,muslStage1,linuxHeadersStage1,ccacheBin,gnumakeStage1

    
       ]
   }
   }