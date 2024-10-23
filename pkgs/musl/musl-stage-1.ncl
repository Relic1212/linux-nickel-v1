let muslBase = import "./musl-base.ncl"
in
let muslStage1 =
  muslBase
  & {
    buildInputs = [
      (import "../busybox/busybox-stage-0.ncl"),
      (import "../llvm/llvm-stage-0.ncl"),
      (import "../musl/musl-stage-0.ncl"),
      (import "../gnumake/gnumake-stage-1.ncl"),
      (import "../ccache/ccache-bin.ncl"),
    ]
  }
in

muslStage1
