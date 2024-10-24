let lib = import "../../nickellib/lib.ncl"
in

let m4Base = import "m4-base.ncl" in
let _m4Stage1 | lib.AutotoolsPackage
  =
    m4Base
    & {
      stage = 1,
      name = "m4-stage-1",
      # buildInputs = [
      #   (import "../busybox/busybox-stage-0.ncl"),
      #   (import "../llvm/llvm-stage-0.ncl"),
      #   (import "../musl/musl-stage-1.ncl"),
      #   (import "../gnumake/gnumake-stage-1.ncl"),
      #   (import "../ccache/ccache-bin.ncl"),
      # ]
    }
  in
{
  busyboxStage0,
  llvmStage0,
  muslStage1,
  gnumakeStage1,
  ccacheBin,
  m4Stage1 =
    _m4Stage1
    & {
      buildInputs =
        lib.biMap [
          busyboxStage0,
          llvmStage0,
          muslStage1,
          gnumakeStage1,
          ccacheBin,
        ]
    }
}
