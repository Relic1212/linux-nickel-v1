let lib = import "../../nickellib/lib.ncl"
in
let flexBase | lib.AutotoolsPackage
  = {
    buildEnv = (lib.AutotoolsPackage.buildEnv & { LD | default = "lld" }),

    name | priority -10 = "flex",
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz",
          sha256sum = "e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995"
        }
      }
    ],
    buildDir = "${SRC}"
  }
  in
{
  flexStage1 =
    flexBase
    & {
      stage = 1,
      name = "flex-stage-1",
      buildInputs = [
        (import "../llvm/llvm-stage-0.ncl"),
        (import "../musl/musl-stage-1.ncl"),
        (import "../gnumake/gnumake.ncl").gnumakeStage1,
        (import "../ccache/ccache-bin.ncl"),
        (import "../m4/m4.ncl").m4Stage1,
        (import "../busybox/busybox-stage-0.ncl"),
      ]
    }
}
