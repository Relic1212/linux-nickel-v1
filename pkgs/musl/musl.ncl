let muslBase = import "./musl-base.ncl"
in
let _muslStage1 =
  muslBase
  & {
    buildInputs = [
      (import "../busybox/busybox-stage-0.ncl"),
      (import "../llvm/llvm-stage-0.ncl"),
      (import "../musl/musl-stage-0.ncl"),
      (import "../gnumake/gnumake.ncl-stage-1"),
      (import "../ccache/ccache-bin.ncl"),
    ]
  }
in

{
  # muslStage1=_muslStage1,
}
