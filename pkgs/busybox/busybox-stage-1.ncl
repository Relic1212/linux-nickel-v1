
let lib = import "../../nickellib/lib.ncl"
in
let x=import "busybox-base.ncl" in 
let busyboxTarget =x.busyboxBaseTarget
in
let 
  busyboxStage1 |lib.MakePackage= busyboxTarget&{
    stage=1,
    name|priority 1="busybox-stage-1",
    buildInputs=[
      (import "../busybox/busybox-stage-0.ncl"),
           (import "../llvm/llvm.ncl").llvmStage1,
           (import "../musl/musl-stage-1.ncl"),
          # (import "../gnumake/gnumake.ncl").gnumakeStage1,
          # (import "../ccache/ccache-bin.ncl"),
          # (import "../linux-headers/linux-headers-stage-1.ncl"),

    ],
   },

   in 
   busyboxStage1