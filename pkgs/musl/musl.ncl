let lib = import "../../nickellib/lib.ncl" in
let muslBase = import "./musl-base.ncl"
in
let _muslStage1 =
  muslBase
  & {
    stage = 1
    #   buildInputs = [
    #     (import "../busybox/busybox-stage-0.ncl"),
    #     (import "../llvm/llvm-stage-0.ncl"),
    #     (import "../musl/musl-stage-0.ncl"),
    #     (import "../gnumake/gnumake-stage-1.ncl"),
    #     (import "../ccache/ccache-bin.ncl"),
    #   ]
  }
in
{
  busyboxStage0,
  llvmStage0,
  gnumakeStage1,
  ccacheBin,
  muslStage0,
  muslStage1 =
    muslBase
    & {
      stage = 1,

      buildInputs =
        lib.biMap [
          busyboxStage0,
          llvmStage0,
          gnumakeStage1,
          ccacheBin,
          muslStage0
        ]
    }
}
