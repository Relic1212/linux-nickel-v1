let flexBase=import "flex-base.ncl" in 
let
  flexStage1 =
    flexBase
    & {
      stage = 1,
      name = "flex-stage-1",
      buildInputs = [
        (import "../llvm/llvm-stage-0.ncl"),
        (import "../musl/musl-stage-1.ncl"),
        (import "../gnumake/gnumake-stage-1.ncl"),
        (import "../ccache/ccache-bin.ncl"),
        (import "../m4/m4-stage-1.ncl"),
        (import "../busybox/busybox-stage-0.ncl"),
      ]
    }
in 
flexStage1